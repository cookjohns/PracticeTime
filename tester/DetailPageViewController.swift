//
//  DetailPageViewController.swift
//  PracticeTime
//
//  Created by John Cook on 12/10/14.
//  Copyright (c) 2014 John Cook. All rights reserved.
//

import UIKit

class DetailPageViewController: UIViewController, UIScrollViewDelegate {
    
    var startTime = NSTimeInterval()
    var timer = NSTimer()
    var time: Int?
    var totalTime: UInt32 = 0

    @IBOutlet weak var stopButtonObj: UIButton!
    @IBOutlet weak var startButtonObj: UIButton!
    @IBOutlet weak var titleField: UILabel!
    @IBOutlet var timerField: UILabel!
    @IBOutlet var todayTimeField: UILabel!
    @IBOutlet weak var monthTimeField: UILabel!
    @IBOutlet weak var totalTimeField: UILabel!
    @IBOutlet weak var percentField: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var ChartLabel: UILabel!
    @IBOutlet weak var CircleLabel: UILabel!
    
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
        var final         = temp! + time!
        piece.setValue(final,      forKey: "totalTime")
        var today         = printDate(NSDate()) as NSString
        today             = today.substringWithRange(NSRange(location: 0, length: 8))
        println(today)
        dictionary[today] = final
        piece.setValue(dictionary, forKey: "times")
        
//        var tempTime: UInt32 = 0
//        if (PieceStorage.sharedInstance.totalTimeInDict != nil) {
//            tempTime = 0
//        }
//        tempTime += Int(time!)
//        PieceStorage.sharedInstance.totalTimeInDict = tempTime
        
        managedContext?.save(nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView.pagingEnabled = true
        self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 700, 320);
        self.navigationController?.navigationBar.tintColor = uicolorFromHex(0xffffff)
        
        self.titleField.text     = piece.valueForKey("title") as? String
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
        
        // print time for today
        var dictionary: Dictionary<String, NSNumber> = piece.valueForKey("times") as Dictionary<String, NSNumber>
        var today = printDate(NSDate()) as NSString
        today     = today.substringWithRange(NSRange(location: 0, length: 8))
        var time  = dictionary[today]
        if (time == nil) {
            time = 0
        }
        var timeStored      = dictionary[today] as Int!
        if (timeStored == nil) {
            self.todayTimeField.text = "Today:           0 minutes"
        }
        else if (timeStored > 60) {
            var hours   = timeStored / 60
            var minutes = timeStored % 60
            self.todayTimeField.text = "Today:           \(minutes) minutes \(hours) hours"
        }
        else {
            self.todayTimeField.text = "Today:           \(time!) minutes"
        }
        
        
        // print time for THIS MONTH
        
        // put times in array to print to line graph
        let sortedKeys = Array(dictionary.keys).sorted(>) // ["Z", "D", "A"]
        var NSWeekVals = [0.0 as NSNumber, 0.0 as NSNumber, 0.0 as NSNumber, 0.0 as NSNumber,
            0.0 as NSNumber, 0.0 as NSNumber, 0.0 as NSNumber]
        // get keys, put in graph
        var i = 0
        while (i < sortedKeys.count && i < 7) {
            NSWeekVals[i] = dictionary[sortedKeys[i]]!
            i++
            
        }
        // convert NSNumber values from dictionary to CGFloat for graph
        // load back into array backwards for proper display on graph
        var weekVals: [CGFloat] = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
        var j = 0
        var load = 6
        while (j < 7) {
            var temp = CGFloat(NSWeekVals[j])
            weekVals[load] = temp
            j++
            load--
        }
        
        var todayTime = dictionary[today]
        if (todayTime) == nil {
            todayTime = Int(0)
        }
        else {
            todayTime = (dictionary[today]!)
        }
        var monthTime = 0//Int(todayTime!)
        
        let calendar  = NSCalendar.currentCalendar()
        var date      = NSDate()
        let dateStr   = "\(date)" as NSString
        let month     = dateStr.substringWithRange(NSRange(location: 5, length: 2))
        let monthInt  = month.toInt()
        var tempMonth = monthInt
        
        // print time for all of the days in the current month
        for key in dictionary.keys {
            // calculate month value of key
            let tempKey = key as NSString
            let tempMonthString = tempKey.substringWithRange(NSRange(location: 0, length: 2))
            tempMonth = tempMonthString.toInt()
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
            var hours   = monthTime / 60
            var minutes = monthTime % 60
            self.monthTimeField.text = "This month:   \(minutes) minutes \(hours) hours"
        }
        else {
            self.monthTimeField.text = "This month:   \(monthTime) minutes"
        }
        
        // print total time
        for key in dictionary.keys {
            //println(key)
            let temp = Int(dictionary[key]!)
            totalTime += temp
        }
        if (totalTime == 0) {
            self.totalTimeField.text = "Total time:     0 minutes"
        }
        else if (totalTime > 60) {
            var hours   = totalTime / 60
            var minutes = totalTime % 60
            self.totalTimeField.text = "Total time:     \(minutes) minutes \(hours) hours"
        }
        else {
            self.totalTimeField.text = "Total time:     \(totalTime) minutes"
        }
        
        // print portion of total practice time
        var appTime = PieceStorage.sharedInstance.totalTimeInDict
        if (appTime == nil) {
            appTime = 0
        }
        let perc: Double   = Double(totalTime) / Double(appTime!)
        var percentOfTotal = 100 * (perc)
        if (appTime == 0) {
            percentOfTotal = 0
        }
        self.percentField.text = "Time is \(percentOfTotal)% of total time."
        
        // get last 7 days of time
        
        
        
        
        
        ///////////   CHARTS    ////////////
        
        // Circle Chart
        CircleLabel.textColor     = PNGreenColor
        CircleLabel.font          = UIFont(name: "Avenir-Medium", size:23.0)
        CircleLabel.textAlignment = NSTextAlignment.Center
        CircleLabel.text          = "Percentage of Goal"
        
        var circleChart:PNCircleChart        = PNCircleChart(frame: CGRectMake(0, 280.0, 320, 175.0), total: 100, current: 60, clockwise: true, shadow: true)
        circleChart.backgroundColor          = UIColor.clearColor()
        circleChart.strokeColor              = PNGreenColor
        circleChart.strokeColorGradientStart = UIColor.blueColor()
        
        // Line Chart
        ChartLabel.textColor     = PNGreenColor
        ChartLabel.font          = UIFont(name: "Avenir-Medium", size:23.0)
        ChartLabel.textAlignment = NSTextAlignment.Center
        ChartLabel.text          = "Time This Week"
        
        var lineChart:PNLineChart    = PNLineChart(frame: CGRectMake(20, 270.0, 320, 200.0))
        lineChart.yLabelFormat       = "%1.1f"
        lineChart.showLabel          = true
        lineChart.backgroundColor    = UIColor.clearColor()
        let todayLabel = today.substringWithRange(NSRange(location: 0, length: 5)) // "12/31"
        let prefix     = today.substringWithRange(NSRange(location: 0, length: 3)) // "12/"
        let dayOfMonth = today.substringWithRange(NSRange(location: 3, length: 2)).toInt() // "31"
//        let dateLabelArray = [prefix + String(dayOfMonth! - 6), prefix + String(dayOfMonth! - 5), prefix + String(dayOfMonth! - 4), prefix + String(dayOfMonth! - 3), prefix + String(dayOfMonth! - 2), prefix + String(dayOfMonth! - 1), todayLabel]
//        for d in dateLabelArray {
//            println(d)
//        }
        
        lineChart.xLabels            = /*dateLabelArray*/ ["SEP 1","SEP 2","SEP 3","SEP 4","SEP 5","SEP 6","SEP 7"]
        lineChart.showCoordinateAxis = true
        
        var data01Array: [CGFloat]   = weekVals
        var data01:PNLineChartData   = PNLineChartData()
        data01.color                 = PNGreenColor
        data01.itemCount             = data01Array.count
        data01.inflexionPointStyle   = PNLineChartData.PNLineChartPointStyle.PNLineChartPointStyleCycle
        data01.getData               = ({(index: Int) -> PNLineChartDataItem in
            var yValue:CGFloat = data01Array[index]
            var item = PNLineChartDataItem()
            item.y = yValue
            return item
        })
        
        lineChart.chartData = [data01]
        lineChart.strokeChart()
        
        circleChart.strokeChart()
        
        scrollView.addSubview(lineChart)
        scrollView.addSubview(ChartLabel)
        scrollView.addSubview(circleChart)
        scrollView.addSubview(CircleLabel)
        
        //////////////    END CHART    //////////////////
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
        var currentTime = NSDate.timeIntervalSinceReferenceDate()
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
