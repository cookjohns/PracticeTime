//
//  FolderPageViewController.swift
//  PracticeTime
//
//  Created by John Cook on 3/15/15.
//  Copyright (c) 2015 John Cook. All rights reserved.
//

import UIKit
import CoreData

@objc(FolderPageViewController)class FolderPageViewController: UITableViewController {
    
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
        
        let entity =  NSEntityDescription.entityForName("Item",
                                                        inManagedObjectContext:
            managedContext!)
        
        let folder = NSManagedObject(entity: entity!,
                                    insertIntoManagedObjectContext:managedContext)
        
        folder.setValue(input,    forKey: "name")
        folder.setValue([],        forKey: "items")
        
        do {
            try managedContext?.save()
        } catch _ {
        }
        DataStore.sharedInstance.folderObjects.append(folder)
    }
}