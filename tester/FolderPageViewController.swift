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
    
    // MARK: - Variable
    
    let managedContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

    // MARK: - viewDid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView(frame:CGRectZero)
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Avenir-Medium", size:23.0)!, NSForegroundColorAttributeName: uicolorFromHex(0xffffff)]
        self.navigationController?.navigationBar.barStyle = UIBarStyle.BlackTranslucent
        self.navigationController?.navigationBar.barTintColor = uicolorFromHex(0x2ecc71)
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.whiteColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.fetch()
        self.tableView.reloadData()
    }
    
    // MARK: - Actions
    
    @IBAction func addFolder(sender: AnyObject) {
        let alert = UIAlertController(title:   "New Name",
                                      message: "Add a new name",
                                      preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Save",
                                       style: .Default,
                                       handler: { (action:UIAlertAction) -> Void in
                                        
                                        let textField = alert.textFields!.first
                                        self.saveFolder(textField!.text!)
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
                              animated:   true,
                              completion: nil)
    }
    
    func saveFolder(input: String) {
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
        DataStore.sharedInstance.addFolder(folder)
    }
    
    // MARK: - UITableView
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataStore.sharedInstance.folderCount()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        let folder = DataStore.sharedInstance.getFolder(indexPath.row) as! Folder

        cell.textLabel!.text = folder.getName()
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
            let itemToDelete = DataStore.sharedInstance.getFolder(indexPath.row)
            managedContext?.deleteObject(itemToDelete)
            do {
                try managedContext?.save()
            } catch _ {
            }
            self.fetch()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    // set current folder in 'folders' when a row on the table is selected
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        let info = DataStore.sharedInstance.info! as Info
        info.currentFolder = indexPath.row
        return indexPath
    }
    
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
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