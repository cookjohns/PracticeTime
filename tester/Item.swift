//
//  Piece.swift
//  tester
//
//  Created by John Cook on 12/16/14.
//  Copyright (c) 2014 John Cook. All rights reserved.
//

import Foundation
import CoreData

class Item: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var lastAccess: NSDate
    @NSManaged var totalTime: Double
    @NSManaged var timeSinceLastAccess: NSNumber
    @NSManaged var times: Dictionary<String, Double> // date as NSDate, totalTime for that instance
    
    func getTotalTime() -> Double {
        return self.totalTime
    }
    
    func getName() -> String {
        return name
    }
    
    func getWeekToDateTimes() -> [Double] {
        var result = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
        let info = DataStore.sharedInstance.info! as Info
        
        let dayInt = info.getStartingDay()
        let temp = NSDate().dayOfWeek()! - dayInt
        var daysInPast = temp >= 0 ? temp : dayInt + abs(temp)
        
        let cal = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let today = cal.startOfDayForDate(NSDate())
        
        for i in 0...daysInPast {
            // get date for key
            let date = NSCalendar.currentCalendar().dateByAddingUnit(.Day, value: -daysInPast, toDate: today, options: [])!
            // save to array, if it's not nil (meaning no entry for that date)
            let key = printDate(date)
            let dict = times as Dictionary<String,Double>
            var test = dict[key]
            if dict[key] != nil {
                result[i] = dict[key]!
            }
            daysInPast -= 1
        }
        
        return result
    }
    
    func getWeekToDateTotal() -> Double {
        var total = 0.0
        let times = self.getWeekToDateTimes()
        for time in times {
            total += time
        }
        return total
    }
    
    func printDate(date:NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        
        let theDateFormat = NSDateFormatterStyle.ShortStyle
        let theTimeFormat = NSDateFormatterStyle.ShortStyle
        
        dateFormatter.dateStyle = theDateFormat
        dateFormatter.timeStyle = theTimeFormat
        
        return dateFormatter.stringFromDate(date)
    }
    
    func addTime(time: Double, date: NSDate) {
        // add to totalTime
        totalTime += time
        
        // add to current date in times
        let cal = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let newDate = cal.startOfDayForDate(date)
        
        var temp = self.times[printDate(newDate)]
        if temp == nil {
            temp = 0.0
        }
        
        let newTime = temp! + time

        times[printDate(newDate)] = newTime
    }
}