//
//  CityWeatherInfoVC.swift
//  Weather
//
//  Created by Дмитрий К on 17.03.2025.
//

import UIKit

class CityWeatherInfoVC: UIViewController {
    
    let stackView = UIStackView()
    
    private lazy var cityNameLabel = CustomLabel(fontSize: 30, weight: .bold)
    private lazy var tempLabel = CustomLabel(fontSize: 45, weight: .bold)
    private lazy var feelsLikeLabel = CustomLabel(fontSize: 16, weight: .regular)
    private lazy var maxMinLabel = CustomLabel(fontSize: 16, weight: .regular)
    
    private lazy var hourlyForecastView = ForecastView(frame: .zero)
    private lazy var scrollView = UIScrollView()
    private lazy var hourlyStackView = UIStackView()
    
    private lazy var dailyForecastView = ForecastView(frame: .zero)
    private lazy var dailyTableView = UITableView()
    
    var dailyForecast: [[ForecastWeatherResponse.ForecastItem]] = []
    
    var cityName: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        dailyTableView.register(DailyCell.self, forCellReuseIdentifier: DailyCell.reuseID)
        getWeatherData()
    }
    
    func getWeatherData() {
        NetworkManager.shared.fetchWeatherData(for: cityName) { result in
            switch result {
            case .success(let city):
                DispatchQueue.main.async {
                    guard let currentWeather = city.currentWeather?.main else { return }
                    
                    self.configureStackView()
                    self.configureHourlyForecastView()
                    self.configureDailyForecastView()
                    self.configureAddButton()
                    
                    let gradientColors = WeatherBackgroundStyle(description: (city.currentWeather?.weather.first?.description)!, icon: (city.currentWeather?.weather.first?.icon)!).backgroundGradient
                    
                    self.cityNameLabel.text = self.cityName
                    self.tempLabel.text = "\(Int(round(currentWeather.temp)))°C"
                    self.feelsLikeLabel.text = "Feels like \(Int(round(currentWeather.feelsLike)))°C"
                    self.maxMinLabel.text = "H: \(Int(round(currentWeather.tempMax)))°C L: \(Int(round(currentWeather.tempMin)))°C"
                    self.addGradientBackground(color1: gradientColors[0], color2: gradientColors[1])
                    
                    if let forecastList = city.forecastWeather?.list {
                        for i in 0...7 {
                            let item = forecastList[i]
                            let weatherItem = WeatherItemInfoView()
                            weatherItem.timeLabel.text = self.formattedHour(from: Int(item.dt), timezoneOffset: (city.forecastWeather?.city.timezone)!)
                            let weatherDescription = item.weather.first?.description ?? ""
                            
                            let weatherIcon = WeatherIcons(description: weatherDescription, icon: item.weather.first?.icon ?? "").systemImageName
                            weatherItem.weatherIcon.tintColor = .white
                            
                            weatherItem.weatherIcon.image = UIImage(systemName: weatherIcon)
                            weatherItem.temperatureLabel.text = "\(Int(round(item.main.temp)))°C"
                            self.hourlyStackView.addArrangedSubview(weatherItem)
                        }
                        
                        self.dailyForecast = self.groupForecastsByDay(forecastList)
                        self.dailyTableView.reloadData()
                    }
                }
            case .failure(let error):
                switch error {
                case .noCity:
                    self.showEmptyState(with: .noCity)
                case .errorFetchingData:
                    self.showEmptyState(with: .errorFetchingData)
                default:
                    self.showEmptyState(with: .unknownProblem)
                }
                return
            }
        }
    }
    
    
    func configureAddButton() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        addButton.tintColor = .white
        navigationItem.rightBarButtonItem = addButton
    }
    
    
    @objc func addButtonTapped() {
        let savedCity = SavedCity(name: self.cityName)
        PersistenceManager.updateWith(city: savedCity, actionType: .add) { [weak self] error in
            guard let self = self else { return }
            guard let  error = error else { return }
            showAlert(error: error)
        }
    }
    
    
    func formattedHour(from timestamp: Int, timezoneOffset: Int) -> String {
        let currentTimeZone = TimeZone.current.secondsFromGMT()
        let dateUTC = Date(timeIntervalSince1970: TimeInterval(timestamp - currentTimeZone))

        let formatter = DateFormatter()
        formatter.dateFormat = "HH"
        formatter.timeZone = TimeZone(secondsFromGMT: timezoneOffset)
        formatter.locale = Locale(identifier: "en_US_POSIX")

        return formatter.string(from: dateUTC)
    }
    
    
    private func configureStackView() {
        view.addSubview(stackView)
        
        stackView.addArrangedSubview(cityNameLabel)
        stackView.addArrangedSubview(tempLabel)
        stackView.addArrangedSubview(feelsLikeLabel)
        stackView.addArrangedSubview(maxMinLabel)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 3
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 160)
        ])
    }
    
    private func configureHourlyForecastView() {
        view.addSubview(hourlyForecastView)
        hourlyForecastView.addSubview(scrollView)
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
            hourlyForecastView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
            hourlyForecastView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            hourlyForecastView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            hourlyForecastView.heightAnchor.constraint(equalToConstant: 140),
            
            scrollView.topAnchor.constraint(equalTo: hourlyForecastView.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: hourlyForecastView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: hourlyForecastView.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: hourlyForecastView.bottomAnchor),
            
            hourlyStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            hourlyStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            hourlyStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            hourlyStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            hourlyStackView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor)
        ])
    }
    
    func configureDailyForecastView() {
        view.addSubview(dailyForecastView)
        dailyTableView.delegate = self
        dailyTableView.dataSource = self
        dailyForecastView.addSubview(dailyTableView)
        
        dailyTableView.backgroundColor = .clear
        dailyTableView.translatesAutoresizingMaskIntoConstraints = false
        dailyTableView.rowHeight = UITableView.automaticDimension
        dailyTableView.estimatedRowHeight = 44
        
        NSLayoutConstraint.activate([
            dailyForecastView.topAnchor.constraint(equalTo: hourlyForecastView.bottomAnchor, constant: 10),
            dailyForecastView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            dailyForecastView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            dailyForecastView.heightAnchor.constraint(equalToConstant: 266),
            
            dailyTableView.topAnchor.constraint(equalTo: dailyForecastView.topAnchor),
            dailyTableView.leadingAnchor.constraint(equalTo: dailyForecastView.leadingAnchor),
            dailyTableView.trailingAnchor.constraint(equalTo: dailyForecastView.trailingAnchor),
            dailyTableView.bottomAnchor.constraint(equalTo: dailyForecastView.bottomAnchor)
        ])
    }
    
    
    func groupForecastsByDay(_ forecasts: [ForecastWeatherResponse.ForecastItem]) -> [[ForecastWeatherResponse.ForecastItem]] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: forecasts) { forecast in
            calendar.startOfDay(for: Date(timeIntervalSince1970: forecast.dt))
        }
        let sortedDays = grouped.keys.sorted()
        
        return sortedDays.map { grouped[$0] ?? [] }
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

extension CityWeatherInfoVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dailyForecast.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DailyCell.reuseID, for: indexPath) as! DailyCell

        let dayForecast = dailyForecast[indexPath.row]
       
        if let firstForecast = dayForecast.first {
            let date = Date(timeIntervalSince1970: TimeInterval(firstForecast.dt))
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEE"
            cell.dayLabel.text = dateFormatter.string(from: date)
        }
     
        let minTemp = dayForecast.map { $0.main.tempMin }.min() ?? 0
        let maxTemp = dayForecast.map { $0.main.tempMax }.max() ?? 0
        cell.minMaxLabel.text = "From \(Int(round(minTemp)))°C to \(Int(round(maxTemp)))°C"
        
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
                cell.image.image = UIImage(systemName: systemIconName)
                cell.image.tintColor = .white
            }
        }
        return cell
    }
}
    
