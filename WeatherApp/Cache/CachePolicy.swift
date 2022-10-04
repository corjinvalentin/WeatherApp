//
//  CachePolicy.swift
//  WeatherApp
//
//  Created by Corjin, Valentin on 8/10/22.
//

import Foundation

protocol CachePolicy {
    func shouldUpdateData(_ data: WeatherViewController.Model) -> Bool
}

final class WeatherOneHourCachePolicy: CachePolicy {
    func shouldUpdateData(_ data: WeatherViewController.Model) -> Bool {
        guard let cachedTime = data.hourly.first?.dt else { return false }
        if cachedTime.timeIntervalSinceNow <= -3600 {
            return true
        }
        return false
    }
}
