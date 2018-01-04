//
//  NSNotificationCenter+sugar.swift
//  App Love
//
//  Created by Woodie Dovich on 2016-07-07.
//  Copyright © 2016 Snowpunch. All rights reserved.
//
//  Syntatic Suger. More condenced forms of adding observers and posting.

import Foundation

extension NotificationCenter {
    
    class func post (aName: String, object: AnyObject?=nil) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: aName), object: object)
    }

    class func addObserver (observer: AnyObject, sel: Selector, name aName: String?, object anObject: AnyObject?=nil) {
        NotificationCenter.default.addObserver(observer, selector: sel, name: aName.map { NSNotification.Name(rawValue: $0) }, object: anObject)
    }
}
