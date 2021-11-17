//
//  ApiWeather.swift
//  MemeteoClient
//
//  Created by ingouackaz on 04/11/2021.
//

import Foundation
import ObjectMapper

public class ApiWeatherModel: MMWeatherModel, Mappable {

    required public init?(map: Map) {}
    
    public var name: String?
    public var dt: Int?
    public var timezone: Int?
    public var dt_txt: String?
    public var dt_date: Date?

    
    public var sys: MMSys? { return _sys }
    private var _sys: ApiSys?

    
    public var weather: [MMWeather]? { return _weather }
    private var _weather: [ApiWeather]?
    
    public var main: MMMain? { return _main }
    private var _main: ApiMain?


    public func mapping(map: Map) {
        _weather <- map["weather"]
        _main <- map["main"]
        _sys <- map["sys"]
        name <- map["name"]
        dt <- map["dt"]
        timezone <- map["timezone"]
        dt_txt <- map["dt_txt"]
        
        // convert to date
        
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dt_date = dateFormatter.date(from: dt_txt ?? "")
    }
    
}
