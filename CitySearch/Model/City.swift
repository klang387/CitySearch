//
//  City.swift
//  CitySearch
//
//  Created by Kevin Langelier on 3/13/19.
//  Copyright © 2019 Kevin Langelier. All rights reserved.
//

import Foundation

class City: Decodable, CustomStringConvertible {
    var country: String
    var name: String
    var id: Int
    var latitude: Float
    var longitude: Float
    
    init(country: String, name: String, id: Int, latitude: Float, longitude: Float) {
        self.country = country
        self.name = name
        self.id = id
        self.latitude = latitude
        self.longitude = longitude
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        country = try values.decode(String.self, forKey: .country)
        name = try values.decode(String.self, forKey: .name)
        id = try values.decode(Int.self, forKey: .id)
        
        let coordinates = try values.nestedContainer(keyedBy: CoordinateKeys.self, forKey: .coordinates)
        latitude = try coordinates.decode(Float.self, forKey: .latitude)
        longitude = try coordinates.decode(Float.self, forKey: .longitude)
    }
    
    enum CodingKeys: String, CodingKey {
        case country
        case name
        case id = "_id"
        case coordinates = "coord"
    }
    
    enum CoordinateKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lon"
    }
    
    var description: String {
        return "\(name.capitalized), \(country.uppercased())"
    }
}
