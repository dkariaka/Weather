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
    
}
