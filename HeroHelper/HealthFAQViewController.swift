import UIKit

class HealthFAQViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let tableView = UITableView()
    private var faqData: [FAQ] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Health FAQs"
        setupNavigationBar()

        faqData = [
                FAQ(question: "What should I do if I experience symptoms of heat stress?",
                    answer: "If you experience symptoms of heat stress, such as dizziness, headache, or excessive sweating, move to a cooler area, drink plenty of water, and inform your supervisor immediately."),
                
                FAQ(question: "How can I protect myself from hazardous materials?",
                    answer: "Always wear the appropriate personal protective equipment (PPE), follow safety protocols, and attend regular training sessions on handling hazardous materials."),
                
                FAQ(question: "What steps should I take if there's a chemical spill?",
                    answer: "Evacuate the area, avoid contact with the spilled material, notify the emergency response team, and follow the emergency procedures outlined in your training."),
                
                FAQ(question: "How can I manage stress while working in a high-pressure environment?",
                    answer: "Take regular breaks, practice deep breathing or mindfulness exercises, talk to a supervisor or a mental health professional if needed, and maintain a healthy work-life balance."),
                
                FAQ(question: "What are the best practices for lifting heavy objects?",
                    answer: "Use proper lifting techniques: keep your back straight, bend your knees, lift with your legs, and avoid twisting your body. Use mechanical aids whenever possible and ask for assistance if needed."),
                
                FAQ(question: "How can I prevent slips, trips, and falls in the workplace?",
                    answer: "Keep work areas clean and free of clutter, wear appropriate footwear, use handrails when available, and report any hazards to your supervisor immediately."),
                
                FAQ(question: "What should I do if I or a coworker get injured on the job?",
                    answer: "Administer first aid if you're trained to do so, call for medical assistance, report the injury to your supervisor, and fill out an incident report as soon as possible."),
                
                FAQ(question: "How can I maintain good respiratory health in a dusty environment?",
                    answer: "Wear a respirator or dust mask, ensure proper ventilation in the work area, take breaks in clean air zones, and attend regular health check-ups."),
                
                FAQ(question: "What are the signs of dehydration, and how can I prevent it?",
                    answer: "Signs of dehydration include dry mouth, fatigue, dizziness, and dark urine. Prevent dehydration by drinking water regularly, especially in hot environments, and avoiding excessive caffeine and alcohol."),
                
                FAQ(question: "How can I stay informed about workplace safety updates?",
                    answer: "Attend regular safety meetings, read company safety bulletins, participate in training sessions, and stay in communication with your safety officer or supervisor.")
            ]
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(FAQTableViewCell.self, forCellReuseIdentifier: "faqCell")
        
        view.addSubview(tableView)
        tableView.frame = view.bounds
        
  
        let fabButton = UIButton(type: .custom)
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 32, weight: .regular, scale: .default)
        let symbolImage = UIImage(systemName: "cross.case.circle", withConfiguration: symbolConfiguration)

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
            navigationItem.title = "Health FAQs"
            navigationController?.navigationBar.largeTitleTextAttributes = [
                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 30)
            ]
        }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return faqData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "faqCell", for: indexPath) as! FAQTableViewCell
        let faq = faqData[indexPath.row]
        cell.configure(with: faq)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        faqData[indexPath.row].isExpanded.toggle()
    
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    @objc private func fabButtonTapped() {
        let doctorViewController = DoctorViewController() 
        doctorViewController.modalPresentationStyle = .fullScreen
        present(doctorViewController, animated: true, completion: nil)
    }
}
