//
//  MainViewController.swift
//  WeatherApp
//
//  Created by Corjin, Valentin on 7/15/22.
//
import CoreLocation
import UIKit

class WeatherPageViewController: UIPageViewController {
    
    private enum Constants {
        static let rightButtonIconName: String = "list.bullet"
        static let leftButtonIconName: String = "map.fill"
        static let locationIconName: String = "location.fill"
    }
    
    // MARK: - Private Properties
    
    private var pages = [UIViewController]()
    private let tab = UITabBar()
    private let rightButton = UIButton()
    private let leftButton = UIButton()
    private let pageControl = UIPageControl()
    private let initialPage = 0
    private let searchController = SearchViewController()
    private let mapController = MapViewController()
    private let locationManager = CLLocationManager()
    private var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
    private var viewModel: WeatherDataViewModel
    private var weatherData: [WeatherViewController.Model] = []
    weak var rootDelegate: RootDelegate?
    
    // MARK: - Lifecycle
    
    init(viewModel: WeatherDataViewModel) {
        self.viewModel = viewModel
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
        
        setupLocationManager()
    }
    
    // MARK: - Private methods
    
    private func bindToViewState(lat: Double, lon: Double) {
        viewModel.displayEvent.bind { [weak self] event in
            guard let self = self else { return }
            switch event {
            case .loading:
                Task {
                    await MainActor.run {
                        self.activityIndicator.startAnimating()
                    }
                    await self.viewModel.loadWeatherData(for: lat, and: lon)
                }
            case .dataLoaded(let data):
                if self.weatherData.isEmpty {
                    self.weatherData = data
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                        self.setupView()
                    }
                } else {
                    self.weatherData = data
                }
            case .newLocationAdded(let data):
                self.weatherData = data
                guard let newPageData = self.weatherData.last else { return }
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.addNewPage(with: newPageData)
                }
            case .loadingError:
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.present(UIAlertController.alert(completionRetry: self.retry, completionIdle: self.loadIdlePage),
                                 animated: true, completion: nil)
                }
            }
        }
    }
    
    private func setupView() {
        setup()
        style()
        layout()
    }
    
    private func setup() {
        
        dataSource = self
        delegate = self
        
        searchController.weatherDelegate = self
        searchController.modalPresentationStyle = .fullScreen
        searchController.modalTransitionStyle = .crossDissolve
        
        mapController.delegate = self
        mapController.modalPresentationStyle = .fullScreen
        
        guard let defaultSunsetTime = Calendar.current.date(bySettingHour: 18, minute: 0, second: 0, of: Date()) else { return }
        rootDelegate?.passSunsetTime(weatherData.isEmpty ? defaultSunsetTime : weatherData[0].sunsetTime)
        loadPagesWithData()
        
        pageControl.addTarget(self, action: #selector(didPressPageControl(_:)), for: .valueChanged)
        
        rightButton.addTarget(self, action: #selector(didPressListButton(_:)), for: .touchUpInside)
        leftButton.addTarget(self, action: #selector(didPressMapButton(_:)), for: .touchUpInside)
    }
    
    private func style() {
        view.backgroundColor = .clear
        
        rightButton.backgroundColor = .clear
        rightButton.setImage(UIImage(systemName: Constants.rightButtonIconName), for: .normal)
        rightButton.tintColor = .systemGray
        rightButton.imageView?.contentMode = .scaleAspectFit
        
        leftButton.backgroundColor = .clear
        leftButton.setImage(UIImage(systemName: Constants.leftButtonIconName), for: .normal)
        leftButton.tintColor = .systemGray
        leftButton.imageView?.contentMode = .scaleAspectFit
        
        tab.translatesAutoresizingMaskIntoConstraints = false
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        leftButton.translatesAutoresizingMaskIntoConstraints = false
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.currentPageIndicatorTintColor = .systemGray
        pageControl.pageIndicatorTintColor = .systemBackground
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = initialPage
        pageControl.setIndicatorImage(UIImage(systemName: Constants.locationIconName), forPage: 0)
    }
    
    private func layout() {
        view.addSubview(tab)
        tab.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tab.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        tab.addSubview(pageControl)
        pageControl.widthAnchor.constraint(equalTo: tab.widthAnchor).isActive = true
        pageControl.heightAnchor.constraint(equalToConstant: 20).isActive = true
        pageControl.centerYAnchor.constraint(equalTo: tab.centerYAnchor).isActive = true
        
        tab.addSubview(rightButton)
        rightButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        rightButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        rightButton.centerYAnchor.constraint(equalTo: tab.centerYAnchor).isActive = true
        rightButton.trailingAnchor.constraint(equalTo: tab.trailingAnchor, constant: -25).isActive = true
        
        tab.addSubview(leftButton)
        leftButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        leftButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        leftButton.centerYAnchor.constraint(equalTo: tab.centerYAnchor).isActive = true
        leftButton.leadingAnchor.constraint(equalTo: tab.leadingAnchor, constant: 25).isActive = true
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        let authorizationStatus = locationManager.authorizationStatus
        if authorizationStatus == CLAuthorizationStatus.notDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else {
            locationManager.requestLocation()
            locationManager.startUpdatingLocation()
        }
    }
        
    private func addNewPage(with data: WeatherViewController.Model) {
        let newLocation = WeatherViewController(weatherData: data)
        newLocation.delegate = self
        pages.append(newLocation)
        pageControl.numberOfPages = pages.count
        let lastPage = pages.count - 1
        setViewControllers([pages[lastPage]], direction: .forward, animated: true, completion: nil)
        pageControl.currentPage = lastPage
    }
    
    private func loadPagesWithData() {
        for weatherDatum in weatherData {
            let newLocation = WeatherViewController(weatherData: weatherDatum)
            newLocation.delegate = self
            pages.append(newLocation)
            pageControl.numberOfPages = pages.count
        }
        setViewControllers([pages[initialPage]], direction: .forward, animated: true, completion: nil)
    }
    
    private func loadIdlePage() {
        let idlePage = IdleViewController()
        idlePage.delegate = self
        idlePage.modalPresentationStyle = .fullScreen
        present(idlePage, animated: false)
    }
    
    @objc private func didPressPageControl(_ sender: UIPageControl) {
        let newPage = sender.currentPage
        setViewControllers([pages[newPage]], direction: .forward, animated: true, completion: nil)
    }
    
    @objc private func didPressListButton(_ sender: UIButton) {
        present(searchController, animated: true, completion: nil)
    }
    
    @objc private func didPressMapButton(_ sender: UIButton) {
        present(mapController, animated: true, completion: nil)
    }
}

// MARK: - UIPageViewControllerDelegate

extension WeatherPageViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        guard let viewControllers = pageViewController.viewControllers else { return }
        guard let currentIndex = pages.firstIndex(of: viewControllers[0]) else { return }
        
        pageControl.currentPage = currentIndex
    }
}

// MARK: - UIPageViewControllerDataSource

extension WeatherPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
        
        if currentIndex == 0 {
            return nil
        } else {
            return pages[currentIndex - 1]
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }

        if currentIndex < pages.count - 1 {
            return pages[currentIndex + 1]
        } else {
            return nil
        }
    }
}

// MARK: - CLLocationManagerDelegate

extension WeatherPageViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        bindToViewState(lat: location.coordinate.latitude, lon: location.coordinate.longitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

// MARK: - WeatherDelegate

extension WeatherPageViewController: WeatherDelegate {
    func removePage(at index: Int) {
        pages.remove(at: index)
        pageControl.numberOfPages = pages.count
        viewModel.deleteWeatherData(at: index)
    }
    
    func moveItem(at sourceIndex: Int, to destinationIndex: Int) {
        let page = pages.remove(at: sourceIndex)
        pages.insert(page, at: destinationIndex)
        viewModel.moveWeatherData(at: sourceIndex, to: destinationIndex)
    }
    
    func getNumberOfPages() -> Int {
        return pages.count
    }
    
    func passData(for index: Int) -> (cityName: String, hourlyForecast: [WeatherViewController.HourlyModel], temperature: WeatherViewController.TempModel)? {
        let data = weatherData[index]
        let cityName = data.cityName
        let hourly = data.hourly
        let daily = data.daily.first?.temp
        guard let dailyTemp = daily else { return nil }
        return (cityName: cityName, hourlyForecast: hourly, temperature: dailyTemp)
    }
    
    func passCVData(for location: WeatherViewController.Location) -> WeatherViewController.Model? {
        for datum in weatherData {
            if datum.location == location {
               return datum
            }
        }
        return nil
    }
    
    func selectWeatherPage(at index: Int) {
        var pageIndex = 0
        while pageIndex <= index {
            setViewControllers([pages[pageIndex]], direction: .forward, animated: true, completion: nil)
            pageIndex += 1
        }
        pageControl.currentPage = index
    }
    
    func addWeatherPage(with address: String) {
        setViewControllers([pages[pages.count-1]], direction: .forward, animated: true, completion: nil)
        activityIndicator.startAnimating()
        Task {
            await viewModel.addWeatherData(for: address)
        }
    }
    
    func convertToCelsius() {
        viewModel.convertToCelsius()
    }
    
    func convertToFahrenheit() {
        viewModel.convertToFahrenheit()
    }
}

// MARK: - MapViewDelegate

extension WeatherPageViewController: MapViewDelegate {
    
    func getCities() -> [MapViewController.Model] {
        return weatherData.map { MapViewController.Model(location: CLLocation(latitude: $0.location.lat, longitude: $0.location.lon),
                                                             currentTemp: $0.hourly[0].temp,
                                                             maxTemp: $0.daily[0].temp.max,
                                                             minTemp: $0.daily[0].temp.min)
        }
    }
}

// MARK: - IdleDelegate

extension WeatherPageViewController: IdleDelegate {
    
    func retry() {
        setupLocationManager()
        viewModel.displayEvent.value = .loading
    }
}

// MARK: - UIAlertController

extension UIAlertController {
    static func alert(completionRetry: @escaping () -> Void, completionIdle: @escaping () -> Void) -> UIAlertController {
        let alert = UIAlertController(title: "Error", message: "Try again", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
            alert.dismiss(animated: true, completion: completionIdle)
        }))
        alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { _ in
            alert.dismiss(animated: true, completion: completionRetry)
        }))
        return alert
    }
}
