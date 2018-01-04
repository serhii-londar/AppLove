//
//  Defaults.swift
//  App Love
//
//  Created by Woodie Dovich on 2016-07-26.
//  Copyright © 2016 Snowpunch. All rights reserved.
//
//  NSUserDefaults wrapper

import UIKit

class Defaults: NSObject {

    class func setInitialDefaults() {
        let defaults = UserDefaults.standard
        if defaults.object(forKey: Const.defaults.loadAllVersionsKey) == nil {
            defaults.set(false, forKey: Const.defaults.loadAllVersionsKey)
        }
        if defaults.object(forKey: Const.defaults.maxPagesToLoadKey) == nil {
            defaults.set(10, forKey: Const.defaults.maxPagesToLoadKey)
        }
    }
    
    class func setLoadAll(loadAll:Bool) {
        let defaults = UserDefaults.standard
        defaults.set(loadAll, forKey: Const.defaults.loadAllVersionsKey)
    }
    
    class func getLoadAllBool() -> Bool {
        let defaults = UserDefaults.standard
        return defaults.bool(forKey: Const.defaults.loadAllVersionsKey)
    }
    
    class func setMaxPagesToLoad(maxPages:Int) {
        let defaults = UserDefaults.standard
        defaults.set(maxPages, forKey: Const.defaults.maxPagesToLoadKey)
    }
    
    class func getMaxPagesToLoadInt() -> Int {
        let defaults = UserDefaults.standard
        return defaults.integer(forKey: Const.defaults.maxPagesToLoadKey)
    }
}
