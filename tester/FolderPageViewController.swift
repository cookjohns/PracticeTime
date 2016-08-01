//
//  FolderPageViewController.swift
//  PracticeTime
//
//  Created by John Cook on 3/15/15.
//  Copyright (c) 2015 John Cook. All rights reserved.
//

import UIKit
import CoreData

@objc(FolderPageViewController) class FolderPageViewController: UITableViewController {
    
    let fetchRequest = NSFetchRequest(entityName: "Folder")
    let managedContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView(frame:CGRectZero)
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Avenir-Medium", size:23.0)!, NSForegroundColorAttributeName: uicolorFromHex(0xffffff)]
        self.navigationController?.navigationBar.barStyle = UIBarStyle.BlackTranslucent
        self.navigationController?.navigationBar.barTintColor = uicolorFromHex(0x2ecc71)
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.whiteColor()
    }
    
    func uicolorFromHex(rgbValue:UInt32)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }
    
    @IBAction func addFolder(sender: AnyObject) {
        
        let alert = UIAlertController(title: "New Name",
                                      message: "Add a new name",
                                      preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Save",
                                       style: .Default,
                                       handler: { (action:UIAlertAction) -> Void in
                                        
                                        let textField = alert.textFields!.first
                                        self.saveName(textField!.text!)
                                        self.tableView.reloadData()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .Default) { (action: UIAlertAction) -> Void in
        }
        
        alert.addTextFieldWithConfigurationHandler {
            (textField: UITextField) -> Void in
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert,
                              animated: true,
                              completion: nil)
    }
    
    func saveName(input: String) {
        
        let entity =  NSEntityDescription.entityForName("Folder",
                                                        inManagedObjectContext:
            managedContext!)
        
        let folder = NSManagedObject(entity: entity!,
                                    insertIntoManagedObjectContext:managedContext)
        
        folder.setValue(input, forKey: "name")
        folder.setValue([],    forKey: "items")
        
        do {
            try managedContext?.save()
        } catch _ {
        }
        DataStore.sharedInstance.folderObjects.append(folder)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataStore.sharedInstance.folderObjects.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        let item = DataStore.sharedInstance.folderObjects[indexPath.row]

        cell.textLabel!.text = item.valueForKey("name") as? String
        cell.textLabel!.font = UIFont(name: "Avenir-Medium", size:20.0)
        cell.textLabel?.textColor = uicolorFromHex(0x2ecc71)

        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let itemToDelete = DataStore.sharedInstance.folderObjects[indexPath.row]
            managedContext?.deleteObject(itemToDelete)
            do {
                try managedContext?.save()
            } catch _ {
            }
            self.fetch()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
        DataStore.sharedInstance.currentItem = indexPath.row
    }
    
    func fetch() {
        // Create a sort descriptor object that sorts on the "name"
        // property of the Core Data object
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        
        // Set the list of sort descriptors in the fetch request,
        // so it includes the sort descriptor
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let fetchResults = (try? managedContext!.executeFetchRequest(fetchRequest)) as? [Folder] {
            DataStore.sharedInstance.folderObjects = fetchResults
        }
    }
    
    // set current folder in 'folders' when a row on the table is selected
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        DataStore.sharedInstance.currentFolder = indexPath.row
        return indexPath
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let fetchRequest = NSFetchRequest(entityName:"Folder")
        
        let fetchedResults =
            (try? managedContext?.executeFetchRequest(fetchRequest)) as? [Folder]
        
        if let results = fetchedResults {
            DataStore.sharedInstance.folderObjects = results
        } else {
            print("Could not fetch")// \(error), \(error!.userInfo)")
        }
        self.tableView.reloadData()
    }
}