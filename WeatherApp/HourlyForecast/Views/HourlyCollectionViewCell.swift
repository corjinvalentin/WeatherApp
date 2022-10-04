//
//  HourlyCollectionViewCell.swift
//  WeatherApp
//
//  Created by Corjin, Valentin on 7/13/22.
//

import UIKit

class HourlyCollectionViewCell: UICollectionViewCell {
    static let identifier = "HourlyCollectionViewCell"
    private enum Constants {
        static let cellWidth: CGFloat = 85.0
        static let blurEffectViewCornerRadius: CGFloat = 8.0
    }
    
    // MARK: - Private Properties
    
    private let blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        return blurEffectView
    }()
    
    private var hourlyForecast: [WeatherViewController.HourlyModel]? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
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
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        blurEffectView.layer.cornerRadius = Constants.blurEffectViewCornerRadius
        blurEffectView.clipsToBounds = true
        
        contentView.addSubview(blurEffectView)
        blurEffectView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        blurEffectView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        blurEffectView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        blurEffectView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        blurEffectView.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(HourlyInfoCollectionViewCell.self, forCellWithReuseIdentifier: HourlyInfoCollectionViewCell.identifier)
        
        blurEffectView.contentView.addSubview(collectionView)
        
        collectionView.widthAnchor.constraint(equalTo: blurEffectView.widthAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalTo: blurEffectView.heightAnchor).isActive = true
    }
    
    // MARK: - Public methods
    
    func passHourlyForecast(hourlyForecast: [WeatherViewController.HourlyModel]) {
        self.hourlyForecast = hourlyForecast
    }
}

// MARK: - UICollectionViewDelegate

extension HourlyCollectionViewCell: UICollectionViewDelegate {
}

// MARK: - UICollectionViewDataSource

extension HourlyCollectionViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 24
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourlyInfoCollectionViewCell.identifier, for: indexPath) as? HourlyInfoCollectionViewCell
        else { return UICollectionViewCell() }
        let hourly = hourlyForecast?[indexPath.item]
        guard let hourly = hourly else { return cell }
        let date = hourly.dt
        let temp = hourly.temp
        let data = HourlyInfoCollectionViewCell.Model(date: date, temp: temp)
        cell.configure(data: data)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension HourlyCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Constants.cellWidth, height: frame.height)
    }
}

