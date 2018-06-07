//
//  CurrentUser.swift
//  Mutadawel
//
//  Created by Appinventiv on 20/03/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import Foundation

let userDefaults = UserDefaults.standard

class CurrentUser {
    
    static var name : String? {
        
        return userDefaults.string(forKey: UserDefaultsKeys.NAME)
    }
    
    static var notification_count : String? {
        return userDefaults.string(forKey: UserDefaultsKeys.notification_count)
    }
	
	static var notification_count_for_bage : Int? {
		return userDefaults.integer(forKey: UserDefaultsKeys.notification_count)
	}

	
    static var chat_notification_count : String? {
        
        return userDefaults.string(forKey: UserDefaultsKeys.chat_notification_count)
        
    }

	static var chat_notification_count_for_bage : Int? {
		return userDefaults.integer(forKey: UserDefaultsKeys.chat_notification_count)
	}
	
    static var app_language : String? {
        
        return userDefaults.string(forKey: UserDefaultsKeys.APP_LANGUAGE)
    }
    
    static var user_name : String? {
        return userDefaults.string(forKey: UserDefaultsKeys.USER_NAME)
    }
    static var user_email : String? {
        return userDefaults.string(forKey: UserDefaultsKeys.USER_EMAIL)
    }
    static var user_id : String? {
        return userDefaults.string(forKey: UserDefaultsKeys.USER_ID)
    }
    static var bio : String? {
        return userDefaults.string(forKey: UserDefaultsKeys.BIO)
    }
    static var profile_pic : String? {
        return userDefaults.string(forKey: UserDefaultsKeys.PROFILE_PIC)
    }
    static var created_at : String? {
        return userDefaults.string(forKey: UserDefaultsKeys.CREATED_AT)
    }
    static var followers : String? {
        return userDefaults.string(forKey: UserDefaultsKeys.FOLLOWERS)
    }
    static var followings : String? {
        return userDefaults.string(forKey: UserDefaultsKeys.FOLLOWINGS)
    }
    static var posts : String? {
        return userDefaults.string(forKey: UserDefaultsKeys.POSTS)
    }
    static var rating : String? {
        return userDefaults.string(forKey: UserDefaultsKeys.Rating)
    }
    static var profit_loss : String? {
        return userDefaults.string(forKey: UserDefaultsKeys.profit_loss)
    }
    static var net_value : String? {
        return userDefaults.string(forKey: UserDefaultsKeys.net_value)
    }
    static var is_currency_selected : String? {
        return userDefaults.string(forKey: UserDefaultsKeys.is_currency_selected)
    }
    static var is_stock_selected : String? {
        return userDefaults.string(forKey: UserDefaultsKeys.is_stock_selected)
    }
    static var markets : String? {
        return userDefaults.string(forKey: UserDefaultsKeys.markets)
    }
    static var is_market_selected : String? {
        return userDefaults.string(forKey: UserDefaultsKeys.is_market_selected)
    }

    
    
}
