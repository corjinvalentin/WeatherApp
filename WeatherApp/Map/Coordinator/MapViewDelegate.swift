//
//  MapViewDelegate.swift
//  WeatherApp
//
//  Created by Corjin, Valentin on 7/26/22.
//

import Foundation
import CoreLocation

protocol MapViewDelegate: AnyObject {
    func getCities() -> [MapViewController.Model]
}
