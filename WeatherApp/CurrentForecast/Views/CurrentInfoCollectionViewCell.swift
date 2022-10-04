//
//  CustomInfoCollectionViewCell.swift
//  WeatherApp
//
//  Created by Corjin, Valentin on 7/14/22.
//

import UIKit

class CurrentInfoCollectionViewCell: UICollectionViewCell {
    static let identifier = "CurrentCollectionViewCell22222222"
    private enum Constants {
        static let blurEffectViewCornerRadius: CGFloat = 8.0
    }
    
    // MARK: - Private Properties
    
    private let blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        return blurEffectView
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
        
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        blurEffectView.layer.cornerRadius = Constants.blurEffectViewCornerRadius
        blurEffectView.clipsToBounds = true
        
        contentView.addSubview(blurEffectView)
        blurEffectView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        blurEffectView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        blurEffectView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        blurEffectView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        blurEffectView.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
    }
}
