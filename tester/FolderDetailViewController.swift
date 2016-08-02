//
//  FolderPageViewController.swift
//  PracticeTime
//
//  Created by John Cook on 3/15/15.
//  Copyright (c) 2015 John Cook. All rights reserved.
//

import UIKit
import CoreData

@objc(FolderDetailViewController) class FolderDetailViewController: UITableViewController {
    
    let folderFetchRequest = NSFetchRequest(entityName: "Folder")
    let managedContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    let folder = DataStore.sharedInstance.getFolder(DataStore.sharedInstance.currentFolder!) as! Folder
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView(frame:CGRectZero)
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Avenir-Medium", size:23.0)!, NSForegroundColorAttributeName: uicolorFromHex(0xffffff)]
        self.navigationController?.navigationBar.barStyle = UIBarStyle.BlackTranslucent
        self.navigationController?.navigationBar.barTintColor = uicolorFromHex(0x2ecc71)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        // set title
        self.navigationItem.title = folder.name
    }
    
    func uicolorFromHex(rgbValue:UInt32)->UIColor{
        let red   = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue  = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return folder.items.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        let item = folder.items[indexPath.row]
        
        cell.textLabel!.text = item.valueForKey("name") as? String
        cell.textLabel!.font = UIFont(name: "Avenir-Medium", size:20.0)
        cell.textLabel?.textColor = uicolorFromHex(0x2ecc71)
        
        return cell
    }
    
    func fetch() {
        // Create a sort descriptor object that sorts on the "name"
        // property of the Core Data object
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        
        // Set the list of sort descriptors in the fetch request,
        // so it includes the sort descriptor
        folderFetchRequest.sortDescriptors = [sortDescriptor]
        
        if let fetchResults = (try? managedContext!.executeFetchRequest(folderFetchRequest)) as? [Folder] {
            DataStore.sharedInstance.folderObjects = fetchResults
        }
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let itemToDelete = folder.getItem(indexPath.row)
            folder.deleteItem(itemToDelete)
            folder.setValue(folder.items, forKey: "items")
            do {
                try managedContext?.save()
            } catch _ {
            }
            self.fetch()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
}