//
//  MMViewControllerCities.swift
//  Memeteo
//
//  Created by ingouackaz on 09/11/2021.
//

import UIKit
import MemeteoClient

class MMViewControllerCities: UIViewController {

    
    var cities: [City] = []
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        
        loadData()
        initUI()
        
    }
    
    
    func initUI(){
        
    }
    
    func loadData(){
        
        
        self.cities = []
        
        if let currentCity =  MemeteoClient.shared.currentCity {
            cities.append(currentCity)
        }

        
        if let localCities = MemeteoClient.shared.cities {
            self.cities = self.cities  + localCities
        }

        self.tableView.reloadData()
    }
    
    
    @IBAction func btnAddCityPressed(){
    
        self.addCity()
    }
    
    func addCity(){
        let alertController = UIAlertController(title: "Add City", message: "", preferredStyle: .alert)
         alertController.addTextField { (textField : UITextField!) -> Void in
             textField.placeholder = "City Name"
         }
         let saveAction = UIAlertAction(title: "Add", style: .default, handler: { alert -> Void in
             let firstTextField = alertController.textFields![0] as UITextField
             print("City Name: \(firstTextField.text)")
            guard let cityname = firstTextField.text else { return }
             self.loadCityWeather(cityname: cityname)
         })
         let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action : UIAlertAction!) -> Void in
            print("Cancel")
         })
      

         alertController.addAction(saveAction)
         alertController.addAction(cancelAction)

         self.present(alertController, animated: true, completion: nil)
    }
    
    func loadCityWeather(cityname:String) {
        MemeteoClient.shared.weatherService?.fetchWeather(city:cityname, completion: { weather, error in
            if weather != nil {
                let newcity : City =   City(city: cityname)
                MemeteoClient.shared.addCity(city: newcity)
                self.loadData()
                self.tableView.reloadData()
            }
            else {
                print("NOT WORKIGN")
            }
        })
    }


}


extension MMViewControllerCities : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let selectedCity = cities[indexPath.item]
        self.dismiss(animated: true) {
            
            if let vc =  UIApplication.getTopViewController() as?  MMTableViewControllerEmbedWeatherToday{
                
                vc.todayViewController?.currentCity = selectedCity
                vc.todayViewController?.loadDataUsingCurrentCity()

            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: MMTableViewCellCity.identifier, for: indexPath) as? MMTableViewCellCity {
            let city : City = cities[indexPath.item]
            
            cell.labelName.text = city.name
            return cell
        }
        
        return UITableViewCell()
    }
}
