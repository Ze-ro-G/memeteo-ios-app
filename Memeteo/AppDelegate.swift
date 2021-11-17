//
//  AppDelegate.swift
//  Memeteo
//
//  Created by ingouackaz on 04/11/2021.
//

import UIKit
import MemeteoClient

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UINavigationBar.appearance().barStyle = .default

        
        MemeteoClient.shared.configure(WithBaseURL: "http://api.openweathermap.org/data/2.5/", ApiKey: "370b77c339e67e81897323b6d1598485")
        
        return true
    }


}

