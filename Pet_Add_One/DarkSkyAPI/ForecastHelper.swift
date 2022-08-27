//
//  DarkSky.swift
//  Forecaste
//
//  Created by CSC214 Instructor on 8/12/19.
//  Copyright © 2019 University of Rochester. All rights reserved.
//
import Foundation

enum ForecastHelperResult {
    case Success(Forecasts)
    case Failure(Error)
}

class ForecastHelper {
    
    let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    private func darkSkyURL(with parameters: [String:String]) -> URL? {
        
        var queryItems = [URLQueryItem]()
        for (key, value) in parameters {
            let item = URLQueryItem(name: key, value: value)
            queryItems.append(item)
        }
        
        guard var components = URLComponents(string: Constants.baseUrl) else { return nil }
        components.queryItems = queryItems
        return components.url
    }
    
    private func getForecasts(from data: Data) -> ForecastHelperResult {
        do {
            let decoder = JSONDecoder()
            let forecasts = try decoder.decode(Forecasts.self, from: data)
            return .Success(forecasts)
        } catch let error {
            return .Failure(error)
        }
    }
    
    func fetchForecasts(completion: @escaping (ForecastHelperResult) -> Void) {
        
        var language = "en"
        if let deviceLanguage = Locale.current.languageCode {
            if deviceLanguage == "de" || deviceLanguage == "fr" {
                language = deviceLanguage
            }
        }
        
        let params = [
            "exclude": "currently,minutely,hourly,alerts,flags",
            "units": "auto",
            "lang": language]
        
        if let url = darkSkyURL(with: params) {
            
            let request = URLRequest(url: url)
            let task = session.dataTask(with: request, completionHandler: { data, response, error in
                guard let jsonData = data else {
                    if let err = error {
                        completion(.Failure(err))
                    }
                    return
                }
                completion(self.getForecasts(from: jsonData))
            })
            task.resume()
        } else {
            completion(.Failure(URLError.badURL as! Error))
        }
    }
}

