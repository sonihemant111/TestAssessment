//
//  StringExtensionTest.swift
//  WeatherInfoTests
//
//  Created by Hemant Soni on 14/06/21.
//

import XCTest
@testable import WeatherInfo

class StringExtensionTest: XCTestCase {
    
    func testRemovedStrippedCharacter() {
        let city = "Jodhpur~"
        print(city.stripped)
        XCTAssertEqual(city.stripped, "Jodhpur", "Stripped cityName must be Jodhpur")
    }
}
