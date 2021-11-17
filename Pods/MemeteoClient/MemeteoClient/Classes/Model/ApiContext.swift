//
//  ApiContext.swift
//  MemeteoClient
//
//  Created by ingouackaz on 04/11/2021.
//

import Foundation

protocol ApiContext: class {
    
    var baseURL: String { get set }
    var apiKey: String { get set }
}
