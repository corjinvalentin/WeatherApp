//
//  WeatherDataModel.swift
//  WeatherApp
//
//  Created by Corjin, Valentin on 7/12/22.
//

import Foundation

struct WeatherDataModel: Codable {
    let lat, lon: Double
    let timezone: String
    let timezoneOffset: Int
    let current: Current
    let hourly: [Current]
    let daily: [Daily]
    
    enum CodingKeys: String, CodingKey {
        case lat, lon, timezone
        case timezoneOffset = "timezone_offset"
        case current, hourly, daily
    }
}

// MARK: - Current
struct Current: Codable {
    let dt: Int
    let sunrise, sunset: Int?
    let temp, feelsLike: Double
    let pressure, humidity: Int
    let dewPoint, uvi: Double
    let clouds, visibility: Int
    let windSpeed: Double
    let windDeg: Int
    let weather: [Weather]
    let windGust: Double?
    let pop: Double?
    
    enum CodingKeys: String, CodingKey {
        case dt, sunrise, sunset, temp
        case feelsLike = "feels_like"
        case pressure, humidity
        case dewPoint = "dew_point"
        case uvi, clouds, visibility
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case weather
        case windGust = "wind_gust"
        case pop
    }
}

// MARK: - Weather
struct Weather: Codable {
    let id: Int
    let main: String
    let weatherDescription: String
    let icon: String
    
    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
}

// MARK: - Daily
struct Daily: Codable {
    let dt, sunrise, sunset, moonrise: Int
    let moonset: Int
    let moonPhase: Double
    let temp: Temp
    let feelsLike: FeelsLike
    let pressure, humidity: Int
    let dewPoint, windSpeed: Double
    let windDeg: Int
    let windGust: Double
    let weather: [Weather]
    let clouds: Int
    let pop, uvi: Double
    let rain: Double?
    
    enum CodingKeys: String, CodingKey {
        case dt, sunrise, sunset, moonrise, moonset
        case moonPhase = "moon_phase"
        case temp
        case feelsLike = "feels_like"
        case pressure, humidity
        case dewPoint = "dew_point"
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case windGust = "wind_gust"
        case weather, clouds, pop, uvi, rain
    }
}

// MARK: - FeelsLike
struct FeelsLike: Codable {
    let day, night, eve, morn: Double
}

// MARK: - Temp
struct Temp: Codable {
    let day, min, max, night: Double
    let eve, morn: Double
}
