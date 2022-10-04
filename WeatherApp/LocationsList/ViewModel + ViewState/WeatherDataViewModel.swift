//
//  WeatherDataViewModel.swift
//  WeatherApp
//
//  Created by Corjin, Valentin on 7/28/22.
//

import Foundation
import CoreLocation

final class WeatherDataViewModel: BindableStateViewModel<WeatherData.DisplayEvent, WeatherData.ViewAction> {
    
    // MARK: - Constants
    
    private enum Constants {
        static let dataCacheKey: String = "weather"
        static let settingsCacheKey: String = "weatherSettings"
    }
    
    // MARK: - Private Properties
    
    private let weather: Dynamic<[WeatherDataModel]> = Dynamic([])
    private let weatherDataCacheManager: WeatherDataCaching
    private let cachePolicy: CachePolicy
    private var weatherData: [WeatherViewController.Model] = []
    private var isCelsius: Bool = true
    private var weatherRepository: WeatherAPIRepository
    
    // MARK: - Lifecycle
    
    init(weatherRepository: WeatherAPIRepository,
         weatherDataCacheManager: WeatherDataCaching,
         cachePolicy: CachePolicy = WeatherOneHourCachePolicy()) {
        self.weatherRepository = weatherRepository
        self.weatherDataCacheManager = weatherDataCacheManager
        self.cachePolicy = cachePolicy
        super.init(initialEvent: .loading)
    }
    
    // MARK: - Public methods
    
    func loadLocalWeatherData(lat: Double, lon: Double) async -> WeatherViewController.Model? {
        do {
            guard let weather = try await weatherRepository.fetchWeatherData(lat: lat, lon: lon) else { return nil }
            guard var model = WeatherPresenter.mapWeather(weather) else { return nil }
            let cityName = try await weatherRepository.getCityName(lat: lat, lon: lon)
            model.cityName = cityName
            model.location = WeatherViewController.Location(lat: lat, lon: lon)
            return model
        } catch {
            let repoError = error as! RepositoryError
            switch repoError {
            case .apiError:
                displayEvent.value = .loadingError
            }
            return nil
        }
    }
    
    func loadWeatherData(for lat: Double, and lon: Double) async {
        guard let locationWeatherData = await loadLocalWeatherData(lat: lat, lon: lon) else { return }
        weatherData.append(locationWeatherData)
        await loadDataFromCache()
        loadSettingsFromCache()
        cacheWeatherData()
        displayEvent.value = .dataLoaded(prepareWeatherDataForView())
    }
    
    func addWeatherData(for address: String) async {
        do {
            let cityLocation = try await weatherRepository.getCityLocation(address: address)
            let weather = try await weatherRepository.fetchWeatherData(lat: cityLocation.coordinate.latitude, lon: cityLocation.coordinate.longitude)
            guard let weather = weather else { return }
            guard var model = WeatherPresenter.mapWeather(weather) else { return }
            let cityName = try await weatherRepository.getCityName(lat: cityLocation.coordinate.latitude, lon: cityLocation.coordinate.longitude)
            model.cityName = cityName
            model.location = WeatherViewController.Location(location: cityLocation)
            weatherData.append(model)
            cacheWeatherData()
            displayEvent.value = .newLocationAdded(prepareWeatherDataForView())
        } catch {
            let repoError = error as! RepositoryError
            switch repoError {
            case .apiError:
                displayEvent.value = .loadingError
            }
        }
    }
    
    func updateWeatherDatum(for model: WeatherViewController.Model) async {
        do {
            let weather = try await weatherRepository.fetchWeatherData(lat: model.location.lat, lon: model.location.lon)
            guard let weather = weather else { return }
            guard var updatedModel = WeatherPresenter.mapWeather(weather) else { return }
            updatedModel.location = model.location
            updatedModel.cityName = model.cityName
            replaceData(model, with: updatedModel)
            cacheWeatherData()
        } catch {
            let repoError = error as! RepositoryError
            switch repoError {
            case .apiError:
                displayEvent.value = .loadingError
            }
        }
    }
    
    func deleteWeatherData(at index: Int) {
        weatherData.remove(at: index)
        cacheWeatherData()
        if weatherData.count == 1 { weatherDataCacheManager.clear(cacheKey: Constants.dataCacheKey) }
        displayEvent.value = .dataLoaded(prepareWeatherDataForView())
    }
    
    func moveWeatherData(at sourceIndex: Int, to destinationIndex: Int) {
        let data = weatherData.remove(at: sourceIndex)
        weatherData.insert(data, at: destinationIndex)
        cacheWeatherData()
        displayEvent.value = .dataLoaded(prepareWeatherDataForView())
    }
    
    func convertToCelsius() {
        guard !isCelsius else {
            return
        }
        isCelsius = true
        weatherDataCacheManager.save([isCelsius], at: Constants.settingsCacheKey)
        displayEvent.value = .dataLoaded(prepareWeatherDataForView())
    }
    
    func convertToFahrenheit() {
        guard isCelsius else {
            return
        }
        isCelsius = false
        weatherDataCacheManager.save([isCelsius], at: Constants.settingsCacheKey)
        displayEvent.value = .dataLoaded(prepareWeatherDataForView())
    }
    
    // MARK: - Private methods
    
    private func loadDataFromCache() async {
        weatherData.append(contentsOf: weatherDataCacheManager.load(from: Constants.dataCacheKey))
        await updateWeatherData()
    }
    
    private func loadSettingsFromCache() {
        guard let temperatureSettings: Bool = weatherDataCacheManager.load(from: Constants.settingsCacheKey).first else { return }
        isCelsius = temperatureSettings
    }
    
    private func updateWeatherData() async {
        guard let currentLocationPage = weatherData.first else { return }
        for weatherDatum in weatherData {
            if weatherDatum.location != currentLocationPage.location {
                if cachePolicy.shouldUpdateData(weatherDatum) {
                    await updateWeatherDatum(for: weatherDatum)
                }
            }
        }
    }
        
    private func replaceData(_ data: WeatherViewController.Model, with newData: WeatherViewController.Model) {
        for (index, weatherDatum) in weatherData.enumerated() {
            if weatherDatum.location == data.location {
                weatherData[index] = newData
                break
            }
        }
    }
    
    private func prepareWeatherDataForView() -> [WeatherViewController.Model] {
        return isCelsius ? weatherData : weatherData.map { WeatherPresenter.convertToFahrenheit($0) }
    }

    private func cacheWeatherData() {
        var cachedData = weatherData
        cachedData.removeFirst()
        if !cachedData.isEmpty {
            weatherDataCacheManager.save(cachedData, at: Constants.dataCacheKey)
        }
    }
}

final class WeatherPresenter {
    
    static func fahrenheitToCelsius(_ temp: Int) -> Int {
        return Int(((Double(temp) - 32 ) / (9/5)).rounded())
    }
    
    static func celsiusToFahrenheit(_ temp: Int) -> Int {
        return Int((Double(temp) * (9/5) + 32).rounded())
    }
    
    static func convertTime(from unix: Int) -> Date {
        let time = TimeInterval(unix)
        let date = Date(timeIntervalSince1970: time)
        return date
    }
    
    static func convertTemp(from fahrenheit: Double) -> Int {
        return Int(((fahrenheit - 32) / (9/5)).rounded())
    }
    
    static func convertToFahrenheit(_ data: WeatherViewController.Model) -> WeatherViewController.Model {
        return WeatherViewController.Model(
            hourly: data.hourly.map {
                WeatherViewController.HourlyModel(
                    dt: $0.dt, sunrise: $0.sunset, sunset: $0.sunset, feelsLike: $0.feelsLike,
                    pressure: $0.pressure, humidity: $0.humidity, temp: celsiusToFahrenheit($0.temp),
                    dewPoint: $0.dewPoint, uvi: $0.uvi, clouds: $0.clouds, visibility: $0.visibility,
                    windSpeed: $0.windSpeed, windDeg: $0.windDeg)},
            cityName: data.cityName,
            daily: data.daily.map {
                WeatherViewController.DailyModel(
                    dt: $0.dt,
                    temp: WeatherViewController.TempModel(
                        day: celsiusToFahrenheit($0.temp.day),
                        min: celsiusToFahrenheit($0.temp.min),
                        max: celsiusToFahrenheit($0.temp.max),
                        night: celsiusToFahrenheit($0.temp.night),
                        eve: celsiusToFahrenheit($0.temp.eve),
                        morn: celsiusToFahrenheit($0.temp.morn)))},
            location: data.location, sunsetTime: data.sunsetTime)
    }
    
    static func mapHourly(_ hourly: Current) -> WeatherViewController.HourlyModel {
        return WeatherViewController.HourlyModel(
            dt: convertTime(from: hourly.dt), sunrise: hourly.sunrise, sunset: hourly.sunset,
            feelsLike: hourly.feelsLike, pressure: hourly.pressure, humidity: hourly.humidity,
            temp: convertTemp(from: hourly.temp), dewPoint: hourly.dewPoint, uvi: hourly.uvi,
            clouds: hourly.clouds, visibility: hourly.visibility, windSpeed: hourly.windSpeed,
            windDeg: hourly.windDeg)
    }
    
    static func mapDaily(_ daily: Daily) -> WeatherViewController.DailyModel {
        return WeatherViewController.DailyModel(
            dt: convertTime(from: daily.dt),
            temp: WeatherViewController.TempModel(
                day: convertTemp(from: daily.temp.day), min: convertTemp(from: daily.temp.min),
                max: convertTemp(from: daily.temp.max), night: convertTemp(from: daily.temp.night),
                eve: convertTemp(from: daily.temp.eve), morn: convertTemp(from: daily.temp.morn)))
    }
    
    static func mapWeather(_ weather: WeatherDataModel) -> WeatherViewController.Model? {
        guard let sunsetUNIX = weather.current.sunset else { return nil }
        return WeatherViewController.Model(hourly: weather.hourly.map {mapHourly($0)}, cityName: "", daily: weather.daily.map { mapDaily($0) }, location: WeatherViewController.Location(), sunsetTime: convertTime(from: sunsetUNIX))
    }
}
