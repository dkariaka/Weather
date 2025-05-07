//
//  WeatherItemInfoView.swift
//  Weather
//
//  Created by Дмитрий К on 29.03.2025.
//

import UIKit

class WeatherItemInfoView: UIView {

    private let stackView = UIStackView()
    
    let timeLabel = UILabel()
    let weatherIcon = UIImageView()
    let temperatureLabel = UILabel()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
    private func configure() {
        addSubview(stackView)
        stackView.addArrangedSubview(timeLabel)
        stackView.addArrangedSubview(weatherIcon)
        stackView.addArrangedSubview(temperatureLabel)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 3
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        
        weatherIcon.contentMode = .scaleAspectFit
        weatherIcon.tintColor = .label
        timeLabel.font = .systemFont(ofSize: 14)
        timeLabel.textColor = .white
        temperatureLabel.font = .systemFont(ofSize: 14)
        temperatureLabel.textColor = .white
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.heightAnchor.constraint(equalToConstant: 100),
            self.widthAnchor.constraint(equalToConstant: 50)
        ])
    }
}
