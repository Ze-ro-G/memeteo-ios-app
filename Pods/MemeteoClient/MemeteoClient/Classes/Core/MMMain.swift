//
//  MMMain.swift
//  MemeteoClient
//
//  Created by ingouackaz on 08/11/2021.
//

import UIKit


public protocol MMMain {
    
    
    var temp: Float? { get  }
    var feels_like: Float? { get  }
    var temp_min: Float? { get  }
    var temp_max: Float? { get  }
    var pressure: Float? { get  }
    var humidity: Float? { get  }

}
