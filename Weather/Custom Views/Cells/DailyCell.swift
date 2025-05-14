//
//  DailyCell.swift
//  Weather
//
//  Created by Дмитрий К on 13.04.2025.
//

import UIKit

class DailyCell: UITableViewCell {

    static let reuseID = "DailyCell"
    var dayLabel = UILabel()
    var image = UIImageView()
    var minMaxLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubview(dayLabel)
        addSubview(image)
        addSubview(minMaxLabel)
        
        backgroundColor = .clear
        
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        image.translatesAutoresizingMaskIntoConstraints = false
        minMaxLabel.translatesAutoresizingMaskIntoConstraints = false
        
        image.contentMode = .scaleAspectFit
        image.tintColor = .label
        
        dayLabel.font = .systemFont(ofSize: 14)
        dayLabel.textColor = .white
        
        minMaxLabel.font = .systemFont(ofSize: 14)
        minMaxLabel.textColor = .white
        minMaxLabel.textAlignment = .right
        
        NSLayoutConstraint.activate([
            dayLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            dayLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            dayLabel.heightAnchor.constraint(equalToConstant: 25),
            dayLabel.widthAnchor.constraint(equalToConstant: 60),
            
            image.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            image.leadingAnchor.constraint(equalTo: dayLabel.trailingAnchor, constant: 25),
            image.heightAnchor.constraint(equalToConstant: 25),
            image.widthAnchor.constraint(equalToConstant: 25),
            
            minMaxLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            minMaxLabel.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 25),
            minMaxLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
            minMaxLabel.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
    
    func populateCell(with dayForecast: [ForecastWeatherResponse.ForecastItem]) {
            if let firstForecast = dayForecast.first {
                let date = Date(timeIntervalSince1970: TimeInterval(firstForecast.dt))
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "EEE"
                self.dayLabel.text = dateFormatter.string(from: date)
            }

            let minTemp = dayForecast.map { $0.main.tempMin }.min() ?? 0
            let maxTemp = dayForecast.map { $0.main.tempMax }.max() ?? 0
            self.minMaxLabel.text = "From \(Int(round(minTemp)))°C to \(Int(round(maxTemp)))°C"

            var iconFrequency: [String: Int] = [:]
            for forecast in dayForecast {
                if let icon = forecast.weather.first?.icon {
                    iconFrequency[icon, default: 0] += 1
                }
            }

            if let mostFrequentIcon = iconFrequency.max(by: { $0.value < $1.value })?.key {
                if let matchingForecast = dayForecast.first(where: { $0.weather.first?.icon == mostFrequentIcon }) {
                    let description = matchingForecast.weather.first?.description ?? ""
                    let systemIconName = WeatherIcons(description: description, icon: mostFrequentIcon).systemImageName
                    self.image.image = UIImage(systemName: systemIconName)
                    self.image.tintColor = .white
                }
            }
        }
}
