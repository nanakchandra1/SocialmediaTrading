//
//  HomeVC.swift
//  Mutadawel
//
//  Created by Appinventiv on 08/02/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit



class HomeVC: MutadawelBaseVC {
    
    enum Requirements {
        
        case market, stock, currency ,none
        
    }

    enum Mode {
        
        case home, trade, ranking
        
    }

    //MARK:- ==============================================================
    //MARK:- IBOutlets

    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var navigationTitle: UILabel!
    @IBOutlet weak var chatBtn: UIButton!
    @IBOutlet weak var notificationCountLbl: UILabel!
    @IBOutlet weak var chatNotificationCntLbl: UILabel!
    @IBOutlet weak var notificationBtn: UIButton!
    @IBOutlet weak var tabsBgView: UIView!
    @IBOutlet weak var homeBtn: UIButton!
    @IBOutlet weak var tradeBtn: UIButton!
    @IBOutlet weak var rankingBtn: UIButton!
    @IBOutlet weak var timelineBtn: UIButton!
    @IBOutlet weak var seperatorView: UIView!
    @IBOutlet weak var seperatorLeadingConstant: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var scrollViewBittomConstnt: NSLayoutConstraint!
    @IBOutlet var scrollViewTopConstnt: NSLayoutConstraint!

	@IBOutlet weak var infoBtn: UIButton!
    @IBOutlet weak var searchBtn: UIButton!
    
    //MARK:- properties
    //MARK:- ==============================================================

    var homeScene: HomePostsVC!
    var tradeScene: TradeVC!
    var rankingScene: RankingVC!
    var intialMode : Mode = .home
    var stockInfo = MyStockListModel()
    var requirements = Requirements.none
    var isNotification = false
    var isLoaded = false

    //MARK:- view life cycle methods
    //MARK:- ==============================================================

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialViewSetUp()
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        self.notificationCountLbl.layer.cornerRadius = 10
        self.notificationCountLbl.layer.masksToBounds = true
        self.chatNotificationCntLbl.layer.cornerRadius = 10
        self.chatNotificationCntLbl.layer.masksToBounds = true
        self.navigationTitle.font = setNavigationTitleFont()
        self.navigationView.backgroundColor = AppColor.navigationBarColor
        
        if !self.isLoaded{
            
            self.addChildView()
            self.isLoaded = true
            
        }

        if self.intialMode == .trade{
            
            self.setSeperatorConstant(constant: screenWidth / 3)
            self.scrollView.setContentOffset(CGPoint.init(x: screenWidth, y: 0), animated: false)
			
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.checkRequirements()
        
        if CurrentUser.chat_notification_count != nil{
            
            self.chatNotificationCntLbl.isHidden = false
            self.chatNotificationCntLbl.text = CurrentUser.chat_notification_count
			
        }else{
            
            self.chatNotificationCntLbl.isHidden = true
			
        }

        if CurrentUser.notification_count != nil{
            self.notificationCountLbl.isHidden = false
            self.notificationCountLbl.text = CurrentUser.notification_count
        }else{
            self.notificationCountLbl.isHidden = true
        }

        NotificationCenter.default.addObserver(self, selector: #selector(self.notificationReceived), name: .myNotificationKey, object: nil)

    }

    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: .myNotificationKey, object: nil)
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.NSManagedObjectContextObjectsDidChange, object: XMPPhelper.sharedInstance().managedObjectContext_messageArchive())
    }
    
    
    
    //MARK:- Private methods
    //MARK:- ==============================================================

    
    private func initialViewSetUp(){
        
        
        self.managedObjectContextObjectsDidChange(notification: nil)
        
        self.chatSetUp()

        self.scrollView.delegate = self
        self.scrollView.frame.size.width = 4*screenWidth
        self.homeBtn.setTitle(TIMELINE.localized, for: UIControlState.normal)
        self.rankingBtn.setTitle(RANKING.localized, for: UIControlState.normal)
        self.tradeBtn.setTitle(TRADE.localized, for: UIControlState.normal)
        self.navigationTitle.text = HOME.localized
      
    }
    
    
    func checkRequirements(){
        
        if CurrentUser.is_market_selected == nil{
            
            self.requirements = .market
            self.showAlert(msg: Please_select_atleast_one_market.localized,title: CHOOSE_MARKET.localized)
            
        }
        else if CurrentUser.is_stock_selected == nil{
            
            self.requirements = .stock
            self.showAlert(msg: Select_atleast_one_stock.localized,title: CHOOSE_a_STOCKS.localized)
            
        }

    }

    
    
    func showAlert(msg: String,title: String){
        
        let alert = UIAlertController(title: "", message: msg, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: title, style: .default, handler: { (UIAlertAction) in
            
            if self.requirements == .market{
                
                let obj = preLoginStoryboard.instantiateViewController(withIdentifier: "ChooseMarketID") as! ChooseMarketVC
                self.navigationController?.pushViewController(obj, animated: true)
                
            }else if self.requirements == .stock{
                
                let obj = preLoginStoryboard.instantiateViewController(withIdentifier: "ChooseIndexesID") as! ChooseIndexesVC
                self.navigationController?.pushViewController(obj, animated: true)
                
            }else if self.requirements == .market{
                
                let obj = preLoginStoryboard.instantiateViewController(withIdentifier: "ChooseCurrencyID") as! ChooseCurrencyVC
                self.navigationController?.pushViewController(obj, animated: true)
                
            }
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    private func setSeperatorConstant(constant: CGFloat){
    
        self.seperatorLeadingConstant.constant = constant
    }
    
    
    func notificationReceived(_ notification : Notification){
    
        self.isNotification = true
        if let type = notification.userInfo?["type"]{
            
            if "\(type)" == "chat"{
            
                if CurrentUser.chat_notification_count != nil{
                    self.chatNotificationCntLbl.isHidden = false
                    self.chatNotificationCntLbl.text = CurrentUser.chat_notification_count
                }else{
                    self.chatNotificationCntLbl.isHidden = true
                }

                
            }else{
            
                if CurrentUser.notification_count != nil{
                    self.notificationCountLbl.isHidden = false
                    self.notificationCountLbl.text = CurrentUser.notification_count
                }else{
                    self.notificationCountLbl.isHidden = true
                }
   
            }
        }
    }
    
    
    //add child views
    
    func addChildView(){
        
        self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: false)
        
        self.homeScene = homeStoryboard.instantiateViewController(withIdentifier: "HomePostsID") as! HomePostsVC
        self.scrollView.addSubview(homeScene.view)
        homeScene.willMove(toParentViewController: self)
        self.addChildViewController(homeScene)
        
        
        self.tradeScene = homeStoryboard.instantiateViewController(withIdentifier: "TradeID") as! TradeVC
        if self.intialMode == .trade{
            self.tradeScene.isStocks = true
        }
        tradeScene.tradeDetail = self.stockInfo
        self.scrollView.addSubview(tradeScene.view)
        tradeScene.willMove(toParentViewController: self)
        self.addChildViewController(tradeScene)
        
        self.rankingScene = homeStoryboard.instantiateViewController(withIdentifier: "RankingID") as! RankingVC
        self.scrollView.addSubview(rankingScene.view)
        rankingScene.willMove(toParentViewController: self)
        self.addChildViewController(rankingScene)

        self.homeScene.view.frame.size.height = screenHeight - 113
        self.tradeScene.view.frame.size.height = screenHeight - 113
        self.rankingScene.view.frame.size.height = screenHeight - 113

        self.homeScene.view.frame.origin = CGPoint.zero
        self.tradeScene.view.frame.origin = CGPoint.init(x: screenWidth, y: 0)
        self.rankingScene.view.frame.origin = CGPoint.init(x: 2*screenWidth, y: 0)
        self.scrollView.contentSize = CGSize(width: screenWidth * 3, height: 1.0)
        self.scrollView.isPagingEnabled = true
        
        
        
        if sharedAppdelegate.appLanguage == .Arabic{
            
            self.scrollView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
            self.tradeScene.view.transform =  CGAffineTransform(rotationAngle: CGFloat(Double.pi))
            self.homeScene.view.transform =  CGAffineTransform(rotationAngle: CGFloat(Double.pi))
            self.rankingScene.view.transform =  CGAffineTransform(rotationAngle: CGFloat(Double.pi))
           // self.scrollViewBittomConstnt.constant = -108
            
        }
    }

   
    
    //MARK:- ==============================================================
    //MARK:- IBAction
    
	@IBAction func infoBtnTapped(_ sender: Any) {
		
		if self.intialMode == .home{
			
			let obj = homeStoryboard.instantiateViewController(withIdentifier: "homeHelpID") as! homeHelpVC
			
			obj.myVideo = "src=\"https://www.youtube.com/embed/S9DqQ8agTuM\""
			
			self.navigationController?.pushViewController(obj, animated: true)
			
			//UIApplication.shared.openURL(URL(string: "https://www.youtube.com/embed/S9DqQ8agTuM")!)
			
		}else if self.intialMode == .trade || self.intialMode == .ranking {
			
			let obj = homeStoryboard.instantiateViewController(withIdentifier: "homeHelpID") as! homeHelpVC
			
			obj.myVideo = "src=\"https://www.youtube.com/embed/BkZXh7N9FfU\""
			
			self.navigationController?.pushViewController(obj, animated: true)
			
			//UIApplication.shared.openURL(URL(string: "https://www.youtube.com/embed/BkZXh7N9FfU")!)
		}
	}
	
    @IBAction func sideMenuBtnTapped(_ sender: UIButton) {
        
        if sharedAppdelegate.appLanguage == .English{
            openLeft()
        }else{
            openRight()
        }
		
        setEvent(eventName: FirebaseEventName.sidemenu, params: ["eventId": "timeline" as NSObject])

    }
    
    
    @IBAction func notificationBtnTapped(_ sender: UIButton) {
        
        let obj = sideMenuStoryboard.instantiateViewController(withIdentifier: "NotificationID") as! NotificationVC
        sharedAppdelegate.nvc.pushViewController(obj, animated: true)
        setEvent(eventName: FirebaseEventName.click_on_notificaton, params: ["eventId": "timeline" as NSObject])
        
    }

    @IBAction func chatBtnTapped(_ sender: UIButton) {
        
        let obj = AppStoryboard.ChatView.instance.instantiateViewController(withIdentifier: "MessagesID") as! MessagesVC
        obj.user_id = CurrentUser.user_id!
        sharedAppdelegate.nvc.pushViewController(obj, animated: true)
        setEvent(eventName: FirebaseEventName.message, params: ["eventId": "timeline" as NSObject])
        
    }
    
    
    @IBAction func homeBtnTapped(_ sender: UIButton) {
		
		self.intialMode = .home
		
        NotificationCenter.default.post(name: .timeLineNotificationKey, object: nil, userInfo: nil)

        self.setSeperatorConstant(constant: 0)
        
        self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: false)

    }
    
    
    @IBAction func tradeBtnTapped(_ sender: UIButton) {
		
		self.intialMode = .trade
		
        self.setSeperatorConstant(constant: screenWidth / 3)
        self.scrollView.setContentOffset(CGPoint.init(x: screenWidth, y: 0), animated: false)
        
    }
    
    @IBAction func rankingBtnTapped(_ sender: UIButton) {
		
		self.intialMode = .ranking
		
		var params = JSONDictionary()
		params["userId"] = CurrentUser.user_id
		params["platform"] = 2
		
		clickRankingAPI(params: params) { (success, msg, data) in
			if success{
			
			}else{
			
			}
		}
		
        self.setSeperatorConstant(constant: 2 * (screenWidth / 3))
        self.scrollView.setContentOffset(CGPoint.init(x: screenWidth*2, y: 0), animated: false)
		
    }
    
    
    @IBAction func searchBtnTap(_ sender: UIButton) {
        
        let obj = homeStoryboard.instantiateViewController(withIdentifier: "SearchID") as! SearchVC
        sharedAppdelegate.nvc.pushViewController(obj, animated: true)
        setEvent(eventName: FirebaseEventName.search, params: ["eventId": "timeline" as NSObject])

    }

}


//MARK:- =================================
//MARK:- Scroll view delegate method

extension HomeVC: UIScrollViewDelegate{

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        self.seperatorLeadingConstant.constant = self.scrollView.contentOffset.x/3

    }
}


//MARK:- =================================
//MARK:- Chat setup

extension HomeVC {
    
    // initiating chat server
    
    func chatSetUp() {
        
        DispatchQueue.main.async {
            let notificationCenter = NotificationCenter.default
            notificationCenter.addObserver(self, selector: #selector(self.managedObjectContextObjectsDidChange), name: NSNotification.Name.NSManagedObjectContextObjectsDidChange, object: XMPPhelper.sharedInstance().managedObjectContext_messageArchive())
        }
    }
    
    
    
    func managedObjectContextObjectsDidChange(notification: NSNotification?){
        
        print_debug(object: XMPPhelper.sharedInstance().getUnreadMessageContactForHome())
        
        
    }
    
    
}
