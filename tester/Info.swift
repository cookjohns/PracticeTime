//
//  Info.swift
//  Charts
//
//  Created by John Cook on 8/5/16.
//  Copyright © 2016 dcg. All rights reserved.
//

import Foundation
import CoreData

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
    
    @NSManaged private var name:            String
    @NSManaged private var allTimes:        Dictionary<String, NSNumber>!
    @NSManaged private var totalTimeInDict: Int
    @NSManaged private var currentItem:     Int
    @NSManaged private var currentFolder:   Int
    @NSManaged private var startingDay:     Int // Saturday = 0
    @NSManaged private var weeklyGoal:      Int
    
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
}