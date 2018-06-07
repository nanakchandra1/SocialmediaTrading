//
//  MarketModel.swift
//  Mutadawel
//
//  Created by Appinventiv on 21/12/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import Foundation
import SwiftyJSON


class MarketModel{
    
    var name: String!
    var image : String!
    var is_selected: String!
    var id: String!
    
    init(with info: JSON) {
        
        self.name = info["name"].stringValue
        self.image = info["image"].stringValue
        self.is_selected = info["is_selected"].stringValue
        self.id = info["id"].stringValue

    }
    init() {
        
    }
}


class AllStockListModel{
    
    var name: String!
    var stock_id : Int!
    var symbol: String!
    var stockFilterType: String!
    var follower: String!
    var is_selected: String!
    
    init(with info: JSON) {
        
        self.name = info["name_en"].string ?? info["name_ar"].stringValue
        self.stock_id = info["id"].intValue
        self.symbol = info["symbol"].stringValue
        self.stockFilterType = info["stockFilterType"].stringValue
        self.follower = info["follower"].stringValue
        self.is_selected = info["is_selected"].stringValue

    }
    init() {
        
    }
}


class PayPalInfoModel{
    
    var holder_name: String!
    var bank_name : String!
    var country: String!
    var city: String!
    var iban: String!
    var account_number: String!
    var paypal_name: String!
    var account: String!

    
    init(with info: JSON) {
        
        self.holder_name = info["holder_name"].stringValue
        self.bank_name = info["bank_name"].stringValue
        self.country = info["country"].stringValue
        self.city = info["city"].stringValue
        self.iban = info["iban"].stringValue
        self.account_number = info["account_number"].stringValue

    }
    init() {
        
    }
}
