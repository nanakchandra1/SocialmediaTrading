//
//  MyStockListModel.swift
//  Mutadawel
//
//  Created by Appinventiv on 26/12/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import Foundation
import SwiftyJSON

class MyStockListModel{
    
    var stock_name : String!
    var quantity : Int!
    var profit_loss : Double!
    var current_price : Double!
    var buy : Double!
    var date : String!
    var symbol: String!
    var buyOrsell: String!
    var stock_id: Int!
    var previous_price: Double!
    var stock: String!
    
    var soldDate: String!
    var amount: String!
    var price: String!

    
    init(withData data : JSON) {
        
        self.stock_name = data["stock_name"].stringValue
        self.quantity = data["quantity"].intValue
        self.profit_loss = data["profit_loss"].doubleValue
        self.current_price = data["current"].double ?? data["current_price"].doubleValue
        self.buy = data["buy"].doubleValue
        self.date = data["date"].stringValue
        self.symbol = data["symbol"].string ?? data["stock_symbol"].stringValue
        self.buyOrsell = data["buyOrsell"].stringValue
        self.stock_id = data["stock_id"].intValue
        self.previous_price = data["previous_price"].doubleValue
        self.stock = data["stock"].stringValue
        self.soldDate = data["soldDate"].string ?? data["boughtDate"].stringValue
        self.amount = data["amount"].stringValue
        self.price = data["price"].stringValue


    }
    
    init() {
        
    }
}


class CurrencyModel{
    
    var symbol: String!
    var follower: String!
    var currency_id: String!
    var is_selected : String!
    
    init(withData data : JSON) {
        
        self.symbol = data["symbol"].stringValue
        self.follower = data["follower"].stringValue
        self.currency_id = data["currency_id"].stringValue
        self.is_selected = data["is_selected"].stringValue

    }
    init(){    }
}



class FollowedMarketModel{
    
    var market_name: String!
    var follower: String!
    var market_id: String!
    
    init(withData data : JSON) {
        
        self.market_name = data["market_name"].stringValue
        self.follower = data["follower"].stringValue
        self.market_id = data["market_id"].stringValue

    }
    init(){    }
}


class FollowedUserModel{
    
    var user_id: Int!
    var is_following: String!
    var name: String!
    var profile_pic: String!
    var rating: Float!
    
    init(withData data : JSON) {
        
        self.user_id = data["user_id"].intValue
        self.is_following = data["is_following"].stringValue
        self.name = data["name"].stringValue
        self.profile_pic = data["profile_pic"].stringValue
        self.rating = data["rating"].floatValue

        
    }
    init(){    }
}

