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
    @NSManaged var totalTime: NSNumber
    @NSManaged var timeSinceLastAccess: NSNumber
    @NSManaged var times: Dictionary<NSDate, NSNumber> // date as NSDate, totalTime for that instance
    
    func getTotalTime() -> NSNumber {
        return self.totalTime
    }
    
    func getWeekTotal() -> NSNumber {
        let calendar = NSCalendar.currentCalendar()

        var total: NSNumber = 0
        
        for i in 0...7 {
            // calculate time for last week
            if let time = times[calendar.dateByAddingUnit(.Day, value: -i, toDate: NSDate(), options: [])!] {
                total = NSNumber(int: total.intValue + time.intValue)
            }
        }
        return 0
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
        var temp = self.times[date]
        var newTime = NSNumber(double: temp!.doubleValue + time)
        times[date] = newTime
    }
}