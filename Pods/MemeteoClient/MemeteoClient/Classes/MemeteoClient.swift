//
//  MemeteoClient.swift
//  Picomto
//
//  Created by ingouackaz on 04/11/2021.
//  Copyright © 2021 Picomto. All rights reserved.
//

import Foundation
import ObjectMapper
//import Pods_Memeteo




public class MemeteoClient {
    
    public static let shared = MemeteoClient()
    
    private init() {
    }
    

    
  // public var userService: AlamofireUserService?
    public var weatherService: AlamofireWeatherService?
  //  public var appService: AlamofireAppService?

    
    public var appStoreID: String?
    public var synchroInProgress: Bool = false
    let clientbundlePath = Bundle(for: MemeteoClient.self).path(forResource: "MemeteoClient", ofType: "bundle") as String?
    
    
    public var context: NonPersistedApiContext? {
        didSet {
            //appService = AlamofireAppService(context: context!)
            weatherService = AlamofireWeatherService(context: context!)
        //    userService = AlamofireUserService(context: context!)
        }
    }
    
    
    public var currentCity:City?  {
        let userDefaults = UserDefaults.standard

        if let decoded  = userDefaults.data(forKey: "currentLocation"){
            let decodedCity = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! City
            return decodedCity
        }
        else {
            return nil
        }
    }

    
    public var cities:[City]?  {
    
        let userDefaults = UserDefaults.standard

        if let decoded  = userDefaults.data(forKey: "cities"){
            let decodedCity = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! [City]
            return decodedCity
        }
        else {
            return nil
        }
    }
    
    public var notes : [Note]? {
        let userDefaults = UserDefaults.standard

        if let decoded  = userDefaults.data(forKey: "notes"){
            let decodedCity = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! [Note]
            return decodedCity
        }
        else {
            return nil
        }
    }
    
    public var currentForecast:ApiForecast?  {
    
        if let currentUserJSON = UserDefaults.standard.object(forKey: "currentLocationForecast") as? [String:Any] {
            let currentUserObject: ApiForecast = ApiForecast(JSON: currentUserJSON)!
            return currentUserObject
        }else {
            return nil
        }
    }
    public var currentWeather:ApiWeatherModel?  {
    
        if let currentUserJSON = UserDefaults.standard.object(forKey: "currentWeatherModel") as? [String:Any] {
            let currentUserObject: ApiWeatherModel = ApiWeatherModel(JSON: currentUserJSON)!
            return currentUserObject
        }else {
            return nil
        }
    }
    
    
    
    public var forecasts: [ApiForecast]? {
        if let currentGroupsJSON = UserDefaults.standard.object(forKey: "forecasts") as? [[String:Any]] {
            let currentGroupObjects: [ApiForecast] = Mapper<ApiForecast>().mapArray(JSONObject: currentGroupsJSON)!
            return currentGroupObjects
        }else {
            return nil
        }
    }
    
    
    public func addNote(note:Note){
        
        
        var notes = [note]
        
        
        if let localNotes = MemeteoClient.shared.notes{
            notes = localNotes + notes
        }
        
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: notes)
        
        let defaults = UserDefaults.standard
        defaults.set(encodedData, forKey: "notes")
        defaults.synchronize()

    }
    
    public func updateNotes(){
        
        
        if let localNotes = MemeteoClient.shared.notes{
           // notes = localNotes + notes
            
            let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: localNotes)
            
            let defaults = UserDefaults.standard
            defaults.set(encodedData, forKey: "notes")
            defaults.synchronize()
            
        }
    }
    public func saveCurrent(city:City){

        
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: city)
        
        let defaults = UserDefaults.standard
        defaults.set(encodedData, forKey: "currentLocation")
        defaults.synchronize()
    }
    
    public func addCity(city:City){
        
        
        var cities = [city]
        
        
        if let localCities = MemeteoClient.shared.cities{
            cities = localCities + cities 
        }
        
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: cities)
        
        let defaults = UserDefaults.standard
        defaults.set(encodedData, forKey: "cities")
        defaults.synchronize()

    }
    
    public func addCurrentCity(city:City){
        
        
        let cities = MemeteoClient.shared.cities ?? [] + [city]
        
        
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: cities)
        
        let defaults = UserDefaults.standard
        defaults.set(encodedData, forKey: "cities")
        defaults.synchronize()

    }

    // Configuration du context
    public func configure(WithBaseURL baseURL:String, ApiKey apiKey: String) {
        self.context = NonPersistedApiContext(
            baseURL: baseURL,
            apiKey: apiKey
        )
    }

}

