import UIKit
import GoogleGenerativeAI

class DoctorViewController: UIViewController {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Doctor Help"
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
        
        // Configure table view
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
        
        chatData.append("User: \(message)")
        chatTableView.reloadData()
        scrollToBottom()

        let healthCheckPrompt = "Is \"\(message)\" a health-related question ? Give answer in \"yes\" or \"no\" only"
        checkIfHealthRelated(prompt: healthCheckPrompt, originalPrompt: message)
        
        messageInputField.text = ""
    }

    private func checkIfHealthRelated(prompt: String, originalPrompt: String) {
        Task {
            do {
                let response = try await model.generateContent(prompt)
                if let text = response.text {
                    DispatchQueue.main.async {
                        if text.lowercased() == "yes" {
                            // Prompt is related to health, fetch response for original prompt
                            self.fetchResponseForHealthPrompt(prompt: originalPrompt + "Give tips in bullet points")
                        } else {
                            // Not related to health, show default message
                            self.chatData.append("AI: Ask Health Related Tips Here")
                            self.chatTableView.reloadData()
                            self.scrollToBottom()
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        // No specific response, show default message
                        self.chatData.append("AI: Ask Health Related Tips Here")
                        self.chatTableView.reloadData()
                        self.scrollToBottom()
                    }
                }
            } catch {
                DispatchQueue.main.async {
        
                    self.chatData.append("AI: Ask Health Related Tips Here")
                    self.chatTableView.reloadData()
                    self.scrollToBottom()
                }
                print("Error checking if health related: \(error)")
            }
        }
    }

    private func fetchResponseForHealthPrompt(prompt: String) {
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

extension DoctorViewController: UITableViewDataSource, UITableViewDelegate {
    
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
