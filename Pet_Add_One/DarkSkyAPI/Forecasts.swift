//
//  Forecast.swift
//  Forecaste
//
//  Created by CSC214 Instructor on 8/12/19.
//  Copyright © 2019 University of Rochester. All rights reserved.
//

import UIKit

// DarkSky api link: https://darksky.net/dev/docs

class Forecast: Decodable {
    var time: Int
    var summary: String
    var icon: String
}

class Daily: Decodable {
    enum CodingKeys: String, CodingKey {
        case summary, icon, data
    }
    
    var summary: String
    var icon: String
    var data: [Forecast]
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        summary = try container.decode(String.self, forKey: .summary)
        icon = try container.decode(String.self, forKey: .icon)
        data = try container.decode([Forecast].self, forKey: .data)
    }
}

class Forecasts: Decodable {
    enum CodingKeys: String, CodingKey {
        case latitude, longitude, timezone, daily
    }
    
    var latitude: Double
    var longitude: Double
    var timezone: String
    var daily: Daily
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        timezone = try container.decode(String.self, forKey: .timezone)
        latitude = try container.decode(Double.self, forKey: .latitude)
        longitude = try container.decode(Double.self, forKey: .longitude)
        daily = try container.decode(Daily.self, forKey: .daily)
    }
}
