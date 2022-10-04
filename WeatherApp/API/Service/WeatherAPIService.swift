//
//  WebService.swift
//  WeatherApp
//
//  Created by Corjin, Valentin on 7/13/22.
//

import Foundation

enum WeatherError: Error {
    case invalidServerResponse
}

class WeatherAPIService {
    
    func getWeatherData(url: URL) async throws -> WeatherDataModel {
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw WeatherError.invalidServerResponse
        }
        
        return try JSONDecoder().decode(WeatherDataModel.self, from: data)
    }
}
