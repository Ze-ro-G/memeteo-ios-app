//
//  ViewController.swift
//  Memeteo
//
//  Created by ingouackaz on 04/11/2021.
//

import UIKit
import Reachability

class MMTableViewControllerEmbedWeatherToday: UIViewController {

    
    var todayViewController : MMTableViewControllerWeatherToday?

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? MMTableViewControllerWeatherToday,
                     segue.identifier == "EmbedSegue" {
             self.todayViewController = vc
             self.todayViewController?.embedViewController = self
         }
    }
}


