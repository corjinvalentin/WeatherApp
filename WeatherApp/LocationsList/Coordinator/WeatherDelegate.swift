//
//  WeatherProtocol.swift
//  WeatherApp
//
//  Created by Corjin, Valentin on 7/22/22.
//

import Foundation
import CoreLocation

protocol WeatherDelegate: AnyObject {
    func addWeatherPage(with address: String)
    func selectWeatherPage(at index: Int)
    func passData(for index: Int) -> (cityName: String, hourlyForecast: [WeatherViewController.HourlyModel], temperature: WeatherViewController.TempModel)?
    func passCVData(for location: WeatherViewController.Location) -> WeatherViewController.Model?
    func moveItem(at sourceIndex: Int, to destinationIndex: Int)
    func getNumberOfPages() -> Int
    func removePage(at index: Int)
    func convertToCelsius()
    func convertToFahrenheit()
}
