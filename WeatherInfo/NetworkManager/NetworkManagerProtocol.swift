//
//  NetworkManagerProtocol.swift
//  WeatherInfo
//
//  Created by Hemant Soni on 14/06/21.
//

import Foundation

protocol NetworkManagerProtocol {
    func fetchCurrentWeather(cityName: String, tempScale: TemperatureScale, completion: @escaping (WeatherModel?,  WeatherInfoError?) -> ())
    func fetchNextFiveWeatherForecast(city: String, completion: @escaping ([ForecastTemperature]?, WeatherInfoError?) -> ())
}
