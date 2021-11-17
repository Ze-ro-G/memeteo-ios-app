//
//  ApiRoute.swift
//  MemeteoClient
//
//  Created by ingouackaz on 04/11/2021.
//

import Foundation

enum ApiRoute { case
    
    fetchCurrentWeather(String),
    fetchCurrentLocationWeather(String,String),
    fetchCurrentLocationForecast(String,String),
    fetchLocationForecast(String),
    renewApp
    
    var path: String {
        switch self {
        case .fetchCurrentWeather(let city): return "weather?q=\(city)"
        case .fetchCurrentLocationWeather(let lat,let long): return "weather?lat=\(lat)&lon=\(long)"
        case .fetchCurrentLocationForecast(let lat,let long): return "forecast?lat=\(lat)&lon=\(long)"
        case .fetchLocationForecast(let city): return "forecast?q=\(city)"
        case .renewApp: return "app/renew"
        }
    }

}
