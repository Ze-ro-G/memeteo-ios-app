//
//  ApiWeather.swift
//  MemeteoClient
//
//  Created by ingouackaz on 04/11/2021.
//

import Foundation
import ObjectMapper

public class ApiWeather: MMWeather, Mappable {
    
    public var id: Int?
    
    public var main: String?
    
    public var description: String?
    
    public var icon: String?
    

    required public init?(map: Map) {}

    
    public func mapping(map: Map) {
        id <- map["id"]
        main <- map["main"]
        description <- map["description"]
        icon <- map["icon"]
    }
    
}
