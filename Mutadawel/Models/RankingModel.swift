//
//  RankingModel.swift
//  Mutadawel
//
//  Created by Appinventiv on 21/12/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import Foundation
import SwiftyJSON

class RankingModel{
    
    var forecast_status: JSON!
    var is_following: String!
    var name: String!
    var right_forecast: String!
    var wrong_forecast: String!
    var forecast_profit: String!

    var wallet_value: Double!
    var forecast_status_precent: Double!
    var profile_pic: String!
    var rating: Double!
    var user_id: Int!
    var right: [Any] = []
    var wrong: [Any] = []

    init(with info : JSON) {
        
        self.forecast_status = info["forecast_status"]
        self.is_following = info["is_following"].stringValue
        self.name = info["name"].stringValue
        self.right_forecast = info["right_forecast"].stringValue
        self.wrong_forecast = info["wrong_forecast"].stringValue
        self.forecast_profit = info["forecast_profit"].stringValue

        self.wallet_value = info["wallet_value"].doubleValue
        self.forecast_status_precent = info["forecast_status_precent"].doubleValue
        self.profile_pic = info["profile_pic"].stringValue
        self.user_id = info["user_id"].intValue
        self.rating = info["rating"].doubleValue
        self.right = self.forecast_status["right"].arrayObject ?? []
        self.wrong = self.forecast_status["wrong"].arrayObject ?? []

    }

    
    init() {
        
    }
}
