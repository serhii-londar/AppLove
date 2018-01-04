//
//  ReviewLoadManager.swift
//  App Love
//
//  Created by Woodie Dovich on 2016-03-24.
//  Copyright © 2016 Snowpunch. All rights reserved.
//
//  Mass Multi-threaded page loader that can be safely canceled.
//  

import UIKit

class ReviewLoadManager: NSObject, ProgressDelegate {
    static let sharedInst = ReviewLoadManager()
    private override init() {} // enforce singleton
    
    var reviews = [ReviewModel]()
    var loadStates = [String:LoadState]() // loading state for every territory.
    var loadingQueue:OperationQueue?
    var firstQuickUpdate:Bool = false
    var loadStateArray = [LoadState]()

    func initializeLoadingStates() {
        loadStates.removeAll()
        loadStateArray.removeAll()
        let territories = TerritoryMgr.sharedInst.getSelectedCountryCodes()
        for code in territories {
            let loadState =  LoadState(territory: code)
            loadStates[code] = loadState
            loadStateArray.append(loadState)
        }
        
        self.firstQuickUpdate = false
    }
    
    func loadReviews() {
        clearReviews()
        initializeLoadingStates()
        self.loadingQueue = nil
        self.loadingQueue = OperationQueue()
        self.loadingQueue?.maxConcurrentOperationCount = 4
        setNotifications()
        NotificationCenter.post(aName: Const.load.loadStart)
        
        let countryCodes = TerritoryMgr.sharedInst.getSelectedCountryCodes()
        
        let allOperationsFinishedOperation = BlockOperation() {
            NotificationCenter.post(aName: Const.load.allLoadingCompleted)
        }
        
        if let appId = AppList.sharedInst.getSelectedModel()?.appId {
            for code in countryCodes {
                let pageInfo = PageInfo(appId: appId, territory: code)
                let operation = TerritoryLoadOperation(pageInfo: pageInfo)
                operation.delegate = self
                allOperationsFinishedOperation.addDependency(operation)
                self.loadingQueue?.addOperation(operation)
            }
        }
        
        OperationQueue.main.addOperation(allOperationsFinishedOperation)
    }
    
    // ProgressDelegate - update bar territory
    func territoryLoadCompleted(country:String) {
        //print("territoryLoadCompleted "+country)
        
        DispatchQueue.main.async {
            let data:[String:AnyObject] = ["territory": country as AnyObject]
            let nc = NotificationCenter.default
            nc.post(name: NSNotification.Name(rawValue: Const.load.territoryDone), object: nil, userInfo: data)
        }
    }
    
    // ProgressDelegate - update bar territory
    func territoryLoadStarted(country:String) {
        //print("territoryLoadStarted "+country)
        
        DispatchQueue.main.async {
            let data:[String:AnyObject] = ["territory":country as AnyObject]
            let nc = NotificationCenter.default
            nc.post(name: NSNotification.Name(rawValue: Const.load.territoryStart), object: nil, userInfo: data)
        }
    }
    
    // ProgressDelegate - update bar territory
    func pageLoaded(country territory:String, reviews:[ReviewModel]?) {
        
        DispatchQueue.main.async {
            
            if reviews == nil {
                if let loadState = self.loadStates[territory] {
                    loadState.error = true
                }
                let data:[String:AnyObject] = ["error":"error" as AnyObject, "territory":territory as AnyObject]
                let nc = NotificationCenter.default
                nc.post(name: NSNotification.Name(rawValue: Const.load.dataError), object: nil, userInfo: data)
            }
            
            if let newReviews = reviews {
                if newReviews.count > 0 {
                    self.reviews.append(contentsOf: newReviews)
                }
                
                if let loadState = self.loadStates[territory] {
                    loadState.count += newReviews.count
                    loadState.error = false
                }
                
                if let loadState = self.loadStates[territory] {
                    loadState.error = false
                    let data:[String:AnyObject] = ["loadState":loadState,"territory":territory as AnyObject]
                    let nc = NotificationCenter.default
                    
                    nc.post(name: NSNotification.Name(rawValue: Const.load.updateAmount), object: nil, userInfo: data)
                }
                
                // let the user read something while still loading, 
                // after the first 99 reviews are loaded - display them.
                if self.firstQuickUpdate == false && self.reviews.count > 99 {
                    self.updateTable()
                }
            }
        }
    }
    
    func updateTable() {
        NotificationCenter.post(aName: Const.load.reloadData)
        self.firstQuickUpdate = true
    }
    
    func setNotifications() {
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.addObserver(observer: self, sel:.updateTableData, name: Const.load.allLoadingCompleted)
    }
    
    func updateTableData(notification: NSNotification) {
        NotificationCenter.post(aName: Const.load.reloadData)
    }
    
    func clearReviews() {
        reviews.removeAll()
        loadStates.removeAll()
    }
    
    func cancelLoading() {
        self.loadingQueue?.cancelAllOperations()
    }
    
    func getNonEmptyTerritories() -> [String] {
        var emptyArray = [String]()
        for (territory,loadState) in loadStates {
            if loadState.count > 0 {
                emptyArray.append(territory)
            }
        }
        return emptyArray;
    }
    
    func getFlaggedReviews() -> [ReviewModel] {
        var flaggedReviews = [ReviewModel]()
        for review in reviews {
            if review.flag == true {
                flaggedReviews.append(review)
            }
        }
        return flaggedReviews
    }
}

private extension Selector {
    static let updateTableData = #selector(ReviewLoadManager.updateTableData(notification:))
}
