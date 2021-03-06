//
//  FolderPopUpViewController.swift
//  PracticeTime
//
//  Created by John Cook on 8/1/16.
//  Copyright © 2016 John Cook. All rights reserved.
//

import UIKit
import CoreData

class FolderPopOverViewController: UITableViewController {
    
    // MARK: - Variables
    
    let folderFetchRequest = NSFetchRequest(entityName: "Folder")
    let managedContext     = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    let info = DataStore.sharedInstance.info! as Info

    let instance = DataStore.sharedInstance

    // MARK: - viewDid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView(frame:CGRectZero)
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Avenir-Medium", size:23.0)!, NSForegroundColorAttributeName: uicolorFromHex(0xffffff)]
        self.navigationController?.navigationBar.barStyle = UIBarStyle.BlackTranslucent
        self.navigationController?.navigationBar.barTintColor = uicolorFromHex(0x2ecc71)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.fetch()
        self.tableView.reloadData()
    }
    
    // MARK: - Actions
    
    @IBAction func cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - UITableView
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if instance.folderCount() > 0 {
            return instance.folderCount()
        }
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        cell.textLabel!.font = UIFont(name: "Avenir-Light", size: 19)
        cell.textLabel?.textColor = UIColor.blackColor()
        
        if instance.folderCount() == 0 {
            cell.textLabel!.text = "Please create a folder"
            cell.textLabel!.textAlignment = .Center
            tableView.separatorStyle = .None
        }
        else {
            let folder = instance.getFolder(indexPath.row)
            
            cell.textLabel!.text = folder.valueForKey("name") as? String
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let info = instance.info! as Info
        let folder = instance.getFolder(indexPath.item) as! Folder
        let currentItem = instance.getItem(info.getCurrentItem()) as! Item
        if instance.folderCount() > 0  && !(folder.containsItem(currentItem.getName())) {
            folder.addItem(currentItem.getName())
            
            do {
                try managedContext?.save()
            } catch _ {
            }
        }
        folder.saveItems()
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - CoreData
    
    func fetch() {
        let folderFetchRequest = NSFetchRequest(entityName: "Folder")
        let itemFetchRequest = NSFetchRequest(entityName: "Item")
        
        
        // Create a sort descriptor object that sorts on the "name"
        // property of the Core Data object
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        
        // Set the list of sort descriptors in the fetch request,
        // so it includes the sort descriptor
        folderFetchRequest.sortDescriptors = [sortDescriptor]
        itemFetchRequest.sortDescriptors = [sortDescriptor]
        
        if let folderFetchResults = (try? managedContext!.executeFetchRequest(folderFetchRequest)) as? [Folder] {
            DataStore.sharedInstance.setFolderObjects(folderFetchResults)
        }
        if let itemFetchResults = (try? managedContext!.executeFetchRequest(itemFetchRequest)) as? [Item] {
            DataStore.sharedInstance.setItemObjects(itemFetchResults)
        }
    }
    
    // MARK: - Formatting
    
    func uicolorFromHex(rgbValue:UInt32)->UIColor{
        let red   = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue  = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }
}