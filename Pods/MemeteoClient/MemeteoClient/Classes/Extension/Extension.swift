//
//  Extension.swift
//  Pods-Memeteo
//
//  Created by ingouackaz on 15/11/2021.
//

import UIKit


extension Date {
    func adding(minutes: Int) -> Date {
        
        return Calendar.current.date(byAdding: .minute, value: minutes, to: self)!
    }
    
    func adding(hour: Int) -> Date {
        
        return Calendar.current.date(byAdding: .hour, value: hour, to: self)!
    }
    
    func adding(day: Int) -> Date {
        
        return Calendar.current.date(byAdding: .day, value: day, to: self)!
    }
    
    func fullDistance(from date: Date, resultIn component: Calendar.Component, calendar: Calendar = .current) -> Int? {
        calendar.dateComponents([component], from: self, to: date).value(for: component)
    }

    func distance(from date: Date, only component: Calendar.Component, calendar: Calendar = .current) -> Int {
        let days1 = calendar.component(component, from: self)
        let days2 = calendar.component(component, from: date)
        return days1 - days2
    }

    func hasSame(_ component: Calendar.Component, as date: Date) -> Bool {
        distance(from: date, only: component) == 0
    }
}

extension Array {
    func unique<T:Hashable>(map: ((Element) -> (T)))  -> [Element] {
        var set = Set<T>() //the unique list kept in a Set for fast retrieval
        var arrayOrdered = [Element]() //keeping the unique list of elements but ordered
        for value in self {
            if !set.contains(map(value)) {
                set.insert(map(value))
                arrayOrdered.append(value)
            }
        }

        return arrayOrdered
    }
}

