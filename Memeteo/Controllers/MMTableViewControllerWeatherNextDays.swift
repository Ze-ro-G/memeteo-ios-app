//
//  MMTableViewControllerWeatherNextDays.swift
//  Memeteo
//
//  Created by ingouackaz on 05/11/2021.
//

import UIKit
import MemeteoClient

class MMTableViewControllerWeatherNextDays: UITableViewController {

    static let identifier : String = "vc.tableviewcontroller.nextdays"
    
    var nextWeekDays : [Date] = []
    var forecasts : [MMWeatherModel] = []
    let numberOfNextDays : Int = 6
    
    
    var embedViewController : MMTableViewControllerWeatherToday?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initData()
        initUI()
    }
    
    func initUI(){
        
    }
    
    func initData(){
        createNextDays()

    }

    
    func reloadData(){
        self.tableView.reloadData()
    }
    
    func createNextDays(){
        
        let today : Date = Date()
        
        
        for n in 1...numberOfNextDays {
            nextWeekDays.append(today.adding(day: n))
        }
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return numberOfNextDays
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: MMTableViewCellWeatherNextDay.identifier, for: indexPath) as? MMTableViewCellWeatherNextDay{

            let day = nextWeekDays[indexPath.item]

            if let weather = forecasts.filter{ $0.dt_date?.hasSame(.day, as: day) == true }.first{
                cell.configure(weather: weather,day: day)

            }
            
            

            return cell

        }


        return UITableViewCell()
    }
    

}
