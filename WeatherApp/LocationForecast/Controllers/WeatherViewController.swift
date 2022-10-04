//
//  NewWeatherViewController.swift
//  WeatherApp
//
//  Created by Corjin, Valentin on 7/21/22.
//

import CoreLocation
import UIKit

class WeatherViewController: UIViewController {

    private enum Constants {
        static let collectionViewCornerRadius: CGFloat = 8.0
        static let collectionViewWidthPadding: CGFloat = -50.0
        static let collectionViewHeightMultiplier: CGFloat = 1.7
        static let headerViewWidthPadding: CGFloat = -50.0
        static let headerViewHeight: CGFloat = 200.0
    }
    
    // MARK: - Private Properties
    
    private var collectionView: UICollectionView?
    weak var delegate: WeatherDelegate?
    private var headerView: HeaderView
    private var weatherData: WeatherViewController.Model
    
    // MARK: - Lifecycle
    
    init(weatherData: WeatherViewController.Model) {
        self.weatherData = weatherData
        self.headerView = HeaderView()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        style()
        layout()
        setupHeader()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView?.reloadData()
        setupHeader()
    }
    
    // MARK: - Private methods
        
    private func setup() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.register(WrapperCollectionViewCell.self, forCellWithReuseIdentifier: WrapperCollectionViewCell.identifier)
    }
    
    private func style() {
        view.backgroundColor = .clear
        collectionView?.layer.cornerRadius = Constants.collectionViewCornerRadius
        collectionView?.backgroundColor = .clear
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.translatesAutoresizingMaskIntoConstraints = false
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.backgroundColor = .clear
    }
    
    private func layout() {
        view.addSubview(headerView)
        headerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: Constants.headerViewWidthPadding).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: Constants.headerViewHeight).isActive = true
        headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        headerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(collectionView!)
        collectionView?.topAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        collectionView?.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView?.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView?.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        collectionView?.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        guard let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        layout.sectionHeadersPinToVisibleBounds = true
    }
    
    private func setupHeader() {
        guard let data = delegate?.passCVData(for: weatherData.location) else { return }
        guard let daily = data.daily.first?.temp else { return }
        let model = HeaderView.Model(hourly: data.hourly, cityName: weatherData.cityName, daily: daily)
        headerView.passModel(model: model)
    }
}

// MARK: - UICollectionViewDelegate

extension WeatherViewController: UICollectionViewDelegate {
}

// MARK: - UICollectionViewDataSource

extension WeatherViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WrapperCollectionViewCell.identifier, for: indexPath) as? WrapperCollectionViewCell
        else { return UICollectionViewCell() }
        guard let data = delegate?.passCVData(for: weatherData.location) else { return UICollectionViewCell() }
        cell.passWeather(weather: data)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension WeatherViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width + Constants.collectionViewWidthPadding,
                      height: view.frame.height * Constants.collectionViewHeightMultiplier)
    }
}

// MARK: - Model

extension WeatherViewController {
    struct Model: Codable {
        let hourly: [HourlyModel]
        var cityName: String
        let daily: [DailyModel]
        var location: Location
        let sunsetTime: Date
    }
    
    struct HourlyModel: Codable {
        let dt: Date
        let sunrise, sunset: Int?
        let feelsLike: Double
        let pressure, humidity, temp: Int
        let dewPoint, uvi: Double
        let clouds, visibility: Int
        let windSpeed: Double
        let windDeg: Int
    }
    
    struct DailyModel: Codable {
        let dt: Date
        let temp: TempModel
    }
    
    struct TempModel: Codable {
        let day, min, max, night: Int
        let eve, morn: Int
    }
    
    struct Location: Codable, Equatable {
        let lat: Double
        let lon: Double
        
        init(location: CLLocation) {
            self.lat = location.coordinate.latitude
            self.lon = location.coordinate.longitude
        }
        
        init(lat: Double, lon: Double) {
            self.lat = lat
            self.lon = lon
        }
        
        init() {
            self.lon = 0
            self.lat = 0
        }
    }
}
