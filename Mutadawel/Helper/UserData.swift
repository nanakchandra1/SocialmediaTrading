//
//  UserData.swift
//  Mutadawel
//
//  Created by Appinventiv on 20/03/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import Foundation


import SwiftyJSON


class UserData {
    
    var name: String!
    var user_id: String!
    var email: String!
    var user_name: String!
    var profile_pic: String!
    var created_at: String!
    var followers: Int!
    var followings: Int!
    var image: String!
    var posts: Int!
    var rating: String!
    var forecast_profit_loss: String!
    var net_value: String!
    var designation: String!
    var is_currency_selected: String!
    var is_stock_selected: String!
    var is_market_selected: String!


    
    init(withJson data : JSON) {
        
        self.name = data["name"].stringValue
        self.user_id = data["user_id"].stringValue
        self.email = data["email"].stringValue
        self.user_name = data["user_name"].stringValue
        self.profile_pic = data["profile_pic"].stringValue
        self.created_at = data["created_at"].stringValue
        self.followers = data["followers"].int ?? data["follower"].intValue
        self.followings = data["followings"].int ?? data["following"].intValue
        self.image = data["image"].stringValue
        self.posts = data["posts"].int ?? data["post"].intValue
        self.rating = data["rating"].stringValue
        self.forecast_profit_loss = data["forecast_profit_loss"].stringValue
        self.net_value = data["net_value"].stringValue
        self.designation = data["designation"].stringValue
        
        let forecast_status = data["forecast_status"].dictionaryValue
        
        self.is_currency_selected = forecast_status["is_currency_selected"]?.stringValue
        self.is_stock_selected = forecast_status["is_stock_selected"]?.stringValue
        
        let market = data["markets"].arrayObject ?? []
        
        if !market.isEmpty{
            self.is_market_selected = "yes"
            userDefaults.set("yes", forKey: UserDefaultsKeys.is_market_selected)

        }


            userDefaults.set(self.name, forKey: UserDefaultsKeys.NAME)
            userDefaults.set(self.email, forKey: UserDefaultsKeys.USER_EMAIL)
            userDefaults.set(self.user_id, forKey: UserDefaultsKeys.USER_ID)
            userDefaults.set(self.user_name, forKey: UserDefaultsKeys.USER_NAME)
        
            userDefaults.set(self.profile_pic, forKey: UserDefaultsKeys.PROFILE_PIC)
            userDefaults.set(self.created_at, forKey: UserDefaultsKeys.CREATED_AT)
            userDefaults.set(self.followers, forKey: UserDefaultsKeys.FOLLOWERS)
            userDefaults.set(self.followings, forKey: UserDefaultsKeys.FOLLOWINGS)
            userDefaults.set(self.posts, forKey: UserDefaultsKeys.POSTS)
            userDefaults.set(self.rating, forKey: UserDefaultsKeys.Rating)
           // userDefaults.set(profit_loss, forKey: UserDefaultsKeys.profit_loss)
            userDefaults.set(self.net_value, forKey: UserDefaultsKeys.net_value)
            userDefaults.set(self.followers, forKey: UserDefaultsKeys.FOLLOWERS)
            userDefaults.set(self.posts, forKey: UserDefaultsKeys.POSTS)
            userDefaults.set(self.designation, forKey: UserDefaultsKeys.BIO)
            userDefaults.set(self.is_currency_selected, forKey: UserDefaultsKeys.is_currency_selected)
            userDefaults.set(self.is_stock_selected, forKey: UserDefaultsKeys.is_stock_selected)

        
    }
    
    init() {
        
    }


    }

