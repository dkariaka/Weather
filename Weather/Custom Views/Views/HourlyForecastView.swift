//
//  HourlyForecastView.swift
//  Weather
//
//  Created by Дмитрий К on 09.05.2025.
//

import UIKit

class HourlyForecastView: ForecastView {
    
    private let scrollView = UIScrollView()
    private let hourlyStackView = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubview(scrollView)
        scrollView.addSubview(hourlyStackView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isScrollEnabled = true
        scrollView.bounces = false
        
        hourlyStackView.axis = .horizontal
        hourlyStackView.alignment = .center
        hourlyStackView.spacing = 10
        hourlyStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            hourlyStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            hourlyStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            hourlyStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            hourlyStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            hourlyStackView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor)
        ])
    }
    
    func populateHourlyForecast(item: WeatherItemInfoView) {
        hourlyStackView.addArrangedSubview(item)
    }
}
