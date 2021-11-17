//
//  ApiCity.swift
//  MemeteoClient
//
//  Created by ingouackaz on 09/11/2021.
//

import UIKit
import ObjectMapper
import MapKit

public class City: NSObject, NSCoding {
    
    public var countryCode: String
    public var name: String
    public var lat: Double
    public var long: Double


    
    public init(name: String,countryCode:String ,lat: Double, long: Double) {
        self.countryCode = countryCode
        self.name = name
        self.lat = lat
        self.long = long
    }
    
    public init(lat: Double, long: Double) {
        self.name = ""
        self.countryCode = ""
        self.lat = lat
        self.long = long
        
    }

    public init(city: String,countryCode:String) {
        self.countryCode = countryCode
        self.name = city
        self.lat = 0
        self.long = 0
    }
    
    
    
    public init(city: String) {
        self.name = city
        self.countryCode = ""
        self.lat = 0
        self.long = 0
    }
    
    
    
    required convenience public init(coder aDecoder: NSCoder) {
        let cCode = aDecoder.decodeObject(forKey: "countryCode") as! String
        let city = aDecoder.decodeObject(forKey: "city") as! String
        let lat = aDecoder.decodeDouble(forKey: "lat")
        let long = aDecoder.decodeDouble(forKey: "long")
        
        self.init(name: city, countryCode: cCode, lat: lat, long: long)
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(countryCode, forKey: "countryCode")
        aCoder.encode(name, forKey: "city")
        aCoder.encode(lat, forKey: "lat")
        aCoder.encode(long, forKey: "long")
    }
}


extension CLLocation {
    func fetchCityAndCountry(completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first?.locality, $0?.first?.country, $1) }
    }
}

