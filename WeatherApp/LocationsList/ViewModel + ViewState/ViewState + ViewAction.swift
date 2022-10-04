//
//  ViewState + ViewAction.swift
//  WeatherApp
//
//  Created by Corjin, Valentin on 7/28/22.
//

import Foundation
import CoreLocation

enum WeatherData {
    enum DisplayEvent {
        case loading
        case dataLoaded([WeatherViewController.Model])
        case newLocationAdded([WeatherViewController.Model])
        case loadingError
    }
    
    enum ViewAction {
        case refresh
        case fetchMoreWeatherData
    }
}
