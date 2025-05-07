//
//  SearchVC.swift
//  Weather
//
//  Created by Дмитрий К on 17.03.2025.
//

import UIKit

class SearchVC: UIViewController {
    
    let searchController = UISearchController()
    var isCityNameEntered: Bool { return !searchController.searchBar.text!.isEmpty }
    
    let tableView = UITableView()
    var savedCities: [SavedCity] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchController()
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getCavedCities()
    }
    
    
    func getCavedCities() {
        PersistenceManager.retrieveCities { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let savedCities):
                self.savedCities = savedCities
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure:
                break
            }
        }
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.rowHeight = 80
        tableView.register(SavedCityCell.self, forCellReuseIdentifier: SavedCityCell.reuseID)
        tableView.backgroundColor = .systemBackground
        
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
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}


extension SearchVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard isCityNameEntered else {
            print("No city entered")
            return
        }
        
        let cityWeatherInfoVC = CityWeatherInfoVC()
        cityWeatherInfoVC.cityName = searchController.searchBar.text
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
        let destVC = CityWeatherInfoVC()
        destVC.cityName = savedCity.name
        navigationController?.pushViewController(destVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        let savedCity = savedCities[indexPath.row]
        savedCities.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .left)
        
        PersistenceManager.updateWith(city: savedCity, actionType: .remove) { [weak self] error in
            guard let self = self else { return }
            
            guard let error = error else { return }
            showAlert(error: error)
            
            return
        }
    }
}
