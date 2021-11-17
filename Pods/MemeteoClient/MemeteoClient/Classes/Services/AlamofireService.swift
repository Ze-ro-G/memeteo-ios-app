//
//  AlamofireService.swift
//  MemeteoClient
//
//  Created by ingouackaz on 04/11/2021.
//


import Alamofire
import SwiftyJSON
import Foundation
import AlamofireObjectMapper


public extension Notification.Name {
    static let didReceiveTokenError = Notification.Name("didReceiveTokenError")
}



public class AlamofireService {
    
    init(context: ApiContext) {
        self.context = context
    }
    
    var context: ApiContext
    
    func get(at route: ApiRoute, params: Parameters? = nil) -> DataRequest {
        return request(
            at: route,
            method: .get,
            params: params,
            encoding: URLEncoding.default)
    }
    
    func post(at route: ApiRoute, params: Parameters? = nil) -> DataRequest {
        return request(
            at: route,
            method: .post,
            params: params,
            encoding: JSONEncoding.default)
    }
    
    func put(at route: ApiRoute, params: Parameters? = nil) -> DataRequest {
        return request(
            at: route,
            method: .put,
            params: params,
            encoding: JSONEncoding.default)
    }
    
    func request(at route: ApiRoute, method: HTTPMethod, params: Parameters?, encoding: ParameterEncoding) -> DataRequest {
        
        let urlStr = context.baseURL +  route.path + "&appid=" + context.apiKey

        let urlString = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""

        let url = NSURL(string: urlString)

        var request = URLRequest(url: url! as URL)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        print("URL \(url)")
        
        return AF.request(request as URLRequestConvertible)
            .validate({ (request, response, data) -> Request.ValidationResult in
                if let data = data {
                    do {
                        let json = try JSON(data: data)
                        print("JSON RECEIVED \(json)")
                        if let status = json["status"].string {
                            if status == "error" {
                                if let errorCode = json["error_code"].int, let errorMessage = json["error_message"].string {
                                    let error: Error = NSError(domain: "Memeteo", code: errorCode, userInfo: [ NSLocalizedDescriptionKey : errorMessage ])                                                                
                                    return Request.ValidationResult.failure(error)
                                }
                            }
                        }
                    } catch {
                        return .success(())
                     //   Request.ValidationResult.success(Void)
                      //  return Request.ValidationResult.success
                    }
                }
                return .success(())
              //  return Request.ValidationResult.success
            })
            .validate()
    }
    
}
