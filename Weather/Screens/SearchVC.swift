//
//  SearchVC.swift
//  Weather
//
//  Created by Дмитрий К on 17.03.2025.
//

import UIKit

class SearchVC: UIViewController {
    
    private let persistenceManager: PersistenceManaging

    init(persistenceManager: PersistenceManaging) {
        self.persistenceManager = persistenceManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let searchController = UISearchController()
    var isCityNameEntered: Bool { return !searchController.searchBar.text!.isEmpty }
    
    let tableView = SavedCitiesTableView(frame: .zero, style: .plain)
    var savedCities: [SavedCity] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.register(SavedCityCell.self, forCellReuseIdentifier: SavedCityCell.reuseID)
        configureSearchController()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getSavedCities()
    }
    
    
    func getSavedCities() {
        persistenceManager.retrieveCities { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let savedCities):
                updateUI(savedCities: savedCities)
            case .failure:
                break
            }
        }
    }
    
    func updateUI(savedCities: [SavedCity]) {
        self.savedCities = savedCities
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds

        tableView.delegate = self
        tableView.dataSource = self
    }
    

    func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search for a city"
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
    }
}


extension SearchVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {}
}


extension SearchVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard isCityNameEntered else { return }
        
        let cityWeatherInfoVC = CityWeatherInfoVC(cityName: searchController.searchBar.text ?? "",persistenceManager: persistenceManager, networkManager: DIContainer.shared.networkManager)
        navigationController?.pushViewController(cityWeatherInfoVC, animated: true)
    }
}

extension SearchVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SavedCityCell.reuseID) as! SavedCityCell
        let savedCity = savedCities[indexPath.row]
        cell.set(savedCity: savedCity)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let savedCity = savedCities[indexPath.row]
        let destVC = CityWeatherInfoVC(cityName: savedCity.name,persistenceManager: persistenceManager, networkManager: DIContainer.shared.networkManager)
        navigationController?.pushViewController(destVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        let savedCity = savedCities[indexPath.row]
        savedCities.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .left)
        
        persistenceManager.updateWith(city: savedCity, actionType: .remove) { [weak self] error in
            guard let self = self else { return }
            
            guard let error = error else { return }
            showAlert(error: error)
            
            return
        }
    }
}
