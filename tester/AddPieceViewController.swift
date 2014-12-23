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
}

