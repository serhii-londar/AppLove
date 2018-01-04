//
//  ReviewParser.swift
//  App Love
//
//  Created by Woodie Dovich on 2016-04-06.
//  Copyright © 2016 Snowpunch. All rights reserved.
//
//  parses both xml and json formats.
//  

import UIKit
import Alamofire
import SwiftyJSON
import SWXMLHash

class ReviewParser: NSObject {
    
    var fullTerritoryName:String
    let pageInfo:PageInfo
    
    init(pageInfo:PageInfo) {
        self.pageInfo = pageInfo
        self.fullTerritoryName = TerritoryMgr.sharedInst.getTerritory(code: pageInfo.territory) ?? pageInfo.territory
    }
    
    func createModels(data: NSData) -> [ReviewModel] {
        if self.pageInfo.preferJSON == true {
            return createModelsFromJSON(data: data)
        }
        return createModelsFromXML(data: data)
    }
    
    func createModelsFromXML(data: NSData) -> [ReviewModel] {
        var reviewsArray = [ReviewModel]()
        let xml = SWXMLHash.parse(data as Data)
        let reviews = xml["feed"]["entry"]
        for item in reviews.all {
            let review = ReviewModel(xml: item)
            if review.name != nil {
                review.territory = fullTerritoryName
                review.territoryCode = pageInfo.territory
                reviewsArray.append(review)
            }
        }
        return reviewsArray
    }
    
    func createModelsFromJSON(data:NSData) -> [ReviewModel] {
        var reviewsArray = [ReviewModel]()
        do {
            let jsonResults = try JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions(rawValue: 0))
            let json = JSON(jsonResults)
            if let entryArray = json["feed"]["entry"].array {
                for json in entryArray {
                    let review = ReviewModel(json: json)
                    if (review.name != nil) {
                        review.territory = fullTerritoryName
                        review.territoryCode = pageInfo.territory
                        reviewsArray.append(review)
                    }
                }
            }
        } catch _ as NSError {
            print("json error")
        }
        return reviewsArray
    }
}
