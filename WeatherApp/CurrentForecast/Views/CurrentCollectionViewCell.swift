//
//  CurrentCollectionViewCell.swift
//  WeatherApp
//
//  Created by Corjin, Valentin on 7/14/22.
//

import UIKit

class CurrentCollectionViewCell: UICollectionViewCell {
    static let identifier = "CurrentCollectionViewCell"
    private enum Constants {
        static let cellSize = CGSize(width: 155, height: 150)
        static let cellEdgeInsets = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
        static let cellLineSpacing: CGFloat = 25.0
        static let cellInferitemSpacing: CGFloat = 20.0
        static let numberOfItemsInSection: Int = 6
        static let cellCornerRadius: CGFloat = 8.0
    }
    
    // MARK: - Private Properties
    
    private var hourlyForecast: [WeatherViewController.HourlyModel]?
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
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
        addSubview(collectionView)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CurrentInfoCollectionViewCell.self, forCellWithReuseIdentifier: CurrentInfoCollectionViewCell.identifier)
        collectionView.widthAnchor.constraint(equalToConstant: frame.width).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: frame.height).isActive = true
    }
    
    // MARK: - Public methods
    
    func passHourlyForecast(hourlyForecast: [WeatherViewController.HourlyModel]) {
        self.hourlyForecast = hourlyForecast
    }
}

// MARK: - UICollectionViewDelegate

extension CurrentCollectionViewCell: UICollectionViewDelegate {
}

// MARK: - UICollectionViewDataSource

extension CurrentCollectionViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Constants.numberOfItemsInSection
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CurrentInfoCollectionViewCell.identifier, for: indexPath) as? CurrentInfoCollectionViewCell
        else { return UICollectionViewCell() }
        cell.layer.cornerRadius = Constants.cellCornerRadius
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout

extension CurrentCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return Constants.cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return Constants.cellEdgeInsets
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.cellLineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.cellInferitemSpacing
    }
}
