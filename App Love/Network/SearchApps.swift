//
//  SearchApps.swift
//  App Love
//
//  Created by Woodie Dovich on 2016-03-26.
//  Copyright © 2016 Snowpunch. All rights reserved.
//
//  Loads array of suggested [AppModel] for search terms.
// 

import Alamofire
import SwiftyJSON

class SearchApps {
    
    class func get(searchStr:String, completion: @escaping (_ appsFound:[AppModel]?,_ succeeded: Bool, _ error:NSError?) -> Void) {
        let array = searchStr.characters.split {$0 == " "}.map(String.init)
        let searchTermsStr = array.joined(separator: "+").lowercased()
        let url = "https://itunes.apple.com/search?term=\(searchTermsStr)&entity=software"
        
        Alamofire.request(url).responseJSON { response in
            switch response.result {
            case .success(_):
                let data = response.value as! [String: AnyObject]
                var apps = [AppModel]()
                if let resultsArray = data["results"] as? [[String: AnyObject]] {
                    for resultsDic in resultsArray {
                        let app = AppModel(resultsDic: resultsDic)
                        apps.append(app)
                    }
                }
                completion(apps, true , nil)
                
            case .failure(let error):
                completion(nil, false , error as NSError)
                
            }
        }
    }
}
