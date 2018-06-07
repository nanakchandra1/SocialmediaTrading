//
//  CurrentPriceIndicatorModel.swift
//  Mutadawel
//
//  Created by Appinventiv on 26/12/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import Foundation
import SwiftyJSON

class CurrentPriceIndicatorModel{
    
    var priceIndicatorDate: String!
    var priceIndicatorStatus: Int!
    var name_en: String!
    var priceindicatorPrice: Double!

    
    init(withData data : JSON) {
        
        self.priceIndicatorDate = data["priceIndicatorDate"].stringValue
        self.priceIndicatorStatus = data["priceIndicatorStatus"].intValue
        self.name_en = data["name_en"].string ?? data["name_ar"].stringValue
        self.priceindicatorPrice = data["priceindicatorPrice"].doubleValue

    }
    
    init() {
        
    }
}


class ForexPriceAPIModel{
    
    var Ask: Double!
    var Bid: Double!
    
    init(withData data : JSON) {
        
        self.Ask = data["priceIndicatorDate"].doubleValue
        self.Bid = data["priceIndicatorStatus"].doubleValue
        
    }
    
    init() {
        
    }
}

class CurrentStockPriceModel{
    
    var current: Double!
    var previous_price: Double!
    
    init(withData data : JSON) {
        
        self.current = data["current"].doubleValue
        self.previous_price = data["previous_price"].doubleValue
        
    }
    
    init() {
        
    }
}


class UserWalletModel{
    
    var cash: Double!
    var stock: Double!
    
    init(withData data : JSON) {
        
        self.cash = data["cash"].doubleValue
        self.stock = data["stock"].doubleValue
        
    }
    
    init() {
        
    }
}


class UsersModel{
    
    var rating: Float!
    var name: String!
    var follower: String!
    var profile_pic: String!
    var user_id: Int!
    var is_following: String!
    
    init(withData data : JSON) {
        
        self.rating = data["rating"].floatValue
        self.name = data["name"].stringValue
        self.follower = data["follower"].stringValue
        self.profile_pic = data["profile_pic"].stringValue
        self.user_id = data["user_id"].int ?? data["id"].intValue
        self.is_following = data["is_following"].stringValue

    }
    
    init() {
        
    }
}

class ChatModel{
    
    var reply: Float!
    var created_date: String!
    var message: String!
    
    init(withData data : JSON) {
        
        self.reply = data["reply"].floatValue
        self.created_date = data["created_date"].stringValue
        self.message = data["message"].stringValue
        
    }
    
    init() {
        
    }
}

