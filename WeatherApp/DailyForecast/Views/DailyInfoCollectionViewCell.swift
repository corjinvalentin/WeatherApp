//
//  DailyInfoCollectionViewCell.swift
//  WeatherApp
//
//  Created by Corjin, Valentin on 7/14/22.
//

import UIKit

class DailyInfoCollectionViewCell: UICollectionViewCell {
    static let identifier = "DailyCollectionViewCell22222222"
    private enum Constants {
        static let timeLabelFontSize: CGFloat = 16.0
        static let timeLabelLeadingAnchorPadding: CGFloat = 20.0
        static let titleLabelFontSize: CGFloat = 16.0
        static let titleLabelTrailingAnchorPadding: CGFloat = -20.0
    }
    
    // MARK: - Private properties
    
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
    
    func configure(data: DailyInfoCollectionViewCell.Model) {
        timeLabel.text = data.date.dayText
        timeLabel.font = UIFont.boldSystemFont(ofSize: Constants.timeLabelFontSize)
        contentView.addSubview(timeLabel)
        timeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.timeLabelLeadingAnchorPadding).isActive = true
        timeLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        titleLabel.text = data.temp.description + "°"
        titleLabel.font = UIFont.boldSystemFont(ofSize: Constants.titleLabelFontSize)
        contentView.addSubview(titleLabel)
        titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Constants.titleLabelTrailingAnchorPadding).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
}

// MARK: - Model

extension DailyInfoCollectionViewCell {
    struct Model {
        let date: Date
        let temp: Int
        
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
