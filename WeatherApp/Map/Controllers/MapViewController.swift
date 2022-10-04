//
//  MapViewController.swift
//  WeatherApp
//
//  Created by Corjin, Valentin on 7/21/22.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    private enum Constants {
        static let blurEffectViewCornerRadius: CGFloat = 8.0
        static let blurEffectViewTopAnchorPadding: CGFloat = 20.0
        static let blurEffectViewLeadingAnchorPadding: CGFloat = 20.0
        static let blurEffectViewWidth: CGFloat = 50.0
        static let blurEffectViewHeight: CGFloat = 30.0
    }
    
    // MARK: - Private Properties
    
    weak var delegate: MapViewDelegate?
    private let mapView = MKMapView()
    private let blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        blurEffectView.layer.cornerRadius = Constants.blurEffectViewCornerRadius
        blurEffectView.clipsToBounds = true
        return blurEffectView
    }()
    private let button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setTitle("OK", for: .normal)
        return button
    }()
    private var orderedAnnotations: [MKAnnotation] = []
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        focusCurrentLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateAnnotations()
    }
    
    // MARK: - Private methods
    
    private func setupView() {
        view.backgroundColor = .clear
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapView)
        mapView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        mapView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        mapView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        
        view.addSubview(blurEffectView)
        blurEffectView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.blurEffectViewTopAnchorPadding).isActive = true
        blurEffectView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Constants.blurEffectViewLeadingAnchorPadding).isActive = true
        blurEffectView.widthAnchor.constraint(equalToConstant: Constants.blurEffectViewWidth).isActive = true
        blurEffectView.heightAnchor.constraint(equalToConstant: Constants.blurEffectViewHeight).isActive = true
        
        blurEffectView.contentView.addSubview(button)
        button.centerYAnchor.constraint(equalTo: blurEffectView.centerYAnchor).isActive = true
        button.centerXAnchor.constraint(equalTo: blurEffectView.centerXAnchor).isActive = true
        button.widthAnchor.constraint(equalTo: blurEffectView.widthAnchor).isActive = true
        button.heightAnchor.constraint(equalTo: blurEffectView.widthAnchor).isActive = true
        button.addTarget(self, action: #selector(didPressButton(_:)), for: .touchUpInside)
    }
    
    private func focusCurrentLocation() {
        let list = delegate?.getCities()
        guard let list = list else { return }
        mapView.setRegion(MKCoordinateRegion(center: list[0].location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)), animated: false)
    }
    
    private func updateAnnotations() {
        mapView.removeAnnotations(mapView.annotations)
        let list = delegate?.getCities()
        guard let list = list else { return }
        for city in list {
            addCustomPin(for: city)
        }
    }
    
    private func addCustomPin(for model: MapViewController.Model) {
        let pin = MKPointAnnotation()
        pin.coordinate = model.location.coordinate
        pin.title = "Current temperature: \(model.currentTemp)°"
        pin.subtitle = "Max: \(model.maxTemp)°  Min: \(model.minTemp)°"
        orderedAnnotations.append(pin)
        mapView.addAnnotation(pin)
    }
    
    @objc private func didPressButton(_ sender: UIButton) {
        dismiss(animated: true)
    }
}

// MARK: - Model

extension MapViewController {
    struct Model {
        let location: CLLocation
        let currentTemp: Int
        let maxTemp: Int
        let minTemp: Int
        
        init() {
            self.location = CLLocation()
            self.currentTemp = 0
            self.maxTemp = 0
            self.minTemp = 0
        }
        
        init(location: CLLocation, currentTemp: Int, maxTemp: Int, minTemp: Int) {
            self.location = location
            self.currentTemp = currentTemp
            self.minTemp = minTemp
            self.maxTemp = maxTemp
        }
    }
}
