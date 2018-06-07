//
//  HomePopUpVC.swift
//  Mutadawel
//
//  Created by Appinventiv on 17/02/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit
import Crashlytics

 protocol TimeLineDelegate: class {
    
      func refreshTimeline(_ info: ForecastPostDetailModel?,count: Int,isComment:Bool)
      func setDurationData(timeLength : String,timeType : String?)
      func setStockFilterType(type : String)
     func setTimeLineFromDetail(info: ForecastPostDetailModel)
    
}


enum SelectPopUp {
    
    case More,Duration,Language,filter,MoreForMyPost,stopLossPopUp
}

enum UpdateForex{
    
    case StopLoss, TakeProfit
}

class HomePopUpVC: MutadawelBaseVC {
    
    //MARK:- IBOutlets
    //MARK:- ================================================
    
    @IBOutlet weak var moreOptionBGView: UIView!
    @IBOutlet weak var hidePostBtn: UIButton!
    @IBOutlet weak var reportPostBtn: UIButton!
    @IBOutlet weak var unFollowUserBtn: UIButton!
    
    @IBOutlet weak var blockUserBtn: UIButton!
    @IBOutlet weak var timeFilterBGview: UIView!
    @IBOutlet weak var filterForTimeLbl: UILabel!
    @IBOutlet weak var bestUserForLbl: UILabel!
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var durationTextField: UITextField!
    @IBOutlet weak var selectDurationBtn: UIButton!
    
    @IBOutlet weak var durationBgView: UIView!
    @IBOutlet weak var weekBtn: UIButton!
    @IBOutlet weak var monthBtn: UIButton!
    @IBOutlet weak var yearbtn: UIButton!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    @IBOutlet weak var changeLagView: UIView!
    @IBOutlet weak var urduBtn: UIButton!
    @IBOutlet weak var englishBtn: UIButton!
    
    
    @IBOutlet weak var rankingFilterpopUpView: UIView!
    @IBOutlet weak var byProfitBtn: UIButton!
    @IBOutlet weak var byCorrectForecastBtn: UIButton!
    @IBOutlet weak var orLbl: UILabel!
    @IBOutlet weak var changeStopLossBtn: UIButton!
    
    @IBOutlet weak var moreOptnForMyPosts: UIView!
    
    @IBOutlet weak var changeTakeProfitBtn: UIButton!
    
    @IBOutlet weak var closeOrderBtn: UIButton!
    
    @IBOutlet weak var stopLossPopUpView: UIView!
    @IBOutlet weak var changeStopLossLbl: UILabel!
    @IBOutlet weak var srLbl: UILabel!
    @IBOutlet weak var amountTxtField: SkyFloatingLabelTextField!
    
    @IBOutlet weak var submitBtnForStopLoss: UIButton!
    
    //MARK:- Properties
    //MARK:- ================================================
    
    var selectPopUp = SelectPopUp.More
    var isFollow = true
    var data = JSONDictionary()
    var delegate:TimeLineDelegate!
    var postInfo = ForecastPostDetailModel()
    var selectedDuartion = "1"
    var updateForex = UpdateForex.StopLoss
    
    
    //MARK:- View life cycle
    //MARK:- ================================================
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
        self.initialSetup()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    //MARK:- Private Methods
    //MARK:- ================================================
    
    
    private func initialSetup(){
        
        self.moreOptionBGView.layer.cornerRadius = 3
        self.numberTextField.text = "1"
        self.durationBgView.isHidden = true
        self.durationBgView.dropShadow()
        self.byProfitBtn.setTitleColor(AppColor.appButtonColor, for: .normal)
        self.byCorrectForecastBtn.setTitleColor(AppColor.appButtonColor, for: .normal)

        if sharedAppdelegate.appLanguage == .Arabic{
            
            self.durationTextField.textAlignment = .right
            self.numberTextField.textAlignment = .right
            self.hidePostBtn.contentHorizontalAlignment = .right
            self.reportPostBtn.contentHorizontalAlignment = .right
            self.unFollowUserBtn.contentHorizontalAlignment = .right
            self.blockUserBtn.contentHorizontalAlignment = .right
            self.changeStopLossBtn.contentHorizontalAlignment = .right
            self.changeTakeProfitBtn.contentHorizontalAlignment = .right
            self.closeOrderBtn.contentHorizontalAlignment = .right
            self.urduBtn.setTitleColor(AppColor.navigationBarColor, for: .normal)
            self.englishBtn.setTitleColor(UIColor.black, for: .normal)

            self.urduBtn.isEnabled = false
            self.englishBtn.isEnabled = true

        }else{
            self.englishBtn.isEnabled = false
            self.urduBtn.isEnabled = true

            self.durationTextField.textAlignment = .left
            self.numberTextField.textAlignment = .left
            self.hidePostBtn.contentHorizontalAlignment = .left
            self.reportPostBtn.contentHorizontalAlignment = .left
            self.unFollowUserBtn.contentHorizontalAlignment = .left
            self.blockUserBtn.contentHorizontalAlignment = .left
            self.changeStopLossBtn.contentHorizontalAlignment = .left
            self.changeTakeProfitBtn.contentHorizontalAlignment = .left
            self.closeOrderBtn.contentHorizontalAlignment = .left
            self.englishBtn.setTitleColor(AppColor.navigationBarColor, for: .normal)
            self.urduBtn.setTitleColor(UIColor.black, for: .normal)

            
        }
        
        self.hidePostBtn.setTitle(HIDE_POST.localized, for: UIControlState.normal)
        self.reportPostBtn.setTitle(REPORT_POST.localized, for: UIControlState.normal)
        
        if self.isFollow{
            
            self.unFollowUserBtn.setTitle(UNFOLLOW_USER.localized, for: UIControlState.normal)
            
        }else{
            
            self.unFollowUserBtn.setTitle(FOLLOW_USER.localized, for: UIControlState.normal)
            
        }
        
        self.blockUserBtn.setTitle(BLOCK_USER.localized, for: UIControlState.normal)
        self.weekBtn.setTitle(WEEK.localized, for: UIControlState.normal)
        self.monthBtn.setTitle(MONTH.localized, for: UIControlState.normal)
        self.yearbtn.setTitle(YEAR.localized, for: UIControlState.normal)
        self.doneBtn.setTitle(DONE.localized, for: UIControlState.normal)
        self.cancelBtn.setTitle(CLOSE.localized, for: UIControlState.normal)
        self.byCorrectForecastBtn.setTitle(BY_CORRECT_FORECAST.localized, for: UIControlState.normal)
        self.byProfitBtn.setTitle(BY_PROFIT.localized, for: UIControlState.normal)
        
        self.changeStopLossBtn.setTitle(Change_Stop_Loss.localized, for: UIControlState.normal)
        self.changeTakeProfitBtn.setTitle(Change_Take_Profit_Price.localized, for: UIControlState.normal)
        self.closeOrderBtn.setTitle(Close_Order.localized, for: UIControlState.normal)
        self.submitBtnForStopLoss.setTitle(SUBMIT_BTN.localized, for: UIControlState.normal)
        self.durationTextField.placeholder = WEEK.localized
        self.filterForTimeLbl.text = FILTER_FOR_TIME.localized
        self.bestUserForLbl.text = BEST_USER_FOR.localized
        self.showPopUp()
        self.amountTxtField.keyboardType = UIKeyboardType.decimalPad
    }
    
    
    func showPopUp(){
        
        if self.selectPopUp == .Duration{
            
            self.moreOptionBGView.isHidden = true
            self.changeLagView.isHidden = true
            self.rankingFilterpopUpView.isHidden = true
            self.moreOptnForMyPosts.isHidden = true
            self.stopLossPopUpView.isHidden = true
            
            
        }else if self.selectPopUp == .More{
            
            self.timeFilterBGview.isHidden = true
            self.durationBgView.isHidden = true
            self.changeLagView.isHidden = true
            self.rankingFilterpopUpView.isHidden = true
            self.moreOptnForMyPosts.isHidden = true
            self.stopLossPopUpView.isHidden = true
            
            
        }else if self.selectPopUp == .Language{
            
            self.timeFilterBGview.isHidden = true
            self.durationBgView.isHidden = true
            self.moreOptionBGView.isHidden = true
            self.rankingFilterpopUpView.isHidden = true
            self.moreOptnForMyPosts.isHidden = true
            self.stopLossPopUpView.isHidden = true
            
        }else if self.selectPopUp == .filter{
            self.timeFilterBGview.isHidden = true
            self.durationBgView.isHidden = true
            self.moreOptionBGView.isHidden = true
            self.moreOptnForMyPosts.isHidden = true
            self.stopLossPopUpView.isHidden = true
            self.changeLagView.isHidden = true
            
        }else if self.selectPopUp == .MoreForMyPost{
            self.timeFilterBGview.isHidden = true
            self.durationBgView.isHidden = true
            self.moreOptionBGView.isHidden = true
            self.rankingFilterpopUpView.isHidden = true
            self.stopLossPopUpView.isHidden = true
            self.changeLagView.isHidden = true
            
            
        }else if self.selectPopUp == .stopLossPopUp{
            self.timeFilterBGview.isHidden = true
            self.durationBgView.isHidden = true
            self.moreOptionBGView.isHidden = true
            self.rankingFilterpopUpView.isHidden = true
            self.moreOptnForMyPosts.isHidden = true
            self.changeLagView.isHidden = true
            
            
        }
        
        
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //if self.selectPopUp == .MoreForMyPost{
            
            if let view = touches.first?.view {
                
                if view == self.view && !self.view.subviews.contains(view) {
                    
                    self.dismiss(animated: true, completion: nil)
                }
            }
            
//        }else{
//            
//            self.dismiss(animated: true, completion: nil)
//            
//        }
        
    }
    
    
    
    func showAlert(isEnglish: Bool){
        
        let alert = UIAlertController(title: "", message: change_lang.localized, preferredStyle: .alert)
        
        
        alert.addAction(UIAlertAction(title: Yes.localized, style: .default, handler: { (UIAlertAction) in
            
            self.setAppLang(isEnglish: isEnglish)
        }))
        
        alert.addAction(UIAlertAction(title: No.localized, style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    func changeLanguage(isEnglish: Bool){
    
        if isEnglish{
            
            UIView.appearance().semanticContentAttribute = .forceLeftToRight

            userDefaults.setValue(App_Language_name.english, forKey: UserDefaultsKeys.APP_LANGUAGE)
            
        }else{
            
            UIView.appearance().semanticContentAttribute = .forceRightToLeft

            userDefaults.setValue(App_Language_name.arabic, forKey: UserDefaultsKeys.APP_LANGUAGE)
            
        }
        
        Crashlytics.sharedInstance().crash()

    }
    
    
    func setAppLang(isEnglish: Bool){
    
        var params = JSONDictionary()
        
        params["userId"] = CurrentUser.user_id
        
        if isEnglish{
            params["lang"] = "en"
        }else{
            params["lang"] = "ar"
        }
        params["device_token"] = (sharedAppdelegate.deviceToken ?? "12345")
        params["device_id"] = UIDevice.current.identifierForVendor?.uuidString

        setLangAPI(params: params) { (success, msg, data) in
            if success{
                    if isEnglish{
                        userDefaults.set("en", forKey: UserDefaultsKeys.APP_LANGUAGE)
                    }else{
                        userDefaults.set("ar", forKey: UserDefaultsKeys.APP_LANGUAGE)  //https://www.youtube.com/watch?v=2mNrYTA0WY4
                    }
                Crashlytics.sharedInstance().crash()
            }
        }
    }
	
    func follow_UnFollow_Friend(url:String){
		
        var params = JSONDictionary()
        params["follower_id"] = CurrentUser.user_id
        params["following_id"] = self.postInfo.user_id
        
        chooseFriendAPI(params: params,url:url) { (success, msg, data) in
            
            if success{
                self.delegate?.refreshTimeline(nil,count: 0, isComment: false)
                self.dismiss(animated: true, completion: nil)
            }else{
                
            }
        }
    }
    
    //MARK:- IBActions
    //MARK:- ================================================
    
    @IBAction func hidePostBtnTapped(_ sender: UIButton) {
        
        var params = JSONDictionary()
        
        params["userId"] = CurrentUser.user_id
        
        params["forecastId"] = self.postInfo.forecast_id
        showLoader()
        
        hidePostAPI(params: params) { (success, msg, data) in
            if success{
                self.delegate?.refreshTimeline(nil,count: 0, isComment: false)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    
    @IBAction func reportPostBtnTapped(_ sender: UIButton) {
        var params = JSONDictionary()
        
        params["userId"] = CurrentUser.user_id
        
        params["forecastId"] = self.postInfo.forecast_id
        showLoader()
        
        reportPostAPI(params: params) { (success, msg, data) in
            
            if success{
                self.dismiss(animated: true, completion: nil)
            }
            showToastWithMessage(msg: msg)
        }
        
    }
    
    
    @IBAction func byprofitBtnTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        self.delegate?.setStockFilterType(type: "0")
    }
    
    
    @IBAction func byCorrectForecastTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        self.delegate?.setStockFilterType(type: "1")
    }
    
    
    @IBAction func unfollowUserBtnTapped(_ sender: UIButton) {
        
        if self.isFollow{
            
            self.follow_UnFollow_Friend(url: EndPoint.unfollowFriendURL)
            
        }else{
            
            self.follow_UnFollow_Friend(url: EndPoint.chooseFriendURL)
            
        }
        
    }
    
    
    @IBAction func blockUserBtnTapped(_ sender: UIButton) {
        
        var params = JSONDictionary()
        
        params["blockerId"] = CurrentUser.user_id
        params["blockedId"] = self.postInfo.user_id

        showLoader()
        
        
        blockUserAPI(params: params) { (success, msg, data) in
            hideLoader()
            
            if success{
                self.delegate?.refreshTimeline(nil,count: 0, isComment: false)
                self.dismiss(animated: true, completion: nil)
            }else{
                showToastWithMessage(msg: msg)
            }
        }
    }
    
    @IBAction func selectDurationBtnTapped(_ sender: UIButton) {
        
        self.durationBgView.isHidden = false
    }
    
    
    @IBAction func weekbtnTapped(_ sender: UIButton) {
        
        self.durationTextField.text = WEEK.localized
        self.durationBgView.isHidden = true
        self.selectedDuartion = "1"
        
        
    }
    
    @IBAction func monthbtnTapped(_ sender: UIButton) {
        
        self.durationTextField.text = MONTH.localized
        self.durationBgView.isHidden = true
        self.selectedDuartion = "2"
        
        
    }
    
    @IBAction func yearbtnTapped(_ sender: UIButton) {
        
        self.durationTextField.text = YEAR.localized
        self.durationBgView.isHidden = true
        self.selectedDuartion = "3"
        
    }
    
    
    @IBAction func doneBtnTapped(_ sender: UIButton) {
        
        
        if self.numberTextField.text != ""{
            self.delegate?.setDurationData(timeLength: self.numberTextField.text!, timeType: self.selectedDuartion)
            
            self.dismiss(animated: true, completion: nil)
        }else{
            showToastWithMessage(msg: Please_add_the_duration.localized)
        }
        
    }
    
    @IBAction func cancelBtnTapped(_ sender: UIButton) {
        
        self.delegate?.setDurationData(timeLength: "", timeType: nil)
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    @IBAction func urduBtnTap(_ sender: UIButton) {
        
        
        self.showAlert(isEnglish: false)
        
    }
    
    @IBAction func englishBtnTap(_ sender: UIButton) {
        
        self.showAlert(isEnglish: true)
    }
    
    @IBAction func changeStopLossBtnTapd(_ sender: UIButton) {
        self.view.endEditing(true)
        
        self.stopLossPopUpView.isHidden = false
        self.updateForex = .StopLoss
        self.changeLagView.isHidden = true
        self.durationBgView.isHidden = true
        self.moreOptionBGView.isHidden = true
        self.rankingFilterpopUpView.isHidden = true
        self.moreOptnForMyPosts.isHidden = true
        self.changeStopLossLbl.text = Change_Stop_Loss.localized
        
    }
    
    
    
    @IBAction func changeTakeProfitBtnTappd(_ sender: UIButton) {
        self.view.endEditing(true)
        
        self.updateForex = .TakeProfit
        self.stopLossPopUpView.isHidden = false
        self.changeLagView.isHidden = true
        self.durationBgView.isHidden = true
        self.moreOptionBGView.isHidden = true
        self.rankingFilterpopUpView.isHidden = true
        self.moreOptnForMyPosts.isHidden = true
        self.changeStopLossLbl.text = Change_Take_Profit_Price.localized
        
    }
    
    
    
    @IBAction func closeOrdrBtnTappd(_ sender: UIButton) {
        
        self.view.endEditing(true)
        
        var params = JSONDictionary()
        
        params["userId"] = CurrentUser.user_id
        
        params["forecastId"] = self.postInfo.forecast_id
        params["forecastPrice"] = self.postInfo.forecast_price
        params["currency"] = self.postInfo.currency
        
        
        showLoader()
        closeOrderAPI(params: params) { (success, msg, data) in
            
            hideLoader()
            
            if success{
                
                self.postInfo.is_updatable = "no"
                self.dismiss(animated: true, completion: nil)
                
                self.delegate.refreshTimeline(self.postInfo,count: 0, isComment: false)
                
            }
        }
    }
    
    
    
    @IBAction func submitBtnTappdForStopLoss(_ sender: UIButton) {
        
        self.view.endEditing(true)
        var params = JSONDictionary()
        
        params["userId"] = CurrentUser.user_id
        
        params["forecastId"] = self.postInfo.forecast_id 
        
        if self.amountTxtField.text != nil{
            
            params["value"] = self.amountTxtField.text
            
        }else{
            
            showToastWithMessage(msg: Please_add_a_price.localized)
            
            return
        }
        
        if self.updateForex == .StopLoss{
            
            self.postInfo.stop_loss = self.amountTxtField.text
            
            params["action"] = 1
            
        }else{
            
            self.postInfo.take_profit = self.amountTxtField.text
            params["action"] = 2
            
        }
        
        showLoader()
        updateForexAPI(params: params) { (success, msg, data) in
            hideLoader()
            
            if success{
                self.dismiss(animated: true, completion: nil)
                self.delegate.refreshTimeline(self.postInfo,count: 0, isComment: false)
            }
            showToastWithMessage(msg: msg)
        }
    }
}


extension HomePopUpVC: UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if isValidNumber(str: string){
            
            return false
        }
        return true
    }
    
}
