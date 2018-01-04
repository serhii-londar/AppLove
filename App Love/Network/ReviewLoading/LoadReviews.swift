//
//  LoadReviews.swift
//  App Love
//
//  Created by Woodie Dovich on 2016-04-06.
//  Copyright © 2016 Snowpunch. All rights reserved.
//
//  Loads one page (0-50) reviews for one territory.
// 

import UIKit

class LoadReviews: NSObject {
    var task:URLSessionDataTask?
    
    func cancel() {
        if let _ = self.task {
            self.task?.cancel()
        }
    }
    
    func getPageUrl(pageInfo:PageInfo) -> String {
        var url = "https://itunes.apple.com/\(pageInfo.territory)/rss/customerreviews/page=\(pageInfo.page)/id=\(pageInfo.appId)/sortBy=mostRecent/"
        url += pageInfo.preferJSON ? "json" : "xml"
        return url
    }
    
    func loadAppReviews(pageInfo:PageInfo, completion: @escaping (_ reviews:[ReviewModel]?,_ succeeded: Bool, _ error:NSError?, _ maxPages:Int) -> Void) {
        
        let url = getPageUrl(pageInfo: pageInfo)
        
        if let reviews = CacheManager.sharedInst.getReviewsFromCache(url: url) {
            completion(reviews, true , nil,10)
        }
        else {
            guard let nsurl = URL(string: url) else { return }
            
            let task = URLSession.shared.dataTask(with: nsurl, completionHandler: { (data, response, error) in
                
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode,
                    let data = data else {
                        completion(nil, false , error as! NSError, 0)
                        return
                }
                
                let allGood = (error == nil && statusCode == 200) // 403 means server blocked.
                
                if allGood {
                    let reviewsArray = ReviewParser(pageInfo: pageInfo).createModels(data: data as NSData)
                    CacheManager.sharedInst.addReviewsToCache(reviews: reviewsArray, url:url)
                    completion(reviewsArray, true , nil,10)
                }
                else {
                    completion(nil, false , error as! NSError, 0)
                }
            })
            task.resume()
        }
    }
}
