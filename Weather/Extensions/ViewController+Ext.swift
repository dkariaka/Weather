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
}
