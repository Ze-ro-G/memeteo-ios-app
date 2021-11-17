//
//  MMTableViewControllerWeather.swift
//  Memeteo
//
//  Created by ingouackaz on 05/11/2021.
//

import UIKit
import CoreLocation
import MemeteoClient
import Reachability



class MMTableViewControllerWeatherToday: UITableViewController {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var labelCurrentTemperature: UILabel!
    @IBOutlet weak var labelCurrentLocation: UILabel!
    @IBOutlet weak var labelCurrentWeatherDescription: UILabel!
    @IBOutlet weak var imageViewWeather: UIImageView!

    
    let reachability = try! Reachability()

    var subViewController : MMTableViewControllerWeatherNextDays?
    var embedViewController : MMTableViewControllerEmbedWeatherToday?
    var locationManager = CLLocationManager()
    var latitude : CLLocationDegrees!
    var longitude: CLLocationDegrees!
    
    
    var forecastToday : [MMWeatherModel] = []
    var currentCity : City?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initData()
        initUI()
        
    }
    
    func initUI(){
        self.tableView.tableHeaderView = nil;
        self.tableView.tableFooterView = nil;
        tableView.removeExtraCellLines()
        tableView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        
        textView.delegate = self
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 0.5
        textView.layer.cornerRadius = 8
        
        labelCurrentLocation.text = ""
        labelCurrentTemperature.text = ""
        labelCurrentWeatherDescription.text = ""
                
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.reloadData()
        collectionView.makeRounded(radius: 10)
        containerView.makeRounded(radius: 10)
    }
    
    func initData(){
        setObservers()
        checkLocationStatus()
    }
    
    func setObservers(){
             NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
            do{
              try reachability.startNotifier()
            }catch{
              print("ERROR : could not start reachability notifier")
            }
    }
    
    func checkLocationStatus(){

        if CLLocationManager.locationServicesEnabled() {
            switch locationManager.authorizationStatus {
                case .denied:
                // load offline data
                loadOfflineData()
                print("Denied")
            case .notDetermined, .restricted:
                    print("No access")
                self.askLocationAuthorization()
                case .authorizedAlways, .authorizedWhenInUse:
                    print("Access")
                self.updatelocation()
                @unknown default:
                break
                }
            } else {
                self.addCity()
                print("Location services are not enabled")
        }
    }
    
    func askLocationAuthorization(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func updatelocation(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    
    @objc func reachabilityChanged(note: Notification) {

      let reachability = note.object as! Reachability

      switch reachability.connection {
      case .wifi:
          print("Reachable via WiFi")
      case .cellular:
          print("Reachable via Cellular")
      case .unavailable:
        print("Network not reachable")
          self.loadOfflineData()
          // load cache data
      case .none:
          print("")
      }
    }
    
    
    func loadOfflineData(){
        
        guard let city = MemeteoClient.shared.currentCity  else {
            // show add city if no local data
            self.addCity()
            return
        }
        
        self.currentCity = city
    
        // load Notes

        if let note =  Note.getNoteFor(city: city, day: Date()){
            textView.text = note.text
        }
        
        // Load Weather
        
        if let weather = MemeteoClient.shared.currentWeather {
            self.setWeather(weather: weather)
        }
        
        self.loadDataUsingCurrentCity()
        
    }
    

    func reloadForecastToday(){
        collectionView.reloadData()
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
        //textField.resignFirstResponder()  /* This line also worked fine for me */
    }
    

    
    // Add city if no city detected
    
    func addCity(){
        let alertController = UIAlertController(title: "Add City", message: "", preferredStyle: .alert)
         alertController.addTextField { (textField : UITextField!) -> Void in
             textField.placeholder = "City Name"
         }
         let saveAction = UIAlertAction(title: "Add", style: .default, handler: { alert -> Void in
             let firstTextField = alertController.textFields![0] as UITextField
             print("City Name: \(String(describing: firstTextField.text))")
            guard let cityname = firstTextField.text else { return }
             
             let city =  City(city: cityname)
             
             // need to find another way to detect city weather
             MemeteoClient.shared.weatherService?.fetchWeather(city: city.name, completion: { weather, error in
    
                 if weather != nil {
                    // city wester existe
                     self.currentCity = city
                     
                     MemeteoClient.shared.saveCurrent(city: self.currentCity!)

                     self.loadDataUsingCurrentCity()
                 }
                 else {
                     // city wester do no exist
                     self.addCity()
                 }
             })
         })


        alertController.addAction(saveAction)
       
        self.embedViewController?.present(alertController, animated: true, completion: nil)
    }
    
    
    
    // Set Data
    
    func setWeather(weather:MMWeatherModel){
 
        DispatchQueue.main.async {
            
            guard let name = weather.name , let description = weather.weather?[0].description , let flt =  weather.main?.temp?.kelvinToCeliusConverter(), let icon = weather.weather?[0].icon  else {
                return
            }
            
            self.labelCurrentTemperature.text = String(describing: flt) + "°"
            self.labelCurrentLocation.text = name
            self.labelCurrentWeatherDescription.text = description
                
            self.imageViewWeather.loadImageFromURL(url: "http://openweathermap.org/img/wn/\(icon)@2x.png")
            


            print("Forecast \(MemeteoClient.shared.forecasts?.count)")
            print("Current Temperature", weather.name)
        }
    }
    
    func setForecast(forecast:MMForecast){
        if let allforecast = forecast.list {
            let todayForecast = allforecast.forDate(date: Date())
            
         
            self.subViewController?.forecasts = allforecast
            self.subViewController?.reloadData()
            
            self.forecastToday = todayForecast
            self.reloadForecastToday()
            print("ARRR \(todayForecast.count)")
        }

    }
    
    
    // Load data from API
    
    func loadDataUsingCurrentCity(){
        

        
        if let cCity = currentCity{
            
            if let note =  Note.getNoteFor(city: cCity, day: Date()){
                textView.text = note.text
            }
            else {
                textView.text = ""
            }
            
            
            MemeteoClient.shared.weatherService?.fetchWeather(city: cCity.name, completion: { weather, error in
                if let weather = weather {
                    self.setWeather(weather: weather)
                }
                else{
                    self.displayAlert(title: "Error", message:"Cant load weather for \(cCity.name)")
                }
            })
            
            MemeteoClient.shared.weatherService?.fetchLocationForecast(city: cCity.name, completion: { forecastWeather, error in
                if let forecast = forecastWeather{
                    self.setForecast(forecast: forecast)
                }
                else{
                    self.displayAlert(title: "Error", message: "Cant load forecasts for \(cCity.name)")
                }
            })
        }

    }
    
    func loadDataUsingCoordinates(lat: String, lon: String) {
        
        MemeteoClient.shared.weatherService?.fetchCurrentLocationForecast(lat: lat, long: lon, completion: { forecastWeather, error in
            
            
            print("Total data:", forecastWeather?.list?.count ?? 0)

            if let allforecast = forecastWeather?.list {
                let todayForecast = allforecast.forDate(date: Date())
                
             
                self.subViewController?.forecasts = allforecast
                self.subViewController?.reloadData()
                
                self.forecastToday = todayForecast
                self.reloadForecastToday()
            }
                        
        })
        
        MemeteoClient.shared.weatherService?.fetchCurrentLocationWeather(lat: lat, long: lon, completion: { weather, error in
            //
            if let weather = weather {
                self.setWeather(weather: weather)
            }
        })
        
    }
     
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textView.resignFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? MMTableViewControllerWeatherNextDays,
                     segue.identifier == "EmbedSegue" {
             self.subViewController = vc
            self.subViewController?.embedViewController = self
         }
    }
}


extension MMTableViewControllerWeatherToday: CLLocationManagerDelegate {


   func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
      print("Location services authorization request")
       
       if manager.authorizationStatus == .denied {
           self.addCity()
       }
   }

   func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       print("Location updated")
       manager.stopUpdatingLocation()
       manager.delegate = nil
       let location = locations[0].coordinate
       latitude = location.latitude
       longitude = location.longitude
       print("Long", longitude.description)
       print("Lat", latitude.description)
       
       // save current location
       let locationL = CLLocation(latitude: latitude, longitude:longitude)

       locationL.fetchCityAndCountry { strCity, country, error in
           guard let city = strCity , let cCode = country  else {
               return
           }
           
           
           let currentcity : City = City(name: city, countryCode: cCode, lat: self.latitude, long: self.longitude)

       
           
           self.currentCity = currentcity
           
           MemeteoClient.shared.saveCurrent(city: currentcity)
           
           self.loadDataUsingCurrentCity()
                      
           print("Current location city\(String(describing:city))")
       }
   }

   func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
      print("Failed to find user's location: \(error.localizedDescription)")
   }
    
    
 }



extension MMTableViewControllerWeatherToday : UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
   
        
        guard let city = currentCity, let noteText = textView.text else {
            return
        }
        
        
        // save Note
        if let note =  Note.getNoteFor(city: city, day: Date()){
            Note.updateNoteFor(text: noteText, city: note.city, day: note.dt)
        }
        else {
            
            let note = Note(text: noteText, dt: Date(), city: city)
            MemeteoClient.shared.addNote(note: note)
        }
    }
}



extension MMTableViewControllerWeatherToday : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 45, height: 90)
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return forecastToday.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MMCollectionViewCellWeatherDay.identifier, for: indexPath) as? MMCollectionViewCellWeatherDay {
            let weather = forecastToday[indexPath.item]

            cell.configure(weather: weather)

            return cell
        }
        
        return UICollectionViewCell()
    }
}


