//
//  CityManager.swift
//  CitySearch
//
//  Created by Kevin Langelier on 3/13/19.
//  Copyright © 2019 Kevin Langelier. All rights reserved.
//

import Foundation

class CityManager {
    static let shared = CityManager()
    private let cityTrie = Trie()
    
    private enum CityImportError: Error {
        case invalidFilePath
    }
        
    func importCityJSON(completion: ((Error?)->Void)?) {
        let bundle = Bundle(for: type(of: self))
        guard let path = bundle.path(forResource: "cities", ofType: "json") else { completion?(CityImportError.invalidFilePath); return }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
            let cities = try JSONDecoder().decode([City].self, from: data)
            cities.forEach {
                cityTrie.insert(city: $0)
            }
            print(cityTrie.matches(prefix: "Bos").map({ $0.description }))
            print(cityTrie.matches(prefix: "New").map({ $0.description }))
        } catch {
            completion?(error)
        }
    }
    
    func getCitiesMatching(prefix: String) -> [City] {
        return cityTrie.matches(prefix:prefix)
    }
}
