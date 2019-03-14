//
//  CitySearchTests.swift
//  CitySearchTests
//
//  Created by Kevin Langelier on 3/13/19.
//  Copyright © 2019 Kevin Langelier. All rights reserved.
//

import XCTest
@testable import CitySearch

class CitySearchTests: XCTestCase {

    func testLoadingCitiesFromJSON() {
        let expectation = self.expectation(description: "loadingFromJSON")
        var errorCheck: Error?
        let manager = CityManager()
        manager.importCityJSON(completion: { (error) in
            errorCheck = error
            expectation.fulfill()
        })
        waitForExpectations(timeout: 60, handler: nil)
        XCTAssertNil(errorCheck)
    }
    
    func testCityDecoding() {
        let json: [[String:Any]] = [
            ["country":"UA","name":"Hurzuf","_id":707860,"coord":["lon":34.283333,"lat":44.549999]],
            ["country":"RU","name":"Novinki","_id":519188,"coord":["lon":37.666668,"lat":55.683334]],
            ["country":"NP","name":"Gorkhā","_id":1283378,"coord":["lon":84.633331,"lat":28]],
            ["country":"IN","name":"State of Haryāna","_id":1270260,"coord":["lon":76,"lat":29]],
            ["country":"UA","name":"Holubynka","_id":708546,"coord":["lon":33.900002,"lat":44.599998]]
        ]
        do {
            let data = try JSONSerialization.data(withJSONObject: json, options: [])
            let cityList = try JSONDecoder().decode([City].self, from: data)
            let expectedCount = json.count
            XCTAssertEqual(expectedCount, cityList.count)
            for i in 0..<json.count {
                guard let name = json[i]["name"] as? String,
                        let country = json[i]["country"] as? String,
                        let coordinates = json[i]["coord"] as? [String:Any],
                        let latitude = (coordinates["lat"] as? NSNumber)?.floatValue,
                        let longitude = (coordinates["lon"] as? NSNumber)?.floatValue else { XCTFail(); return }
                    
                XCTAssertEqual(cityList[i].name, name)
                XCTAssertEqual(cityList[i].country, country)
                XCTAssertEqual(cityList[i].latitude, latitude)
                XCTAssertEqual(cityList[i].longitude, longitude)
            }
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testTrieInsertionAndRetrieval() {
        let cities: [City] = [
            City(country: "US", name: "Boston", id: 1, latitude: 12, longitude: 12),
            City(country: "US", name: "Boise", id: 2, latitude: 12, longitude: 12),
            City(country: "US", name: "Bostonia", id: 3, latitude: 12, longitude: 12),
            City(country: "US", name: "New York", id: 4, latitude: 12, longitude: 12),
            City(country: "US", name: "New Orleans", id: 5, latitude: 12, longitude: 12)
        ]
        let trie = Trie()
        cities.forEach {
            trie.insert(city: $0)
        }
        XCTAssertEqual(trie.matches(prefix: "Boi").first?.name ?? "", "Boise")
        XCTAssertEqual(trie.matches(prefix: "Bo").count, 3)
        XCTAssertEqual(trie.matches(prefix: "new").count, 2)
        XCTAssertEqual(trie.matches(prefix: "").count, 5)
        XCTAssertEqual(trie.matches(prefix: "@").count, 0)
    }

}
