//
//  WeekdayStartView.swift
//  PracticeTime
//
//  Created by John Cook on 8/2/16.
//  Copyright © 2016 John Cook. All rights reserved.
//

import UIKit

class WeekdayStartView: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    // MARK: - Variables
    
    let managedContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    let info = DataStore.sharedInstance.info! as Info
    
    let pickerData = [
        ["Saturday","Sunday","Monday","Tuesday","Wednesday", "Thursday", "Friday"]
    ]
    
    enum PickerComponent: Int {
        case days = 0
    }
    
    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var dayPicker: UIPickerView!
    
    // MARK: - viewDid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Avenir-Medium", size:23.0)!, NSForegroundColorAttributeName: uicolorFromHex(0xffffff)]
        self.navigationController?.navigationBar.barStyle = UIBarStyle.BlackTranslucent
        self.navigationController?.navigationBar.barTintColor = uicolorFromHex(0x2ecc71)
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.whiteColor()
        self.navigationItem.leftBarButtonItem?.tintColor  = UIColor.whiteColor()
        
        myLabel.textColor = UIColor.blackColor()
        myLabel.font      = UIFont(name: "Avenir-Medium", size: 17)

        
        dayPicker.delegate        = self
        dayPicker.dataSource      = self
        dayPicker.backgroundColor = uicolorFromHex(0xecf0f1)
        dayPicker.selectRow(2, inComponent: PickerComponent.days.rawValue, animated: false)
        dayPicker.setValue(UIColor.blackColor(), forKeyPath: "textColor")
        dayPicker.setValue(0.8, forKeyPath: "alpha")
    }
    
    override func viewWillDisappear(animated: Bool) {
        ModalTransitionMediator.instance.sendPopoverDismissed(true)
    }
    
    // MARK: - Actions
    
    @IBAction func cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func save(sender: AnyObject) {
        let daysComponent   = PickerComponent.days.rawValue
        
        // calculate hours from picker
        let day = dayPicker.selectedRowInComponent(daysComponent)
        info.changeStartingDay(day)
        
        // save
        do {
            try managedContext?.save()
        } catch {
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK - Picker Delgates and DataSource

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return pickerData.count
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData[component].count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[component][row]
    }
    
    // MARK: - Formatting
    
    func uicolorFromHex(rgbValue:UInt32)->UIColor{
        let red   = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue  = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }
}
