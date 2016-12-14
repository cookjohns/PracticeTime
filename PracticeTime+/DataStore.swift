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
    
    // MARK: - Variables
    
    var seamStore: SMStore?
    
    /* Singleton */
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
    
    /*
     * Contains all archived variables:
     * 
     * allTimes: Dictionary<String, NSNumber>!
     * totalTimeInDict: Int
     * currentTime:     Int
     * currentFolder:   Int
     * startingDat:     Int
     * weeklyGoal:      Int
     */
    internal var info: Info?
    
    private var itemObjects   = [NSManagedObject]()
    
    private var folderObjects = [NSManagedObject]()
    
    // MARK: - Functions
    
    func addItem(item: NSManagedObject) {
        itemObjects.append(item)
    }
    
    func removeItem(index: Int) {
        folderObjects.removeAtIndex(index)
    }
    
    func addFolder(folder: NSManagedObject) {
        folderObjects.append(folder)
    }
    
    func removeFolder(index: Int) {
        folderObjects.removeAtIndex(index)
    }
    
    func getItem(index: Int) -> NSManagedObject {
        return itemObjects[index]
    }
    
    func getItem(name: String) -> NSManagedObject {
        for i in itemObjects {
            let item = i as! Item
            if item.name == name {
                return item
            }
        }
        return Item(nameIn: "none")
    }
    
    func getAllItems() -> [NSManagedObject] {
        return itemObjects
    }
    
    func setItemObjects(input: [Item]) {
        itemObjects = input
    }
    
    func itemCount() -> Int {
        return itemObjects.count
    }
    
    func getFolder(index: Int) -> NSManagedObject {
        return folderObjects[index]
    }
    
    func getAllFolders() -> [NSManagedObject] {
        return folderObjects
    }
    
    func setFolderObjects(input: [Folder]) {
        folderObjects = input
    }
    
    func folderCount() -> Int {
        return folderObjects.count
    }
    
    func getItemIndexForName(input: String) -> Int {
        for i in 0..<itemObjects.count {
            let item = itemObjects[i] as! Item
            if item.getName() == input {
                return i
            }
        }
        return -1
    }
    
    func removeItemFromAllFolders(input: NSManagedObject) {
        let item = input as! Item
        let itemName = item.name
        for f in folderObjects{
            let folder = f as! Folder
            folder.deleteItem(itemName)
        }
    }
}