//
//  Info.swift
//  Charts
//
//  Created by John Cook on 8/5/16.
//  Copyright © 2016 dcg. All rights reserved.
//

import Foundation
import CoreData
import CloudKit

class Info: NSManagedObject {
    
    /* Singleton */
    class var sharedInstance: Info {
        struct Static {
            static var instance: Info?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = Info()
        }
        return Static.instance!
    }
        
    @NSManaged var name:            String
    @NSManaged var dict:            NSString
    @NSManaged var totalTimeInDict: Int
    @NSManaged var currentItem:     Int
    @NSManaged var currentFolder:   Int
    @NSManaged var startingDay:     Int // Saturday = 0
    @NSManaged var weeklyGoal:      Int
    @NSManaged var iCloudActive:    Bool
    
    var allTimes: Dictionary<String, NSNumber>! = [:]
    
    func getStartingDay() -> Int {
        return startingDay
    }
    
    func changeStartingDay(input: Int) {
        startingDay = input
    }
    
    func getCurrentItem() -> Int {
        return currentItem
    }
    
    func changeCurrentItem(input: Int) {
        currentItem = input
    }
    
    func getCurrentFolder() -> Int {
        return currentFolder
    }
    
    func changeCurrentFolder(input: Int) {
        currentFolder = input
    }
    
    func getWeeklyGoal() -> Int {
        return weeklyGoal
    }
    
    func changeWeeklyGoal(input: Int) {
        weeklyGoal = input
    }
    
    func getTotalTimeInDict() -> Int {
        return totalTimeInDict
    }
    
    func changeTotalTimeInDict(input: Int) {
        totalTimeInDict = input
    }
    
    func saveAllTimes() {
        do {
            let jsonData = try NSJSONSerialization.dataWithJSONObject(allTimes, options: NSJSONWritingOptions.PrettyPrinted)
            let string = NSString(data: jsonData, encoding: NSUTF8StringEncoding)
            dict = string!
        } catch let error as NSError {
            print(error)
        }
    }
    
    func loadItems() {
        do {
            let data = dict.dataUsingEncoding(NSUTF8StringEncoding)
            let decoded = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? [String:Double]
            allTimes = decoded!
        } catch let error as NSError {
            print(error)
        }
    }
}