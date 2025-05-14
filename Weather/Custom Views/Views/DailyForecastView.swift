//
//  DailyForecastView.swift
//  Weather
//
//  Created by Дмитрий К on 09.05.2025.
//

import UIKit

class DailyForecastView: ForecastView {
   
    let dailyTableView = UITableView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubview(dailyTableView)
        
        dailyTableView.backgroundColor = .clear
        dailyTableView.translatesAutoresizingMaskIntoConstraints = false
        dailyTableView.rowHeight = UITableView.automaticDimension
        dailyTableView.estimatedRowHeight = 44
        
        NSLayoutConstraint.activate([
            dailyTableView.topAnchor.constraint(equalTo: self.topAnchor),
            dailyTableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            dailyTableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            dailyTableView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    func setDelegate(_ delegate: UITableViewDelegate, dataSource: UITableViewDataSource) {
        dailyTableView.delegate = delegate
        dailyTableView.dataSource = dataSource
    }
}
