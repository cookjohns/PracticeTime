//
//  DismissSegue.swift
//  PracticeTime
//
//  Created by John Cook on 12/9/14.
//  Copyright (c) 2014 John Cook. All rights reserved.
//

import UIKit

@objc(DismissSegue) class DismissSegue: UIStoryboardSegue {
   
    override func perform() {
        if let controller = sourceViewController.presentingViewController? {
            controller.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
}
