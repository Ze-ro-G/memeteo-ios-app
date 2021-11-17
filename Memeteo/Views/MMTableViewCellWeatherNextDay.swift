//
//  MMTableViewCellWeatherNextDay.swift
//  Memeteo
//
//  Created by ingouackaz on 05/11/2021.
//

import UIKit
import MemeteoClient

class MMTableViewCellWeatherNextDay: UITableViewCell {

    static let identifier : String = "cell.weather.nextday"

    @IBOutlet weak var labelDateDay: UILabel!
    @IBOutlet weak var imageViewWeather: UIImageView!
    @IBOutlet weak var labelMinTemp: UILabel!
    @IBOutlet weak var labelMaxTemp: UILabel!

    
    @IBOutlet weak var tableView: UITableView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.labelDateDay.text = ""
        self.labelMinTemp.text = ""
        self.labelMaxTemp.text = ""

    }
    
    func configure(weather:MMWeatherModel,day:Date){
    
        

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let dayInWeek = dateFormatter.string(from: day)
        
        self.labelDateDay.text = dayInWeek
        
        
        guard let tempMax = weather.main?.temp_max, let tempMin = weather.main?.temp_min else {
            return 
        }

        self.labelMaxTemp.text = "\(tempMax.kelvinToCeliusConverter()) °"
        self.labelMinTemp.text = "\(tempMin.kelvinToCeliusConverter()) °"
        
        if let icon = weather.weather?[0].icon {
            self.imageViewWeather.loadImageFromURL(url: "http://openweathermap.org/img/wn/\(icon)@2x.png")
        }

        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
