//
//  AddNewPostPrivateMethods.swift
//  Mutadawel
//
//  Created by Appinventiv on 18/12/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import Foundation
import SwiftyJSON

extension AddNewPostVC{
    
     func initialSetupView() {
        
        self.addPostTableView.delegate = self
        self.addPostTableView.dataSource = self
        self.picker?.delegate = self
        self.chooseExpectBgView.isHidden = true
        self.popUpView.layer.cornerRadius = 3
        self.dropDownView.layer.borderWidth = 1
        self.doneBtn.layer.borderWidth = 1
        self.doneBtn.layer.borderColor = UIColor.lightGray.cgColor
        self.dropDownView.layer.borderColor = AppColor.appTextColor.cgColor
        self.datePickerBottomConstraint.constant = -200
        self.generalLbl.textColor = AppColor.appButtonColor
        self.navigationTitle.font = setNavigationTitleFont()
        
        self.generalLbl.textColor = UIColor.darkGray
        self.generalImg.image = UIImage(named: "ic_add_new_post_general_deselect")
        self.expectLbl.textColor = AppColor.appButtonColor
        self.expectImg.image = UIImage(named: "ic_add_new_post_expectation_select")
        self.conditionLbl.textColor = UIColor.darkGray
        self.conditionImg.image = UIImage(named: "ic_add_new_post_conditions_expectation_deselect")
        
        self.stockBtn.setTitle(STOCK.localized, for: UIControlState.normal)
        self.forexBtn.setTitle(FOREX.localized, for: UIControlState.normal)
        self.navigationTitle.text = ADD_NEW_FORECAST.localized
        self.generalLbl.text = GENERAL.localized
        self.expectLbl.text = FORECAST.localized
        self.conditionLbl.text = CONDITIONAL_FORECAST.localized
        self.orLbl.text = OR.localized
        self.datePicker.datePickerMode = .dateAndTime
        self.doneBtn.setTitle(DONE.localized, for: .normal)
        self.stockBtn.setTitleColor(AppColor.appButtonColor, for: .normal)
        self.forexBtn.setTitleColor(AppColor.appButtonColor, for: .normal)
        
        self.addPostTableView.reloadData()
        
    }
    
    func dismissKeyboard(_sender: AnyObject){
        
        self.view.endEditing(true)
    }
    
    func getForexCurrentPrice(symbol: String){
        
        let token = "37BC3DE2C8E745F5A80F79CBE53FA4C2"
        let url = "http://globalcurrencies.xignite.com/xGlobalCurrencies.json/GetRealTimeRate?Symbol=\(symbol)&_TOKEN=\(token)"
        
        forexAPI(url: url) { (success, msg, data) in
            
            if success{
                
                self.forcastPriceDetail = ForexPriceAPIModel(withData: data!)
                
                    if self.buy_sell == .Buy{
                        
                        self.forecastDetail["price"] = self.forcastPriceDetail.Bid ?? 0
                        self.forecastDetail["current_price"] = self.forcastPriceDetail.Bid ?? 0
                        
                    }else if self.buy_sell == .Sell{
                        
                        self.forecastDetail["price"] = self.forcastPriceDetail.Ask ?? 0
                        self.forecastDetail["current_price"] = self.forcastPriceDetail.Ask ?? 0
                        
                    }
                self.addPostTableView.reloadData()
            }
        }
    }
    
    func selectFromToTime(){
        
        let dateFormater = DateFormatter()
        self.datePicker.minimumDate = Date()
        dateFormater.dateFormat = "yyyy-MM-dd HH:mm:ss "
        let showtime = dateFormater.string(from: self.datePicker.date)
        if self.chooseTimeType == .From{
            self.forecastDetail["from_time"] = showtime as AnyObject
        }else if self.chooseTimeType == .To{
            self.forecastDetail["to_time"] = showtime as AnyObject
        }else if self.chooseTimeType == .Within1 && self.within_type == .Within1{
            self.forecastDetail["within1"] = showtime as AnyObject
        }else if self.chooseTimeType == .Within2 && self.within_type == .Within2{
            self.forecastDetail["within2"] = showtime as AnyObject
        }
        self.addPostTableView.reloadData()
    }
    
    
    func removeImagebtnTapped(_ sender: UIButton){
        
        self.selectedImage = nil
        self.addPostTableView.reloadData()
    }
    
    
    func showPopUp(){
        
        if self.popUp_type == .Sell{
            
            self.shortTermBtn.setTitle(BUY.localized, for: UIControlState.normal)
            self.lonTermBtn.setTitle(SELL.localized, for: UIControlState.normal)
            
        }else{
            
            self.shortTermBtn.setTitle(Short_Time.localized, for: UIControlState.normal)
            self.lonTermBtn.setTitle(Long_Time.localized, for: UIControlState.normal)
            
        }
        
    }
    
    
    
    func hideDatePicker(){
        
        UIView.animate(withDuration: 0.5, animations: {
            
            self.datePickerBottomConstraint.constant = -200
            self.view.layoutIfNeeded()
            
        }) { (true) in
            self.chooseExpectBgView.isHidden = true
        }
    }
    
    
    
    func showDatePicker(){
        
        UIView.animate(withDuration: 0.5, animations: {
            self.datePicker.reloadInputViews()
            self.chooseExpectBgView.isHidden = false
            self.popUpView.isHidden = true
            
            let dateFormatter = DateFormatter()
            
            if self.chooseTimeType == .To {
                
                if let from = self.forecastDetail["from_time"]{
                    
                    dateFormatter.dateFormat = "MM-dd-yyyy hh:mm"
                    
                    let fromDate = dateFormatter.date(from: "\(from)")
                    
                    self.datePicker.minimumDate = fromDate
                    
                }
            }else{
                self.datePicker.minimumDate = Date()
            }
            self.datePickerBottomConstraint.constant = 0
            self.view.layoutIfNeeded()
            
        }, completion: { (true) in
            
        })
    }
    
// add general post
    
     func addGeneralPost(){
        
        var params = JSONDictionary()
        
        if self.selectedImage != nil{
            
            params["image"] = self.forecastDetail["image"]
        }
        
        if let caption = self.forecastDetail["caption"],"\(caption)" != ""{
            
            params["caption"] = caption
            
        }else{
            
            sharedAppdelegate.nvc.view.makeToast(Please_add_a_comment.localized)
            return
        }
        
        params["post_type"] = 1
        params["user_id"] = CurrentUser.user_id
        
        self.addNewPostService(with: params)

    }
    
  // add forecast post
    
    func validateForeCastPost() -> Bool{
        
        guard let _ = self.forecastDetail["stock_id"] else{
            
            sharedAppdelegate.nvc.view.makeToast(Please_select_stock.localized)
            setEvent(eventName: FirebaseEventName.choose_stock_error, params: ["eventId": self.eventId as NSObject])
            
            return false
        }
        guard let duration = self.forecastDetail["duration"], "\(duration)" != "" else{
            
            sharedAppdelegate.nvc.view.makeToast(Please_add_the_duration.localized)
            setEvent(eventName: FirebaseEventName.enter_duration_error, params: ["eventId": self.eventId as NSObject])
            
            return false
        }
        
        if self.percentageForExpectation <= 1.24 {
            
            showToastWithMessage(msg: Message_for_prsentage_error.localized)
            return false

            
        }else if self.percentageForExpectation > 1.24 {
            
            guard let price = self.forecastDetail["price"], "\(price)" != "" else{
                
                sharedAppdelegate.nvc.view.makeToast(Please_add_the_price.localized)
                setEvent(eventName: FirebaseEventName.enter_then_price_error, params: ["eventId": self.eventId as NSObject])
                
                return false
            }
        }
        return true

    }
    
     func addForeCastPost(){
        
        guard self.validateForeCastPost() else{return}
        
        var params = JSONDictionary()
        
        params["price"] = self.forecastDetail["price"] ?? ""
        params["caption"]   =  self.forecastDetail["caption"] ?? ""
        params["image"] = self.forecastDetail["image"] ?? ""
        params["stockSymbol"] = forecastDetail["symbol"] ?? ""
        params["market_type"] = 2
        params["post_type"] = 2
        params["user_id"] = CurrentUser.user_id
        params["market_id"] = "1"
        params["stock_id"] = self.forecastDetail["stock_id"] ?? ""
        params["duration"] = self.forecastDetail["duration"] ?? ""
        self.addNewPostService(with: params)
    }

    // add conditional post
    
    func validateConditionalForecastPost() -> Bool{
        
        guard let _ = self.forecastDetail["stock_id"]else{
            sharedAppdelegate.nvc.view.makeToast(Please_select_stock.localized)
            setEvent(eventName: FirebaseEventName.choose_stock_error, params: ["eventId": self.eventId as NSObject])
            
            return false
        }
        
        guard let condition1 = self.forecastDetail["condition1"], "\(condition1)" != "" else{
            sharedAppdelegate.nvc.view.makeToast(Please_add_the_condition1.localized)
            setEvent(eventName: FirebaseEventName.enter_if_error, params: ["eventId": self.eventId as NSObject])
            
            return false
        }
        guard let within1 = self.forecastDetail["within1"], "\(within1)" != ""  else{
            sharedAppdelegate.nvc.view.makeToast(Please_fill_within_field.localized)
            setEvent(eventName: FirebaseEventName.enter_within_error, params: ["eventId": self.eventId as NSObject])
            
            return false
        }
        
        if self.percentageForExpectation <= 1.24 {
            
            self.view.endEditing(true)
            
            showToastWithMessage(msg: Message_for_prsentage_error.localized)
            return false

        }else if self.percentageForExpectation > 1.24 {
            
            self.view.endEditing(true)
            
            guard let condition2 = self.forecastDetail["condition2"], "\(condition2)" != ""  else{
                sharedAppdelegate.nvc.view.makeToast(Please_add_the_condition2.localized)
                return false
            }
            
        }
        guard let within2 = self.forecastDetail["within2"], "\(within2)" != "" else{
            sharedAppdelegate.nvc.view.makeToast(Please_fill_within_field.localized)
            return false
        }

        return true

    }

     func addConditionalForecastPost(){
        
        guard self.validateConditionalForecastPost() else{return}
        var params = JSONDictionary()

        params["condition2"] = self.forecastDetail["condition2"] ?? ""
        params["caption"]   = self.forecastDetail["caption"] ?? ""
        params["image"] = self.forecastDetail["image"] ?? ""
        params["stockSymbol"] = forecastDetail["symbol"] ?? ""
        params["post_type"] = 3
        params["user_id"] = CurrentUser.user_id
        params["market_id"] = "1"
        params["stock_id"]  = self.forecastDetail["stock_id"] ?? ""
        params["condition1"] = self.forecastDetail["condition1"] ?? ""
        params["within1"] = self.forecastDetail["within1"] ?? ""
        params["within2"] = self.forecastDetail["within2"] ?? ""
        params["market_type"] = 2
        params["user_id"] = CurrentUser.user_id 
        params["market_id"] = "1"

        self.addNewPostService(with: params)
    }

   // add new post service call
    
   func addForecastInfo(_ sender: UIButton){
        
        self.view.endEditing(true)
    
        if self.addPostType == .General{
            
            self.addGeneralPost()
            
        }else if self.addPostType == .Forcast{
            
            self.addForeCastPost()
            
        }else{
            
            self.addConditionalForecastPost()
        }
    
    }
    
     func addNewPostService(with params: JSONDictionary){
        
        showLoader()
        
        addForecastAPI(params: params) { (success, msg, data) in
            
            hideLoader()
            
            if success{
                
                setEvent(eventName: FirebaseEventName.successful_post, params: ["eventId": self.eventId as NSObject])
                _ = sharedAppdelegate.nvc.popViewController(animated: true)
                
                if self.addPostType == .General{
                    
                    showToastWithMessage(msg: Message_has_been_posted_successfully.localized)
                    
                }else{
                    
                    showToastWithMessage(msg: Forecast_has_been_posted_successfully.localized)
                    
                }
                
                self.delegate?.refreshTimeline(nil,count: 0, isComment: false)
            }else{
                
                showToastWithMessage(msg: msg)
                
            }
        }

    }
    
}
