//
//  EmptyStateView.swift
//  Weather
//
//  Created by Дмитрий К on 03.05.2025.
//

import UIKit

class EmptyStateView: UIView {
    
    let messageLabel = CustomLabel(fontSize: 28, weight: .bold)

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(errorMessage: Errors){
        super.init(frame: .zero)
        messageLabel.text = errorMessage.rawValue
        configure()
    }
    
    private func configure() {
        self.backgroundColor = .systemBackground
        addSubview(messageLabel)
        
        messageLabel.numberOfLines = 5
        messageLabel.textColor = .label
        messageLabel.textAlignment = .center
        
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            messageLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -150),
            messageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40),
            messageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40),
            messageLabel.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
}
