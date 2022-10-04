//
//  WeatherRepository.swift
//  WeatherApp
//
//  Created by Corjin, Valentin on 7/27/22.
//

import Foundation
import CoreLocation

enum RepositoryError: Error {
    case apiError
}

final class WeatherAPIRepository {
    
    private let weatherAPIService: WeatherAPIService
    
    init(weatherService: WeatherAPIService) {
        self.weatherAPIService = weatherService
    }

    public func fetchWeatherData(lat: Double, lon: Double) async throws -> WeatherDataModel? {
        let url = APIModel.getURL(lat: lat, lon: lon)
        do {
            return try await weatherAPIService.getWeatherData(url: url)
        } catch {
            throw RepositoryError.apiError
        }
    }
    
    public func getCityName(lat: Double, lon: Double) async throws -> String {
        let location = CLLocation(latitude: lat, longitude: lon)
        do {
            let placemarks = try await CLGeocoder().reverseGeocodeLocation(location)
            let cityName = placemarks.first(where: { placemark in
                placemark.locality != nil
            })?.locality ?? ""
            return cityName
        } catch {
            throw RepositoryError.apiError
        }
    }
    
    public func getCityLocation(address: String) async throws -> CLLocation {
        do {
            let placemarkers = try await CLGeocoder().geocodeAddressString(address)
            let location = placemarkers.first(where: { placemark in
                placemark.location != nil
            })?.location ?? CLLocation()
            return location
        } catch {
            throw RepositoryError.apiError
        }
    }
}
