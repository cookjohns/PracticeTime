//
//  ViewController.swift
//  PracticeTime
//
//  Created by John Cook on 12/9/14.
//  Copyright (c) 2014 John Cook. All rights reserved.
//

import UIKit
import CoreData

class AddPieceViewController: UIViewController {
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var titleField: UITextField!
    let managedContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Avenir-Medium", size:23.0)!, NSForegroundColorAttributeName: uicolorFromHex(0xffffff)]
        self.navigationController?.navigationBar.barTintColor = uicolorFromHex(0x2ecc71)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "DismissAndSave" {
            self.saveName(titleField.text)
            //saveName(titleField.text)
        }
    }
    
    func saveName(input: String) {

        let entity =  NSEntityDescription.entityForName("Piece",
            inManagedObjectContext:
            managedContext!)
        
        let piece = NSManagedObject(entity: entity!,
            insertIntoManagedObjectContext:managedContext)
        var today = printDate(NSDate())
        var dict: Dictionary<String, NSNumber> = [today:0]
        
        piece.setValue(input,    forKey: "title")
        piece.setValue(0,        forKey: "totalTime")
        piece.setValue(NSDate(), forKey: "lastAccess")
        piece.setValue(0.0,      forKey: "timeSinceLastAccess")
        piece.setValue(dict,     forKey: "times")
        
        managedContext?.save(nil)
        
        PieceStorage.sharedInstance.pieceObjects.append(piece)
    }
    
    override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!) {
        self.view.endEditing(true)
    }
    
    func printDate(date:NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        
        var theDateFormat = NSDateFormatterStyle.ShortStyle
        let theTimeFormat = NSDateFormatterStyle.ShortStyle
        
        dateFormatter.dateStyle = theDateFormat
        dateFormatter.timeStyle = theTimeFormat
        
        return dateFormatter.stringFromDate(date)
    }
    
    func uicolorFromHex(rgbValue:UInt32)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }
}

