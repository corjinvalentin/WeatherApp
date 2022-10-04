//
//  WrapperCollectionViewCell.swift
//  WeatherApp
//
//  Created by Corjin, Valentin on 7/19/22.
//

import UIKit

class WrapperCollectionViewCell: UICollectionViewCell {
    static let identifier = "WrapperCollectionViewCell"
    private enum Constants {
        static let firstSectionHeight: CGFloat = 150.0
        static let firstSectionEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        static let secondSectionHeight: CGFloat = 400.0
        static let secondSectionEdgeInsets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        static let thirdSectionHeight: CGFloat = 600.0
        static let thirdSectionEdgeInsets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        static let numberOfSections: Int = 3
        static let numberOfItemsInSection: Int = 1
    }
    
    // MARK: - Private Properties
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    private var weather: WeatherViewController.Model? {
        didSet {
            collectionView.reloadData()
        }
    }

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
        contentView.backgroundColor = .clear
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(HourlyCollectionViewCell.self, forCellWithReuseIdentifier: HourlyCollectionViewCell.identifier)
        collectionView.register(DailyCollectionViewCell.self, forCellWithReuseIdentifier: DailyCollectionViewCell.identifier)
        collectionView.register(CurrentCollectionViewCell.self, forCellWithReuseIdentifier: CurrentCollectionViewCell.identifier)
        
        contentView.addSubview(collectionView)
        collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    // MARK: - Public methods
    
    func passWeather(weather: WeatherViewController.Model) {
        self.weather = weather
    }
}


// MARK: - UICollectionViewDelegate

extension WrapperCollectionViewCell: UICollectionViewDelegate {
}

// MARK: - UICollectionViewDataSource

extension WrapperCollectionViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Constants.numberOfItemsInSection
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            guard
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourlyCollectionViewCell.identifier, for: indexPath) as? HourlyCollectionViewCell
            else { return UICollectionViewCell() }
            let hourly = weather?.hourly
            guard let hourly = hourly else { return cell }
            cell.passHourlyForecast(hourlyForecast: hourly)
            return cell
            
        case 1:
            guard
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DailyCollectionViewCell.identifier, for: indexPath) as? DailyCollectionViewCell
            else { return UICollectionViewCell() }
            let daily = weather?.daily
            guard let daily = daily else { return cell }
            cell.passDailyForecast(dailyForecast: daily)
            return cell
        
        case 2:
            guard
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CurrentCollectionViewCell.identifier, for: indexPath) as? CurrentCollectionViewCell
            else { return UICollectionViewCell() }
            let hourly = weather?.hourly
            guard let hourly = hourly else { return cell }
            cell.passHourlyForecast(hourlyForecast: hourly)
            return cell
            
        default: return UICollectionViewCell()
        }
    }
        
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Constants.numberOfSections
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension WrapperCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0: return CGSize(width: contentView.frame.width, height: Constants.firstSectionHeight)
        case 1: return CGSize(width: contentView.frame.width, height: Constants.secondSectionHeight)
        case 2: return CGSize(width: contentView.frame.width, height: Constants.thirdSectionHeight)
        default: return CGSize()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch section {
        case 0: return Constants.firstSectionEdgeInsets
        case 1: return Constants.secondSectionEdgeInsets
        case 2: return Constants.thirdSectionEdgeInsets
        default: return UIEdgeInsets()
        }
    }
}
