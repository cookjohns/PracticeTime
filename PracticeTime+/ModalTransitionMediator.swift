//
//  ModalTransitionMediator.swift
//  PracticeTime
//
//  Created by John Cook on 8/5/16.
//  Copyright © 2016 John Cook. All rights reserved.
//

protocol ModalTransitionListener {
    func popoverDismissed()
}

class ModalTransitionMediator {
    
    /* Singleton */
    class var instance: ModalTransitionMediator {
        struct Static {
            static let instance: ModalTransitionMediator = ModalTransitionMediator()
        }
        return Static.instance
    }
    
    private var listener: ModalTransitionListener?
    
    private init() {
        
    }
    
    func setListener(listener: ModalTransitionListener) {
        self.listener = listener
    }
    
    func sendPopoverDismissed(modelChanged: Bool) {
        listener?.popoverDismissed()
    }
}