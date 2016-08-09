//
//  FolderPageViewController.swift
//  PracticeTime
//
//  Created by John Cook on 3/15/15.
//  Copyright (c) 2015 John Cook. All rights reserved.
//

import UIKit
import CoreData

@objc(FolderDetailViewController) class FolderDetailViewController: UITableViewController, ModalTransitionListener {
    
    // MARK: - Variables
    
    let folderFetchRequest = NSFetchRequest(entityName: "Folder")
    let managedContext     = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    let info = DataStore.sharedInstance.info! as Info
    
    var folder: Folder?
    
    // MARK: - viewDid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView(frame:CGRectZero)
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Avenir-Medium", size:23.0)!, NSForegroundColorAttributeName: uicolorFromHex(0xffffff)]
        self.navigationController?.navigationBar.barStyle = UIBarStyle.BlackTranslucent
        self.navigationController?.navigationBar.barTintColor = uicolorFromHex(0x2ecc71)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        // listener for resetting view
        ModalTransitionMediator.instance.setListener(self)
        
        // set title
        folder = (DataStore.sharedInstance.getFolder(info.getCurrentFolder()) as! Folder)
        self.navigationItem.title = folder!.name
    }
    
    // MARK: - UITableView
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        folder = (DataStore.sharedInstance.getFolder(info.getCurrentFolder()) as! Folder)
        if folder!.items.count == 0 {
            return 1
        }
        return folder!.items.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        folder = (DataStore.sharedInstance.getFolder(info.getCurrentFolder()) as! Folder)
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        cell.accessoryType = .None
        
        cell.textLabel!.font = UIFont(name: "Avenir-Medium", size:20.0)
        cell.textLabel?.textColor = uicolorFromHex(0x2ecc71)

        if folder!.itemCount() == 0 {
            cell.textLabel!.text = "This folder is empty"
            cell.textLabel!.textAlignment = .Center
            tableView.separatorStyle = .None
        }
        else {
            if indexPath.row <= (DataStore.sharedInstance.getAllItems().count)-1 {
                let name = folder!.getNameAtIndex(indexPath.row)
                cell.textLabel!.text = name
            }
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        folder = (DataStore.sharedInstance.getFolder(info.getCurrentFolder()) as! Folder)
        if folder!.itemCount() > 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
            // set currentItem based on item selected (match by name)
            let instance = DataStore.sharedInstance
            let info = instance.info! as Info
        
            // get name of selected item
            folder = (instance.getFolder(info.getCurrentFolder()) as! Folder)
            let selectedName = folder!.getNameAtIndex(indexPath.row)
            // get index of selected item (match by name)
            let itemIndex = instance.getItemIndexForName(selectedName)
        
            // set currentItem
            info.changeCurrentItem(itemIndex)
            
            // perform segue
            self.performSegueWithIdentifier("folderToItemDetailSegue", sender: cell)
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
            let itemToDelete = folder!.getNameAtIndex(indexPath.row)
            folder!.deleteItem(itemToDelete)
            folder!.setValue(folder!.items, forKey: "items")
            do {
                try managedContext?.save()
            } catch _ {
            }
            self.fetch()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    // MARK: - CoreData
    
    func fetch() {
        // Create a sort descriptor object that sorts on the "name"
        // property of the Core Data object
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        
        // Set the list of sort descriptors in the fetch request,
        // so it includes the sort descriptor
        folderFetchRequest.sortDescriptors = [sortDescriptor]
        
        if let fetchResults = (try? managedContext!.executeFetchRequest(folderFetchRequest)) as? [Folder] {
            DataStore.sharedInstance.setFolderObjects(fetchResults)
        }
    }
    
    // MARK: - ModalTransitionListener
    
    func popoverDismissed() {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
        let indexPathZero = NSIndexPath(forRow: 0, inSection: 0)
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPathZero)
        self.tableView.reloadData()
    }
    
    // MARK: - Formatting
    
    func uicolorFromHex(rgbValue:UInt32)->UIColor{
        let red   = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue  = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }
}