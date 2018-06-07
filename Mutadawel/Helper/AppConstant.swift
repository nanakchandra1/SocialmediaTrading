//
//  AppConstant.swift
//  Mutadawel
//
//  Created by Appinventiv on 07/02/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import Foundation
import UIKit



struct AppColor {
    
    static let navigationBarColor = UIColor(red: 172/255, green: 20/255, blue: 87/255, alpha: 1)
    static let appButtonColor = UIColor(red: 233/255, green: 31/255, blue: 99/255, alpha: 1)
    static let blue = UIColor(red: 29/255, green: 145/255, blue: 234/255, alpha: 1)
    static let appTextColor = UIColor(red: 96/255, green: 125/255, blue: 139/255, alpha: 1)
    
    
    static let appPinkColor = UIColor(red: 173/255, green: 20/255, blue: 87/255, alpha: 1)
    
    
}

struct AppFont {
    
    static let RobotoCondenseRegular = "RobotoCondensed-Regular"
    static let RobotoCondenseMed = "Roboto-Medium"
    static let RobotoCondenseBold = "Roboto-Bold"
    
}

struct ButtonImg {
    
    static let burgerBtn = UIImage(named:"ic_home_nav")
    static let backbtn = UIImage(named:"ic_sign_in_back")
    static let settingTooglrOff = UIImage(named:"ic_settings_toggle_off")
    static let settingTooglrOn = UIImage(named:"ic_settings_toggle_on")
    static let forwordArrow = UIImage(named:"ic_profile_small_next")
    static let selectedCircle = UIImage(named: "ic_choose_indexes_eclipseselect")
    static let deSelectedCircle = UIImage(named: "ic_choose_indexes_eclipsedeselect")
}

struct Status {
    static let one = "1"
    static let two = "2"
    static let three = "3"
    static let four = "4"
    static let five = "5"
    static let six = "6"
    static let seven = "7"
    static let eight = "8"
    static let nine = "9"
    static let zero = "0"
}

struct VideoURLRegex {
    
    static let youtubeRegex = "((?<=(v|V)/)|(?<=be/)|(?<=(\\?|\\&)v=)|(?<=embed/))([\\w-]++)"
    
    static let vimeoRegex  = "https?:\\/\\/(?:www\\.|player\\.)?vimeo.com\\/(?:channels\\/(?:\\w+\\/)?|groups\\/([^\\/]*)\\/videos\\/|album\\/(\\d+)\\/video\\/|video\\/|)(\\d+)(?:$|\\/|\\?)"
    
}

struct AppNavigationTitleName {
    static let signIn = "Sign In"
    static let signup = "Sign Up"
    static let chooseMarket = "Choose Market"
    static let chooseIndexes = "Choose Stocks"
    static let chooseCurrency = "Choose Currencies"
    static let choosePeople = "Choose People"
    static let home = "Home"
    static let trade = "Trade"
    static let ranking = "Ranking"
    static let timeLine = "Timeline"
    static let myProfile = "My Profile"
    static let following = "Following"
    static let followers = "Followers"
    static let posts = "Posts"
    static let expextation = "Expectation"
    static let right_expextation = "Right Expectation"
    static let wrong_expextation = "Wrong Expectation"
    static let profit_lose = "Profit & Lost"
    static let userProfile = "User Profile"
    static let priceIndicator = "Price Indicator"
    static let setting = "Settings"
    static let changePass = "Change Password"
    static let subscription = "Wallet"
    static let contactUs = "Contact Us"
    static let aboutUs = "About Us"
    static let notification = "Notifications"
    static let messages = "Messages"
    static let resetPass = "Reset Password"
    static let support = "Support Request"
    static let alert = "Alert"
}


struct App_Language_name{
    
    static let arabic = "arabic"
    static let english = "english"
}


struct FirebaseEventName {
    
    static let login = "sign_in"
    static let signup = "sign_up"
    static let register = "register"
    static let wrong_email = "wrong_email"
    static let wrong_no = "wrong_number"
    static let no_image = "no_photo_error"
    static let user_exist = "user_already_exist"
    static let wrong_pass = "wrong_password"
    static let term_cond = "terms_and_condition"
    static let success_register = "successful_registration"
    static let forgot_pass = "forget_password"
    static let sign_up = "sign_up"
    static let success_Login = "successful_login"
    static let wrong_userid_or_pass = "wrong_userid_or_password"
    static let wrong_userid = "wrong_userid"
    static let password_sent = "password_sent"
    static let user_profile_click = "user_prfile_click"
    static let new_post = "new_post"
    static let search = "search"
    static let message = "message"
    static let notification = "notification"
    static let like = "like"
    static let comment = "comment"
    static let sidemenu = "side_menu"
    static let share = "share"
    static let three_dots = "3_dots"
    static let success_trade = "successful_trade"
    static let choose_stock_error = "choose_stock_error"
    static let choose_quantity_error = "choose_quantity_error"
    static let choose_by_or_sell_error = "choose_buy_or_sell_error"
    static let no_enough_cash = "no_enough_cash"
    static let no_enouph_stock_to_sell = "no_enouph_stock_to_sell"
    static let click_on_clock = "click_on_clock"
    static let filter_by_delta = "filter_by_delta"
    static let filter_by_stock = "filter_by_stock"
    static let filter_by_profit = "filter_by_profit"
    static let WALLET_NET_VALUE = "wallet_net_value"
    
    static let filter_by_correct_forecast = "filter_by_correct_forecast"
    static let filter_by_wallet = "filter_by_wallet"
    static let follow_user = "follow_user"
    static let unfollow_user = "unfollow_user"
    static let click_on_user_picture = "click_on_user_picture"
    static let click_on_following = "click_on_following"
    static let click_on_follower = "click_on_follower"
    static let click_on_post = "click_on_post"
    static let click_on_forecast = "click_on_forecast"
    static let click_on_pending_forecast = "click_on_pending_forecast"
    static let click_on_notificaton = "click_on_notification"
    static let click_on_donation = "click_on_donation"
    static let click_on_right_forecast = "click_on_right_forecast"
    static let click_on_wrong_forecast = "click_on_wrong_forecast"
    static let follow = "follow"
    static let home = "home"
    
    static let profit_loss = "profit_&_loss"
    static let status_forecast = "status_forecast"
    static let wallet_net_value = "wallet_net_value"
    static let unfollow = "unfollow"
    static let profile = "profile"
    static let price_indicator = "shaprice_indicator"
    static let wallet = "wallet"
    static let setting = "setting"
    static let contact_us = "contact_us"
    static let about_us = "about_us"
    static let sign_out = "sign_out"
    static let help = "help"
    
    static let edit_profile = "edit_profile"
    static let Wallet = "Wallet"
    static let account_information     = "account_information"
    static let choose_market = "choose_market"
    static let please_choose_stock_error = "please_choose_stock_error"
    static let pleasea_choose_price_error = "pleasea_choose_price_error"
    static let successful_submit = "successful_submit"
    static let successful_edit_profile = "successful_edit_profile"
    static let pay_pal = "settpay_paling"
    static let bank_account = "bank_account"
    static let please_enter_a_valid_email = "please_enter_a_valid_email"
    static let please_enter_name_error = "seplease_enter_name_error"
    static let please_enter_bank_name_error = "seplease_enter_bank_name_error"
    static let please_enter_country_error = "please_enter_country_error"
    static let please_enter_city_error = "please_enter_city_error"
    static let please_enter_ibank_error = "please_enter_ibank_error"
    static let click_on_cashe = "click_on_cashe"
    static let click_on_stock = "click_on_stock"
    static let click_on_add_more_money = "click_on_add_more_money"
    static let click_on_my_donation = "click_on_my_donation"
    static let click_on_payment = "click_on_payment"
    static let successful_payment = "successful_payment"
    static let invite_profile = "invite_profile"
    static let block_users = "block_users"
    static let change_language = "change_language"
    static let desclaimer = "desclaimer"
    static let successful_invite_user = "successful_invite_user"
    static let sent_message_successful = "sent_message_successful"
    static let no = "no"
    static let yes = "yes"
    static let camera_click = "camera_click"
    static let successful_post_general = "successful_post_general"
    static let enter_stock_error  = "enter_stock_error "
    static let enter_if_error = "enter_if_error"
    static let enter_within_error = "enter_within_error"
    static let successful_post_stock  = "successful_post_stock "
    static let conditional_forecast = "conditional_forecast"
    static let enter_then_price_error = "enter_then_price_error"
    static let enter_duration_error = "enter_duration_error"
    static let enter_forecast_price_error = "enter_forecast_price_error"
    static let successful_post_stock_forecast = "successful_post_stock_forecast"
    static let enter_currency_error = "enter_currency_error"
    static let enter_buy_error = "enter_buy_error"
    static let enter_type_error = "enter_type_error"
    static let enter_stop_loss_error = "enter_stop_loss_error"
    static let enter_take_profit_error = "enter_take_profit_error"
    static let successful_post = "successful_post"
}

// Wallet Net Value

let FROM = "From"
let TO = "To"
let SOLD = "Sold"
let BOUGHT = "Bought"
let WALLET_BALANCE = "WalletBalance"
let SHARE = "Share"
let SHARES = "Shares"

//price Indicator

let LIST = "LIST"
let CURRENT_PRICE_INDICATOR = "CURRENT_PRICE_INDICATOR"
let REQUIRED_STOCK_PRICE = "REQUIRED_STOCK_PRICE"
let FOREX_MARKET = "Forex Market"

// Login Screen

let SIGN_IN = "SIGN_IN"
let EMAIL_OR_MOB_NO_TEXTFIELD = "EMAIL_OR_MOB_NO_TEXTFIELD"
let PASSWORD = "PASSWORD"
let FORGOT_PASS_BTN = "FORGOT_PASS_BTN"
let CHANGE_LANG_BTN = "CHANGE_LANG_BTN"

// SIGNUP Screen

let SIGN_UP = "SIGN_UP"
let NICK_NAME = "NICK_NAME"
let CODE = "CODE"
let MOBILE_NO =  "MOBILE_NO"
let EMAIL = "EMAIL"
let TERMS_AND_CONDITIONS = "TERMS_AND_CONDITIONS"
let T_C = "T_C"

// Choose Market Screen
let CHOOSE_MARKET = "CHOOSE_MARKET"
let CHOOSE_OTHET_MARKET = "CHOOSE_OTHET_MARKET"
let MARKET = "MARKET"

// Choose Stocks Screen
let CHOOSE_STOCKS = "CHOOSE_STOCKS"
let CHOOSE_a_STOCKS = "CHOOSE_a_STOCKS"

let SEARCH = "SEARCH"
let NEXT = "NEXT"
let SELECT_ALL = "SELECT_ALL"
let DESELECT_ALL = "DESELECT_ALL"
let CONTINUE = "CONTINUE"
let CHOOSE_CURRENCIES = "CHOOSE_CURRENCIES"

// Choose Peopole Screen
let CHOOSE_PEOPLE = "CHOOSE_PEOPLE"
let START = "START"
let FOLLOW = "FOLLOW"
let USER_NAME = "USER_NAME"
let RATE = "RATE"
let UNBLOCK = "UNBLOCK"

// Reset Password Screen

let RESET_PASS = "RESET_PASS"
let SEND_NEW_PASS_BTN = "SEND_NEW_PASS_BTN"

// About Us Screen

let ABOUT_US = "ABOUT_US"
let CONTACT_US = "CONTACT_US"

// Contact Us Screen
let SUBJECT = "SUBJECT"
let MESSAGE = "MESSAGE"
let NAME = "NAME"
let DESCRIBE_ISSUE = "DESCRIBE_ISSUE"
let SEND_MSG_BTN = "SEND_MSG_BTN"
let SEND_NEW_MSG = "SEND_NEW_MSG"
let DESCRIPTION_LABEL = "DESCRIPTION_LABEL"
let DESC_LABEL = "DESC_LABEL"


// Following Markets Screen
let FOLLOWING_MARKET = "FOLLOWING_MARKET"
let UNFOLLOW = "UNFOLLOW"


// Price Indicatoe Screen

let PRICE_INDICATOR = "PRICE_INDICATOR"
let STOCK_NAME = "STOCK_NAME"
let PRICE = "PRICE"
let FORECASTED_PRICE = "FORECASTED_PRICE"
let SUBMIT_BTN = "SUBMIT_BTN"
let JOINED = "JOINED"
let TOTAL = "TOTAL"

// Profile screen

let DONATE = "DONATE"
let DONATE_TO = "DONATE_TO"
let POINTS = "POINTS"
let USER_PROFILE = "USER_PROFILE"
let USER_BIOGRAPHY = "USER_BIOGRAPHY"
let PROFILE = "PROFILE"
let FOLLOWING = "FOLLOWING"
let FOLLOWERS = "FOLLOWERS"
let POSTS = "POSTS"
let EDIT_PROFILE = "EDIT_PROFILE"
let PROFIT_AND_LOST = "PROFIT_AND_LOST"
let STATUS_OF_EXT = "STATUS_OF_EXT"
let CHANGE_PROFILE_PHOTO = "CHANGE_PROFILE_PHOTO"
let UPGRADE_ACCOUNT = "UPGRADE_ACCOUNT"
let MY_PROFILE = "MY_PROFILE"
let ON = "ON"
let OFF = "OFF"
let ACCOUNT_NOTIFICATIONS = "ACCOUNT_NOTIFICATIONS"
let DESCRIPTION = "DESCRIPTION"
let NOTI_DESCRIPTION = "NOTI_DESCRIPTION"
let NOTI_OFF_DESCRIPTION = "NOTI_OFF_DESCRIPTION"

// Expectations screen

let EXPECTATIONS = "EXPECTATIONS"
let PENDING_EXPECTATION = "PENDING_EXPECTATION"
let RIGHT_EXPECTATION = "RIGHT_EXPECTATION"
let WRONG_EXPECTATION = "WRONG_EXPECTATION"

// Subscriptions screen

let SUBSCRIPTIONS = "SUBSCRIPTIONS"
let CASH = "CASH"
let STOCKS = "STOCKS"
let ADD_MORE_MONEY = "ADD_MORE_MONEY"
let MY_DONATION = "MY_DONATION"
let PAY_TO = "PAY_TO"
let PAYMENT_BTN = "PAYMENT_BTN"



// My Stocks screen
let COMMENT = "COMMENT"
let CURRENT_PRICE = "CURRENT_PRICE"
let QUANTITY = "QUANTITY"
let QUANTITY_NO = "QUANTITY_NO"
let MY_STOCK_LIST = "MY_STOCK_LIST"//My Stocks List
let VERSUS = "VERSUS"

// Messages screen

let MESSAGES = "MESSAGES"
let DELET_CONVERSATION_BTN = "DELET_CONVERSATION_BTN"
let MUTE_NOTIFICATION_BTN = "MUTE_NOTIFICATION_BTN"

// Notifications screen

let NOTIFICATIONS = "NOTIFICATIONS"

// Edit Profile Screen

let BIO = "BIO"
let SAVE_BTN = "SAVE_BTN"
let CHOOSE_PROFILE_PIC = "CHOOSE_PROFILE_PIC"

// Status of expect Screen

let STATUS_OF_FORECAST = "STATUS_OF_FORECAST"
let CORRECT = "CORRECT"
let FAILED = "FAILED"

// Home Screen

let HOME = "HOME"
let TIMELINE = "TIMELINE"
let TRADE = "TRADE"
let RANKING = "RANKING"
let FORECAST_TIME = "FORECAST_TIME"
let BEFORE = "BEFORE"
let FORECAST_PRICE = "FORECAST_PRICE"
let PRICE_WHEN_FORECAST = "PRICE_WHEN_FORECAST"
let WALLET_NET_VALUE = "WALLET_NET_VALUE"
let USER_LIST = "USER_LIST"
let Reply = "Reply"
// TRADE Screen

let BUY = "BUY"
let SELL = "SELL"
let BUY_SELL = "BUY_SELL"
let TYPE = "TYPE"
let STOP_LOSS = "STOP_LOSS"
let TAKE_PROFIT = "TAKE_PROFIT"
let IF = "IF"
let WITHIN = "WITHIN"
let THEN = "THEN"
let FROM_TIME = "FROM_TIME"
let TO_TIME = "TO_TIME"

//TRADE post

let NUMBER_OF_STOCKS = "NUMBER_OF_STOCKS"
let BUYING_SUCCEEDED = "BUYING_SUCCEEDED"
let SELLING_SUCCEEDED = "SELLING_SUCCEEDED"
let SELLING_WITH_LOSS = "SELLING_WITH_LOSS"
let JUST_SELLING = "JUST_SELLING"
let PRICE_OF_ONE_STOCK = "PRICE_OF_ONE_STOCK"
let LAST_QUANTITY = "LAST_QUANTITY"
let DATE_OF_FIRST_BUYING = "DATE_OF_FIRST_BUYING"
let REAL_S = "REAL_S"

let Iـpurchased = "i_purchased"
let I_SOLD = "i_sold"
let PROFIT = "PROFIT"
let WITH_PROFIT = "WITH_PROFIT"
let LOSS = "LOSS"
let ForPrice = "FOR"
let WITHOUT_PROFIT = "WITHOUT_PROFIT"
let trade_stock = "tradeStock"

// Ranking Screen

let WRONG = "WRONG"
let RIGHT = "RIGHT"
let ALL = "ALL"
let BY_DELTA_FORECAST = "BY_DELTA_FORECAST"
let BY_CORRECT_FORECAST = "BY_CORRECT_FORECAST"
let BY_FORECAST_PROFIT = "BY_FORECAST_PROFIT"
let BY_WALLET_PROFIT = "BY_WALLET_PROFIT"
let BY_STOCK = "BY_STOCK"

// Popup Screen

let HIDE_POST = "HIDE_POST"
let REPORT_POST = "REPORT_POST"
let UNFOLLOW_USER = "UNFOLLOW_USER"
let FOLLOW_USER = "FOLLOW_USER"
let BLOCK_USER = "BLOCK_USER"
let BLOCKED_USER = "BLOCKED_USER"

let FILTER_FOR_TIME = "FILTER_FOR_TIME"
let BEST_USER_FOR = "BEST_USER_FOR"
let WEEK = "WEEK"
let MONTH = "MONTH"
let YEAR = "YEAR"
let DONE = "DONE"
let CLOSE = "CLOSE"
let BY_PROFIT = "BY_PROFIT"
let Change_Stop_Loss = "Change_Stop_Loss"
let Change_Take_Profit_Price = "Change_Take_Profit_Price"
let Close_Order = "Close_Order"


//Settings
let SETTINGS = "SETTINGS"
let FOLLOWING_PEOPLE = "FOLLOWING_PEOPLE"
let FOLLOWING_MARKETS = "FOLLOWING_MARKETS"
let CHANGE_PASSWORD = "CHANGE_PASSWORD"
let INVITE_FRIENDS = "INVITE_FRIENDS"
let CHANGE_LANGUAGE = "CHANGE_LANGUAGE"
let DISCLAIMER = "DISCLAIMER"

// add new post

let ADD_NEW_FORECAST = "ADD_NEW_FORECAST"
let GENERAL = "GENERAL"
let FORECAST = "FORECAST"
let CONDITIONAL_FORECAST = "CONDITIONAL_FORECAST"
let STOCK = "STOCK"
let CURRENCY  = "CURRENCY"
let FOREX = "FOREX"
let OR = "OR"
let SEND = "SEND"
let DURATION_FORECAST = "DURATION_FORECAST"
let OKAY = "OKAY"
let CHOOSE_IMAGE = "CHOOSE_IMAGE"
let CAMERA = "CAMERA"
let GALLERY = "GALLERY"
let HAPPENING = "HAPPENING"
let CANCEL = "CANCEL"
let ADMIN = "ADMIN"

// My Donation list

let MY_DONATION_LIST = "MY_DONATION_LIST"
let AMOUNT = "AMOUNT"
let Successfully_donated = "Successfully_donated"
let TRANSFER_FROM_TRIDDER = "TRANSFER_FROM_TRIDDER"
let SUCCESSFULL_TRANSFER = "SUCCESSFULL_TRANSFER"


//My Followers

let MY_FOLLOWERS = "MY_FOLLOWERS"
let MY_FOLLOWERS_LIST = "MY_FOLLOWERS_LIST"
//My Following

let MY_FOLLOWING = "MY_FOLLOWING"

//SideMenu

let WALLET = "WALLET"
let SUPPORT = "SUPPORT"
let SIGN_OUT = "SIGN_OUT"

//change password

let CURRENT_PASSWORD = "CURRENT_PASSWORD"
let NEW_PASSWORD = "NEW_PASSWORD"
let RE_TYPE_PASSWORD = "RE_TYPE_PASSWORD"

//search

let Search_Forecast = "Search_Forecast"
let Search_Stocks = "Search_Stocks"

//Paypal
let PayPaltitle = "PayPaltitle"
let Enter_Paypal_Info = "Enter_Paypal_Info"
let Enter_Personal_Account = "Enter_Personal_Account"
let Full_Name = "Full_Name"
let Account_Name = "Account_Name"
let Country = "Country"
let City = "City"
let IBAN = "IBAN"
let Account_Number = "Account_Number"
let Add_Paypal = "Add_Paypal"
let PayPal_Name = "PayPal_Name"
let PayPal_Email = "PayPal_Email"

//Toast Messages

let Enter_User_Name = "Enter_User_Name"
let Enter_Password     = "Enter_Password"
let Please_enter_the_Name = "Please_enter_the_Name"
let Please_enter_the_subject = "Please_enter_the_subject"
let Please_enter_the_message = "Please_enter_the_message"

let Please_enter_the_UserName = "Please_enter_the_UserName"
let username_must_5_char = "username_must_5_char"
let Please_enter_valid_UserName = "Please_enter_valid_UserName"
let Please_enter_Country_Code = "Please_enter_Country_Code"
let Please_enter_the_Mobile_Number = "Please_enter_the_Mobile_Number"
let Please_enter_the_Email_Address = "Please_enter_the_Email_Address"
let Please_enter_Email_or_Mobile_number_or_Username = "Please enter Email or Mobile number or Username"

let Please_enter_valid_Email_Address = "Please_enter_valid_Email_Address"
let Please_enter_the_Password = "Please_enter_the_Password"
let Password_must_be_more_than_7_characters     = "Password_must_be_more_than_7_characters"
let Password_should_not_be_more_than_20_characters = "Password_should_not_be_more_than_20_characters"
let Camera_Unavailable     = "Camera_Unavailable"
let Please_check_to_see_if_it_is_disconnected_or_in_use_by_another_application = "Please_check_to_see_if_it_is_disconnected_or_in_use_by_another_application"
let Photo_Library_Unavailable = "Photo_Library_Unavailable"
let Please_check_to_see_if_device_settings_does_not_allow_photo_library_access = "Please_check_to_see_if_device_settings_does_not_allow_photo_library_access"
let Please_select_atleast_one_market = "Please_select_atleast_one_market"
let Please_enter_Current_Password = "Please_enter_Current_Password"
let Please_enter_New_Password = "Please_enter_New_Password"
let Please_enter_Confirm_Password = "Please_enter_Confirm_Password"
let Please_enter_bio     = "Please_enter_bio"
let Please_add_a_comment = "Please_add_a_comment"
let write_a_comment = "write_a_comment"
let write_a_reply = "write_a_reply"
let Please_select_stock = "Please_select_stock"
let Please_add_the_duration = "Please_add_the_duration"
let Please_add_the_price = "Please_add_the_price"
let Please_add_a_price = "Please_add_a_price"
let price_indicator_success = "price_indicator_success"
let Please_select_currency = "Please_select_currency"
let Please_choose_buy_or_sell = "Please_choose_buy_or_sell"
let Please_fill_stop_loss = "Please_fill_stop_loss"
let Please_fill_take_profit = "Please_fill_take_profit"
let Please_select_type = "Please_select_type"
let Please_add_the_condition1 = "Please_add_the_condition1"
let Please_add_the_condition2 = "Please_add_the_condition2"
let Please_fill_within_field = "Please_fill_within_field"
let Please_select_from_time = "Please_select_from_time"
let Please_select_to_time = "Please_select_to_time"
let Forecast_has_been_posted_successfully = "Forecast_has_been_posted_successfully"
let Message_has_been_posted_successfully = "Message_has_been_posted_successfully"
let Message_for_prsentage_error = "PRSENTAGE_ERROR"

let message_for_trade_stock_price = "TRADE_STOCK_PRICE_ERROR"

let Short_Time = "Short_Time"
let Long_Time = "Long_Time"
let Please_add_quantity = "Please_add_quantity"
let Reset_password_link_has_been_sent_to_your_registered_email_address = "Reset_password_link_has_been_sent_to_your_registered_email_address"
let The_password_has_been_changed_successfully = "The_password_has_been_changed_successfully"
let You_can_not_unfollow_this_market = "You_can_not_unfollow_this_market"
let Your_message_has_been_sent_successfully = "Your_message_has_been_sent_successfully"
let Please_add_the_details = "Please_add_the_details"
let Please_add_profile_image = "Please_add_profile_image"
let Select_atleast_one_market = "Select_atleast_one_market"
let Select_atleast_one_stock = "Select_atleast_one_stock"
let Select_atleast_one_currency = "Select_atleast_one_currency"
let Enter_the_amount = "Enter_the_amount"
let LogOut = "LogOut"
let Yes = "Yes"
let No = "No"
let Enter_paypal_name = "Enter_paypal_name"
let Enter_paypal_email_or_mobile_number = "Enter_paypal_email_or_mobile_number"

let Please_enter_your_full_name = "Please_enter_your_full_name"
let Please_enter_your_bank_name = "Please_enter_your_bank_name"
let Please_enter_your_country = "Please_enter_your_country"
let Please_enter_your_city = "Please_enter_your_city"
let Please_enter_your_IBAN = "Please_enter_your_IBAN"
let Please_enter_your_account_number = "Please_enter_your_account_number"
let coming_soon = "coming_soon"


let SEND_PUSH_CHAT = "SEND_PUSH_CHAT"
let NO_MSG_FOUND = "No Message Found"
let K_Messages = "Messages"
let K_Mute = "Mute"
let K_Block = "Block"
let K_UNblock = "Unblock"
let K_Unmute = "Unmute";
let K_Select_From_Option = "Select from option"
let K_Cancel = "Cancel"
let K_Camera = "Camera"
let K_Galery = "Gallery"
let K_Select_Option = "Select option:"
let K_Contact_Profile = "Contact Profile"
let k_Delete = "k_Delete"

let k_Do_you_want_delete_user = "k_Do_you_want_delete_user"

let UNMUTE_NOTIFICATION_BTN = "UNMUTE_NOTIFICATION_BTN"

let Stock_has_been_bought_successfully = "Stock_has_been_bought_successfully"
let Stock_has_been_sold_successfully = "Stock_has_been_sold_successfully"
let Profile_has_been_updated_uccessfully = "Profile_has_been_updated_uccessfully"
let Your_information_has_been_saved = "Your_information_has_been_saved"
let data_not_available = "data_not_available"

let Are_you_sure_you_want_to_Buy_the_stock = "Are_you_sure_you_want_to_Buy_the_stock"
let Are_you_sure_you_want_to_Sell_the_stock = "Are_you_sure_you_want_to_Sell_the_stock"

let No_forecast_is_posted = "No_forecast_is_posted"
let No_Comments_on_this_Posts = "No_Comments_on_this_Posts"
let No_Likes_on_this_post_yet = "No_Likes_on_this_post_yet"
let No_Blocked_Users = "No_Blocked_Users"
let No_follewers_yet = "No_follewers_yet"
let Your_are_not_following_anyone = "Your_are_not_following_anyone"

let Trade_dummy_text = "Trade_dummy_text"
let Price_Indicator_dummy_text = "Price_Indicator_dummy_text"
let Waalet_dummy_text = "Waalet_dummy_text"

let ago = "ago"
let just_now = "just_now"
let mins_ago = "mins_ago"
let hrs_ago = "hrs_ago"
let hr_ago = "hr_ago"
let Yesterday = "Yesterday"
let days_ago = "days_ago"
let Weeks_ago = "Weeks_ago"
let Months_ago = "Months_ago"
let Years_ago = "Years_ago"

let mobile_validation = "mobile_validation"
let change_lang = "change_lang"
let pass_validation = "pass_validation"

// messages of post actions

let commentOnPost = "comment_on_post"
let likeOnPost = "like_on_post"
let replyOnComment = "reply_on_comment"

let forecastSuccess = "FORECAST_SUCCESS"
let forecastFailed = "FORECAST_FAILED"

