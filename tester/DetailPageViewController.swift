//
//  DetailPageViewController.swift
//  PracticeTime
//
//  Created by John Cook on 12/10/14.
//  Copyright (c) 2014 John Cook. All rights reserved.
//

import UIKit
import Foundation

class DetailPageViewController: UIViewController, UIScrollViewDelegate {
    
    var startTime = NSTimeInterval()
    var timer     = NSTimer()
    var time:       Int?
    var totalTime:  UInt32 = 0
    var weekArray: [CGFloat]?

    @IBOutlet weak var stopButtonObj:  UIButton!
    @IBOutlet weak var startButtonObj: UIButton!
    @IBOutlet weak var titleField:     UILabel!
    @IBOutlet      var timerField:     UILabel!
    @IBOutlet      var todayTimeField: UILabel!
    @IBOutlet weak var monthTimeField: UILabel!
    @IBOutlet weak var totalTimeField: UILabel!
    @IBOutlet weak var percentField:   UILabel!
    @IBOutlet weak var scrollView:     UIScrollView!
    @IBOutlet weak var ChartLabel:     UILabel!
    @IBOutlet weak var CircleLabel:    UILabel!
    
    let piece = DataStore.sharedInstance.itemObjects[DataStore.sharedInstance.currentItem!]
    let managedContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var didStop: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.scrollView.pagingEnabled = true
//        self.scrollView.contentSize = CGSize(width:self.view.bounds.size.width, height:700)
//        self.scrollView.contentSize.width = scrollView.frame.size.width
//        self.scrollView.directionalLockEnabled = true;
        self.navigationController?.navigationBar.tintColor = uicolorFromHex(0xffffff)
        
        self.titleField.text     = piece.valueForKey("name") as? String
        startButtonObj.tintColor = uicolorFromHex(0x2ecc71)
        startButtonObj.titleLabel!.font      = UIFont(name: "Avenir-Medium", size:23.0)
        stopButtonObj.tintColor  = uicolorFromHex(0x2ecc71)
        stopButtonObj.titleLabel!.font       = UIFont(name: "Avenir-Medium", size:23.0)
        titleField.textColor     = uicolorFromHex(0x2ecc71)
        titleField.font          = UIFont(name: "Avenir-Medium", size:23.0)
        todayTimeField.textColor = uicolorFromHex(0x2ecc71)
        timerField.textColor     = uicolorFromHex(0x2ecc71)
        timerField.font          = UIFont(name: "Avenir-Medium", size:23.0)
        monthTimeField.textColor = uicolorFromHex(0x2ecc71)
        totalTimeField.textColor = uicolorFromHex(0x2ecc71)
        percentField.textColor   = uicolorFromHex(0x2ecc71)
        
        printTimes()
        chartSetup(weekArray!)
    }
    
    override func viewWillLayoutSubviews()
    {
        super.viewWillLayoutSubviews();
//        self.scrollView.frame = self.view.bounds;
//        self.scrollView.contentSize.height = 700; // Or whatever you want it to be.
    }
    
    
    func printTimes() {
        // print time for today
        var dictionary: Dictionary<String, NSNumber> = piece.valueForKey("times") as! Dictionary<String, NSNumber>
        var today = printDate(NSDate()) as NSString
        today     = today.substringWithRange(NSRange(location: 0, length: 8))
        var time  = dictionary[today as String]
        if (time == nil) {
            time = 0
        }
        let timeStored      = dictionary[today as String] as Int!
        if (timeStored == nil) {
            self.todayTimeField.text = "Today:           0 minutes"
        }
        else if (timeStored > 60) {
            let hours   = timeStored / 60
            let minutes = timeStored % 60
            self.todayTimeField.text = "Today:           \(minutes) minutes \(hours) hours"
        }
        else {
            self.todayTimeField.text = "Today:           \(time!) minutes"
        }
        
        
        // print time for THIS MONTH
        
        // put times in array to print to line graph
        let sortedKeys = Array(dictionary.keys).sort(>) // ["Z", "D", "A"]
        var NSWeekVals = [0.0 as NSNumber, 0.0 as NSNumber, 0.0 as NSNumber, 0.0 as NSNumber,
            0.0 as NSNumber, 0.0 as NSNumber, 0.0 as NSNumber]
        // get keys, put in graph
        var i = 0
        while (i < sortedKeys.count && i < 7) {
            NSWeekVals[i] = dictionary[sortedKeys[i]]!
            i += 1
            
        }
        // convert NSNumber values from dictionary to CGFloat for graph
        // load back into array backwards for proper display on graph
        var weekVals: [CGFloat] = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
        var j = 0
        var load = 6
        while (j < 7) {
            let temp = CGFloat(NSWeekVals[j])
            weekVals[load] = temp
            j += 1
            load -= 1
        }
        
        var todayTime = dictionary[today as String]
        if (todayTime) == nil {
            todayTime = Int(0)
        }
        else {
            todayTime = (dictionary[today as String]!)
        }
        var monthTime = 0
        
        let calendar  = NSCalendar.currentCalendar()
        let date      = NSDate()
        let dateStr   = "\(date)" as NSString
        let month     = dateStr.substringWithRange(NSRange(location: 5, length: 2))
        let monthInt  = Int(month)
        var tempMonth = monthInt
        
        // print time for all of the days in the current month
        for key in dictionary.keys {
            // calculate month value of key
            let tempKey = key as NSString
            let tempMonthString = tempKey.substringWithRange(NSRange(location: 0, length: 2))
            tempMonth = Int(tempMonthString)
            //println(tempMonth!)
            
            // add time from that day if date is in current month
            if (tempMonth == monthInt) {
                let temp = Int(dictionary[key]!)
                monthTime += temp  // holds total time for this month, in minutes
            }
        }
        if (monthTime == 0) {
            self.monthTimeField.text = "This month:   0 minutes"
        }
        else if (monthTime > 60) {
            let hours   = monthTime / 60
            let minutes = monthTime % 60
            self.monthTimeField.text = "This month:   \(minutes) minutes \(hours) hours"
        }
        else {
            self.monthTimeField.text = "This month:   \(monthTime) minutes"
        }
        
        // print total time
        for key in dictionary.keys {
            let temp = Int(dictionary[key]!)
            let x = UInt32(temp)
            totalTime += x
        }
        if (totalTime == 0) {
            self.totalTimeField.text = "Total time:     0 minutes"
        }
        else if (totalTime > 60) {
            let hours   = totalTime / 60
            let minutes = totalTime % 60
            self.totalTimeField.text = "Total time:     \(minutes) minutes \(hours) hours"
        }
        else {
            self.totalTimeField.text = "Total time:     \(totalTime) minutes"
        }
        
        // print portion of total practice time
        var appTime = DataStore.sharedInstance.totalTimeInDict
        if (appTime == nil) {
            appTime = 0
        }
        let perc: Double   = Double(totalTime) / Double(appTime!)
        var percentOfTotal = 100 * (perc)
        if (appTime == 0) {
            percentOfTotal = 0
        }
        self.percentField.text = "Time is \(percentOfTotal)% of total time."
        weekArray = weekVals
    }
    
    func chartSetup(weekVals: [CGFloat]) {
//        let calendar  = NSCalendar.currentCalendar()
//        let date      = NSDate()
//        
//        // Circle Chart
//        CircleLabel.textColor     = PNGreenColor
//        CircleLabel.font          = UIFont(name: "Avenir-Medium", size:23.0)
//        CircleLabel.textAlignment = NSTextAlignment.Center
//        CircleLabel.text          = "Percentage of Goal"
//        
//        let circleChart:PNCircleChart        = PNCircleChart(frame: CGRectMake(0, 280.0, 320, 175.0), total: 100, current: 60, clockwise: true, shadow: true)
//        circleChart.backgroundColor          = UIColor.clearColor()
//        circleChart.strokeColor              = PNGreenColor
//        circleChart.strokeColorGradientStart = UIColor.blueColor()
//        
//        // Line Chart
//        ChartLabel.textColor     = PNGreenColor
//        ChartLabel.font          = UIFont(name: "Avenir-Medium", size:23.0)
//        ChartLabel.textAlignment = NSTextAlignment.Center
//        ChartLabel.text          = "Time This Week"
//        
//        let lineChart:PNLineChart    = PNLineChart(frame: CGRectMake(20, 270.0, 320, 200.0))
//        lineChart.yLabelFormat       = "%1.1f"
//        lineChart.showLabel          = true
//        lineChart.backgroundColor    = UIColor.clearColor()
//        
//        // Add seven previous dates to dateLabelArray for printing in chart
//        let components = NSDateComponents()
//        
//        components.day = -1
//        let minusOne   = calendar.dateByAddingComponents(components, toDate: date, options: [])
//        components.day = -2
//        let minusTwo   = calendar.dateByAddingComponents(components, toDate: date, options: [])
//        components.day = -3
//        let minusThree = calendar.dateByAddingComponents(components, toDate: date, options: [])
//        components.day = -4
//        let minusFour  = calendar.dateByAddingComponents(components, toDate: date, options: [])
//        components.day = -5
//        let minusFive  = calendar.dateByAddingComponents(components, toDate: date, options: [])
//        components.day = -6
//        let minusSix   = calendar.dateByAddingComponents(components, toDate: date, options: [])
//        
//        var todayForm      = (printDate(NSDate()) as NSString).substringWithRange(NSRange(location: 0, length: 5))
//        todayForm          = dateFormat(todayForm)
//        var minusOneForm   = (printDate(minusOne!) as NSString).substringWithRange(NSRange(location: 0, length: 5))
//        minusOneForm       = dateFormat(minusOneForm)
//        var minusTwoForm   = (printDate(minusTwo!) as NSString).substringWithRange(NSRange(location: 0, length: 5))
//        minusTwoForm       = dateFormat(minusTwoForm)
//        var minusThreeForm = (printDate(minusThree!) as NSString).substringWithRange(NSRange(location: 0, length: 5))
//        minusThreeForm     = dateFormat(minusThreeForm)
//        var minusFourForm  = (printDate(minusFour!) as NSString).substringWithRange(NSRange(location: 0, length: 5))
//        minusFourForm      = dateFormat(minusFourForm)
//        var minusFiveForm  = (printDate(minusFive!) as NSString).substringWithRange(NSRange(location: 0, length: 5))
//        minusFiveForm      = dateFormat(minusFiveForm)
//        var minusSixForm   = (printDate(minusSix!) as NSString).substringWithRange(NSRange(location: 0, length: 5))
//        minusSixForm       = dateFormat(minusSixForm)
//        
//        let dateLabelArray = [minusSixForm, minusFiveForm, minusThreeForm, minusTwoForm, minusOneForm, todayForm]
//        
//        lineChart.xLabels            = dateLabelArray
//        lineChart.showCoordinateAxis = true
//        
//        var data01Array: [CGFloat]   = weekVals
//        let data01:PNLineChartData   = PNLineChartData()
//        data01.color                 = PNGreenColor
//        data01.itemCount             = data01Array.count
//        data01.inflexionPointStyle   = PNLineChartData.PNLineChartPointStyle.PNLineChartPointStyleCycle
//        data01.getData               = ({(index: Int) -> PNLineChartDataItem in
//            let yValue:CGFloat = data01Array[index]
//            let item = PNLineChartDataItem()
//            item.y   = yValue
//            return item
//        })
//        
//        lineChart.chartData = [data01]
//        lineChart.strokeChart()
//        
//        circleChart.strokeChart()
//        
//        scrollView.addSubview(lineChart)
//        scrollView.addSubview(ChartLabel)
//        scrollView.addSubview(circleChart)
//        scrollView.addSubview(CircleLabel)
    }
    
    @IBAction func startButton(sender:AnyObject) {
        didStop = false
        if !timer.valid {
            let aSelector : Selector = #selector(DetailPageViewController.updateTime)
            timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: aSelector, userInfo:   nil, repeats: true)
            startTime = NSDate.timeIntervalSinceReferenceDate()
        }
        piece.setValue(NSDate(),      forKey: "lastAccess")
        do {
            try managedContext?.save()
        } catch _ {
        }
    }
    @IBAction func stopButton(sender:AnyObject) {
        timer.invalidate()
        didStop = true
        var dictionary: Dictionary<String, NSNumber> = piece.valueForKey("times") as! Dictionary<String, NSNumber>
        var temp = dictionary[printDate(NSDate())] as Int?
        if (temp == nil) {
            temp = 0
        }
        let final         = temp! + time!
        piece.setValue(final,      forKey: "totalTime")
        var today         = printDate(NSDate()) as NSString
        today             = today.substringWithRange(NSRange(location: 0, length: 8))
        print(today)
        dictionary[today as String] = final
        piece.setValue(dictionary, forKey: "times")
        
        do {
            try managedContext?.save()
        } catch _ {
        }
    }
    
    func dateFormat(input: String) -> String {
        var result = input
        var array = Array(result.characters)
        if (array[1] == "/") {
            result = "0" + result
        }
        array = Array(result.characters)
        if (array[4] == "/") {
            let resultNS = result as NSString
            result       = resultNS.substringWithRange(NSRange(location: 0, length: 3)) + "0" + resultNS.substringWithRange(NSRange(location: 3, length: 1))
        }
        return result
    }
    
    func uicolorFromHex(rgbValue:UInt32)->UIColor{
        let red   = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue  = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateTime() {
        let currentTime = NSDate.timeIntervalSinceReferenceDate()
        var elapsedTime: NSTimeInterval = currentTime - startTime
        let minutes     = UInt8(elapsedTime / 60.0)
        elapsedTime    -= (NSTimeInterval(minutes) * 60)
        let seconds     = UInt8(elapsedTime)
        elapsedTime    -= NSTimeInterval(seconds)
        let fraction    = UInt8(elapsedTime * 100)
        let strMinutes  = minutes > 9 ? String(minutes):"0" + String(minutes)
        let strSeconds  = seconds > 9 ? String(seconds):"0" + String(seconds)
        let strFraction = fraction > 9 ? String(fraction):"0" + String(fraction)
        timerField.text = "\(strMinutes):\(strSeconds):\(strFraction)"
        time = Int(strMinutes)
    }
    
    func printDate(date:NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        
        let theDateFormat = NSDateFormatterStyle.ShortStyle
        let theTimeFormat = NSDateFormatterStyle.ShortStyle
        
        dateFormatter.dateStyle = theDateFormat
        dateFormatter.timeStyle = theTimeFormat
        
        return dateFormatter.stringFromDate(date)
    }

    // MARK: - Navigation

    // Preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        timer.invalidate()
        if (didStop == false) {
            let temp = piece.valueForKey("totalTime") as! Int?
            let final = temp! + time!
            piece.setValue(final,      forKey: "totalTime")
            do {
                try managedContext?.save()
            } catch _ {
            }
        }
    }
}