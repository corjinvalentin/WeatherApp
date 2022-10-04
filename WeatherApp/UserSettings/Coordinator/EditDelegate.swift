//
//  EditDelegate.swift
//  WeatherApp
//
//  Created by Corjin, Valentin on 7/25/22.
//

import Foundation

protocol EditDelegate: AnyObject {
    func startEditing()
    func convertToCelsius()
    func convertToFahrenheit()
}
