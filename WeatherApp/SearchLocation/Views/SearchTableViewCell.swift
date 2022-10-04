//
//  SearchTableViewCell.swift
//  WeatherApp
//
//  Created by Corjin, Valentin on 7/22/22.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    static let identifier = "SearchTableViewCell"
    private enum Constants {
        static let cityLabelLeadingAnchorPadding: CGFloat = 20.0
        static let cityLabelTopAnchorPadding: CGFloat = 5.0
        static let cityLabelWidthAnchorMultiplier: CGFloat = 0.5
        static let cityLabelHeight: CGFloat = 50.0
        static let tempLabelTrailingAnchorPadding: CGFloat = -5.0
        static let tempLabelWidth: CGFloat = 80.0
        static let tempLabelHeight: CGFloat = 50.0
        static let smallLabelTrailingAnchorPadding: CGFloat = -8.0
        static let smallLabelWidth: CGFloat = 130.0
        static let smallLabelHeight: CGFloat = 50.0
    }
    
    // MARK: - Private Properties
    
    private var cellData: SearchTableViewCell.Model? {
        didSet{
            guard let cellData = cellData else { return }
            tempLabel.text = cellData.currentTemp.description + "°"
            cityLabel.text = cellData.cityName
            smallLabel.text = "Max: \(cellData.maxTemp)°  Min: \(cellData.minTemp)°"
        }
    }
    
    private let cityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let tempLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 40)
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let smallLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
        
    // MARK: - Private methods
    
    private func setupView() {
        layer.cornerRadius = 8
        backgroundColor = .tertiarySystemBackground
                
        contentView.addSubview(cityLabel)
        cityLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.cityLabelLeadingAnchorPadding).isActive = true
        cityLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.cityLabelTopAnchorPadding).isActive = true
        cityLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: Constants.cityLabelWidthAnchorMultiplier).isActive = true
        cityLabel.heightAnchor.constraint(equalToConstant: Constants.cityLabelHeight).isActive = true
        
        contentView.addSubview(tempLabel)
        tempLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Constants.tempLabelTrailingAnchorPadding).isActive = true
        tempLabel.topAnchor.constraint(equalTo: cityLabel.topAnchor).isActive = true
        tempLabel.widthAnchor.constraint(equalToConstant: Constants.tempLabelWidth).isActive = true
        tempLabel.heightAnchor.constraint(equalToConstant: Constants.tempLabelHeight).isActive = true
        
        contentView.addSubview(smallLabel)
        smallLabel.trailingAnchor.constraint(equalTo: tempLabel.trailingAnchor, constant: Constants.smallLabelTrailingAnchorPadding).isActive = true
        smallLabel.topAnchor.constraint(equalTo: tempLabel.bottomAnchor).isActive = true
        smallLabel.widthAnchor.constraint(equalToConstant: Constants.smallLabelWidth).isActive = true
        smallLabel.heightAnchor.constraint(equalToConstant: Constants.smallLabelHeight).isActive = true
    }
    
    // MARK: - Public methods
    
    func passCellData(data: SearchTableViewCell.Model) {
        cellData = data
    }
}

// MARK: - Model

extension SearchTableViewCell {
    struct Model {
        let cityName: String
        let currentTemp: Int
        let maxTemp: Int
        let minTemp: Int
        
        init(cityName: String, temp: Int, maxTemp: Int, minTemp: Int) {
            self.cityName = cityName
            self.currentTemp = temp
            self.maxTemp = maxTemp
            self.minTemp = minTemp
        }
        
        init() {
            self.cityName = ""
            self.currentTemp = 0
            self.minTemp = 0
            self.maxTemp = 0
        }
    }
}

