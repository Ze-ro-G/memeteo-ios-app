//
//  MMWeatherModel.swift
//  MemeteoClient
//
//  Created by ingouackaz on 04/11/2021.
//

import Foundation

public protocol MMWeatherModel {
    
    var weather: [MMWeather]? { get }
    var main: MMMain? { get }
    var sys: MMSys? { get }
    var name: String? { get }
    var dt: Int? { get }
    var dt_date: Date? { get }

    var timezone: Int? { get }
    var dt_txt: String? { get }
}


public extension Array where Element == MMWeatherModel {
    func forDate(date:Date) -> [MMWeatherModel] {
        
        let arrr = self.filter{ $0.dt_date?.hasSame(.day, as:date) == true }

        return arrr
    }
}
