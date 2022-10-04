//
//  IdleViewController.swift
//  WeatherApp
//
//  Created by Corjin, Valentin on 8/12/22.
//

import Foundation
import UIKit

class IdleViewController: UIViewController {
    
    private enum Constants {
        static let blurEffectViewCornerRadius: CGFloat = 8.0
        static let blurEffectViewTopAnchorPadding: CGFloat = 10
        static let blurEffectViewWidthMultiplier: CGFloat = 0.9
        static let titleLabelFontSize: CGFloat = 80.0
        static let titleLabelTopAnchorPadding: CGFloat = 15.0
        static let titleLabelHeight: CGFloat = 200.0
        static let titleLabelWidth: CGFloat = 400.0
        static let iconName: String = "wifi.slash"
        static let iconNameTopAnchorPadding: CGFloat = 50.0
        static let iconNameWidth: CGFloat = 120.0
        static let iconNameHeight: CGFloat = 100.0
        static let detailLabelFontSize: CGFloat = 26.0
        static let detailLabelTopAnchorPadding: CGFloat = 30.0
        static let detailLabelHeight: CGFloat = 100.0
    }
    
    // MARK: - Private Properties
    
    weak var delegate: IdleDelegate?
    private let blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        blurEffectView.layer.cornerRadius = Constants.blurEffectViewCornerRadius
        blurEffectView.clipsToBounds = true
        return blurEffectView
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: Constants.titleLabelFontSize)
        label.textAlignment = .center
        label.text = "--"
        return label
    }()
    private let iconView: UIImageView = {
        let icon = UIImageView(image: UIImage(systemName: Constants.iconName))
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.tintColor = .white
        return icon
    }()
    private let detailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: Constants.detailLabelFontSize)
        label.textAlignment = .center
        label.text = NSLocalizedString("Application Weather is not available", comment: "No internet connection")
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: - Private methods
    
    private func setupView() {
        view.backgroundColor = .clear
        
        view.addSubview(titleLabel)
        titleLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.titleLabelTopAnchorPadding).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: Constants.titleLabelHeight).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: Constants.titleLabelWidth).isActive = true
        
        view.addSubview(blurEffectView)
        blurEffectView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.blurEffectViewTopAnchorPadding).isActive = true
        blurEffectView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: Constants.blurEffectViewWidthMultiplier).isActive = true
        blurEffectView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        blurEffectView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        blurEffectView.contentView.addSubview(iconView)
        iconView.centerXAnchor.constraint(equalTo: blurEffectView.centerXAnchor).isActive = true
        iconView.topAnchor.constraint(equalTo: blurEffectView.topAnchor, constant: Constants.iconNameTopAnchorPadding).isActive = true
        iconView.widthAnchor.constraint(equalToConstant: Constants.iconNameWidth).isActive = true
        iconView.heightAnchor.constraint(equalToConstant: Constants.iconNameHeight).isActive = true
        
        blurEffectView.contentView.addSubview(detailLabel)
        detailLabel.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: Constants.detailLabelFontSize).isActive = true
        detailLabel.widthAnchor.constraint(equalTo: blurEffectView.widthAnchor).isActive = true
        detailLabel.heightAnchor.constraint(equalToConstant: Constants.detailLabelHeight).isActive = true
        detailLabel.centerXAnchor.constraint(equalTo: blurEffectView.centerXAnchor).isActive = true
        
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe))
        swipe.direction = .down
        view.addGestureRecognizer(swipe)
    }
    
    @objc private func didSwipe() {
        dismiss(animated: false)
        delegate?.retry()
    }
}
