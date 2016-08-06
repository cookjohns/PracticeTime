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
    
    internal var info: Info?
    
    private var itemObjects  = [NSManagedObject]()
    
    private var folderObjects = [NSManagedObject]()
    
    
    func addItem(item: NSManagedObject) {
        itemObjects.append(item)
    }
    
    func addFolder(folder: NSManagedObject) {
        folderObjects.append(folder)
    }
    
    func getItem(index: Int) -> NSManagedObject {
        return itemObjects[index]
    }
    
    func getAllItems() -> [NSManagedObject] {
        return itemObjects
    }
    
    func setItemObjects(input: [Item]) {
        itemObjects = input
        for i in input {
            print(i.getName())
        }
        print("\n")
    }
    
    func itemCount() -> Int {
        return itemObjects.count
    }
    
    func getFolder(index: Int) -> NSManagedObject {
        var test = folderObjects[index]
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
}