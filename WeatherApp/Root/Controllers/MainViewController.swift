//
//  MainView.swift
//  WeatherApp
//
//  Created by Corjin, Valentin on 7/18/22.
//

import UIKit

class MainViewController: UIViewController {
    
    private enum BackgroundConstants {
        static let day = "day"
        static let night = "night"
    }
    
    // MARK: - Private Properties
    
    private let viewModel = WeatherDataViewModel(weatherRepository: WeatherAPIRepository(weatherService: WeatherAPIService()),
                                                 weatherDataCacheManager: WeatherDataCacheManager())
    private var pageVC: WeatherPageViewController?
    private let backgroundView = UIImageView()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    // MARK: - Private methods
    
    private func setup() {
        pageVC = WeatherPageViewController(viewModel: viewModel)
        pageVC?.rootDelegate = self
        guard let pageVC = pageVC else { return }

        view.addSubview(backgroundView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundView.image = UIImage(named: BackgroundConstants.day)
        backgroundView.contentMode = .scaleAspectFill
        backgroundView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        backgroundView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true

        view.addSubview(pageVC.view)
    }
}

extension MainViewController: RootDelegate {
    func passSunsetTime(_ sunsetTime: Date) {
        backgroundView.image = Date.now < sunsetTime ? UIImage(named: BackgroundConstants.day) : UIImage(named: BackgroundConstants.night)
    }
}
