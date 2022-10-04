//
//  APIModel.swift
//  WeatherApp
//
//  Created by Corjin, Valentin on 7/12/22.
//

import Foundation

class APIModel {
    private static let key = "2a0bd1f415c2aff8a0cb9c66da030efa"
    
    static func getURL(lat: Double, lon: Double) -> URL {
        let url = URL(string:
                        "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(lon)&units=imperial&exclude=minutely,alerts&appid=\(self.key)")
        return url!
    }
}
