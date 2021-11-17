//
//  AlamofireWeatherService.swift
//  MemeteoClient
//
//  Created by ingouackaz on 04/11/2021.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

public typealias WeatherResult = (_ weather: MMWeatherModel?, _ error: Error?) -> ()
public typealias ForecastResult = (_ weather: MMForecast?, _ error: Error?) -> ()

public protocol WeatherService: AnyObject {
    
    func fetchWeather(city: String, completion: @escaping WeatherResult)
    func fetchCurrentLocationWeather(lat: String, long: String, completion: @escaping WeatherResult)
    func fetchCurrentLocationForecast(lat: String, long: String, completion: @escaping ForecastResult)
    func fetchLocationForecast(city: String, completion: @escaping ForecastResult)

    
}

public class AlamofireWeatherService: AlamofireService, WeatherService {
    
    public func fetchCurrentLocationForecast(lat: String, long: String, completion: @escaping ForecastResult) {
        
        get(at: .fetchCurrentLocationForecast(lat, long), params: nil).responseObject { (res:DataResponse<ApiForecast, AFError>) in
            // save in back
            
            if let forecast = res.value {
                UserDefaults.standard.set(forecast.toJSON(), forKey: "currentLocationForecast")
            }
            
            
            
            completion(res.value, res.error)
        }
    }
    
    public func fetchLocationForecast(city: String, completion: @escaping ForecastResult) {
        
        get(at: .fetchLocationForecast(city), params: nil).responseObject { (res:DataResponse<ApiForecast, AFError>) in
            // save in back
            
            if let forecasts = res.value?.list as? [ApiForecast] {
                                                
                let f =   MemeteoClient.shared.forecasts ?? [] + forecasts
                
                let total = f.unique { forecast in
                    return forecast.city?.name
                }
                
                let groupsJSON = Mapper<ApiForecast>().toJSONArray(total)
                UserDefaults.standard.set(groupsJSON, forKey: "forecasts")
                UserDefaults.standard.synchronize()
            }
            
            
            completion(res.value, res.error)
        }
    }
    
    
    public func fetchCurrentLocationWeather(lat: String, long: String, completion: @escaping WeatherResult) {
        
    
        get(at: .fetchCurrentLocationWeather(lat, long), params: nil).responseObject { (res: DataResponse<ApiWeatherModel,AFError>) in
                        
            
            if let weather = res.value {
                UserDefaults.standard.set(weather.toJSON(), forKey: "currentWeatherModel")
            }

            completion(res.value, res.error)
        }
    }
    
    

    override init(context: ApiContext) {
        super.init(context: context)
    }
    
    public func fetchWeather(city: String, completion: @escaping WeatherResult) {
        
        get(at: .fetchCurrentWeather(city), params: nil).responseObject { (res: DataResponse<ApiWeatherModel,AFError>) in
            
            completion(res.value, res.error)
        }
    }
    
}

