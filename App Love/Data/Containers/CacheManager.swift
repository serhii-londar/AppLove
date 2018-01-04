//
//  CacheManager.swift
//  App Love
//
//  Created by Woodie Dovich on 2016-03-09.
//  Copyright © 2016 Snowpunch. All rights reserved.
//
//  Each key here prepresents 1 page network call which can be 1-50 ReviewModels.
//  Network call is bypassed if Cache already contains the parsed models.
//  Key is URL without the JSON or XML as part of the end of the URL.
// 
//  todo: Replace url stripping with manual key fabrication from PageInfo (appid+page).
// 

import UIKit

class CacheManager {
    static let sharedInst = CacheManager()       
    private init() {} // enforce singleton
    
//    var cache:NSCache = NSCache()
    var ignore:Bool = false
    
    func addReviewsToCache(reviews:[ReviewModel], url:String) {
//        let datedReviews = ExpireableReviews(reviews: reviews, date: NSDate())
//        let urlKey = getUrlKey(url: url)
//        cache.setObject(datedReviews, forKey: urlKey)
    }
    
    func getReviewsFromCache(url:String) -> [ReviewModel]? {
//        guard ignore == false else { return nil }
        
//        let urlKey = getUrlKey(url: url)
//        if let cachedReviews = cache.objectForKey(urlKey) as? ExpireableReviews {
//
//            if cachedReviews.isExpired() {
//                cache.removeObjectForKey(url)
//                return nil
//            }
//
//            if cachedReviews.reviews.count == 0 {
//                return nil
//            }
//
//            return cachedReviews.reviews
//        }
        return nil
    }
    
    // the models are the same regardless of which source they came from.
    // url is the same except for the last few characters ('json' or 'xml') so that 
    // part is stripped.
    func getUrlKey(url:String) -> String {
        if url.contains("json") {
            let newstr = url.replacingOccurrences(of: "json", with:"")
            return newstr
        }
        if url.contains("xml") {
            let newstr = url.replacingOccurrences(of: "xml", with: "")
            return newstr
        }
        return url
    }
    
    func startIgnoringCache() {
        ignore = true
    }
    
    func stopIgnoringCache() {
        ignore = false
    }
}

// will use the date portion in the future.
class ExpireableReviews {
    var date:NSDate
    var reviews:[ReviewModel]
    
    init(reviews:[ReviewModel], date:NSDate) {
        self.date = date
        self.reviews = reviews
    }
    
    // stub for now (later maybe 3 days)
    func isExpired() -> Bool {
        return false
    }
}
