//
//  SingleInfoCollectionViewCell.swift
//  WeatherApp
//
//  Created by Corjin, Valentin on 7/13/22.
//

import UIKit

class HourlyInfoCollectionViewCell: UICollectionViewCell {
    static let identifier = "HourlyCollectionViewCell22222222"
    private enum Constants {
        static let timeLabelFontSize: CGFloat = 16.0
        static let timeLabelTopAnchorPadding: CGFloat = 20.0
        static let titleLabelFontSize: CGFloat = 16.0
        static let titleLabelBottomAnchorPadding: CGFloat = -20.0
    }
    
    // MARK: - Private Properties
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Private methods
    
    private func setupView() {
        backgroundColor = UIColor.clear
    }
    
    // MARK: - Public methods
    
    func configure(data: HourlyInfoCollectionViewCell.Model) {
        timeLabel.text = data.date.timeText
        timeLabel.font = UIFont.boldSystemFont(ofSize: Constants.timeLabelFontSize)
        contentView.addSubview(timeLabel)
        timeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.timeLabelTopAnchorPadding).isActive = true
        timeLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        
        titleLabel.text = data.temp.description + "°"
        titleLabel.font = UIFont.boldSystemFont(ofSize: Constants.titleLabelFontSize)
        contentView.addSubview(titleLabel)
        titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: Constants.titleLabelBottomAnchorPadding).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
    }
}

// MARK: - Model

extension HourlyInfoCollectionViewCell {
    struct Model {
        var date: Date
        var temp: Int
        
        init(date: Date, temp: Int) {
            self.date = date
            self.temp = temp
        }
        
        init() {
            self.date = Date.now
            self.temp = 0
        }
    }
}

