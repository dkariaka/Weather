//
//  CityWeatherInfoVC.swift
//  Weather
//
//  Created by Дмитрий К on 17.03.2025.
//

import UIKit

class CityWeatherInfoVC: UIViewController {
    
    private let persistenceManager: PersistenceManaging
    
    private let networkManager: NetworkManagerProtocol

    init(cityName: String ,persistenceManager: PersistenceManaging, networkManager: NetworkManagerProtocol) { //= DIContainer.shared.persistenceManager
        self.cityName = cityName
        self.persistenceManager = persistenceManager
        self.networkManager = networkManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var stackView = CurrentWeatherStackView()
    private var hourlyForecastView = HourlyForecastView(frame: .zero)
    private var dailyForecastView = DailyForecastView(frame: .zero)
    
    var dailyForecast: [[ForecastWeatherResponse.ForecastItem]] = []
    
    var cityName: String

    override func viewDidLoad() {
        super.viewDidLoad()
        dailyForecastView.dailyTableView.register(DailyCell.self, forCellReuseIdentifier: DailyCell.reuseID)
        configureUI()
        getWeatherData()
    }
    
    
    func getWeatherData() {
        networkManager.fetchWeatherData(for: cityName) { result in
            switch result {
            case .success(let city):
                self.updateUI(with: city)
            case .failure(let error):
                self.showEmptyState(with: error)
                return
            }
        }
    }
    
    func configureUI() {
        configure(stackView, top: view.safeAreaLayoutGuide.topAnchor, topConstant: 5, leadingConstant: 0, trailingConstant: 0, height: 160)
        configure(hourlyForecastView, top: stackView.bottomAnchor, topConstant: 20, leadingConstant: 15, trailingConstant: 15, height: 140)
        configure(dailyForecastView, top: hourlyForecastView.bottomAnchor, topConstant: 10, leadingConstant: 15, trailingConstant: 15, height: 266)
        dailyForecastView.setDelegate(self, dataSource: self)
        configureAddButton()
    }
    
    
    func setBackground(for city: City) {
        guard let currentWeather = city.currentWeather?.weather.first else { return }
        let gradientColors = WeatherBackgroundStyle(description: currentWeather.description, icon: currentWeather.icon).backgroundGradient
        addGradientBackground(color1: gradientColors[0], color2: gradientColors[1])
    }
    
    
    private func updateDailyForecast(with city: City) {
        guard let forecastList = city.forecastWeather?.list else { return }

        self.dailyForecast = city.groupForecastsByDay(forecastList)
        self.dailyForecastView.dailyTableView.reloadData()
    }

    
    private func updateHourlyForecast(with city: City) {
        guard let forecastList = city.forecastWeather?.list, let timezoneOffset = city.forecastWeather?.city.timezone else { return }

        for item in forecastList.prefix(8) {
            let weatherItem = WeatherItemInfoView()
            weatherItem.populateUI(with: item, timezoneOffset: timezoneOffset)
            self.hourlyForecastView.populateHourlyForecast(item: weatherItem)
        }
    }
    
    
    private func updateCurrentWeatherUI(with city: City) {
        guard let currentWeather = city.currentWeather?.main else { return }

        self.stackView.populateStackWith(
            name: self.cityName,
            temp: "\(Int(round(currentWeather.temp)))°C",
            feelsLike: "Feels like \(Int(round(currentWeather.feelsLike)))°C",
            maxMin: "H: \(Int(round(currentWeather.tempMax)))°C L: \(Int(round(currentWeather.tempMin)))°C"
        )
    }
    
    
    func updateUI(with city: City) {
        DispatchQueue.main.async {
            self.setBackground(for: city)
            self.updateCurrentWeatherUI(with: city)
            self.updateHourlyForecast(with: city)
            self.updateDailyForecast(with: city)
        }
    }
    
    
    @objc func addButtonTapped() {
        let savedCity = SavedCity(name: self.cityName)
        persistenceManager.updateWith(city: savedCity, actionType: .add) { [weak self] error in
            guard let self = self else { return }
            guard let  error = error else { return }
            showAlert(error: error)
        }
    }
    
    
    func configureAddButton() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        addButton.tintColor = .white
        navigationItem.rightBarButtonItem = addButton
    }
    
    
    func configure(_ subview: UIView, top: NSLayoutYAxisAnchor, topConstant: CGFloat, leadingConstant: CGFloat, trailingConstant: CGFloat, height: CGFloat) {
        view.addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subview.topAnchor.constraint(equalTo: top, constant: topConstant),
            subview.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leadingConstant),
            subview.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -trailingConstant),
            subview.heightAnchor.constraint(equalToConstant: height)
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
        cell.populateCell(with: dayForecast)
        return cell
    }
}
    
