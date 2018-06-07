//
//  LeftSlideMenuVC.swift
//  Mutadawel
//
//  Created by Appinventiv on 10/02/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit



class LeftSlideMenuVC: MutadawelBaseVC {
    
    @IBOutlet weak var lefiSidePenalTableView: UITableView!
    
    let optionArray = ["",HOME.localized,PROFILE.localized,PRICE_INDICATOR.localized,WALLET.localized,SETTINGS.localized,CONTACT_US.localized,ABOUT_US.localized,SUPPORT.localized,SIGN_OUT.localized]
    let eventArray = [FirebaseEventName.profile,FirebaseEventName.home,FirebaseEventName.profile,FirebaseEventName.price_indicator,FirebaseEventName.wallet,FirebaseEventName.setting,FirebaseEventName.contact_us,FirebaseEventName.about_us,FirebaseEventName.help,FirebaseEventName.sign_out]
    let optionImgArray = ["","ic_sidemenu_home","ic_sidemenu_profile","ic_sidemenu_price_indicator","ic_sidemenu_wallet","ic_sidemenu_settings","ic_sidemenu_contact_us","ic_sidemenu_about_us","ic_sidemenu_support","ic_sidemenu_signout"]
    
    let eventId = "sidemenue"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialViewStup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.lefiSidePenalTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func initialViewStup(){
        
        self.lefiSidePenalTableView.delegate = self
        self.lefiSidePenalTableView.dataSource = self
        self.lefiSidePenalTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }
    
    func showAlert(){
        
        let alert = UIAlertController(title: "", message: LogOut.localized, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: No.localized, style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: Yes.localized, style: .default, handler: { (UIAlertAction) in
            self.logOut()
            setEvent(eventName: FirebaseEventName.yes, params: ["eventId": "sign out" as NSObject])
            
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    func logOut(){
        
        
        var params = JSONDictionary()
        
        params["userId"] = CurrentUser.user_id
        
        if sharedAppdelegate.deviceToken != nil{
            
            params["device_token"] = sharedAppdelegate.deviceToken!
            
        }else{
            
            params["device_token"] = "12345" 
        }
        
        params["device_id"] = UIDevice.current.identifierForVendor?.uuidString
        
        showLoader()
        
        logOutAPI(params: params) { (success, msg, data) in
            
            hideLoader()
            if success{
                XMPPhelper.sharedInstance().disconnect()
                cleaeUserDefault()
                goToLoginOption()
                
            }else{
                XMPPhelper.sharedInstance().disconnect()
                cleaeUserDefault()
                goToLoginOption()
                
            }
        }
        
    }
    
}


//MARK:- ================================================
//MARK:- UItable view delegate and datasource

extension LeftSlideMenuVC: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 200
            
        }else{
            return 44
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SlideMenuUserDetailCell", for: indexPath) as! SlideMenuUserDetailCell
            
            cell.setLayout()
            if let rate = CurrentUser.rating, !rate.isEmpty{
                cell.setRating(rating: Float(rate)!)
            }
            return cell
            
        }else{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuOptionCell", for: indexPath) as! SideMenuOptionCell
            cell.optionNameLbl.text = self.optionArray[indexPath.row]
            cell.symbolImg.image = UIImage(named: self.optionImgArray[indexPath.row])
            return cell
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        switch indexPath.row{
            
        case 0:
            let obj = sideMenuStoryboard.instantiateViewController(withIdentifier: "MyProfileID") as! MyProfileVC
            obj.profileState = .SideMenu
            self.closeSlideMenu()
            setEvent(eventName: FirebaseEventName.profile, params: ["eventId": self.eventId as NSObject])
            sharedAppdelegate.nvc.pushViewController(obj, animated: true)
            
        case 1:
            
            let obj = homeStoryboard.instantiateViewController(withIdentifier: "HomeID") as! HomeVC
            self.closeSlideMenu()
            setEvent(eventName: FirebaseEventName.home, params: ["eventId": self.eventId as NSObject])
            
            gotoFromSideMenu(mainViewController: obj)
            
        case 2:
            setEvent(eventName: FirebaseEventName.profile, params: ["eventId": self.eventId as NSObject])
            
            let obj = sideMenuStoryboard.instantiateViewController(withIdentifier: "MyProfileID") as! MyProfileVC
            obj.profileState = .SideMenu
            self.closeSlideMenu()
            sharedAppdelegate.nvc.pushViewController(obj, animated: true)
        case 3:
            let obj = sideMenuStoryboard.instantiateViewController(withIdentifier: "PriceIndicatorID") as! PriceIndicatorVC
            self.closeSlideMenu()
            setEvent(eventName: FirebaseEventName.price_indicator, params: ["eventId": self.eventId as NSObject])
            
            gotoFromSideMenu(mainViewController: obj)
            
        case 4:
            let obj = sideMenuStoryboard.instantiateViewController(withIdentifier: "SubscriptionID") as! SubscriptionVC
            obj.sideMenuState = .SideMenu
            self.closeSlideMenu()
            setEvent(eventName: FirebaseEventName.wallet, params: ["eventId": self.eventId as NSObject])
            
            sharedAppdelegate.nvc.pushViewController(obj, animated: true)
            
        case 5:
            let obj = settingsStoryboard.instantiateViewController(withIdentifier: "SettingsID") as! SettingsVC
            gotoFromSideMenu(mainViewController: obj)
            setEvent(eventName: FirebaseEventName.setting, params: ["eventId": self.eventId as NSObject])
            
            
        case 6:
            let obj = sideMenuStoryboard.instantiateViewController(withIdentifier: "ContactUsID") as! ContactUsVC
            obj.sideMenuState = .SideMenu
            obj.contactState = .Contact
            setEvent(eventName: FirebaseEventName.contact_us, params: ["eventId": self.eventId as NSObject])
            gotoFromSideMenu(mainViewController: obj)
            
        case 7:
            let obj = sideMenuStoryboard.instantiateViewController(withIdentifier: "AboutUsID") as! AboutUsVC
            gotoFromSideMenu(mainViewController: obj)
            setEvent(eventName: FirebaseEventName.about_us, params: ["eventId": self.eventId as NSObject])
            
            
        case 8:
            let obj = sideMenuStoryboard.instantiateViewController(withIdentifier: "ContactUsID") as! ContactUsVC
            obj.sideMenuState = .SideMenu
            setEvent(eventName: FirebaseEventName.help, params: ["eventId": self.eventId as NSObject])
            
            obj.contactState = .Support
            gotoFromSideMenu(mainViewController: obj)
            
        case 9:
            self.showAlert()
            setEvent(eventName: FirebaseEventName.sign_out, params: ["eventId": self.eventId as NSObject])
            
            
        default:
            print_debug(object: "")
            
        }
    }
    
    func closeSlideMenu(){
        if sharedAppdelegate.appLanguage == .English{
            closeLeft()
        }else{
            closeRight()
        }
    }
    
}


//MARK:- ==============================
//MARK:- cell clasess

class SlideMenuUserDetailCell: UITableViewCell {
    
    @IBOutlet weak var backGroundImg: UIImageView!
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    
    
    @IBOutlet weak var floatRatingView: FloatRatingView!
    @IBOutlet weak var rateLbl: UILabel!
    @IBOutlet weak var rateViewWidthConstant: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.userImg.layer.cornerRadius = self.userImg.frame.width/2
        self.userImg.layer.masksToBounds = true
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    
    func setLayout(){
        
        self.userImg.layer.cornerRadius = 45/2
        self.userImg.layer.masksToBounds = true
        
        if CurrentUser.name != nil{
            
            self.userNameLbl.text = CurrentUser.name!
            
        }
        
        if CurrentUser.profile_pic != nil{
            
            let imageUrl = URL(string: CurrentUser.profile_pic!)
            print_debug(object: imageUrl)
            self.userImg.sd_setImage(with: imageUrl, placeholderImage: #imageLiteral(resourceName: "ic_profile_placeholder"))
            print_debug(object: imageUrl)
            
        }
        
    }
    
    
    
    func setRating(rating: Float){
        
        //      self.floatRatingView.rating = rating
        self.floatRatingView.maxRating = 1
        self.rateLbl.text = "\(rating)"
        
        
        switch rating{
            
        case 0..<1:
            
            self.rateViewWidthConstant.constant = 16
            self.floatRatingView.maxRating = 1
            
            
        case 1:
            self.rateViewWidthConstant.constant = 16
            self.floatRatingView.maxRating = 1
            
        case (1.1)..<2:
            self.rateViewWidthConstant.constant = 16
            self.floatRatingView.maxRating = 1
            
        case 2:
            self.rateViewWidthConstant.constant = 32
            self.floatRatingView.maxRating = 2
            
        case (2.1)..<3:
            self.rateViewWidthConstant.constant = 32
            self.floatRatingView.maxRating = 2
            
        case 3:
            self.rateViewWidthConstant.constant = 48
            self.floatRatingView.maxRating = 3
            
        case (3.1)..<4:
            self.rateViewWidthConstant.constant = 48
            self.floatRatingView.maxRating = 3
            
        case 4:
            self.rateViewWidthConstant.constant = 64
            self.floatRatingView.maxRating = 4
            
        case (4.1)..<5:
            self.rateViewWidthConstant.constant = 64
            self.floatRatingView.maxRating = 4
            
        case 5:
            self.rateViewWidthConstant.constant = 80
            self.floatRatingView.maxRating = 5
            
        default: print_debug(object: "nothing")
        }
    }
    
    
}

class SideMenuOptionCell: UITableViewCell {
    @IBOutlet weak var symbolImg: UIImageView!
    @IBOutlet weak var optionNameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
