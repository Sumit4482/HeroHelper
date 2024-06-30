//
//  EquipmentTroubleshootingViewController.swift
//  HeroHelper
//
//  Created by E5000855 on 29/06/24.
//

import UIKit
import GoogleGenerativeAI

class EquipmentTroubleshootingViewController: UIViewController {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Equipment Troubleshooting"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        return button
    }()
    
    private let messageInputField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Type your message here"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send", for: .normal)
        button.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        return button
    }()
    
    private let chatTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        return tableView
    }()
    
    private var chatData: [String] = []
    
    // Google Generative AI setup
    let model = GenerativeModel(name: "gemini-pro", apiKey: "AIzaSyB7O_pCoXdzsMAytdUssXNuK0ApF-3PIXg")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupSubviews()
        

        chatTableView.delegate = self
        chatTableView.dataSource = self
        chatTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        chatTableView.tableFooterView = UIView()
    }
    
    private func setupSubviews() {
        view.addSubview(titleLabel)
        view.addSubview(closeButton)
        view.addSubview(chatTableView)
        view.addSubview(messageInputField)
        view.addSubview(sendButton)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        chatTableView.translatesAutoresizingMaskIntoConstraints = false
        messageInputField.translatesAutoresizingMaskIntoConstraints = false
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            closeButton.widthAnchor.constraint(equalToConstant: 32),
            closeButton.heightAnchor.constraint(equalToConstant: 32),
            
            chatTableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            chatTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            chatTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            chatTableView.bottomAnchor.constraint(equalTo: messageInputField.topAnchor, constant: -20),
            
            messageInputField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            messageInputField.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            messageInputField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -10),
            
            sendButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            sendButton.bottomAnchor.constraint(equalTo: messageInputField.bottomAnchor),
            sendButton.widthAnchor.constraint(equalToConstant: 80),
            sendButton.heightAnchor.constraint(equalTo: messageInputField.heightAnchor)
        ])
    }
    
    @objc private func closeTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func sendMessage() {
        guard let message = messageInputField.text, !message.isEmpty else {
            return
        }
        
        // Add user's message to chat data
        chatData.append("User: \(message)")
        chatTableView.reloadData()
        scrollToBottom()
        
        // Call method to check if prompt is related to equipment troubleshooting
        checkIfEquipmentRelated(prompt: message)
        
        messageInputField.text = ""
    }
    
    private func checkIfEquipmentRelated(prompt: String) {
        let keywords = ["equipment", "troubleshooting", "repair", "broken", "damaged", "hardware"]
        let lowercasedPrompt = prompt.lowercased()
        
        let isRelated = keywords.contains { lowercasedPrompt.contains($0) }
        
        if isRelated {
            // Prompt is related to equipment troubleshooting, fetch response
            fetchResponseForEquipmentPrompt(prompt: prompt)
        } else {
            // Not related to equipment troubleshooting, show default message
            DispatchQueue.main.async {
                self.chatData.append("AI: Ask Equipment Troubleshooting Tips Here")
                self.chatTableView.reloadData()
                self.scrollToBottom()
            }
        }
    }
    
    private func fetchResponseForEquipmentPrompt(prompt: String) {
        Task {
            do {
                let response = try await model.generateContent(prompt)
                if let text = response.text {
                    DispatchQueue.main.async {
                        self.chatData.append("AI: \(text)")
                        self.chatTableView.reloadData()
                        self.scrollToBottom()
                    }
                } else {
                    DispatchQueue.main.async {
                        self.chatData.append("AI: Empty response")
                        self.chatTableView.reloadData()
                        self.scrollToBottom()
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.chatData.append("AI: Error generating content")
                    self.chatTableView.reloadData()
                    self.scrollToBottom()
                }
                print("Error generating content: \(error)")
            }
        }
    }
    
    private func scrollToBottom() {
        if chatData.isEmpty { return }
        
        let indexPath = IndexPath(row: chatData.count - 1, section: 0)
        chatTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
}

extension EquipmentTroubleshootingViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = chatData[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        return cell
    }
}
