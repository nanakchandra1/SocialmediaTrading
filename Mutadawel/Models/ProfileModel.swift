//
//  ProfileModel.swift
//  Mutadawel
//
//  Created by Appinventiv on 26/12/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import Foundation
import SwiftyJSON

class ProfileModel{
    
    var profile_pic: String!
    var is_notification_on: String!
    var name: String!
    var right: [Any]!
    var wrong: [Any]!
    var forecast_profit_loss: String!
    var forecast_status_precent: Double!
    var net_value: Double!
    var markets: [MarketModel] = []
    var forecast: String!
    var pending_forecast: String!
    var right_forecast: String!
    var wrong_forecast: String!
    var user_id: Int!
    var created_at: String!
    var follower: String!
    var following: String!
    var post: String!
    var designation: String!
    var rating: Float!
    var is_following: String!
    
    
    init(withData data: JSON) {
        
        self.profile_pic = data["profile_pic"].stringValue
        self.is_notification_on = data["is_notification_on"].stringValue
        self.name = data["name"].stringValue
        self.forecast_profit_loss = data["forecast_profit_loss"].stringValue
        self.forecast_status_precent = data["forecast_status_precent"].doubleValue
        self.net_value = (data["net_value"].double ?? 0).roundTo(places: 2)
        self.forecast = data["forecast"].stringValue
        self.pending_forecast = data["pending_forecast"].stringValue
        self.right_forecast = data["right_forecast"].stringValue
        self.wrong_forecast = data["wrong_forecast"].stringValue
        self.user_id = data["user_id"].intValue
        self.created_at = data["created_at"].stringValue
        self.follower = data["follower"].stringValue
        self.following = data["following"].stringValue
        self.post = data["post"].stringValue
        self.designation = data["designation"].stringValue
        self.rating = data["rating"].floatValue
        self.is_following = data["is_following"].stringValue

        let marketArr = data["markets"].arrayValue
        self.markets = marketArr.map({ (market) -> MarketModel in
            MarketModel(with: market)
        })
        
        let forecast_status = data["forecast_status"]
        self.right = forecast_status["right"].arrayObject
        self.wrong = forecast_status["wrong"].arrayObject

    }
    
    init() {
        
    }
}
