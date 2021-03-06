//
//  WeatherViewModelTest.swift
//  WeatherInfoTests
//
//  Created by Hemant Soni on 14/06/21.
//

import XCTest
@testable import WeatherInfo

class WeatherViewModelTest: XCTestCase {
    private var expectation = XCTestExpectation()
    private var weatherViewModel = WeatherViewModel()
    
    override func setUpWithError() throws {
        let urlManager = URLManager()
        let url1 = URL(string: urlManager.getURLToFetchWeatherOfCity(city: "Jodhpur", tempUnit: TemperatureScale.getUserSavedSettingTempUnitType().rawValue))

        let url2 = URL(string: urlManager.getURLToFetchWeatherOfCity(city: "Jaipur", tempUnit: TemperatureScale.getUserSavedSettingTempUnitType().rawValue))
        
        URLProtocolMock.testURLs = [url1! : "WeatherData", url2! : "EmptyWeather"]
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolMock.self]
        let session = URLSession(configuration: config)
        NetworkManager.main.setMockSession(session: session)
    }
        
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        URLProtocolMock.clearMock()
    }
    
    func testGetCityWeatherPositive() throws {
        // prepare weatherViewModel
        var weatherData = WeatherModel()
        weatherData.cityID = 4163971
        weatherData.name = "Jodhpur"
        weatherViewModel.weatherData = weatherData
        weatherViewModel.indexPath = IndexPath(row: 0, section: 0)
        weatherViewModel.delegate = self

        expectation = self.expectation(description: "Success Test")
        // We will get the weather data as we have mock the session with proper weather in json named WeatherData
        weatherViewModel.getWeatherData()
        waitForExpectations(timeout: 10)
    }
    
    func testGetCityWeatherNegative() throws {
        // prepare weatherViewModel
        var weatherData = WeatherModel()
        weatherData.cityID = 4163973
        weatherData.name = "Jaipur"
        weatherViewModel.weatherData = weatherData
        weatherViewModel.indexPath = IndexPath(row: 0, section: 0)
        weatherViewModel.delegate = self

        expectation = self.expectation(description: "Success Test")
        // We will not get weather data as we have mock the session with out weather data in json named EmptyWeather
        weatherViewModel.getWeatherData()
        waitForExpectations(timeout: 10)
    }
}

extension WeatherViewModelTest: WeatherViewModelProtocol {
    func didFailWithError(_ indexPath: IndexPath, _ error: WeatherInfoError) {
        print(error.rawValue)
        expectation.fulfill()
    }
    
    func didReceiveTemperatureData(_ indexPath: IndexPath) {
        XCTAssertNotEqual(weatherViewModel.temperature, "", "temperature should not be empty")
        XCTAssertEqual(weatherViewModel.cityName, "Jodhpur", "city name should be Jodhpur")
        XCTAssertEqual(weatherViewModel.countryName, "In", "Country name must be IN")
        XCTAssertEqual(weatherViewModel.cityID, 4163971,"city ID must be 4163971")
        
        if let settingsModel = UserDefaults.standard.getUserSavedSettings() {
            if settingsModel.tempUnit == "Celsius" {
                XCTAssertEqual(weatherViewModel.temperature, "83.28???", "Country name must be IN")
                XCTAssertEqual(weatherViewModel.maxTemperature, "83.28???", "Country name must be IN")
                XCTAssertEqual(weatherViewModel.minTemperature, "83.28???", "Country name must be IN")
            } else {
                XCTAssertEqual(weatherViewModel.temperature, "83.28???", "Country name must be IN")
                XCTAssertEqual(weatherViewModel.maxTemperature, "83.28???", "Country name must be IN")
                XCTAssertEqual(weatherViewModel.minTemperature, "83.28???", "Country name must be")
            }
        }
        
        expectation.fulfill()
    }
}
