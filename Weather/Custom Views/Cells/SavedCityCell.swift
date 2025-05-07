//
//  SavedCityCell.swift
//  Weather
//
//  Created by Дмитрий К on 16.04.2025.
//

import UIKit

class SavedCityCell: UITableViewCell {
    
    static let reuseID = "SavedCity"
    let nameLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(savedCity: SavedCity) {
        nameLabel.text = savedCity.name
    }
    
    private func configure() {
        addSubview(nameLabel)
        nameLabel.textColor = .label
        nameLabel.textAlignment = .left
        nameLabel.font = .systemFont(ofSize: 26)
        
        accessoryType = .disclosureIndicator
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -12),
            nameLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
}
