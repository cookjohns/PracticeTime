//
//  DataStore.swift
//  PracticeTimeNew
//
//  Created by John Cook on 12/16/14.
//  Copyright (c) 2014 John Cook. All rights reserved.
//

import Foundation
import CoreData

class DataStore {
    class var sharedInstance: DataStore {
        struct Static {
            static var instance: DataStore?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = DataStore()
        }
        return Static.instance!
    }
    
    var itemObjects  = [NSManagedObject]()
    
    var folderObjects = [NSManagedObject]()
    
    var allTimes: Dictionary<String, NSNumber>!
    
    var totalTimeInDict: Int?
    
    var currentItem:  Int?
    
    var currentFolder: Int?
    
    func addItem(item: NSManagedObject) {
        itemObjects.append(item)
    }
    
    func addFolder(folder: NSManagedObject) {
        folderObjects.append(folder)
    }
    
    func getItem(index: Int) -> NSManagedObject {
        return itemObjects[index]
    }
    
    func getFolder(index: Int) -> NSManagedObject {
        return folderObjects[index]
    }
}