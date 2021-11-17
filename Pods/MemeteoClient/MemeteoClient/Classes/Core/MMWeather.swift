//
//  MMWeather.swift
//  MemeteoClient
//
//  Created by ingouackaz on 04/11/2021.
//

import Foundation


public protocol MMWeather {
    
    
    var id: Int? { get }
    var main: String? { get }
    var description: String? { get }
    var icon: String? { get }

}
