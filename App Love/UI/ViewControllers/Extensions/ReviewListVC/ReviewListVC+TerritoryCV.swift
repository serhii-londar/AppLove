//
//  ReviewListVC+CVDataSource.swift
//  App Love
//
//  Created by Woodie Dovich on 2016-08-18.
//  Copyright © 2016 Snowpunch. All rights reserved.
//
//  Territory loading control.
//  Horrizontal UICollectionView filled with territory flags.
//  Notifications from loader to visually show loading progress.
//

import UIKit

private extension Selector {
    static let finishedLoading = #selector(ReviewListVC.finishedLoading)
    static let updateLoadingCount = #selector(ReviewListVC.updateLoadingCount)
    static let startLoading = #selector(ReviewListVC.startLoading)
}

extension ReviewListVC: UICollectionViewDataSource {
    
    func showEmptyView() {
        territoryCollection.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        appName.text = "Select an App"
        aveRating.text = "on the left"
    }
    
    func setupCollection() {
        
        territoryCollection.delegate = self
        territoryCollection.dataSource = self
        territoryCollection.bounces = true
        territoryCollection.autoresizingMask = [UIViewAutoresizing.flexibleHeight, UIViewAutoresizing.flexibleWidth]
        territoryCollection.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        territoryCollection.register(TerritoryLoadCell.self, forCellWithReuseIdentifier: "territoryLoadCell")
        territoryCollection.register(UINib(nibName: "TerritoryLoadCell", bundle: nil), forCellWithReuseIdentifier: "territoryLoadCell")
        
        // App Info
        if let appModel = AppList.sharedInst.getSelectedModel(),
            let urlStr = appModel.icon100,
            let url =  URL(string:urlStr) {
            appIcon.sd_setImage(with: url, placeholderImage: UIImage(named:"defaulticon"))
            appName.text = appModel.appName
            let totalReviewsLoaded = ReviewLoadManager.sharedInst.reviews.count
            aveRating.text = "Reviews Loaded : "+String(totalReviewsLoaded)
            territoryCollection.reloadData()
        }
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ReviewLoadManager.sharedInst.loadStates.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "territoryLoadCell", for: indexPath as IndexPath) as! TerritoryLoadCell
        
        let loadState = ReviewLoadManager.sharedInst.loadStateArray[indexPath.row]
        
        cell.setup(loadState: loadState)
        cell.setNeedsUpdateConstraints()
        
        return cell
    }
}

extension ReviewListVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sideSize = CGSize(width: 26,height: 43)
        return sideSize;
    }
}

// Territory Loading CollectionView
extension ReviewListVC {
    
    func scrollFlagsToEnd() {
        let finalPos =  ReviewLoadManager.sharedInst.loadStateArray.count - 1
        if finalPos > 0 {
            let path = IndexPath(row: finalPos, section: 0)
            territoryCollection.scrollToItem(at: path, at: UICollectionViewScrollPosition.centeredHorizontally, animated: true)
            
        }
    }
    
    func scrollFlagsToBeginning() {
        
        if ReviewLoadManager.sharedInst.loadStateArray.count == 0 {
            return
        }
        
        let finalPos =  0
        let path = IndexPath(row: finalPos, section: 0)
        territoryCollection.scrollToItem(at: path, at: UICollectionViewScrollPosition.centeredHorizontally, animated: true)
    }

    func registerTerritoryNotificationsForLoader() {
        NotificationCenter.addObserver(observer: self, sel: .startLoading, name: Const.load.loadStart)
        NotificationCenter.addObserver(observer: self, sel: .finishedLoading, name: Const.load.allLoadingCompleted)
        NotificationCenter.addObserver(observer: self, sel: .updateLoadingCount, name:Const.load.updateAmount)
    }

    func startLoading() {
        scrollFlagsToBeginning()
    }
    
    // scrollToEndWhenFinishedLoading
    func finishedLoading() {
        scrollFlagsToEnd()
        let totalReviewsLoaded = ReviewLoadManager.sharedInst.reviews.count
        self.aveRating.text = "Reviews Loaded : "+String(totalReviewsLoaded)
    }
    
    func updateLoadingCount(notification: NSNotification) {
        let totalReviewsLoaded = ReviewLoadManager.sharedInst.reviews.count
        self.aveRating.text = "Loading Reviews : "+String(totalReviewsLoaded)
    }
}
