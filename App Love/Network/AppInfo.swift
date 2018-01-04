//
//  AppInfo.swift
//  App Love
//
//  Created by Woodie Dovich on 2016-03-26.
//  Copyright © 2016 Snowpunch. All rights reserved.
//
//  Loads app info (needed to create an AppModel) from a single app id.
// 

import Alamofire

class AppInfo {

    class func get(appID:String, completion: @escaping (_ model:AppModel?,_ succeeded: Bool, _ error:NSError?) -> Void) {
        let url = "https://itunes.apple.com/lookup?id=\(appID)"
        
        Alamofire.request(url).responseJSON { response in
            switch response.result {
                
            case .success(let data):
                let rootDic = data as! [String : AnyObject]
                if let resultsArray = rootDic["results"] as? [AnyObject], let firstElement = resultsArray.first,
                    let finalDic = firstElement as? [String: AnyObject] {
                        let appStoreModel = AppModel(resultsDic:finalDic)
                    completion(appStoreModel, true , nil)
                }
                
            case .failure(let error):
                completion(nil, false , error as NSError)
            }
        }
    }
}
