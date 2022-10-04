//
//  CacheManager.swift
//  WeatherApp
//
//  Created by Corjin, Valentin on 8/3/22.
//

import Foundation

protocol WeatherDataCaching {
    func save<T: Codable>(_ data: [T], at cacheKey: String)
    func load<T: Codable>(from cacheKey: String) -> [T]
    func clear(cacheKey: String)
}

final class WeatherDataCacheManager: WeatherDataCaching {
    
    internal func save<T: Codable>(_ data: [T], at cacheKey: String) {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(cacheKey)
        if let encodedData = try? JSONEncoder().encode(data) {
            try? encodedData.write(to: path)
        }
    }
    
    internal func load<T: Codable>(from cacheKey: String) -> [T] {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(cacheKey)
        guard
            let cacheData = try? Data(contentsOf: path),
            let savedData = try? JSONDecoder().decode([T].self, from: cacheData)
        else { return [] }
        return savedData
    }
    
    internal func clear(cacheKey: String) {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(cacheKey)
        try? FileManager.default.removeItem(at: path)
    }
}
