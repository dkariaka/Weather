//
//  SavedCitiesTableView.swift
//  Weather
//
//  Created by Дмитрий К on 11.05.2025.
//

import UIKit

class SavedCitiesTableView: UITableView {

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        rowHeight = 80
        backgroundColor = .systemBackground
    }
}
