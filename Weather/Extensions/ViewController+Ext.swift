//
//  ViewController+Ext.swift
//  Weather
//
//  Created by Дмитрий К on 06.05.2025.
//

import UIKit

extension UIViewController {
    func showAlert(error: Errors) {
        let alert = UIAlertController(title: "Notification", message: error.rawValue, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alert, animated: true)
    }
    
    
    func addGradientBackground(color1: UIColor, color2: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            color1.cgColor,
            color2.cgColor
        ]
       
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.4, y: 0.6)
       
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    
    func showEmptyState(with message: Errors) {
        let emptyStateView = EmptyStateView(errorMessage: message)
        emptyStateView.bounds = view.bounds
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emptyStateView)

        NSLayoutConstraint.activate([
            emptyStateView.topAnchor.constraint(equalTo: view.topAnchor),
            emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emptyStateView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
