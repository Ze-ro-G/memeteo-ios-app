//
//  NonPersistentApiContext.swift
//  MemeteoClient
//
//  Created by ingouackaz on 04/11/2021.
//

import Foundation

public class NonPersistedApiContext: ApiContext {
    
    init(baseURL: String,  apiKey: String) {
        self.baseURL = baseURL
        self.apiKey = apiKey
    }
    
    public var baseURL: String
    public var apiKey: String

}
