//
//  YelpClient.swift
//  MyYelp
//
//  Created by Nhung Huynh on 7/15/16.
//  Copyright © 2016 Nhung Huynh. All rights reserved.
//

import UIKit
import OAuthSwift
// You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
let yelpConsumerKey = "vxKwwcR_NMQ7WaEiQBK_CA"
let yelpConsumerSecret = "33QCvh5bIF5jIHR5klQr7RtBDhQ"
let yelpToken = "uRcRswHFYa1VkDrGV6LAW2F8clGh5JHV"
let yelpTokenSecret = "mqtKIxMIR4iBtBPZCmCLEb-Dz3Y"

enum YelpSortMode: Int {
    case bestMatched = 0, distance, highestRated
}

class YelpClient : OAuthSwiftClient {
    
    private static var __once: () = {
            return YelpClient(consumerKey: yelpConsumerKey, consumerSecret: yelpConsumerSecret, oauthToken: yelpToken, oauthTokenSecret: yelpTokenSecret, version: .oauth2)
//        YelpClient(consumerKey: yelpConsumerKey, consumerSecret: yelpConsumerSecret, accessToken: yelpToken, accessTokenSecret: yelpTokenSecret)
        }()
    
    var accessToken: String!
    var accessSecret: String!
    
    class var sharedInstance : YelpClient? {
        struct Static {
            static var token : Int = 0
            static var instance : YelpClient? = nil
        }
        
        _ = YelpClient.__once
        return Static.instance
    }

    
    func searchWithTerm(_ term: String, completion: @escaping ([Business], NSError?) -> Void) {
        return searchWithTerm(term, sort: nil, categories: nil, deals: nil, completion: completion)
    }

    func searchWithTerm(_ term: String, sort: Int?, categories: [String]?, deals: Bool?, completion: @escaping ([Business], NSError?) -> Void) {
        // For additional parameters, see http://www.yelp.com/developers/documentation/v2/search_api
        
        // Default the location to San Francisco
        var parameters: [String : AnyObject] = ["term": term as AnyObject, "ll": "37.785771,-122.406165" as AnyObject]
        
        if sort != nil {
//            parameters["sort"] = sort!.rawValue
            parameters["sort"] = sort as AnyObject
        }
        
        if categories != nil && categories!.count > 0 {
            parameters["category_filter"] = (categories!).joined(separator: ",") as AnyObject
        }
        
        if deals != nil {
            parameters["deals_filter"] = deals! as AnyObject
        }
        
        print(parameters)
        YelpClient.sharedInstance?.get("https://api.yelp.com/v2/search", parameters: parameters, headers: nil, success: { (response) in
            let jsonData = try! JSONSerialization.jsonObject(with: response.data, options: JSONSerialization.ReadingOptions.allowFragments) as? NSDictionary
            
            //            print(jsonData)
            
            let businesses =  Business(dictionary: jsonData!)
            let dictionaries = jsonData!["businesses"] as? [NSDictionary]
            if dictionaries != nil {
                completion(Business.businesses(array: dictionaries!), nil)
            }
        }, failure: { (error) in
            print(error)
        })
//        return self.GET("search", parameters: parameters, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
//            let dictionaries = response["businesses"] as? [NSDictionary]
//            if dictionaries != nil {
//                completion(Business.businesses(array: dictionaries!), nil)
//            }
//            }, failure: { (operation: AFHTTPRequestOperation?, error: NSError!) -> Void in
//                completion(nil, error)
//        })!
        
    }
    
//    init() {
//        let baseUrl = NSURL(string: "https://api.yelp.com/v2/")
////        super.init(baseURL: baseUrl, consumerKey: key, consumerSecret: secret);
//        
//        let oathSwift = OAuthSwiftClient(consumerKey: yelpConsumerKey, consumerSecret: yelpConsumerSecret, accessToken: yelpToken, accessTokenSecret: yelpTokenSecret)
////        oathSwift.get("https://api.yelp.com/v2/", success: { (data, response) in
////                print(data)
////            }, failure: nil)
//        
//        
//        var parameters: [String : AnyObject] = ["term": "a", "ll": "37.785771,-122.406165"]
//        
//        print(parameters)
//        oathSwift.get("https://api.yelp.com/v2/search", parameters: parameters, headers: nil, success: { (data, response) in
//            
//            }) { (error) in
//                print(error)
//        }
//        
////        oathSwift.get("https://api.yelp.com/v2/", success: { (data, response) in
////            print(data)
////            }) { (error) in
////                print(error.code)
////                print(error)
////        }
//    }
    
    
}

