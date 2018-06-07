//
//  ForecastPostDetailModel.swift
//  Mutadawel
//
//  Created by Appinventiv on 19/12/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import Foundation
import SwiftyJSON

class ForecastPostDetailModel{
    
    var user_id: Int!
    var user_name: String!
    var caption: String!
    var action_post_type: String!
    var like_user_name: String!
    var comment_user_name: String!
    var reply_user_name: String!
    var replay_username: String!
    var post_like: Int!
    var post_comment: Int!
    var stock_name: String!
    var forecast_price: String!
    var price: String!
    var before1: String!
    var created_date: String!
    var reply_user_img: String!
    var follower_reply: String!
    var is_commented: String!
    var profile_pic: String!
    var is_liked: String!
    var is_shared: String!
    var share_count: Int!
    var image: String!
    var condition1: String!
    var before2: String!
    var condition2: String!
    var created_at: String!
    var if_mark: String!
    var then_mark: String!
    var entry_price_mark: String!
    var forecast_id: String!
    var current_price: String!
    var buyORsell: String!
    var currency: String!
    var stop_loss: String!
    var take_profit: String!
    var before_mark: String!
    var take_profit_mark: String!
    var from_time: String!
    var to_time: String!
    var stop_loss_mark: String!
    var trade_stock_name_ar: String!
    var trade_stock_name_en: String!
    var trade_stock_price: Double!
    var trade_stock_quantity: Int!
    var trade_stock_buy_or_sell: Int!
    var trade_stock_total_wallet_increase: Double!
    var trade_stock_date: String!
    var previous_quantity: String!
    var post_type: String!
    var forecast_status: String!
    var is_updatable: String!
    var is_following: String!
    var add_description: String!
    var ad_link: String!
    var sponsor_by: String!

    
    init(with data: JSON) {
        
        self.user_id = data["user_id"].intValue
        self.user_name = data["user_name"].stringValue
        self.caption = data["caption"].stringValue
        self.action_post_type = data["action_post_type"].stringValue
        self.like_user_name = data["like_user_name"].stringValue
        self.comment_user_name = data["comment_user_name"].stringValue
        self.reply_user_name = data["reply_user_name"].stringValue
        self.replay_username = data["replay_username"].stringValue
        self.post_like = data["post_like"].intValue
        self.post_comment = data["post_comment"].intValue
        self.stock_name = data["stock_name"].stringValue
        self.forecast_price = data["forecast_price"].stringValue
        self.price = data["price"].stringValue
        self.before1 = data["before1"].stringValue
        self.created_date = data["created_date"].stringValue
        self.reply_user_img = data["reply_user_img"].stringValue
        self.follower_reply = data["follower_reply"].stringValue
        self.is_commented = data["is_commented"].stringValue
        self.profile_pic = data["profile_pic"].stringValue
        self.is_liked = data["is_liked"].stringValue
        self.is_shared = data["is_shared"].stringValue
        self.share_count = data["share_count"].intValue
        self.image = data["image"].stringValue
        self.entry_price_mark = data["entry_price_mark"].stringValue
        self.condition1 = data["condition1"].stringValue
        self.before2 = data["before2"].stringValue
        self.condition2 = data["condition2"].stringValue
        self.created_at = data["created_at"].stringValue
        self.if_mark = data["if_mark"].stringValue
        self.then_mark = data["then_mark"].stringValue
        self.buyORsell = data["buyORsell"].stringValue
        self.currency = data["currency"].stringValue
        self.take_profit = data["take_profit"].stringValue
        self.stop_loss = data["stop_loss"].stringValue
        self.before_mark = data["before_mark"].stringValue
        self.take_profit_mark = data["take_profit_mark"].stringValue
        self.stop_loss_mark = data["stop_loss_mark"].stringValue
        self.from_time = data["from_time"].stringValue
        self.to_time = data["to_time"].stringValue
        self.forecast_id = data["forecast_id"].stringValue
        self.current_price = data["current_price"].stringValue
        self.trade_stock_name_en = data["trade_stock_name_en"].stringValue
        self.trade_stock_name_ar = data["trade_stock_name_ar"].stringValue
        self.trade_stock_price = data["trade_stock_price"].doubleValue
        self.trade_stock_quantity = data["trade_stock_quantity"].intValue
        self.trade_stock_buy_or_sell = data["trade_stock_buy_or_sell"].intValue
        self.trade_stock_total_wallet_increase = data["trade_stock_total_wallet_increase"].doubleValue
        self.trade_stock_date = data["trade_stock_date"].stringValue
        self.previous_quantity = data["previous_quantity"].stringValue
        self.post_type = data["post_type"].stringValue
        self.forecast_status = data["forecast_status"].stringValue
        self.is_updatable = data["is_updatable"].stringValue
        self.is_following = data["is_following"].stringValue
        
        self.ad_link = data["ad_link"].stringValue
        self.add_description = data["add_description"].stringValue
        self.sponsor_by = data["sponsor_by"].stringValue


    }
    
    init() {
        
    }
    
}
