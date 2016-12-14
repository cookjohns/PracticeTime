//
//  Folder.swift
//  PracticeTime
//
//  Created by John Cook on 8/1/16.
//  Copyright © 2016 John Cook. All rights reserved.
//

import Foundation
import CoreData

class Folder: NSManagedObject {
    
    @NSManaged var name:  String
    @NSManaged var dict:  NSString
    
    var items: [String] = [] // holds indices of objects in DataStore.itemObjects
    
    func addItem(input: String) {
        items.append(input)
        saveItems()
    }
    
    func getName() -> String {
        return name
    }
    
    func changeName(input: String) {
        name = input
    }
    
    func deleteItem(input: String) {
        for i in 0..<items.count {
            if items[i] == input {
                items.removeAtIndex(i)
                saveItems()
                return
            }
        }
    }
    
    func getItem(name: String) -> Item {
//        return items[index] as! Item
        return DataStore.sharedInstance.getItem(name) as! Item
    }
    
    func getNameAtIndex(index: Int) -> String {
        return items[index]
    }
    
    func getItems() -> [NSManagedObject] {
        var result: [NSManagedObject] = []
        for name in 0..<items.count {
            let itemToAdd = DataStore.sharedInstance.getItem(name)
            let itemAsItem = itemToAdd as! Item
            if itemAsItem.name != "none" {
                result.append(itemToAdd)
            }
        }
        return result
    }
    
    func containsItem(input: String) -> Bool {
        for i in 0..<items.count {
            if items[i] == input {
                return true
            }
        }
        return false
    }
    
    func getIndexOfItem(input: String) -> Int {
        for i in 0..<items.count {
            if items[i] == input {
                return i
            }
        }
        return -1
    }
    
    func itemCount() -> Int {
        return items.count
    }
    
    func saveItems() {
        do {
            let jsonData = try NSJSONSerialization.dataWithJSONObject(items, options: NSJSONWritingOptions.PrettyPrinted)
            let string = NSString(data: jsonData, encoding: NSUTF8StringEncoding)
            dict = string!
        } catch let error as NSError {
            print(error)
        }
    }
    
    func loadItems() {
        do {
            let data = dict.dataUsingEncoding(NSUTF8StringEncoding)
            let decoded = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? [String]
            items = decoded!
        } catch let error as NSError {
            print(error)
        }
    }
}