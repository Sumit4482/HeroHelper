//
//  TipTableViewCell.swift
//  HeroHelper
//
//  Created by E5000855 on 29/06/24.
//

import Foundation
import UIKit

class TipTableViewCell: UITableViewCell {
    
    private let questionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 0
        return label
    }()
    
    private let answerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.textColor = .gray
        return label
    }()
    
    private let padding: CGFloat = 16
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(questionLabel)
        contentView.addSubview(answerLabel)
        
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        answerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            questionLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            questionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            questionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            
            answerLabel.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 8),
            answerLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            answerLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            answerLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with tip: Tip) {
        questionLabel.text = tip.question
        answerLabel.text = tip.isExpanded ? tip.answer : ""
    }
}

// MARK: - Tip Data Model

struct Tip {
    let question: String
    let answer: String
    var isExpanded: Bool = false
}
