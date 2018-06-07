//
//  OtherUserProfileVc.swift
//  Mutadawel
//
//  Created by ApInventiv Technologies on 02/03/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit
import GraphKit
import StoreKit
import SKPhotoBrowser

enum OtherProfileState{
    case SideMenu,None
}

enum NotificationState{
    case on,off
}
class OtherUserProfileVc: UIViewController {
    
    //MARK:- =======================================
    //MARK:- IBOutlets
    
    
    @IBOutlet weak var otherUserProfileTableView: UITableView!
    @IBOutlet weak var notificationPopupBgView: UIView!
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var notificationStatus: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var statusBtn: UIButton!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var donatePopUpView: UIView!
    @IBOutlet weak var donateToLbl: UILabel!
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var userLbl: UILabel!
    @IBOutlet weak var donateAmntTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var donateBtn: UIButton!
    
    //MARK:- =======================================
    //MARK:- properties
    
    var isFollow = false
    var userID: Int = 0
    var userInfo = ProfileModel()
    var rightForcast = [Any]()
    var wrongForecast = [Any]()
    var plans : [SKProduct]?
    var pickOption:[Int] = [50, 100, 300, 500, 999]
    var selectedAmount:Double = 50
    var notificationState = NotificationState.off
    var eventId = "other user profile"
    
    
    //MARK:- =======================================
    //MARK:- view life cycle methods
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.initialViewStup()
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        if sharedAppdelegate.appLanguage == .English{
            
            slideMenuController()?.removeLeftGestures()
            
        }else{
            slideMenuController()?.removeRightGestures()
        }
        
        self.getUSerInfo()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        if sharedAppdelegate.appLanguage == .English{
            
            slideMenuController()?.addLeftGestures()
            
        }else{
            
            slideMenuController()?.addRightGestures()
            
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
        if let view = touches.first?.view {
            
            if view == self.notificationPopupBgView && !self.notificationPopupBgView.subviews.contains(view) {
                
                self.notificationPopupBgView.isHidden = true
                
            }
        }
    }
    
    
    //MARK:- =======================================
    //MARK:- Private functions
    
    
    func initialViewStup(){
        
        self.otherUserProfileTableView.delegate = self
        self.otherUserProfileTableView.dataSource = self
        self.notificationPopupBgView.isHidden = true
        self.popUpView.layer.cornerRadius = 3
        self.donatePopUpView.layer.cornerRadius = 3
        self.userImg.layer.cornerRadius = self.userImg.bounds.height / 2
        self.userImg.layer.masksToBounds = true
        
        if sharedAppdelegate.appLanguage == .Arabic{
            self.donateAmntTextField.textAlignment = .right
        }else{
            self.donateAmntTextField.textAlignment = .left
        }
        
        self.donateToLbl.text = DONATE_TO.localized
        self.donateBtn.setTitle(DONATE.localized, for: .normal)
        self.notificationStatus.text = ACCOUNT_NOTIFICATIONS.localized
        self.descriptionLbl.text = DESCRIPTION.localized
        
        self.otherUserProfileTableView.register(UINib(nibName: "ProfileMarketCell", bundle: nil), forCellReuseIdentifier: "ProfileMarketCell")
        
        let pickerView = UIPickerView()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.showsSelectionIndicator = true
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.black
        toolBar.tintColor = UIColor.white
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(donePicker))
        
        toolBar.setItems([doneButton], animated: false)
        
        toolBar.isUserInteractionEnabled = true
        // pickerView = UIPickerView(frame: CGRect(x: 0, y: 200, width: 150, height: 175))
        pickerView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        self.donateAmntTextField.inputView = pickerView
        self.donateAmntTextField.inputAccessoryView = toolBar
        
        
    }
    
    
    func viewImageInMultipleImageViewer() {
        
        guard let pic = self.userInfo.profile_pic, !pic.isEmpty else{return}
        let browser = SKPhotoBrowser(photos: createWebPhotos())
        browser.initializePageIndex(0)
        browser.delegate = self
        
        present(browser, animated: true, completion: nil)
        
    }
    
    func donePicker() {
        
        _ = self.donateAmntTextField.resignFirstResponder()
        
    }
    
    
    func getPlans() {
        
        //tableView.reloadData()
        showLoader()
        RageProducts.store.requestProducts{success, products in
            if success {
                
                hideLoader()
                
                self.donate(transactionId: "")
                
            }else{
                
                hideLoader()
            }
        }
    }
    
    
    func donate(transactionId: String){
        
        self.view.endEditing(true)
        var params = JSONDictionary()
        params["senderId"] = CurrentUser.user_id
        params["recieverId"] = self.userID
        params["transactionId"] = 3
        params["amount"] = self.selectedAmount
        params["currency"] = "SR"
        
        showLoader()
        makeDonationAPI(params: params) { (success, msg, data) in
            
            hideLoader()
            
            print_debug(object: data)
            
            if success{
                
                self.notificationPopupBgView.isHidden = true
                
                showToastWithMessage(msg: Successfully_donated.localized)
                
            }else{
                
                showToastWithMessage(msg: msg)
            }
        }
    }
    
    
    fileprivate func getUSerInfo(){
        
        var params = JSONDictionary()
        params["userId"] = self.userID
        params["myId"] = CurrentUser.user_id
        
        showLoader()
        userProfileAPI(params: params) { (success, msg, data) in
            hideLoader()
            print_debug(object: data)
            
            if success{
                
                self.userInfo = ProfileModel(withData: data!)
                
                if let img = self.userInfo.profile_pic{
                    
                    let imageUrl = URL(string: img)
                    
                    self.userImg.sd_setImage(with: imageUrl, placeholderImage: #imageLiteral(resourceName: "ic_following_placeholder"))
                    
                }
                
                if let is_notification_on = self.userInfo.is_notification_on{
                    
                    
                    if is_notification_on == "off"{
                        
                        self.notificationState = .off
                        self.statusBtn.setImage(UIImage(named:"ic_box_deselect"), for: UIControlState.normal)
                        self.descriptionLbl.text = DESCRIPTION.localized
                        self.statusLbl.text = OFF.localized
                        
                        
                    }else{
                        
                        self.notificationState = .on
                        self.statusBtn.setImage(UIImage(named:"ic_box_select"), for: UIControlState.normal)
                        self.descriptionLbl.text = NOTI_DESCRIPTION.localized
                        self.statusLbl.text = ON.localized
                        
                        
                    }
                }
                if let name = self.userInfo.name{
                    
                    self.userLbl.text = name
                    
                    self.userNameLbl.text = name
                    
                }
                
            }
//            else{
//                
//                // showToastWithMessage(msg: msg)
//                let obj = postDetailStoryboard.instantiateViewController(withIdentifier: "SomethingWentWrongVC") as! SomethingWentWrongVC
//                obj.delegate = self
//                obj.modalPresentationStyle = .overCurrentContext
//                //              obj.modalTransitionStyle = .partialCurl
//                self.navigationController?.present(obj, animated: true, completion: nil)
//                
//            }
            
            self.otherUserProfileTableView.reloadData()
        }
    }
    
    
    
    func follow_UnFollow_Friend(_ url:String){
        
        var params = JSONDictionary()
        
        if CurrentUser.user_id != nil{
            
            params["follower_id"] = CurrentUser.user_id! 
            
        }
        if let following_id = self.userInfo.user_id{
            params["following_id"] = following_id
        }
        
        print_debug(object: url)
        print_debug(object: params)
        showLoader()
        chooseFriendAPI(params: params,url:url) { (success, msg, data) in
            hideLoader()
            if success{
                if url == EndPoint.unfollowFriendURL{
                    
                    self.userInfo.is_following = "no"
                    self.userInfo.is_notification_on = "off"
                    
                }else{
                    
                    self.userInfo.is_following = "yes"
                    
                }
                self.otherUserProfileTableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: UITableViewRowAnimation.none)
            }else{
                
            }
        }
    }
    
    
    
    func setNotificationState(){
        
        var params = JSONDictionary()
        
        params["userId"] = CurrentUser.user_id
        
        params["unfollowingId"] = self.userID
        
        
        if self.notificationState == .on{
            
            self.statusLbl.text = ON.localized
            
            params["action"] = 2
            
        }else{
            
            self.statusLbl.text = OFF.localized
            
            params["action"] = 1
            
        }
        showLoader()
        accntNotificationAPI(params: params) { (success, msg, data) in
            hideLoader()
            print_debug(object: data)
            
            if success{
                
                
                if self.notificationState == .on{
                    
                    self.notificationState = .off
                    self.userInfo.is_notification_on = "off"
                    showToastWithMessage(msg: NOTI_OFF_DESCRIPTION.localized)
                    
                }else{
                    
                    
                    self.notificationState = .on
                    self.userInfo.is_notification_on = "on"
                    showToastWithMessage(msg: NOTI_DESCRIPTION.localized)
                    
                }
                
                
                self.otherUserProfileTableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
            }else{
                showToastWithMessage(msg: msg)
            }
            
        }
        
        
    }
    
    
    //MARK:- =======================================
    //MARK:- IBActions
    
    
    @IBAction func donateBtnTapped(_ sender: UIButton) {
        self.donate(transactionId: "")
        //self.getPlans()
    }
    
    
    @IBAction func editProfileBtntap(_ sender: UIButton) {
        
        let obj = sideMenuStoryboard.instantiateViewController(withIdentifier: "EditProfileID") as! EditProfileVc
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    @IBAction func walletBtnTap(_ sender: UIButton) {
        
        let obj = sideMenuStoryboard.instantiateViewController(withIdentifier: "SubscriptionID") as! SubscriptionVC
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    @IBAction func statusExpeditionBtnTap(_ sender: UIButton) {
        let obj = sideMenuStoryboard.instantiateViewController(withIdentifier: "StatusOfExpectationVc") as! StatusOfExpectationVc
        obj.userId = self.userID
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    
    
    @IBAction func NotificationCheckBoxTapped(_ sender: UIButton) {
        
    }
}


extension OtherUserProfileVc: TryAgainDelegate{
    
    func tryAgain() {
        self.getUSerInfo()
    }
}


//MARK:- =======================================
//MARK:- tableview datasource and delegate

extension OtherUserProfileVc: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
            
        }else{
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "OtherProfileInfoCell", for: indexPath) as! OtherProfileInfoCell
            cell.imageBtn.addTarget(self, action: #selector(OtherUserProfileVc.viewImageInMultipleImageViewer), for: .touchUpInside)
            
            cell.followerBtn.addTarget(self, action: #selector(OtherUserProfileVc.followersBtnTapped), for: .touchUpInside)
            cell.followingBtn.addTarget(self, action: #selector(OtherUserProfileVc.followingBtnTapped), for: .touchUpInside)
            cell.pointsBtn.addTarget(self, action: #selector(OtherUserProfileVc.postsBtnTapped), for: .touchUpInside)
            cell.followBtn.addTarget(self, action: #selector(OtherUserProfileVc.editProfileBtnTapped), for: .touchUpInside)
            cell.backBtn.addTarget(self, action: #selector(OtherUserProfileVc.backBtnTapped), for: .touchUpInside)
            cell.msgBtn.addTarget(self, action: #selector(OtherUserProfileVc.commentBtnTapped(_:)), for: .touchUpInside)
            cell.notificationBtn.addTarget(self, action: #selector(OtherUserProfileVc.notificationBtnTapped(_:)), for: .touchUpInside)
            cell.donateBtn.addTarget(self, action: #selector(OtherUserProfileVc.donationBtnTapped(_:)), for: .touchUpInside)
            
            cell.followBtn.layer.cornerRadius = 2
            cell.setUserInfo(userInfo: self.userInfo)
            return cell
            
        case 1:
            
            if indexPath.row == 0{
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "OtherProfitLostCell", for: indexPath) as! OtherProfitLostCell
                
                self.rightForcast = self.userInfo.right ?? []
                
                self.wrongForecast = self.userInfo.wrong ?? []
                
                cell.seperatorView.isHidden = false
                cell.graphView.dataSource = self
                cell.graphView.draw()
                cell.graphView.reset()
                cell.graphView.draw()
                cell.graphView.isHidden = false
                cell.profitlostBtn.addTarget(self, action: #selector(OtherUserProfileVc.profitLostBtnBtnTapped), for: .touchUpInside)
                cell.statusOfExpectLbl.isHidden = false
                if let profit_loss = self.userInfo.forecast_profit_loss{
                    cell.profitlLostValue.text = "\(profit_loss)%"
                }
                if let status = self.userInfo.forecast_status_precent{
                    cell.expectValueLbl.text = "\(status.roundTo(places: 4))%"
                    
                    if status < 0{
                        
                        cell.upDownArrowIng.image = #imageLiteral(resourceName: "ic_home_downarrow")
                    }else{
                        
                        cell.upDownArrowIng.image = #imageLiteral(resourceName: "ic_home_uparrow")
                    }
                    
                }
                
                return cell
                
            }else{
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileMarketCell", for: indexPath) as! ProfileMarketCell
                cell.forwordArrowImg.isHidden = true
                if indexPath.row == 1{
                    
                    cell.marketNameLbl.text = WALLET_NET_VALUE.localized
                    let net_value = "\(self.userInfo.net_value ?? 0)"
                    cell.marketValueLbl.text = "SR " + net_value
                    cell.seperatorView.isHidden = false
                    
                    cell.marketSymbolWidthConstant.constant = 0
                    
                    cell.moreMarketLbl.text = ""
                    cell.selectMarketBtn.addTarget(self, action: #selector(OtherUserProfileVc.walletNetValueTapped), for: .touchUpInside)
                }else{
                    
                    cell.marketNameLbl.text = MARKET.localized
                    
                    cell.seperatorView.isHidden = true
                    
                    cell.marketSymbolWidthConstant.constant = 25
                    
                    
                    if !self.userInfo.markets.isEmpty{
                        
                        if let name = self.userInfo.markets.first?.name{
                            
                            cell.marketValueLbl.text = name
                        }
                        
                        if self.userInfo.markets.count > 1{
                            
                            cell.moreMarketLbl.text = " +\(self.userInfo.markets.count - 1)"
                        }
                    }
                    
                    cell.selectMarketBtn.addTarget(self, action: #selector(OtherUserProfileVc.markrtBtnTapped), for: .touchUpInside)
                }
                return cell
            }
        default:
            fatalError()
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = Bundle.main.loadNibNamed("ProfileHeaderView", owner: self, options: nil)?.first! as! ProfileHeaderView
        
        headerView.dropShadow()
        
        headerView.expectationBtn.addTarget(self, action: #selector(MyProfileVC.expctationBtnTapped), for: .touchUpInside)
        headerView.pendingExpectationBtn.addTarget(self, action: #selector(MyProfileVC.pendingexpctationBtnTapped), for: .touchUpInside)
        headerView.wrongExpectationBtn.addTarget(self, action: #selector(MyProfileVC.wrongExpctationBtnTapped), for: .touchUpInside)
        
        headerView.rightExpectationBtn.addTarget(self, action: #selector(MyProfileVC.rightExpctationBtnTapped), for: .touchUpInside)
        
        if let forecast =  self.userInfo.forecast {
            
            headerView.expectationCountLbl.text = "\(forecast)"
        }
        
        if let pending_forecast = self.userInfo.pending_forecast {
            
            headerView.pendingExpectationCountLbl.text = "\(pending_forecast)"
        }
        
        if let right_forecast =  self.userInfo.right_forecast {
            
            headerView.rightExpectationCountLbl.text = "\(right_forecast)"
        }
        
        if let wrong_forecast =  self.userInfo.wrong_forecast {
            
            headerView.wrongExpectationCountLbl.text = "\(wrong_forecast)"
        }
        
        //		let forecast =  self.userInfo["forecast"]
        //		let forecastCount :Int = forecast as! Int
        //
        //		let right_forecast =  self.userInfo["right_forecast"]
        //		let right_forecastCount :Int = right_forecast as! Int
        //
        //		let wrong_forecast =  self.userInfo["wrong_forecast"]
        //		let wrong_forecastCount :Int = wrong_forecast as! Int
        //
        //		let pending_forecastCount = forecastCount - (right_forecastCount + wrong_forecastCount)
        //
        //		headerView.pendingExpectationCountLbl.text = "\(pending_forecastCount)"
        
        
        return headerView
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 1{
            
            return 64
            
        }else{
            
            return 0
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
        case 0:
            return 500
        case 1:
            if indexPath.row == 0{
                return 125
                
            }else{
                return 44
            }
            
        default:
            return 44
        }
    }
    
    
    //MARK:- =======================================
    //MARK:- target methods
    
    func followingBtnTapped(_ sender: UIButton){
        
        setEvent(eventName: FirebaseEventName.click_on_following, params: ["eventId": self.eventId as NSObject])
        
        let obj = settingsStoryboard.instantiateViewController(withIdentifier: "MyFollowingID") as! MyFollowingVC
        if let id = self.userInfo.user_id{
            obj.userID = id
        }else{
            obj.userID = 0
        }
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    func followersBtnTapped(_ sender: UIButton){
        setEvent(eventName: FirebaseEventName.click_on_follower, params: ["eventId": self.eventId as NSObject])
        
        let obj = settingsStoryboard.instantiateViewController(withIdentifier: "MyFollowersID") as! MyFollowersVC
        if let id = self.userInfo.user_id{
            obj.userID = Int(id)
        }else{
            obj.userID = 0
        }
        self.navigationController?.pushViewController(obj, animated: true)
        
    }
    
    func postsBtnTapped(_ sender: UIButton){
        setEvent(eventName: FirebaseEventName.click_on_post, params: ["eventId": self.eventId as NSObject])
        
        let obj = sideMenuStoryboard.instantiateViewController(withIdentifier: "PostsID") as! PostsVC
        obj.userId = self.userID
        sharedAppdelegate.nvc.pushViewController(obj, animated: true)
    }
    
    
    func backBtnTapped(_ sender: UIButton){
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    func editProfileBtnTapped(_ sender: UIButton){
        setEvent(eventName: FirebaseEventName.edit_profile, params: ["eventId": self.eventId as NSObject])
        
        if let is_following =  self.userInfo.is_following{
            
            if is_following.lowercased() == "yes"{
                self.follow_UnFollow_Friend(EndPoint.unfollowFriendURL)
            }else{
                self.follow_UnFollow_Friend(EndPoint.chooseFriendURL)
            }
        }
    }
    
    func expctationBtnTapped(_ sender: UIButton){
        setEvent(eventName: FirebaseEventName.click_on_forecast, params: ["eventId": self.eventId as NSObject])
        
        let obj = sideMenuStoryboard.instantiateViewController(withIdentifier: "ExpectationID") as! ExpectationVC
        obj.expectationState = .All
        obj.userId = self.userID
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    func pendingexpctationBtnTapped(_ sender: UIButton){
        setEvent(eventName: FirebaseEventName.click_on_pending_forecast, params: ["eventId": self.eventId as NSObject])
        
        let obj = sideMenuStoryboard.instantiateViewController(withIdentifier: "ExpectationID") as! ExpectationVC
        obj.expectationState = .pending
        obj.userId = self.userID
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    func wrongExpctationBtnTapped(_ sender: UIButton){
        setEvent(eventName: FirebaseEventName.click_on_wrong_forecast, params: ["eventId": self.eventId as NSObject])
        
        let obj = sideMenuStoryboard.instantiateViewController(withIdentifier: "ExpectationID") as! ExpectationVC
        obj.expectationState = .Wrong
        obj.userId = self.userID
        self.navigationController?.pushViewController(obj, animated: true)
        
    }
    
    
    func rightExpctationBtnTapped(_ sender: UIButton){
        setEvent(eventName: FirebaseEventName.click_on_right_forecast, params: ["eventId": self.eventId as NSObject])
        
        let obj = sideMenuStoryboard.instantiateViewController(withIdentifier: "ExpectationID") as! ExpectationVC
        obj.expectationState = .Right
        obj.userId = self.userID
        self.navigationController?.pushViewController(obj, animated: true)
        
    }
    
    func profitLostBtnBtnTapped(_ sender: UIButton){
        setEvent(eventName: FirebaseEventName.profit_loss, params: ["eventId": self.eventId as NSObject])
        
        let obj = sideMenuStoryboard.instantiateViewController(withIdentifier: "ExpectationID") as! ExpectationVC
        obj.expectationState = .ProfitLoss
        obj.userId = self.userID
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    func markrtBtnTapped(_ sender: UIButton){
        
        showToastWithMessage(msg: "\(coming_soon.localized)")
        //			let obj = sideMenuStoryboard.instantiateViewController(withIdentifier: "MarketID") as! MarketVC
        //			sharedAppdelegate.nvc.pushViewController(obj, animated: true)
        
        
    }
    
    func notificationBtnTapped(_ sender: UIButton){
        setEvent(eventName: FirebaseEventName.click_on_notificaton, params: ["eventId": self.eventId as NSObject])
        
        self.setNotificationState()
        
    }
    
    
    func commentBtnTapped(_ sender: UIButton){
        
        /*let popUp = sideMenuStoryboard .instantiateViewController(withIdentifier: "MessagesID") as! MessagesVC
         popUp.profileState = .None
         sharedAppdelegate.nvc.pushViewController(popUp, animated: true)*/
        
        //xmppchange
        let vc = AppStoryboard.ChatView.instance.instantiateViewController(withIdentifier: "ChatViewControllerSwift") as! ChatViewControllerSwift
        vc.user_id = CurrentUser.user_id ?? ""
        vc.other_user_id = "\(self.userInfo.user_id!)"
        vc.recieverId = "\(self.userInfo.user_id!)"
        vc.otherUserName = userInfo.name ?? ""
        vc.otherUserProfileImageUrl = userInfo.profile_pic ?? ""
        
        
        _ = self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func donationBtnTapped(_ sender: UIButton) {
        showToastWithMessage(msg: coming_soon.localized)
        setEvent(eventName: FirebaseEventName.click_on_donation, params: ["eventId": self.eventId as NSObject])
        
        //        self.notificationPopupBgView.isHidden = false
        //        self.popUpView.isHidden = true
        //        self.donatePopUpView.isHidden = false
        //        self.donateAmntTextField.text = "\(self.pickOption[0])"
    }
    
    func walletNetValueTapped(_ sender: UIButton) {
        
        //showToastWithMessage(msg: "\(coming_soon.localized)")
        let obj = sideMenuStoryboard.instantiateViewController(withIdentifier: "WalletNetValueID") as! WalletNetValueVC
        obj.userID = "\(self.userID)"
        self.navigationController?.pushViewController(obj, animated: true)
    }
}


extension OtherUserProfileVc : SKPhotoBrowserDelegate {
    
    func createWebPhotos() -> [SKPhotoProtocol] {
        
        let image = self.userInfo.profile_pic ?? ""
        let images: [String] = [image]
        
        return (0..<images.count).map { (i: Int) -> SKPhotoProtocol in
            
            let photo = SKPhoto.photoWithImageURL(image, holder: #imageLiteral(resourceName: "ic_sidemenu_about_us"))
            
            photo.caption = ""
            photo.shouldCachePhotoURLImage = false
            return photo
        }
    }
}


//MARK:- =======================================
//MARK:- Graph datasource


extension OtherUserProfileVc: GKLineGraphDataSource {
    
    
    func numberOfLines() -> Int {
        
        return 2
        
    }
    
    
    func colorForLine(at index: Int) -> UIColor! {
        
        let colourArr = [AppColor.blue, AppColor.appButtonColor]
        
        return colourArr[index]
        
    }
    
    
    func valuesForLine(at index: Int) -> [Any]! {
        
        let lineDrawArr:Array = [self.rightForcast,self.wrongForecast]
        
        return lineDrawArr[index]
    }
    
}

//MARK:- =======================================
//MARK:- picker view delegate and datasource


extension OtherUserProfileVc: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickOption.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString?  {
        let titleData = "SR \(pickOption[row])"
        let myTitle = NSAttributedString.init(string: titleData, attributes: [NSFontAttributeName:UIFont.init(name: "Georgia", size: 15.0)!,NSForegroundColorAttributeName:#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)])
        return myTitle
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        self.selectedAmount = Double(pickOption[row])
        
        self.donateAmntTextField.text = "\(pickOption[row])"
        
    }
    
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat{
        
        return 200
        
    }
    
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat{
        
        return 35
        
    }
}


//MARK:- =======================================
//MARK:- Table view cell classess

class OtherProfileInfoCell: UITableViewCell {
    
    //MARK:- ==========================================================
    //MARK:- IBOutlets
    
    @IBOutlet weak var navigationTitleLbl: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var imageBtn: UIButton!
    @IBOutlet weak var nameRatingBgView: UIView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var joineddateLbl: UILabel!
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var bioLbl: UILabel!
    @IBOutlet weak var rateLbl: UILabel!
    @IBOutlet weak var followFollowersBgView: UIView!
    @IBOutlet weak var followingCountLbl: UILabel!
    @IBOutlet weak var followingLbl: UILabel!
    @IBOutlet weak var followingBtn: UIButton!
    @IBOutlet weak var pointsCountLbl: UILabel!
    @IBOutlet weak var pointsLbl: UILabel!
    @IBOutlet weak var pointsBtn: UIButton!
    @IBOutlet weak var followersCountLbl: UILabel!
    @IBOutlet weak var followersLbl: UILabel!
    @IBOutlet weak var followerBtn: UIButton!
    //    @IBOutlet weak var editBtnWidthConstant: NSLayoutConstraint!
    @IBOutlet weak var followBtn: UIButton!
    
    @IBOutlet weak var msgBtn: UIButton!
    @IBOutlet weak var donateBtn: UIButton!
    
    @IBOutlet weak var notificationBtn: UIButton!
    @IBOutlet weak var floatingRatingView: FloatRatingView!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        self.navigationTitleLbl.font = setNavigationTitleFont()
        self.navigationTitleLbl.font = setNavigationTitleFont()
        self.navigationTitleLbl.text = USER_PROFILE.localized
        self.followingLbl.text = FOLLOWING.localized
        self.followersLbl.text = FOLLOWERS.localized
        self.pointsLbl.text = POSTS.localized
        self.donateBtn.setTitle(DONATE.localized, for: .normal)
        self.followBtn.setTitle("", for: .normal)
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    
    
    
    func setUserInfo(userInfo: ProfileModel){
        self.userImage.layer.cornerRadius = 25
        self.userImage.layer.masksToBounds = true
        self.backBtn.rotateBackImage()
        
        if let name = userInfo.name{
            self.userName.text = name
        }
        if let created_at = userInfo.created_at{
            self.joineddateLbl.text = "\(JOINED.localized): \(created_at)"
        }
        if let follower = userInfo.follower{
            self.followersCountLbl.text = "\(follower)"
        }
        if let following = userInfo.following{
            self.followingCountLbl.text = "\(following)"
        }
        if let post = userInfo.post{
            self.pointsCountLbl.text = "\(post)"
        }
        if let designation = userInfo.designation{
            self.bioLbl.text = "\(designation)"
        }
        if let rating = userInfo.rating{
            setRating(rating: rating )
        }
        if let img = userInfo.profile_pic{
            let imageUrl = URL(string: img)
            self.userImage.sd_setImage(with: imageUrl, placeholderImage: #imageLiteral(resourceName: "ic_following_placeholder"))
        }
        
        if let is_notification_on = userInfo.is_notification_on{
            
            
            if is_notification_on == "off"{
                
                self.notificationBtn.setImage(UIImage(named:"ic_user_profile_chat_bell_deselect"), for: UIControlState.normal)
                
            }else{
                
                self.notificationBtn.setImage(UIImage(named:"ic_user_profile_chat_bell_select"), for: UIControlState.normal)
                
            }
        }
        if let is_following = userInfo.is_following{
            
            if is_following.lowercased() == "yes"{
                
                //self.followBtn.setImage(UIImage(named: "ic_following_tick"), for: UIControlState.normal)
                self.followBtn.setTitle(UNFOLLOW.localized, for: UIControlState.normal)
                self.notificationBtn.isEnabled = true
                
            }else{
                
                self.followBtn.setImage(UIImage(named: ""), for: UIControlState.normal)
                self.followBtn.setTitle(FOLLOW.localized, for: UIControlState.normal)
                self.notificationBtn.isEnabled = false
                self.notificationBtn.setImage(UIImage(named:"ic_user_profile_chat_bell_deselect"), for: UIControlState.normal)
                
            }
        }
    }
    
    
    func setRating(rating: Float){
        
        self.floatingRatingView.rating = rating
        self.rateLbl.text = "\(rating)"
        
    }
    
}

class OtherProfitLostCell: UITableViewCell {
    
    @IBOutlet weak var statusForwardArrow: UIImageView!
    @IBOutlet weak var graphView: GKLineGraph!
    @IBOutlet weak var profitlostBtn: UIButton!
    @IBOutlet weak var profitlostLbl: UILabel!
    @IBOutlet weak var profitlLostValue: UILabel!
    @IBOutlet weak var forwordArrowImg: UIImageView!
    @IBOutlet weak var statusOfExpectView: UIView!
    @IBOutlet weak var upDownArrowIng: UIImageView!
    @IBOutlet weak var expectValueLbl: UILabel!
    @IBOutlet weak var statusOfExpectLbl: UILabel!
    @IBOutlet weak var seperatorView: UIView!
    @IBOutlet weak var graphImg: UIImageView!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        self.selectionStyle = .none
        self.graphView.lineWidth = 2.0
        self.graphView.margin = 0.0
        self.profitlostLbl.text = PROFIT_AND_LOST.localized
        self.statusOfExpectLbl.text = STATUS_OF_FORECAST.localized
        self.expectValueLbl.text = "0%"
        
        
        if sharedAppdelegate.appLanguage == .Arabic
        {
            self.forwordArrowImg.image = #imageLiteral(resourceName: "ic_settings_backarrow")
            self.statusForwardArrow.image = #imageLiteral(resourceName: "ic_settings_backarrow")
            
        }else{
            
            self.forwordArrowImg.image = #imageLiteral(resourceName: "ic_settings_nextarrow")
            self.statusForwardArrow.image = #imageLiteral(resourceName: "ic_settings_nextarrow")
            
        }
    }
}



