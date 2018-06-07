//
//  WalletInfo.swift
//  Mutadawel
//
//  Created by Appinventiv on 21/12/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import Foundation
import SwiftyJSON

class WalletInfoModel{
    
    var stockData: [StockDataModel] = []
    var totalBoughtAMount: Double!
    var totalSellAMount: Double!
    var walletnetValue: Double!
    var label: JSONArray!
    var values: JSONArray!
    var graphData: JSON!
    var fromDate: String!
    var toDate: String!
    
    init(withData data: JSON) {
        self.fromDate = data["fromDate"].stringValue
        self.toDate = data["toDate"].stringValue

        self.totalBoughtAMount = data["totalBoughtAMount"].doubleValue
        self.totalSellAMount = data["totalSellAMount"].doubleValue
        self.walletnetValue = data["walletnetValue"].doubleValue

        self.graphData = data["graphData"]
        self.label = self.graphData["values"].arrayValue
        self.values = self.graphData["values"].arrayValue

        let stock_data = data["stockData"].arrayValue
        
        for res in stock_data{
            let s_data = StockDataModel(withData: res)
            self.stockData.append(s_data)
        }
    }
    
    init() {
        
    }
}





class StockDataModel{
    
    var stock_name: String!
    var soldStock: Int!
    var avgSoldStockPrice: Double!
    var boughtStock: Int!
    var avgBoughtStockPrice: Double!
    var per: Double!
    var created_at: String!
    var share: Int!
    var profit: Double!


    init(withData data: JSON) {
        
        self.stock_name = data["stock_name"].stringValue
        self.soldStock = data["soldStock"].intValue
        self.avgSoldStockPrice = data["avgSoldStockPrice"].doubleValue
        self.boughtStock = data["boughtStock"].intValue
        self.avgBoughtStockPrice = data["avgBoughtStockPrice"].doubleValue
        self.per = data["per"].doubleValue
        self.share = data["share"].intValue
        self.created_at = data["created_at"].stringValue
        self.profit = data["profit"].doubleValue

    }
    
    init() {
        
    }

}

class MyWalletModel{
    
    var cash: Double!
    var stock: Double!
    var coins: Double!
    var total_donation: Double!
    
    init(withData data: JSON) {
        
        self.cash = data["cash"].doubleValue
        self.stock = data["stock"].doubleValue
        self.coins = data["coins"].doubleValue
        self.total_donation = data["total_donation"].doubleValue
        
    }
    
    init() {
        
    }
    
}

