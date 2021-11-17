//
//  ApiNote.swift
//  Pods-Memeteo
//
//  Created by ingouackaz on 16/11/2021.
//

import UIKit

public class Note: NSObject, NSCoding {
    
    public var text: String
    public var dt: Date
    public var city: City


    
    public init(text: String,dt:Date ,city: City) {
        self.text = text
        self.dt = dt
        self.city = city
    }
    


    required convenience public init(coder aDecoder: NSCoder) {
        let dt = aDecoder.decodeObject(forKey: "dt") as! Date
        let city = aDecoder.decodeObject(forKey: "city") as! City
        let text = aDecoder.decodeObject(forKey: "text") as! String

        self.init(text: text, dt: dt, city: city)
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(dt, forKey: "dt")
        aCoder.encode(city, forKey: "city")
        aCoder.encode(text, forKey: "text")
    }
    
    public func updateNoteWith(txt:String){
        
        guard var notes = MemeteoClient.shared.notes else{
            return
            }
        
        
        
        MemeteoClient.shared.notes?.filter { ct in
            return (ct.city.name == city.name && ct.dt.hasSame(.day, as: self.dt))
       }.first?.text = text
        
//        if let row =  MemeteoClient.shared.notes?.firstIndex(where: {$0.city.name == self.city.name}) {
//            MemeteoClient.shared.notes?[row] = Note(text: txt, dt: self.dt, city: self.city)
//
//        }
//        if let row = notes.firstIndex(where: {$0.city.name == self.city.name}) {
//            notes[row] = Note(text: txt, dt: self.dt, city: self.city)
//
//            notes.remove(at: row)
//        }
        
        
        
      // notes.first(where: { $0.city.name == self.city.name })?.text = txt

//      notes.filter { ct in
//            return (ct.city.name == self.city.name && ct.dt.hasSame(.day, as: self.dt))
//        }.first?.text = txt
    }
    
    public class func getNoteFor(city:City,day:Date) ->Note?{
        
        guard let notes = MemeteoClient.shared.notes else{
            return nil
            }
        let  note =    notes.filter { ct in
            return (ct.city.name == city.name && ct.dt.hasSame(.day, as: day))
            }.first
            
            return note
    }
    
    public class func updateNoteFor(text:String, city:City,day:Date) {
        
        guard let notes = MemeteoClient.shared.notes else{
            return
            }
        
        
      var nfilter =   notes.filter { ct in
            return !(ct.city.name == city.name && ct.dt.hasSame(.day, as: day))
            }
      
        nfilter.append(Note(text: text, dt: day, city: city))
        
        
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: nfilter)
        
        let defaults = UserDefaults.standard
        defaults.set(encodedData, forKey: "notes")
        defaults.synchronize()


         //   return note
    }
}
