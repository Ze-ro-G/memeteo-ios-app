//
//  ApiForecast.swift
//  MemeteoClient
//
//  Created by ingouackaz on 09/11/2021.
//

import UIKit
import ObjectMapper


public class ApiForecast: MMForecast, Mappable {

    public var list: [MMWeatherModel]? {return _list}
    public var city: City?

    private var _list: [ApiWeatherModel]?

    required public init?(map: Map) {}

    
    public func mapping(map: Map) {
        _list <- map["list"]
        
        var cityname = ""
        var cCode = ""

        cityname   <- map["city.name"]
        cCode  <- map["city.country"]
        self.city = City(city: cityname, countryCode: cCode)
    }
    
}
