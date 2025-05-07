//
//  CustomLabel.swift
//  Weather
//
//  Created by Дмитрий К on 16.04.2025.
//

import UIKit

class CustomLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(fontSize: CGFloat, weight: UIFont.Weight) {
        super.init(frame: .zero)
        self.font = .systemFont(ofSize: fontSize, weight: weight)
        self.textColor = .white
    }
    
}
