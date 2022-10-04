//
//  HeaderCollectionReusableView.swift
//  WeatherApp
//
//  Created by Corjin, Valentin on 7/18/22.
//

import UIKit

class HeaderView: UIView {
    
    private enum Constants {
        static let cityLabelFontSize: CGFloat = 30.0
        static let cityLabelTopAnchorPadding: CGFloat = 10.0
        static let titleLabelFontSize: CGFloat = 80.0
        static let titleLabelTopAnchorPadding: CGFloat = 5.0
        static let tempLabelFontSize: CGFloat = 20.0
        static let tempLabelBottomAnchorPadding: CGFloat = -20.0
    }
    
    // MARK: - Private Properties
    
    private var data: HeaderView.Model? {
        didSet {
            guard let data = data else { return }
            titleLabel.text = data.hourly[0].temp.description + "°"
            cityLabel.text = data.cityName
            tempLabel.text = "Max: \(data.daily.max)°  Min: \(data.daily.min)°"
        }
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var cityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var tempLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Lifecycle
    
    init(data: HeaderView.Model) {
        self.data = data
        super.init(frame: CGRect())
        setup()
    }
    
    init() {
        super.init(frame: CGRect())
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    // MARK: - Private methods
    
    private func setup() {
        backgroundColor = .clear
        
        addSubview(cityLabel)
        cityLabel.font = UIFont.systemFont(ofSize: Constants.cityLabelFontSize)
        cityLabel.textAlignment = .center
        cityLabel.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        cityLabel.topAnchor.constraint(equalTo: topAnchor, constant: Constants.cityLabelTopAnchorPadding).isActive = true
        
        addSubview(titleLabel)
        titleLabel.font = UIFont.systemFont(ofSize: Constants.titleLabelFontSize)
        titleLabel.textAlignment = .center
        titleLabel.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: Constants.titleLabelTopAnchorPadding).isActive = true
        
        addSubview(tempLabel)
        tempLabel.font = UIFont.systemFont(ofSize: Constants.tempLabelFontSize)
        tempLabel.textAlignment = .center
        tempLabel.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        tempLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        tempLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: Constants.tempLabelBottomAnchorPadding).isActive = true
    }
    
    // MARK: - Public methods
    
    func passModel(model: HeaderView.Model) {
        data = model
    }
}

// MARK: - Model

extension HeaderView {
    struct Model {
        let hourly: [WeatherViewController.HourlyModel]
        let cityName: String
        let daily: WeatherViewController.TempModel
    }
}
