//
//  ApiSys.swift
//  MemeteoClient
//
//  Created by ingouackaz on 09/11/2021.
//

import UIKit
import ObjectMapper



public class ApiSys: MMSys, Mappable {

    public var country: String?
    public var sunrise: Int?
    public var sunset: Int?
    

    required public init?(map: Map) {}

    
    public func mapping(map: Map) {
        country <- map["country"]
        sunrise <- map["sunrise"]
        sunset <- map["sunset"]
    }
    
}
