//
//  MMForecast.swift
//  MemeteoClient
//
//  Created by ingouackaz on 09/11/2021.
//

import UIKit


public protocol MMForecast {
    
    var list: [MMWeatherModel]? { get }
    var city : City? { get }
}




public extension Array where Element == MMForecast {
    func forCity(city:String) -> [MMForecast] {
        
        let arrr = self.filter{ return $0.city?.name == city }
        return arrr
    }
}
