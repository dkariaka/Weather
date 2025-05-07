//
//  ForecastView.swift
//  Weather
//
//  Created by Дмитрий К on 16.04.2025.
//

import UIKit

class ForecastView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        self.layer.cornerRadius = 18
        self.backgroundColor = UIColor.white.withAlphaComponent(0.25)
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.1
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 6
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
}
