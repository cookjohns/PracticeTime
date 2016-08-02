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
    
    func getTotalTime() -> NSNumber {
        return self.totalTime
    }
    
    func getWeekTotal() -> NSNumber {
        let calendar = NSCalendar.currentCalendar()

        var total: Double = 0
        
        for i in 0...7 {
            // calculate time for last week
            let cal = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
            let today = cal.startOfDayForDate(NSDate())
            let date = calendar.dateByAddingUnit(.Day, value: -i, toDate: today, options: [])!
            if let time = times[printDate(date)] {
                total = total + time
            }
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