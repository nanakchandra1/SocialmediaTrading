//
//  NotificationVC.swift
//  Mutadawel
//
//  Created by Appinventiv on 10/02/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit
import SwiftyJSON

class NotificationVC: MutadawelBaseVC {
    
    //MARK:- IBOUTlets
    //MARK:- ==================================
    
    @IBOutlet weak var notificationTableView: UITableView!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var navigationTitle: UILabel!
    
    //MARK:- Properties
    //MARK:- ==================================
    
    var notificatinList  = JSONArray()
    
    var refreshControl = UIRefreshControl()
    
    var postDetail = JSONDictionary()
    
    var isPush = false
    
    
    //MARK:- View life cycles
    //MARK:- ==================================
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.initialViewStup()
        
    }
    
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
    }
    
    
    //MARK:- Private methods
    //MARK:- ==================================
    
    
    func initialViewStup(){
        
        readNotificationAPI(params: ["userId":CurrentUser.user_id])
        userDefaults.removeObject(forKey: UserDefaultsKeys.notification_count)
        self.navigationTitle.text = NOTIFICATIONS.localized
        self.navigationTitle.font = setNavigationTitleFont()
        self.navigationView.backgroundColor = AppColor.navigationBarColor
        self.notificationTableView.delegate = self
        self.notificationTableView.dataSource = self
        self.refreshControl.attributedTitle = NSAttributedString(string: "")
        self.notificationTableView.estimatedRowHeight = 50
        self.refreshControl.addTarget(self, action: #selector(NotificationVC.getNotificationList), for: UIControlEvents.valueChanged)
        
        self.notificationTableView?.addSubview(refreshControl)
        
        self.getNotificationList()
        
        if self.isPush{
            
            self.getForecastDetail(index: nil)
            
        }else{
            
            if let userId = self.postDetail["user_id"] as? Int{
                
                let popUp = sideMenuStoryboard.instantiateViewController(withIdentifier: "OtherUserProfileVc") as! OtherUserProfileVc
                
                popUp.userID = userId
                
                sharedAppdelegate.nvc.pushViewController(popUp, animated: true)
                
            }
        }
        
        if self.isPush{
            
            self.backBtn.setImage(ButtonImg.burgerBtn, for: UIControlState.normal)
        }else{
            
            self.backBtn.rotateBackImage()
        }
    }
    
	
	
    func getNotificationList(){
        
        var params = JSONDictionary()
        params["userId"] = CurrentUser.user_id!
        
        showLoader()
        self.refreshControl.endRefreshing()
        
        notificationListAPI(params: params) { (success, msg, data) in
            
            print_debug(object: data)
            
            hideLoader()
            
            if success{
                
                self.notificatinList = data!
                
            }else{
                
                showToastWithMessage(msg: msg)
                
            }
            
            self.notificationTableView.reloadData()
            
            print_debug(object: data)
            
        }
    }
    
    
    func getForecastDetail(index: Int?){
        
        var params = JSONDictionary()
        
        params["myId"] = CurrentUser.user_id
        
        if index != nil{
            
            let user_id = self.notificatinList[index!]["user_id"].stringValue
            let postId = self.notificatinList[index!]["forecast_id"].stringValue
            params["userId"] = user_id as AnyObject
            params["postId"] = postId as AnyObject

        }else{
            
            if let user_id = self.postDetail["user_id"]{
                
                params["userId"] = user_id as AnyObject
                
            }
            
            if let postId = self.postDetail["post_id"]{
                
                params["postId"] = postId as AnyObject
                
            }
            
        }
        self.forecastDetail(params: params)
        
    }
    
    
    func forecastDetail(params: JSONDictionary){
        
        postDetailAPI(params: params) { (success, msg, data) in
            
            if success{
                
                let postDtail = ForecastPostDetailModel(with: data!)
                
                switch postDtail.post_type {
                    
                case Status.one:
                    
                    let popUp = postDetailStoryboard.instantiateViewController(withIdentifier: "GeneralPostID") as! GeneralPostVC
                    
                    popUp.info = postDtail
                    
                    popUp.postDetailType = .Notification
                    
                    popUp.modalPresentationStyle = .overCurrentContext

                    sharedAppdelegate.nvc.pushViewController(popUp, animated: true)
                    
                case Status.two:
                    
                    let popUp = postDetailStoryboard.instantiateViewController(withIdentifier: "ForecastStockID") as! ForecastStockVC
                    popUp.info = postDtail
                    popUp.postDetailType = .Notification
                    popUp.modalPresentationStyle = .overCurrentContext
                    sharedAppdelegate.nvc.pushViewController(popUp, animated: true)
                    
                case Status.three:
                    let popUp = postDetailStoryboard.instantiateViewController(withIdentifier: "ForecastForexID") as! ForecastForexVC
                    popUp.info = postDtail
                    popUp.postDetailType = .Notification
                    popUp.modalPresentationStyle = .overCurrentContext
                    sharedAppdelegate.nvc.pushViewController(popUp, animated: true)
                    
                case Status.four:
                    
                    let popUp = postDetailStoryboard.instantiateViewController(withIdentifier: "ConditionStockID") as! ConditionStockVC
                    popUp.info = postDtail
                    popUp.postDetailType = .Notification
                    popUp.modalPresentationStyle = .overCurrentContext
                    sharedAppdelegate.nvc.pushViewController(popUp, animated: true)
                    
                case Status.five:
                    
                    let popUp = postDetailStoryboard.instantiateViewController(withIdentifier: "ConditionForecastForexID") as! ConditionForecastForexVC
                    popUp.info = postDtail
                    popUp.postDetailType = .Notification
                    popUp.modalPresentationStyle = .overCurrentContext
                    sharedAppdelegate.nvc.pushViewController(popUp, animated: true)
                    
                default:
                    fatalError()
                }
            }
        }
    }
    
    
    //MARK:- IBActions
    //MARK:- ==================================
    
    @IBAction func backBtnTappe(_ sender: UIButton) {
        
        if sharedAppdelegate.appLanguage == .English{
            if self.isPush{
                
                openLeft()
                
            }else{
                
                sharedAppdelegate.nvc.popViewController(animated: true)
            }
            
        }else{
            
            if self.isPush{
                
                openRight()
                
            }else{
                
                sharedAppdelegate.nvc.popViewController(animated: true)
            }
            
        }
    }
}



//MARK:- ================================================
//MARK:- UItable view delegate and datasource

extension NotificationVC: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.notificatinList.count
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as! NotificationCell
        
        cell.populateData(info: self.notificatinList[indexPath.row])
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
            let postId = self.notificatinList[indexPath.row]["forecast_id"].stringValue
            if postId == Status.zero{
                
                let userId = self.notificatinList[indexPath.row]["user_id"].intValue
                
                    if userId == currentUserId(){
                        
                        let popUp = sideMenuStoryboard.instantiateViewController(withIdentifier: "MyProfileID") as! MyProfileVC
                        
                        sharedAppdelegate.nvc.pushViewController(popUp, animated: true)

                    }else{
                        
                        let popUp = sideMenuStoryboard.instantiateViewController(withIdentifier: "OtherUserProfileVc") as! OtherUserProfileVc
                        
                        popUp.userID = userId
                        
                        sharedAppdelegate.nvc.pushViewController(popUp, animated: true)

                    }
                
            }else{
                self.getForecastDetail(index: indexPath.row)
            }
    }
}


//MARK:- TableviewCell Classess
//MARK:- ==================================


class NotificationCell: UITableViewCell {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var eventLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.userNameLbl.text = USER_NAME.localized
        self.userImg.layer.cornerRadius = 20
        self.userImg.layer.masksToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    
    func populateData(info: JSON){
        
            self.userNameLbl.text = info["user_name"].stringValue
            self.eventLbl.text = info["event"].stringValue
            self.descriptionLbl.text = info["message"].stringValue
            self.timeLbl.text = setDateFormate(dateString: info["created_date"].stringValue)
        
        if let img = info["profile_pic"].string{
            let imageUrl = URL(string: img)
            self.userImg.sd_setImage(with: imageUrl, placeholderImage: #imageLiteral(resourceName: "ic_following_placeholder"))
        }
    }
    
}
