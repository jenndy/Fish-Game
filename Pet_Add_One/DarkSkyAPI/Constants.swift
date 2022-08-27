//   Constants.swift
//   Forecast
//
//  Created by: CSC214 Instructor on 11/14/19.
//  Copyright © 2019 University of Rochester. All rights reserved.
//

import Foundation

public struct Constants {
    
    // Rochester, NY
    public static let latitude = 43.2360
    public static let longitude = -77.6933
    
    public static let apiKey = "df7b9a38b514814c8370588c21486774"
    public static let baseUrl = "https://api.darksky.net/forecast/\(apiKey)/\(latitude),\(longitude)/"
}

