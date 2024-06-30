//
//  EquipmentFAQViewController.swift
//  HeroHelper
//
//  Created by E5000855 on 29/06/24.
//
import UIKit

class EquipmentTipsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let tableView = UITableView()
    private var tipsData: [Tip] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Equipment Tips"
        setupNavigationBar()
        // Example data
        tipsData = [
            Tip(question: "How should I handle a broken equipment situation?",
                answer: "If equipment breaks down, immediately secure the area, follow lockout/tagout procedures, and notify maintenance personnel. Do not attempt repairs unless trained and authorized."),
            
            Tip(question: "What should I do if I notice unusual noises or vibrations from equipment?",
                answer: "Stop the equipment if safe to do so, inspect for loose parts or obstructions, and report findings to maintenance for further inspection and repairs."),
            
            Tip(question: "How often should equipment be inspected?",
                answer: "Equipment should undergo regular inspections as per the manufacturer's guidelines and your organization's maintenance schedule. Critical equipment may require daily checks."),
            
            Tip(question: "What are the steps to follow when performing equipment repairs?",
                answer: "Ensure proper safety precautions are in place, refer to equipment manuals for repair procedures, use appropriate tools and PPE, and test equipment thoroughly before returning to service."),
            
            Tip(question: "Who should be notified in case of equipment malfunction?",
                answer: "Notify your supervisor or the designated maintenance personnel immediately. Document the issue and any actions taken for future reference."),
            Tip(question: "What are the common causes of equipment overheating, and how should it be addressed?",
                answer: "Common causes include blocked ventilation, low lubrication, or excessive load. Address by clearing vents, adding lubrication, and reducing load as necessary."),
            
            Tip(question: "How can I prevent equipment failures during extreme weather conditions?",
                answer: "Ensure equipment is properly insulated and protected from environmental elements. Implement heating or cooling systems if required."),
            
            Tip(question: "What safety precautions should I take when handling electrical equipment?",
                answer: "Always de-energize equipment before inspection or repair. Use insulated tools and wear appropriate PPE to prevent electrical hazards."),
            
            Tip(question: "What should I do if I encounter a hydraulic system leak?",
                answer: "Contain the leak using absorbent materials, shut off the equipment, and notify maintenance immediately. Do not attempt to repair hydraulic lines unless trained."),
            
            Tip(question: "How can I ensure equipment reliability during peak operational periods?",
                answer: "Schedule preventive maintenance during off-peak hours, monitor equipment closely for signs of stress, and have contingency plans for quick repairs."),
        ]
       
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TipTableViewCell.self, forCellReuseIdentifier: "tipCell")
        
        view.addSubview(tableView)
        tableView.frame = view.bounds
        
        // Add floating action button (FAB)
        let fabButton = UIButton(type: .custom)
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 32, weight: .regular, scale: .default)
        let symbolImage = UIImage(systemName: "hammer.circle", withConfiguration: symbolConfiguration)
        
        fabButton.setImage(symbolImage, for: .normal)
        fabButton.tintColor = .white
        fabButton.backgroundColor = .systemBlue
        fabButton.layer.cornerRadius = 28
        fabButton.layer.shadowColor = UIColor.black.cgColor
        fabButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        fabButton.layer.shadowOpacity = 0.5
        fabButton.layer.shadowRadius = 3
        fabButton.addTarget(self, action: #selector(fabButtonTapped), for: .touchUpInside)
        
        view.addSubview(fabButton)
        fabButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            fabButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60),
            fabButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            fabButton.widthAnchor.constraint(equalToConstant: 56),
            fabButton.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
    private func setupNavigationBar() {
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationItem.largeTitleDisplayMode = .always
            navigationItem.title = "Equipment Tips"
            navigationController?.navigationBar.largeTitleTextAttributes = [
                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 30)
            ]
        }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tipsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tipCell", for: indexPath) as! TipTableViewCell
        let tip = tipsData[indexPath.row]
        cell.configure(with: tip)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        tipsData[indexPath.row].isExpanded.toggle()
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    @objc private func fabButtonTapped() {
        let equipmentViewController = EquipmentTroubleshootingViewController() 
        equipmentViewController.modalPresentationStyle = .fullScreen
        present(equipmentViewController, animated: true, completion: nil)
    }
}
