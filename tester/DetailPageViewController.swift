//
//  DetailPageViewController.swift
//  PracticeTime
//
//  Created by John Cook on 12/10/14.
//  Copyright (c) 2014 John Cook. All rights reserved.
//

import UIKit

class DetailPageViewController: UIViewController {
    
    var startTime = NSTimeInterval()
    var timer = NSTimer()
    var time: Int?

    @IBOutlet weak var stopButtonObj: UIButton!
    @IBOutlet weak var startButtonObj: UIButton!
    @IBOutlet weak var titleField: UILabel!
    @IBOutlet var timerField: UILabel!
    @IBOutlet var totalTimeField: UILabel!
    @IBOutlet weak var monthTimeField: UILabel!
    
    let piece = PieceStorage.sharedInstance.pieceObjects[PieceStorage.sharedInstance.currentIndex!]
    let managedContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
    var didStop: Bool?
    
    @IBAction func startButton(sender:AnyObject) {
        didStop = false
        if !timer.valid {
        let aSelector : Selector = "updateTime"
            timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: aSelector, userInfo:   nil, repeats: true)
            startTime = NSDate.timeIntervalSinceReferenceDate()
        }
        piece.setValue(NSDate(),      forKey: "lastAccess")
        
        managedContext?.save(nil)
    }
    @IBAction func stopButton(sender:AnyObject) {
        timer.invalidate()
        didStop = true
        var dictionary: Dictionary<String, NSNumber> = piece.valueForKey("times") as Dictionary<String, NSNumber>
        var temp = dictionary[printDate(NSDate())] as Int?
        if (temp == nil) {
            temp = 0
        }
        var final = temp! + time!
        piece.setValue(final,      forKey: "totalTime")
        var today = printDate(NSDate())
        dictionary[today] = final
        piece.setValue(dictionary, forKey: "times")
        managedContext?.save(nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleField.text = piece.valueForKey("title") as String
        self.titleField.text = piece.valueForKey("title") as String
        startButtonObj.tintColor = uicolorFromHex(0x2ecc71)
        stopButtonObj.tintColor = uicolorFromHex(0x2ecc71)
        titleField.textColor = uicolorFromHex(0x2ecc71)
        totalTimeField.textColor = uicolorFromHex(0x2ecc71)
        timerField.textColor = uicolorFromHex(0x2ecc71)
        monthTimeField.textColor = uicolorFromHex(0x2ecc71)
        
        // print time for today
        var dictionary: Dictionary<String, NSNumber> = piece.valueForKey("times") as Dictionary<String, NSNumber>
        var today = printDate(NSDate())
        var time = dictionary[today]
        if (time == nil) {
            time = 0
        }
        var timeStored = dictionary[today] as Int!
        if (timeStored == nil) {
            self.totalTimeField.text = "Today's time: 0 minutes"
        }
        else if (timeStored > 60) {
            var hours = timeStored / 60
            var minutes = timeStored % 60
            self.totalTimeField.text = "Today's time: \(minutes) minutes \(hours) hours"
        }
        else {
            self.totalTimeField.text = "Today's time: \(time!) minutes"
        }
        
        // print time for this month
        var todayTime = dictionary[today]
        if (todayTime) == nil {
            todayTime = Int(0)
        }
        else {
            todayTime = (dictionary[today]!)
        }
        var monthTime = Int(todayTime!)
        
        let calendar = NSCalendar.currentCalendar()
        var date = NSDate()
        let dateStr = "\(date)" as NSString
        let month = dateStr.substringWithRange(NSRange(location: 5, length: 2))
        let monthInt = month.toInt()
        var tempMonth = monthInt
        
        // all of the days in the current month
        while (tempMonth == monthInt) {
            // calculate day
            let components = NSDateComponents()
            components.day = -1
            let tempDate = "\(calendar.dateByAddingComponents(components, toDate: date, options: nil))" as NSString
            let temp = tempDate.substringWithRange(NSRange(location: 14, length: 2))
            tempMonth = temp.toInt()
            date = calendar.dateByAddingComponents(components, toDate: date, options: nil)!
            
            // add time from that day
            todayTime = dictionary[printDate(date)]
            if (todayTime) == nil {
                todayTime = Int(0)
            }
            else {
                todayTime = (dictionary[today]!)
            }
            monthTime += Int(todayTime!)  // holds total time for this month, in minutes
        }
        if (monthTime == 0) {
            self.monthTimeField.text = "This month's time: 0 minutes"
        }
        else if (monthTime > 60) {
            var hours = monthTime / 60
            var minutes = monthTime % 60
            self.monthTimeField.text = "This month's time: \(minutes) minutes \(hours) hours"
        }
        else {
            self.monthTimeField.text = "This month's time: \(monthTime) minutes"
        }
    }
    
    func uicolorFromHex(rgbValue:UInt32)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateTime() {
        var currentTime = NSDate.timeIntervalSinceReferenceDate()
        var elapsedTime: NSTimeInterval = currentTime - startTime
        let minutes = UInt8(elapsedTime / 60.0)
        elapsedTime -= (NSTimeInterval(minutes) * 60)
        let seconds = UInt8(elapsedTime)
        elapsedTime -= NSTimeInterval(seconds)
        let fraction = UInt8(elapsedTime * 100)
        let strMinutes = minutes > 9 ? String(minutes):"0" + String(minutes)
        let strSeconds = seconds > 9 ? String(seconds):"0" + String(seconds)
        let strFraction = fraction > 9 ? String(fraction):"0" + String(fraction)
        timerField.text = "\(strMinutes):\(strSeconds):\(strFraction)"
        time = strMinutes.toInt()
    }
    
    func printDate(date:NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        
        var theDateFormat = NSDateFormatterStyle.ShortStyle
        let theTimeFormat = NSDateFormatterStyle.ShortStyle
        
        dateFormatter.dateStyle = theDateFormat
        dateFormatter.timeStyle = theTimeFormat
        
        return dateFormatter.stringFromDate(date)
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        timer.invalidate()
        if (didStop == false) {
            var temp = piece.valueForKey("totalTime") as Int?
            var final = temp! + time!
            piece.setValue(final,      forKey: "totalTime")
            managedContext?.save(nil)
        }
    }

}
