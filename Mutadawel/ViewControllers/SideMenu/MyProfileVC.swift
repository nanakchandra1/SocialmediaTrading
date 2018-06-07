//
//  MyProfileVC.swift
//  Mutadawel
//
//  Created by Appinventiv on 10/02/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit
import GraphKit
import SDWebImage
import SKPhotoBrowser

enum ProfileState{
    case SideMenu,None
}

class MyProfileVC: MutadawelBaseVC {
    
    //MARK:- =========================================
    //MARK:- IBOutlets
    
    @IBOutlet weak var myProfileTableView: UITableView!
    @IBOutlet weak var addMoreMoneyBgView: UIView!
    @IBOutlet weak var addMoneyPopUpView: UIView!
    @IBOutlet weak var addMoreMoneyLbl: UILabel!
    @IBOutlet weak var payToLbl: UILabel!
    @IBOutlet weak var paidAmountLbl: SkyFloatingLabelTextField!
    @IBOutlet weak var showAmntLbl: UILabel!
    @IBOutlet weak var payMentBtn: UIButton!
    @IBOutlet weak var downArrow: UIImageView!
    
    //MARK:- =========================================
    //MARK:- Properties
    
    
    var profileState = ProfileState.None
    var isFollow = false
    var userInfo = ProfileModel()
    var rightForcast = [Any]()
    var wrongForecast = [Any]()
    let eventId = "my profile"
    
    
    //MARK:- =========================================
    //MARK:- View life cycle methods
    
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
        self.myProfileTableView.reloadData()
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
    
    
    
    //MARK:- =========================================
    //MARK:- Private methods
    
    fileprivate func initialViewStup(){
        
        self.myProfileTableView.delegate = self
        self.myProfileTableView.dataSource = self
        self.addMoreMoneyBgView.isHidden = true
        
        if sharedAppdelegate.appLanguage == .Arabic{
            
            self.paidAmountLbl.textAlignment = .right
            
        }else{
            
            self.paidAmountLbl.textAlignment = .left
            
        }
        
        self.getUSerInfo()
        self.myProfileTableView.register(UINib(nibName: "ProfileMarketCell", bundle: nil), forCellReuseIdentifier: "ProfileMarketCell")
    }
    
    func viewImageInMultipleImageViewer() {
        guard let pic = self.userInfo.profile_pic, !pic.isEmpty else{return}
        
        let browser = SKPhotoBrowser(photos: createWebPhotos())
        browser.initializePageIndex(0)
        browser.delegate = self
        
        present(browser, animated: true, completion: nil)
        
    }
    
    
    fileprivate func getUSerInfo(){
        
        var params = JSONDictionary()
        params["userId"] = CurrentUser.user_id!
        myProfileAPI(params: params) { (success, msg, data) in
            print_debug(object: data)
            if success{
                self.userInfo = ProfileModel(withData: data!)
                _ = UserData(withJson: data!)
            }else{
                showToastWithMessage(msg: msg)
            }
            self.myProfileTableView.reloadData()
        }
    }
    
    
    //MARK:- =========================================
    //MARK:- IBActions
    
    
    @IBAction func editProfileBtntap(_ sender: UIButton) {
        setEvent(eventName: FirebaseEventName.edit_profile, params: ["eventId": self.eventId as NSObject])
        
        let obj = sideMenuStoryboard.instantiateViewController(withIdentifier: "EditProfileID") as! EditProfileVc
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    @IBAction func walletBtnTap(_ sender: UIButton) {
        setEvent(eventName: FirebaseEventName.wallet, params: ["eventId": self.eventId as NSObject])
        
        let obj = sideMenuStoryboard.instantiateViewController(withIdentifier: "SubscriptionID") as! SubscriptionVC
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    
    @IBAction func statusBtnTap(_ sender: UIButton) {
        setEvent(eventName: FirebaseEventName.status_forecast, params: ["eventId": self.eventId as NSObject])
        
        let obj = sideMenuStoryboard.instantiateViewController(withIdentifier: "StatusOfExpectationVc") as! StatusOfExpectationVc
        obj.userId = currentUserId()
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    //    @IBAction func paymentBtnTapped(_ sender: UIButton) {
    //
    //        self.addMoreMoneyBgView.isHidden = true
    //    }
}


//MARK:- =========================================
//MARK:- Tableview delegate and datasource

extension MyProfileVC: UITableViewDelegate,UITableViewDataSource{
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
            
        }else{
            return 4
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyProfileInfoCell", for: indexPath) as! MyProfileInfoCell
            cell.setLayout(profileState: self.profileState)
            cell.imageBtn.addTarget(self, action: #selector(MyProfileVC.viewImageInMultipleImageViewer), for: .touchUpInside)
            
            cell.followersBtn.addTarget(self, action: #selector(MyProfileVC.followersBtnTapped), for: .touchUpInside)
            cell.followingBtn.addTarget(self, action: #selector(MyProfileVC.followingBtnTapped), for: .touchUpInside)
            cell.pointsBtn.addTarget(self, action: #selector(MyProfileVC.postsBtnTapped), for: .touchUpInside)
            cell.editProfileBtn.addTarget(self, action: #selector(MyProfileVC.editProfileBtnTapped), for: .touchUpInside)
            cell.backBtn.addTarget(self, action: #selector(MyProfileVC.backBtnTapped), for: .touchUpInside)
            cell.editProfileBtn.layer.cornerRadius = 2
            
            //          cell..layer.cornerRadius = 2
            cell.editProfileBtn.setTitle(EDIT_PROFILE.localized, for: UIControlState.normal)
            cell.navigationTitleLbl.text = MY_PROFILE.localized
            return cell
            
        case 1:
            
            if indexPath.row == 0{
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "ProfitLostCell", for: indexPath) as! ProfitLostCell
                cell.graphView.dataSource = self
                cell.graphView.isHidden = false
                cell.graphView.draw()
                cell.graphView.reset()
                cell.graphView.draw()
                
                self.rightForcast = self.userInfo.right ?? []
                
                self.wrongForecast = self.userInfo.wrong ?? []
                
                cell.seperetorView.isHidden = false
                cell.profitlostBtn.addTarget(self, action: #selector(MyProfileVC.profitLostBtnBtnTapped), for: .touchUpInside)
                cell.statusOfExpectLbl.isHidden = false
                cell.expectValueLbl.isHidden = false
                cell.expextSepView.isHidden = false
                cell.profitlostLbl.text = PROFIT_AND_LOST.localized
                if CurrentUser.profit_loss != nil{
                    let profit = Double(CurrentUser.profit_loss!)
                    cell.profitlLostValue.text = "\(profit!)%"
                }
                
                if let status = self.userInfo.forecast_status_precent{
                    
                    cell.expectValueLbl.text = "\(status.roundTo(places: 4))%"
                    
                    if status < 0{
                        
                        cell.statusExpectUpDownImg.image = #imageLiteral(resourceName: "ic_home_downarrow")
                    }else{
                        
                        cell.statusExpectUpDownImg.image = #imageLiteral(resourceName: "ic_home_uparrow")
                    }
                    
                }
                
                return cell
                
            }else if indexPath.row == 3{
                let cell = tableView.dequeueReusableCell(withIdentifier: "UpgradeAccCell", for: indexPath) as! UpgradeAccCell
                cell.upgradeAccBtn.addTarget(self, action: #selector(MyProfileVC.upgradeAccBtnTapped), for: .touchUpInside)
                
                return cell
                
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileMarketCell", for: indexPath) as! ProfileMarketCell
                cell.selectMarketBtn.addTarget(self, action: #selector(MyProfileVC.markrtBtnTapped), for: .touchUpInside)
                if indexPath.row == 1{
                    cell.marketNameLbl.text = WALLET_NET_VALUE.localized
                    if CurrentUser.net_value != nil{
                        cell.marketValueLbl.text = "SR \(CurrentUser.net_value!)"
                    }
                    cell.seperatorView.isHidden = false
                    cell.marketSymbolWidthConstant.constant = 0
                    cell.moreMarketLbl.text = ""
                    
                }else{
                    cell.marketNameLbl.text = CHOOSE_MARKET.localized
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
                }
                return cell
            }        default:
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
            return 462
        case 1:
            if indexPath.row == 0{
                return 125
                
            }else{
                return 50
            }
            
        default:
            return 50
        }
    }
    
    
    //MARK:- =========================================
    //MARK:- Target methods
    
    func backBtnTapped(_ sender: UIButton){
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    // following list
    
    func followingBtnTapped(_ sender: UIButton){
        setEvent(eventName: FirebaseEventName.click_on_following, params: ["eventId": self.eventId as NSObject])
        
        let obj = settingsStoryboard.instantiateViewController(withIdentifier: "MyFollowingID") as! MyFollowingVC
        obj.userID = currentUserId()
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    // followers list
    
    func followersBtnTapped(_ sender: UIButton){
        setEvent(eventName: FirebaseEventName.click_on_follower, params: ["eventId": self.eventId as NSObject])
        
        let obj = settingsStoryboard.instantiateViewController(withIdentifier: "MyFollowersID") as! MyFollowersVC
        obj.userID = currentUserId()
        self.navigationController?.pushViewController(obj, animated: true)
        
    }
    
    // post list
    
    func postsBtnTapped(_ sender: UIButton){
        setEvent(eventName: FirebaseEventName.click_on_post, params: ["eventId": self.eventId as NSObject])
        
        let expectScene = sideMenuStoryboard.instantiateViewController(withIdentifier: "PostsID") as! PostsVC
        expectScene.userId = currentUserId()
        self.navigationController?.pushViewController(expectScene, animated: true)
        
    }
    
    // edit profile
    
    func editProfileBtnTapped(_ sender: UIButton){
        
        self.isFollow = !self.isFollow
        setEvent(eventName: FirebaseEventName.edit_profile, params: ["eventId": self.eventId as NSObject])
        
        self.myProfileTableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: UITableViewRowAnimation.none)
    }
    
    
    // account info
    
    func upgradeAccBtnTapped(_ sender: UIButton){
        setEvent(eventName: FirebaseEventName.account_information, params: ["eventId": self.eventId as NSObject])
        
        self.addMoreMoneyBgView.isHidden = true
        let payPalPage = sideMenuStoryboard.instantiateViewController(withIdentifier: "PayPalInformationID") as! PayPalInformationVC
        self.navigationController?.pushViewController(payPalPage, animated: true)
    }
    
    
    // forecast list
    
    func expctationBtnTapped(_ sender: UIButton){
        setEvent(eventName: FirebaseEventName.click_on_forecast, params: ["eventId": self.eventId as NSObject])
        
        let expectScene = sideMenuStoryboard.instantiateViewController(withIdentifier: "ExpectationID") as! ExpectationVC
        expectScene.expectationState = .All
        expectScene.userId = currentUserId()
        self.navigationController?.pushViewController(expectScene, animated: true)
    }
    
    // pending forecast list
    
    func pendingexpctationBtnTapped(_ sender: UIButton){
        setEvent(eventName: FirebaseEventName.click_on_pending_forecast, params: ["eventId": self.eventId as NSObject])
        
        let expectScene = sideMenuStoryboard.instantiateViewController(withIdentifier: "ExpectationID") as! ExpectationVC
        expectScene.expectationState = .pending
        expectScene.userId = currentUserId()
        self.navigationController?.pushViewController(expectScene, animated: true)
    }
    
    // wrong forecast list
    
    func wrongExpctationBtnTapped(_ sender: UIButton){
        setEvent(eventName: FirebaseEventName.click_on_wrong_forecast, params: ["eventId": self.eventId as NSObject])
        
        let expectScene = sideMenuStoryboard.instantiateViewController(withIdentifier: "ExpectationID") as! ExpectationVC
        expectScene.expectationState = .Wrong
        expectScene.userId = currentUserId()
        self.navigationController?.pushViewController(expectScene, animated: true)
    }
    
    
    // right forecast list
    
    
    func rightExpctationBtnTapped(_ sender: UIButton){
        setEvent(eventName: FirebaseEventName.click_on_right_forecast, params: ["eventId": self.eventId as NSObject])
        
        let expectScene = sideMenuStoryboard.instantiateViewController(withIdentifier: "ExpectationID") as! ExpectationVC
        expectScene.expectationState = .Right
        expectScene.userId = currentUserId()
        self.navigationController?.pushViewController(expectScene, animated: true)
        
    }
    
    // profit loss list
    
    func profitLostBtnBtnTapped(_ sender: UIButton){
        setEvent(eventName: FirebaseEventName.profit_loss, params: ["eventId": self.eventId as NSObject])
        
        let expectScene = sideMenuStoryboard.instantiateViewController(withIdentifier: "ExpectationID") as! ExpectationVC
        expectScene.expectationState = .ProfitLoss
        expectScene.userId = currentUserId()
        self.navigationController?.pushViewController(expectScene, animated: true)
    }
    
    
    // market list
    
    func markrtBtnTapped(_ sender: UIButton){
        setEvent(eventName: FirebaseEventName.choose_market, params: ["eventId": self.eventId as NSObject])
        
        guard let indexPath = sender.tableViewIndexPath(tableView: self.myProfileTableView) else{return}
        if indexPath.row == 1{
            
            //	showToastWithMessage(msg: "\(coming_soon.localized)")
            
            let obj = sideMenuStoryboard.instantiateViewController(withIdentifier: "SubscriptionID") as! SubscriptionVC
            sharedAppdelegate.nvc.pushViewController(obj, animated: true)
            
        }else{
            
            showToastWithMessage(msg: "\(coming_soon.localized)")
            
            //            let obj = preLoginStoryboard.instantiateViewController(withIdentifier: "MarketID") as! MarketVC
            //            sharedAppdelegate.nvc.pushViewController(obj, animated: true)
        }
    }
}


extension MyProfileVC : SKPhotoBrowserDelegate {
    
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


//MARK:- =========================================
//MARK:- Graph datasource methods

extension MyProfileVC: GKLineGraphDataSource {
    
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


//MARK:- =========================================
//MARK:- Tableview cell classess

class MyProfileInfoCell: UITableViewCell {
    
    //MARK:- ==========================================================
    //MARK:- IBOutlets
    
    @IBOutlet weak var navigationTitleLbl: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var nameRatingBgView: UIView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var joineddateLbl: UILabel!
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var rateLbl: UILabel!
    @IBOutlet weak var followFollowersBgView: UIView!
    @IBOutlet weak var imageBtn: UIButton!
    @IBOutlet weak var followingCountLbl: UILabel!
    @IBOutlet weak var followingLbl: UILabel!
    @IBOutlet weak var followingBtn: UIButton!
    @IBOutlet weak var pointsCountLbl: UILabel!
    @IBOutlet weak var pointsLbl: UILabel!
    @IBOutlet weak var pointsBtn: UIButton!
    @IBOutlet weak var followersCountLbl: UILabel!
    @IBOutlet weak var followersLbl: UILabel!
    @IBOutlet weak var bioLbl: UILabel!
    @IBOutlet weak var floatingRatingView: FloatRatingView!
    @IBOutlet weak var followersBtn: UIButton!
    @IBOutlet weak var editBtnWidthConstant: NSLayoutConstraint!
    @IBOutlet weak var editProfileBtn: UIButton!
    
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        self.navigationTitleLbl.font = setNavigationTitleFont()
        self.selectionStyle = .none
        self.editProfileBtn.setTitle(EDIT_PROFILE.localized, for: .normal)
        self.pointsLbl.text = POSTS.localized
        self.followingLbl.text = FOLLOWING.localized
        self.followersLbl.text = FOLLOWERS.localized
        self.navigationTitleLbl.text = MY_PROFILE.localized
        self.bioLbl.text = ""
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    
    func setLayout(profileState: ProfileState){
        
        self.backBtn.rotateBackImage()
        
        self.userImage.layer.cornerRadius = 25
        self.userImage.layer.masksToBounds = true
        
        self.userName.text = "\(CurrentUser.name ?? "")"
        self.joineddateLbl.text = "\(JOINED.localized): \(CurrentUser.created_at ?? "")"
        self.followersCountLbl.text = "\(CurrentUser.followers ?? "0")"
        self.followingCountLbl.text = "\(CurrentUser.followings ?? "0")"
        self.pointsCountLbl.text = "\(CurrentUser.posts ?? "0")"
        self.bioLbl.text = CurrentUser.bio ?? ""
        
        if let rate = CurrentUser.rating, !rate.isEmpty{
            setRating(rating: Float(rate)!)
        }
        
        guard let imageUrl = URL(string: CurrentUser.profile_pic ?? "") else{return}
        delayWithSeconds(1, completion: {
            self.userImage.sd_setImage(with: imageUrl, placeholderImage: #imageLiteral(resourceName: "ic_profile_placeholder"))
        })
    }
    
    func setRating(rating: Float){
        
        self.floatingRatingView.rating = rating
        self.rateLbl.text = "\(rating)"
        
    }
    
}


class ProfitLostCell: UITableViewCell {
    
    @IBOutlet weak var statusForwardArrow: UIImageView!
    @IBOutlet weak var graphView: GKLineGraph!
    @IBOutlet weak var profitlostBtn: UIButton!
    @IBOutlet weak var profitlostLbl: UILabel!
    @IBOutlet weak var statusExpectUpDownImg: UIImageView!
    @IBOutlet weak var profitlLostValue: UILabel!
    @IBOutlet weak var forwordArrowImg: UIImageView!
    @IBOutlet weak var statusOfExpectView: UIView!
    @IBOutlet weak var expectValueLbl: UILabel!
    @IBOutlet weak var statusOfExpectLbl: UILabel!
    @IBOutlet weak var seperetorView: UIView!
    @IBOutlet weak var expextSepView: UIView!
    
    
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


class UpgradeAccCell: UITableViewCell {
    
    @IBOutlet weak var upgradeAccBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.upgradeAccBtn.setTitle(UPGRADE_ACCOUNT.localized, for: .normal)
    }
}
