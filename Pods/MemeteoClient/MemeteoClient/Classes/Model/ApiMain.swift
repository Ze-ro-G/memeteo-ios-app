//
//  ApiMain.swift
//  MemeteoClient
//
//  Created by ingouackaz on 08/11/2021.
//

import UIKit
import ObjectMapper




public class ApiMain: MMMain, Mappable {
    
    public var temp: Float?    
    public var feels_like: Float?
    public var temp_min: Float?
    public var temp_max: Float?
    public var pressure: Float?
    public var humidity: Float?
    
    

    required public init?(map: Map) {}

    
    public func mapping(map: Map) {
        temp <- map["temp"]
        feels_like <- map["access_token"]
        temp_min <- map["temp_min"]
        temp_max <- map["temp_max"]
        pressure <- map["pressure"]
        humidity <- map["humidity"]
    }
    
}
