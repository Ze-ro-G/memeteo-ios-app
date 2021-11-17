//
//  MMCollectionViewCellWeatherDay.swift
//  Memeteo
//
//  Created by ingouackaz on 05/11/2021.
//

import UIKit
import MemeteoClient

class MMCollectionViewCellWeatherDay: UICollectionViewCell {
    
    static let identifier : String = "cell.weather.day"
    
    @IBOutlet weak var labelHour: UILabel!
    @IBOutlet weak var labelDegree: UILabel!
    @IBOutlet weak var imageViewWeather: UIImageView!

    func configure(weather:MMWeatherModel){
        
        
        if let icon = weather.weather?[0].icon {
            self.imageViewWeather.loadImageFromURL(url: "http://openweathermap.org/img/wn/\(icon)@2x.png")
        }
        
        
             if let date = weather.dt_date {
                 let calendar = Calendar.current
                 let hour = calendar.component(.hour, from: date)
                 
                 self.labelHour.text = "\(hour)" + "h00"

                 if let celcius = weather.main?.temp?.kelvinToCeliusConverter(){
                     self.labelDegree.text = "\(celcius)" + "°"
                 }
             }
        
    }
}
