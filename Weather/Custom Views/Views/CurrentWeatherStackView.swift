//
//  CurrentWeatherStackView.swift
//  Weather
//
//  Created by Дмитрий К on 09.05.2025.
//

import UIKit

class CurrentWeatherStackView: UIStackView {
    
    private let cityNameLabel = CustomLabel(fontSize: 30, weight: .bold)
    private let tempLabel = CustomLabel(fontSize: 45, weight: .bold)
    private let feelsLikeLabel = CustomLabel(fontSize: 16, weight: .regular)
    private let maxMinLabel = CustomLabel(fontSize: 16, weight: .regular)

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addArrangedSubview(cityNameLabel)
        addArrangedSubview(tempLabel)
        addArrangedSubview(feelsLikeLabel)
        addArrangedSubview(maxMinLabel)
        translatesAutoresizingMaskIntoConstraints = false
        axis = .vertical
        spacing = 3
        alignment = .center
        distribution = .equalSpacing
    }
    
    func populateStackWith(name: String, temp: String, feelsLike: String, maxMin: String) {
        cityNameLabel.text = name
        tempLabel.text = temp
        feelsLikeLabel.text = feelsLike
        maxMinLabel.text = maxMin
    }
}
