//
//  DailyCollectionViewCell.swift
//  WeatherApp
//
//  Created by Corjin, Valentin on 7/14/22.
//

import UIKit

class DailyCollectionViewCell: UICollectionViewCell {
    static let identifier = "Daily"
    private enum Constants {
        static let blurEffectViewCornerRadius: CGFloat = 8.0
        static let cellHeight: CGFloat = 50.0
    }
    
    // MARK: - Private Properties
    
    private let blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        return blurEffectView
    }()
    
    private var dailyForecast: [WeatherViewController.DailyModel]? {
        didSet {
            collectionView.reloadData()
        }
    }
    
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
    
    convenience init(frame: CGRect, dailyForecast: [WeatherViewController.DailyModel]) {
        self.init(frame: frame)
        self.dailyForecast = dailyForecast
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
        collectionView.register(DailyInfoCollectionViewCell.self, forCellWithReuseIdentifier: DailyInfoCollectionViewCell.identifier)
        
        blurEffectView.contentView.addSubview(collectionView)
        
        collectionView.widthAnchor.constraint(equalTo: blurEffectView.widthAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalTo: blurEffectView.heightAnchor).isActive = true
    }
    
    // MARK: - Public methods
    
    func passDailyForecast(dailyForecast: [WeatherViewController.DailyModel]) {
        self.dailyForecast = dailyForecast
    }
}

// MARK: - UICollectionViewDelegate

extension DailyCollectionViewCell: UICollectionViewDelegate {
}

// MARK: - UICollectionViewDataSource

extension DailyCollectionViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DailyInfoCollectionViewCell.identifier, for: indexPath) as? DailyInfoCollectionViewCell
        else { return UICollectionViewCell() }
        let daily = dailyForecast?[indexPath.item]
        guard let daily = daily else { return cell }
        let date = daily.dt
        let temp = daily.temp.day
        let data = DailyInfoCollectionViewCell.Model(date: date, temp: temp)
        cell.configure(data: data)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension DailyCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width, height: Constants.cellHeight)
    }
}
