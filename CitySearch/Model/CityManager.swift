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
    var fullCityList: [City] = []
    var firstLetterMap: [Character:[City]] = [:]
    
    private enum CityImportError: Error {
        case invalidFilePath
    }
        
    func importCityJSON(completion: ((Error?)->Void)?) {
        DispatchQueue.global(qos: .default).async { [unowned self] in
            let bundle = Bundle(for: type(of: self))
            guard let path = bundle.path(forResource: "cities", ofType: "json") else { completion?(CityImportError.invalidFilePath); return }
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                let cityList = try JSONDecoder().decode([City].self, from: data)
                cityList.forEach {
                    self.cityTrie.insert(city: $0)
                }
                self.fullCityList = self.searchTrieForCitiesMatching(prefix: "")
                for char in "abcdefghijklmnopqrstuvwxyz" {
                    self.firstLetterMap[char] = self.searchTrieForCitiesMatching(prefix: String(char))
                }
                DispatchQueue.main.async {
                    completion?(nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion?(error)
                }
            }
        }
    }
    
    private func searchTrieForCitiesMatching(prefix: String) -> [City] {
        return cityTrie.matches(prefix:prefix)
    }
    
    func getCitiesMatching(prefix: String) -> [City] {
        if prefix.isEmpty {
            return fullCityList
        } else if prefix.count == 1, let char = prefix.lowercased().first {
            return firstLetterMap[char] ?? []
        } else {
            return searchTrieForCitiesMatching(prefix: prefix)
        }
    }
}
