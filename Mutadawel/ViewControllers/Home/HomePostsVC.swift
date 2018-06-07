//
//  HomePostsVC.swift
//  Mutadawel
//
//  Created by Appinventiv on 08/02/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit
import Social
import SKPhotoBrowser

enum SetTimeline{
    case Comment,more,None
}

class HomePostsVC: MutadawelBaseVC {
    
    //MARK:- IBActions
    //MARK:- ================================================

    @IBOutlet weak var postTableView: UITableView!
    @IBOutlet weak var editPostBtn: UIButton!
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    var forcastInfoList = [ForecastPostDetailModel]()
    var currentPage:Int = 0
    var likeCounter = 0
    var selectedIndex:Int!
    var selectedInfo = ForecastPostDetailModel()
    var isRefesh = false
    var setTimeLine = SetTimeline.None
    var refreshControl = UIRefreshControl()
	var posttype = ""
    var userID: Int = 0
	var currentPrice: Double = 0.0
    var menuImages = [SKPhoto]()

    //MARK:- View life cycle methods
    //MARK:- ==========================

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.initialViewStup()
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshTimeLine), name: .timeLineNotificationKey, object: nil)
        
    }
    
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        
        if sharedAppdelegate.appLanguage == .Arabic{
            
            if UIApplication.shared.statusBarFrame.height > 20{
                
                self.topConstraint.constant = 70
                
            }else{
                self.topConstraint.constant = 15

            }
        }
    }

    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: .timeLineNotificationKey, object: nil)
    }
    
    
    
    override func viewWillLayoutSubviews() {
        
        super.viewWillLayoutSubviews()
        
    }
    
    
    //MARK:-  methods
    //MARK:- ==========================

    func initialViewStup(){
        
        self.postTableView.delegate = self
        
        self.postTableView.dataSource = self
        
        self.editPostBtn.layer.cornerRadius = 25
        
        self.postTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        self.postTableView.register(UINib(nibName: "PostInfoCell", bundle: nil), forCellReuseIdentifier: "PostInfoCell")
        
        self.postTableView.register(UINib(nibName: "GeneralPostInfoCell", bundle: nil), forCellReuseIdentifier: "GeneralPostInfoCell")
        
        self.postTableView.register(UINib(nibName: "PostInfoCondtnForexCell", bundle: nil), forCellReuseIdentifier: "PostInfoCondtnForexCell")
        
        self.postTableView.register(UINib(nibName: "PostInfoCondtnStockCell", bundle: nil), forCellReuseIdentifier: "PostInfoCondtnStockCell")
        
        self.postTableView.register(UINib(nibName: "PostInfoCondtnForexTwoCell", bundle: nil), forCellReuseIdentifier: "PostInfoCondtnForexTwoCell")
        self.postTableView.register(UINib(nibName: "AddsCell", bundle: nil), forCellReuseIdentifier: "AddsCell")
        self.postTableView.register(UINib(nibName: "VideosAddCell", bundle: nil), forCellReuseIdentifier: "VideosAddCell")
        self.postTableView.register(UINib(nibName: "ActivityIndicatorCell", bundle: nil), forCellReuseIdentifier: "ActivityIndicatorCell")

        self.postTableView.estimatedRowHeight = 100
        
        self.refreshControl.attributedTitle = NSAttributedString(string: "")
        self.refreshControl.tintColor = AppColor.navigationBarColor
        self.refreshControl.addTarget(self, action: #selector(HomePostsVC.getTimeLine), for: UIControlEvents.valueChanged)
		
//		self.refreshControl.addTarget(self, action: #selector(HomePostsVC.getTimeLineForRefreshControl), for: UIControlEvents.valueChanged)
		
        self.postTableView?.addSubview(refreshControl)

        self.getTimeLine()
    }
    

    func refreshTimeLine(){
    
        self.currentPage = 0
        
        if !self.forcastInfoList.isEmpty{
            
            self.postTableView.scrollToRow(at: IndexPath(row: 0, section: 0) , at: .top, animated: true)

        }
    }
    
    
    func showNodata(){
        
        if self.forcastInfoList.isEmpty{
            
            self.postTableView.backgroundView = makeLbl(view: self.postTableView, msg: data_not_available.localized)
            self.postTableView.backgroundView?.isHidden = false
            
        }else{
            
            self.postTableView.backgroundView?.isHidden = true
        }
    }
	
    func viewImageInMultipleImageViewer() {
        
        let browser = SKPhotoBrowser(photos: createWebPhotos())
        browser.initializePageIndex(0)
        browser.delegate = self
        
        present(browser, animated: true, completion: nil)
        
    }

    
    func getTimeLine(){
		
		if self.refreshControl.isRefreshing{
			
			self.currentPage = 0
		}
		
        var params = JSONDictionary()
        params["userId"] = CurrentUser.user_id
        params["deviceType"] = 2
        params["offset"] = self.currentPage
		
        timeLineAPI(params: params) { (success, msg, data) in
			
            self.refreshControl.endRefreshing()
			
			hideLoader()
			
            if success{
                
                print_debug(object: data!)
                
                if self.currentPage == 0{
                    
                    self.forcastInfoList = data!.map({ (posts) -> ForecastPostDetailModel in
                        ForecastPostDetailModel(with: posts)
                    })
					
                }else{
                    for res in data!{
                        
                        let postData = ForecastPostDetailModel(with: res)
                        self.forcastInfoList.append(postData)
                        
                    }
                }
				
                self.postTableView.reloadData()
                //self.postTableView.scrollToRow(at: IndexPath(row: 0, section: 0) , at: .top, animated: true)
            }
        }
    }
	

    //MARK:- IBActions
    //MARK:- ================================================


    @IBAction func editPostBtnTapped(_ sender: UIButton) {
        
        self.setTimeLine = .None
        let obj = homeStoryboard.instantiateViewController(withIdentifier: "AddNewPostID") as! AddNewPostVC
        obj.delegate = self
        sharedAppdelegate.nvc.pushViewController(obj, animated: true)
        setEvent(eventName: FirebaseEventName.new_post, params: ["eventId": "timeline" as NSObject])

    }
    
}


//MARK:- UItable view delegate and datasource methods
//MARK:- ================================================


extension HomePostsVC: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0{
            return forcastInfoList.count
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
        if indexPath.section == 0{
		
        let data = self.forcastInfoList[indexPath.row]
		
        let post_type = data.post_type ?? ""
        
        switch post_type {
            
        case Status.one:
			
			let cell = tableView.dequeueReusableCell(withIdentifier: "GeneralPostInfoCell", for: indexPath) as! GeneralPostInfoCell
			
			//cell.setupView()
            cell.likersCountBtn.addTarget(self, action: #selector(HomePostsVC.likeBtnTapped(_:)), for: .touchUpInside)
            cell.commentersBtn.addTarget(self, action: #selector(HomePostsVC.commentBtnTapped(_:)), for: .touchUpInside)
            cell.sharesBtn.addTarget(self, action: #selector(HomePostsVC.shareBtnTapped(_:)), for: .touchUpInside)
//            cell.moreCountBtn.addTarget(self, action: #selector(HomePostsVC.moreBtnTapped(_:)), for: .touchUpInside)

            cell.likeBtn.addTarget(self, action: #selector(HomePostsVC.likeBtnTapped(_:)), for: .touchUpInside)
            cell.commentBtn.addTarget(self, action: #selector(HomePostsVC.commentBtnTapped(_:)), for: .touchUpInside)
			cell.commentCommentBtn.addTarget(self, action: #selector(HomePostsVC.commentBtnTapped(_:)), for: .touchUpInside)
            cell.shareBtn.addTarget(self, action: #selector(HomePostsVC.shareBtnTapped(_:)), for: .touchUpInside)
            cell.optionBtn.addTarget(self, action: #selector(HomePostsVC.moreBtnTapped(_:)), for: .touchUpInside)
            cell.userProfileBtn.addTarget(self, action: #selector(HomePostsVC.userProfileTapped(_:)), for: .touchUpInside)

            cell.populateView(index: indexPath, info: data)
            cell.lestSideView.backgroundColor = UIColor.white
            cell.commentValue.urlLinkTapHandler = { label, url, range in
                NSLog("URL \(url) tapped")
                openUrlLink(url)
				}
			
            return cell
				
			
        case Status.two:
			
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostInfoCell", for: indexPath) as! PostInfoCell
			
            cell.setupView()
            cell.likersCountBtn.addTarget(self, action: #selector(HomePostsVC.likeBtnTapped(_:)), for: .touchUpInside)
            cell.commentersBtn.addTarget(self, action: #selector(HomePostsVC.commentBtnTapped(_:)), for: .touchUpInside)
            cell.sharesBtn.addTarget(self, action: #selector(HomePostsVC.shareBtnTapped(_:)), for: .touchUpInside)
            //cell.moreCountBtn.addTarget(self, action: #selector(HomePostsVC.moreBtnTapped(_:)), for: .touchUpInside)
            cell.likeBtn.addTarget(self, action: #selector(HomePostsVC.likeBtnTapped(_:)), for: .touchUpInside)
            cell.commentBtn.addTarget(self, action: #selector(HomePostsVC.commentBtnTapped(_:)), for: .touchUpInside)
			cell.commentCommentBtn.addTarget(self, action: #selector(HomePostsVC.commentBtnTapped(_:)), for: .touchUpInside)
            cell.shareBtn.addTarget(self, action: #selector(HomePostsVC.shareBtnTapped(_:)), for: .touchUpInside)
            cell.optionBtn.addTarget(self, action: #selector(HomePostsVC.moreBtnTapped(_:)), for: .touchUpInside)
            cell.userProfileBtn.addTarget(self, action: #selector(HomePostsVC.userProfileTapped(_:)), for: .touchUpInside)
            cell.populateView(index: indexPath, info: data)
            cell.lestSideView.backgroundColor = UIColor.white
            cell.commentValue.urlLinkTapHandler = { label, url, range in
                NSLog("URL \(url) tapped")
                openUrlLink(url)
				}
			
            return cell

            
        case Status.three:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostInfoCondtnForexCell", for: indexPath) as! PostInfoCondtnForexCell
			
			cell.setupView()
            cell.likersCountBtn.addTarget(self, action: #selector(HomePostsVC.likeBtnTapped(_:)), for: .touchUpInside)
            cell.commentersBtn.addTarget(self, action: #selector(HomePostsVC.commentBtnTapped(_:)), for: .touchUpInside)
            cell.sharesBtn.addTarget(self, action: #selector(HomePostsVC.shareBtnTapped(_:)), for: .touchUpInside)
            //cell.moreCountBtn.addTarget(self, action: #selector(HomePostsVC.moreBtnTapped(_:)), for: .touchUpInside)
            cell.likeBtn.addTarget(self, action: #selector(HomePostsVC.likeBtnTapped(_:)), for: .touchUpInside)
            cell.commentBtn.addTarget(self, action: #selector(HomePostsVC.commentBtnTapped(_:)), for: .touchUpInside)
			cell.commentCommentBtn.addTarget(self, action: #selector(HomePostsVC.commentBtnTapped(_:)), for: .touchUpInside)
            cell.shareBtn.addTarget(self, action: #selector(HomePostsVC.shareBtnTapped(_:)), for: .touchUpInside)
            cell.optionBtn.addTarget(self, action: #selector(HomePostsVC.moreBtnTapped(_:)), for: .touchUpInside)
            cell.userProfileBtn.addTarget(self, action: #selector(HomePostsVC.userProfileTapped(_:)), for: .touchUpInside)
            cell.populateView(index: indexPath, info: data)
            cell.lestSideView.backgroundColor = UIColor.white
            cell.commentValue.urlLinkTapHandler = { label, url, range in
                NSLog("URL \(url) tapped")
                openUrlLink(url)
				}
			
            return cell

        case Status.four:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostInfoCondtnStockCell", for: indexPath) as! PostInfoCondtnStockCell
            cell.setupView()
			
            cell.likersCountBtn.addTarget(self, action: #selector(HomePostsVC.likeBtnTapped(_:)), for: .touchUpInside)
            cell.commentersBtn.addTarget(self, action: #selector(HomePostsVC.commentBtnTapped(_:)), for: .touchUpInside)
            cell.sharesBtn.addTarget(self, action: #selector(HomePostsVC.shareBtnTapped(_:)), for: .touchUpInside)
            cell.likeBtn.addTarget(self, action: #selector(HomePostsVC.likeBtnTapped(_:)), for: .touchUpInside)
            cell.commentBtn.addTarget(self, action: #selector(HomePostsVC.commentBtnTapped(_:)), for: .touchUpInside)
			cell.commentCommentBtn.addTarget(self, action: #selector(HomePostsVC.commentBtnTapped(_:)), for: .touchUpInside)
            cell.shareBtn.addTarget(self, action: #selector(HomePostsVC.shareBtnTapped(_:)), for: .touchUpInside)
            cell.optionBtn.addTarget(self, action: #selector(HomePostsVC.moreBtnTapped(_:)), for: .touchUpInside)
            cell.userProfileBtn.addTarget(self, action: #selector(HomePostsVC.userProfileTapped(_:)), for: .touchUpInside)
            cell.populateView(index: indexPath, info: data)
            cell.lestSideView.backgroundColor = UIColor.white
            cell.commentValue.urlLinkTapHandler = { label, url, range in
                NSLog("URL \(url) tapped")
                openUrlLink(url)
				}
	
            return cell

            
        case Status.five:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostInfoCondtnForexTwoCell", for: indexPath) as! PostInfoCondtnForexTwoCell
			
            //cell.setupView()
            cell.likersCountBtn.addTarget(self, action: #selector(HomePostsVC.likeBtnTapped(_:)), for: .touchUpInside)
            cell.commentersBtn.addTarget(self, action: #selector(HomePostsVC.commentBtnTapped(_:)), for: .touchUpInside)
            cell.sharesBtn.addTarget(self, action: #selector(HomePostsVC.shareBtnTapped(_:)), for: .touchUpInside)
           // cell.moreCountBtn.addTarget(self, action: #selector(HomePostsVC.moreBtnTapped(_:)), for: .touchUpInside)
            cell.likeBtn.addTarget(self, action: #selector(HomePostsVC.likeBtnTapped(_:)), for: .touchUpInside)
            cell.commentBtn.addTarget(self, action: #selector(HomePostsVC.commentBtnTapped(_:)), for: .touchUpInside)
			cell.commentCommentBtn.addTarget(self, action: #selector(HomePostsVC.commentBtnTapped(_:)), for: .touchUpInside)
            cell.shareBtn.addTarget(self, action: #selector(HomePostsVC.shareBtnTapped(_:)), for: .touchUpInside)
            cell.optionBtn.addTarget(self, action: #selector(HomePostsVC.moreBtnTapped(_:)), for: .touchUpInside)
            cell.userProfileBtn.addTarget(self, action: #selector(HomePostsVC.userProfileTapped(_:)), for: .touchUpInside)
            cell.populateView(index: indexPath, info: data)
            cell.lestSideView.backgroundColor = UIColor.white
            cell.commentValue.urlLinkTapHandler = { label, url, range in
                NSLog("URL \(url) tapped")
                openUrlLink(url)
				}
			
            return cell
			
		case Status.six:
			
			let nib = UINib(nibName: "tradePostCell", bundle: nil)
			
			tableView.register(nib, forCellReuseIdentifier: "tradePostCell")
			
			let cell = tableView.dequeueReusableCell(withIdentifier: "tradePostCell", for: indexPath) as! tradePostCell
			
			//cell.setupView()
			cell.likersCountBtn.addTarget(self, action: #selector(HomePostsVC.likeBtnTapped(_:)), for: .touchUpInside)
			cell.commentersBtn.addTarget(self, action: #selector(HomePostsVC.commentBtnTapped(_:)), for: .touchUpInside)
			cell.sharesBtn.addTarget(self, action: #selector(HomePostsVC.shareBtnTapped(_:)), for: .touchUpInside)
			// cell.moreCountBtn.addTarget(self, action: #selector(HomePostsVC.moreBtnTapped(_:)), for: .touchUpInside)
			cell.likeBtn.addTarget(self, action: #selector(HomePostsVC.likeBtnTapped(_:)), for: .touchUpInside)
			cell.commentBtn.addTarget(self, action: #selector(HomePostsVC.commentBtnTapped(_:)), for: .touchUpInside)
			cell.commentCommentBtn.addTarget(self, action: #selector(HomePostsVC.commentBtnTapped(_:)), for: .touchUpInside)
			cell.shareBtn.addTarget(self, action: #selector(HomePostsVC.shareBtnTapped(_:)), for: .touchUpInside)
			cell.optionBtn.addTarget(self, action: #selector(HomePostsVC.moreBtnTapped(_:)), for: .touchUpInside)
			cell.userProfileBtn.addTarget(self, action: #selector(HomePostsVC.userProfileTapped(_:)), for: .touchUpInside)
			cell.populateView(index: indexPath, info: data)
			//cell.lestSideView.backgroundColor = UIColor.white
			
			
			return cell
		
        case Status.seven:
            
            let add_link = data.ad_link ?? ""
            let image = data.image ?? ""
            
            if add_link.isEmpty && image.isEmpty{
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "AddsCell", for: indexPath) as! AddsCell
                cell.populateData(with: data)
                return cell
                
            }else if !image.isEmpty{
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "AddsCell", for: indexPath) as! AddsCell
                cell.populateData(with: data)
                return cell
                
                
            }else if !add_link.isEmpty{
                let cell = tableView.dequeueReusableCell(withIdentifier: "VideosAddCell", for: indexPath) as! VideosAddCell
                cell.populateData(with: data)
                
                return cell
                
            }else{
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "AddsCell", for: indexPath) as! AddsCell
                cell.populateData(with: data)
                return cell
            }

        default:
			
            fatalError()
			
        }
            
        }else{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityIndicatorCell", for: indexPath) as! ActivityIndicatorCell
            self.currentPage += 1
            self.getTimeLine()

            return cell

        }
    }
	
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0{
        let data = self.forcastInfoList[indexPath.row]
        self.selectedIndex = indexPath.row
        let post_type = data.post_type ?? ""
        
        switch post_type {
            
        case Status.one:
            
            let popUp = postDetailStoryboard.instantiateViewController(withIdentifier: "GeneralPostID") as! GeneralPostVC
            
            popUp.delegate = self
            popUp.info = data
            let navigationController = UINavigationController(rootViewController: popUp)
            navigationController.modalPresentationStyle = .overCurrentContext
            navigationController.isNavigationBarHidden = true
           sharedAppdelegate.nvc.present(navigationController, animated: true, completion: nil)

        case Status.two:
			
            let popUp = postDetailStoryboard.instantiateViewController(withIdentifier: "ForecastStockID") as! ForecastStockVC
            popUp.delegate = self
            popUp.info = data
			
            let navigationController = UINavigationController(rootViewController: popUp)
            navigationController.modalPresentationStyle = .overCurrentContext
            navigationController.isNavigationBarHidden = true
            sharedAppdelegate.nvc.present(navigationController, animated: true, completion: nil)

        case Status.three:
            let popUp = postDetailStoryboard.instantiateViewController(withIdentifier: "ForecastForexID") as! ForecastForexVC
            popUp.delegate = self
            popUp.info = data
            let navigationController = UINavigationController(rootViewController: popUp)
            navigationController.modalPresentationStyle = .overCurrentContext
            navigationController.isNavigationBarHidden = true
            sharedAppdelegate.nvc.present(navigationController, animated: true, completion: nil)

        case Status.four:
            
            let popUp = postDetailStoryboard.instantiateViewController(withIdentifier: "ConditionStockID") as! ConditionStockVC
            popUp.delegate = self
            popUp.info = data
            let navigationController = UINavigationController(rootViewController: popUp)
            navigationController.modalPresentationStyle = .overCurrentContext
            navigationController.isNavigationBarHidden = true
            sharedAppdelegate.nvc.present(navigationController, animated: true, completion: nil)

        case Status.five:
            
            let popUp = postDetailStoryboard.instantiateViewController(withIdentifier: "ConditionForecastForexID") as! ConditionForecastForexVC
            popUp.delegate = self
            popUp.info = data
            let navigationController = UINavigationController(rootViewController: popUp)
            navigationController.modalPresentationStyle = .overCurrentContext
            navigationController.isNavigationBarHidden = true
            sharedAppdelegate.nvc.present(navigationController, animated: true, completion: nil)

        case Status.six:
            
            let popUp = postDetailStoryboard.instantiateViewController(withIdentifier: "TradePostID") as! TradePostVC
            popUp.delegate = self
            popUp.info = data
            let navigationController = UINavigationController(rootViewController: popUp)
            navigationController.modalPresentationStyle = .overCurrentContext
            navigationController.isNavigationBarHidden = true
            sharedAppdelegate.nvc.present(navigationController, animated: true, completion: nil)

        case Status.seven:
            
            let add_link = data.ad_link ?? ""
            let image = data.image ?? ""
            
            if !add_link.isEmpty{
                
                guard let url = URL(string: add_link) else{return}
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }else if !image.isEmpty{
                
                self.viewImageInMultipleImageViewer()
                
            }

        default:
            fatalError()
        }
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0{
        return UITableViewAutomaticDimension
        }else{
            
            return 70
        }
        
    }
	
	
	
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//
//        let endScrolling = scrollView.contentOffset.y + scrollView.contentSize.height
//        if endScrolling > scrollView.contentSize.height {
//
//            self.currentPage += 1
//            self.getTimeLine()
//
//        }
//    }
    

    //MARK:-  target methods
    //MARK:- ================================================

    func imageBtnTapped(_ sender: UIButton){
        
        guard let indexPath = sender.tableViewIndexPath(tableView: self.postTableView) else{return}
        self.selectedIndex = indexPath.row
        self.viewImageInMultipleImageViewer()
    }


    func likeBtnTapped(_ sender: UIButton){
        
        self.setTimeLine = .None
        
        guard let indexPath = sender.tableViewIndexPath(tableView: self.postTableView) else{return}
        
        let info = self.forcastInfoList[indexPath.row]
        
        if let post_like = info.post_like{
            
            self.likeCounter = post_like
            
        }
        
        
        var params = JSONDictionary()
        
            params["userId"] = CurrentUser.user_id
        
            params["forecastId"] = info.forecast_id
        
        if let is_like = info.is_liked{
            
            if is_like == "yes"{
                
                params["action"] = 2 as AnyObject?
                
            }else{
                
                params["action"] = 1 as AnyObject?
                
            }
        }
        
        
        showLoader()
        
        saveLikeAPI(params: params) { (success, msg, data) in
            
            hideLoader()
            
            if success{
                
                
                if let is_like = info.is_liked{
                    
                    if is_like == "yes"{
                        
                        self.likeCounter -= 1
                        
                        self.forcastInfoList[indexPath.row].is_liked = "no"
                        
                    }else{
                        
                        self.likeCounter += 1
                        
                        self.forcastInfoList[indexPath.row].is_liked = "yes"
                        
                    }
                }
                
                self.forcastInfoList[indexPath.row].post_like = self.likeCounter
                
            }
            
            self.postTableView.reloadData()
            //self.postTableView.reloadRows(at: [indexPath as IndexPath], with: .none)
        }
        
        setEvent(eventName: FirebaseEventName.like, params: ["eventId": "timeline" as NSObject])


 }
    
    
    
    func commentBtnTapped(_ sender: UIButton){
        
        self.setTimeLine = .Comment

        guard let indexPath = sender.tableViewIndexPath(tableView: self.postTableView) else{return}
        self.selectedIndex = indexPath.row
        let popUp = homeStoryboard.instantiateViewController(withIdentifier: "CommentID") as! CommentVC
        popUp.userDetail = self.forcastInfoList[indexPath.row]
        popUp.setView = .Comment
        popUp.delegate = self
        popUp.modalPresentationStyle = .overCurrentContext
        sharedAppdelegate.nvc.pushViewController(popUp, animated: true)
        setEvent(eventName: FirebaseEventName.comment, params: ["eventId": "timeline" as NSObject])

        //self.present(popUp, animated: true, completion: nil)
    }
    //==============MARK:- draw text in img we shared ============
	
	func textToImage(drawText text: NSString, text2: NSString, inImage image: UIImage, atPoint y: CGFloat, y2: CGFloat, userImg: UIImage, userName: NSString) -> UIImage {
		
		let textColor = UIColor.white
		let textAlignment = NSMutableParagraphStyle()
			textAlignment.alignment = NSTextAlignment.center
		var textFont: UIFont = UIFont()
		var text2Font: UIFont = UIFont()
		
		if sharedAppdelegate.appLanguage == .English{
			
			textFont = UIFont(name: "Roboto-Light", size: 22)!
			text2Font = UIFont(name: "Roboto-Bold", size: 22)!
		}else{
			
			textFont = UIFont(name: "GESSTwoLight-Light", size: 22)!
			text2Font = UIFont(name: "GESSTwoBold-Bold", size: 22)!
		}
		let scale = UIScreen.main.scale
		UIGraphicsBeginImageContextWithOptions(image.size, false, scale)
		
		
		
		let textFontAttributes = [
			NSFontAttributeName: textFont,
			
			NSForegroundColorAttributeName: textColor,
			] as [String : Any]
		
		let textFontAttributes2 = [
			NSFontAttributeName: text2Font,
			
			NSForegroundColorAttributeName: textColor,
			] as [String : Any]
		
		let textFontAttributes3 = [
			
			NSForegroundColorAttributeName: textColor
			] as [String : Any]
		
		let textsize = text.size(attributes: textFontAttributes)
		let text2size = text2.size(attributes: textFontAttributes)
		
		
		
		image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
		
		
		
		let rect = CGRect(origin: CGPoint(x: (image.size.width - textsize.width)/2, y: y), size: image.size)
		let rect2 = CGRect(origin: CGPoint(x: (image.size.width - text2size.width)/2, y: y2), size: image.size)
		let rectUserName = CGRect(origin: CGPoint(x: 60, y: 20), size: image.size)
		
		let imageRect  = CGRect(origin: CGPoint(x: 10, y: 10), size: CGSize(width: 40, height: 40))
		
		let imgeView = UIImageView()
		
		imgeView.frame.size.width = 40
		imgeView.frame.size.height = 40
		
		imgeView.contentMode = UIViewContentMode.scaleAspectFit
		imgeView.layer.cornerRadius = 20
		imgeView.layer.masksToBounds = true
		
		imgeView.image = userImg
		imgeView.drawHierarchy(in: imageRect, afterScreenUpdates: true)
		
		text.draw(in: rect, withAttributes: textFontAttributes)
		text2.draw(in: rect2, withAttributes: textFontAttributes2)
		userName.draw(in: rectUserName, withAttributes: textFontAttributes3)
		
		let newImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		return newImage!
	}
	//=======share func=============
	func forUserTradePost(info: ForecastPostDetailModel){
		
		var imgY = CGFloat()
		var	imgY2 = CGFloat()
		var buyOrSell = 0
		var txtForImg = ""
		var txtForImgMoney = ""
		var profit: Double = 0.0
		var stockName = ""
		var stockQuantity = 0
		var stockPriceTrade: Double = 0.0
		var img = UIImage()
		var usrname = ""
		if let stock_quantity = info.trade_stock_quantity{
			
			stockQuantity = stock_quantity
		}
		
		if let user_image = info.profile_pic{
			
			if user_image == ""{
				
				img = #imageLiteral(resourceName: "ic_following_placeholder")
				
			}else{
				let url = URL(string: user_image)
				let data = NSData(contentsOf: url!)
				img = UIImage(data: data! as Data)!
			}
		}
		if let user_name = info.user_name{
			
			usrname = user_name
		}
		
		if sharedAppdelegate.appLanguage == .Arabic{
			
			imgY = 200
			imgY2 = 244
			
			if let stock_name = info.trade_stock_name_ar{
				
				stockName = stock_name
			}
		}else{
			
			imgY = 200
			imgY2 = 244
			
			if let stock_name = info.trade_stock_name_en{
				
				stockName = stock_name
			}
		}
		
		if let buy_or_sell = info.trade_stock_buy_or_sell{
			buyOrSell = buy_or_sell
		}
		if buyOrSell == 1 {
			
			if let stock_price = info.trade_stock_price{
				
				stockPriceTrade = stock_price
			}
			
			txtForImg = "\(Iـpurchased.localized) \(stockName) \(stockQuantity) \(trade_stock.localized)"
			txtForImgMoney = "\(ForPrice.localized) \(stockPriceTrade) \(REAL_S.localized)"
			
		}else if buyOrSell == 2 {
			
			if let wallet_increase = info.trade_stock_total_wallet_increase{
				
				profit = wallet_increase
			}
			
			if profit < 0 {
				
				txtForImg = "\(I_SOLD.localized) \(stockName) \(stockQuantity) \(trade_stock.localized)"
				txtForImgMoney = "\(LOSS.localized) \(abs(profit)) \(REAL_S.localized)"
				
			}else if profit > 0 {
				
				txtForImg = "\(I_SOLD.localized) \(stockName) \(stockQuantity) \(trade_stock.localized)"
				txtForImgMoney = "\(WITH_PROFIT.localized) \(profit) \(REAL_S.localized)"
				
			}else{
				
				txtForImg = "\(I_SOLD.localized) \(stockName) \(stockQuantity) \(trade_stock.localized)"
				txtForImgMoney = "\(WITHOUT_PROFIT.localized)"
			}
		}
		if sharedAppdelegate.appLanguage == .English{
			
			img = self.textToImage(drawText: txtForImg as NSString, text2: txtForImgMoney as NSString, inImage: #imageLiteral(resourceName: "shareWalletEnglish"), atPoint: imgY , y2: imgY2, userImg: img, userName: usrname as NSString )
		}else{
			
			img = self.textToImage(drawText: txtForImg as NSString, text2: txtForImgMoney as NSString, inImage: #imageLiteral(resourceName: "shareWalletArabic"), atPoint: imgY , y2: imgY2, userImg: img, userName: usrname as NSString )
		}
		
		
		imageDisplayShareSheet(shareContent: img, viewController: self)
	}

    func shareBtnTapped(_ sender: UIButton){
		
        guard let indexPath = sender.tableViewIndexPath(tableView: self.postTableView) else{return}
        let info = self.forcastInfoList[indexPath.row]
        var params = JSONDictionary()

        
        params["userId"] = CurrentUser.user_id
        params["postId"] = info.forecast_id
        self.userID = info.user_id
        self.posttype = info.post_type 
        
		if self.posttype == Status.six && self.userID ==  currentUserId() {
			
			showLoader()
			
			sharePostAPI(params: params) { (success, msg, data) in
				
				hideLoader()
				
				self.forUserTradePost(info: info)
				
				if success{
					var count = 0
					if let share_count = info.share_count{
						
						count = share_count
						count = count + 1
					}
					
					setEvent(eventName: FirebaseEventName.share, params: ["eventId": "timeline" as NSObject])
					
					self.forcastInfoList[indexPath.row].is_shared = "yes"
					self.forcastInfoList[indexPath.row].share_count = count
					self.postTableView.reloadRows(at: [indexPath as IndexPath], with: .none)
                    
				}
			}
		}else{
			showLoader()
			
			sharePostAPI(params: params) { (success, msg, data) in
            
				hideLoader()
            
				if success{
					var count = 0
					if let share_count = info.share_count{
                
						count = share_count
						count = count + 1

                    
					}
                
					setEvent(eventName: FirebaseEventName.share, params: ["eventId": "timeline" as NSObject])

                    
                    let SmartLink = "tridder.net/smart-link/"
                    
                    
                    if let id = info.forecast_id{
                        
                        let longstring = id
                        let data = (longstring).data(using: String.Encoding.utf8)
                        let base64 = data!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
                        
                        displayShareSheet(shareContent: "\(SmartLink)\(base64)", viewController: self)
                    }
                    
                    self.forcastInfoList[indexPath.row].is_shared = "yes"
                    self.forcastInfoList[indexPath.row].share_count = count

                    self.postTableView.reloadRows(at: [indexPath as IndexPath], with: .none)
				}
			}
		}
	}
    
    
    
    func moreBtnTapped(_ sender: UIButton){
        
        guard let indexPath = sender.tableViewIndexPath(tableView: self.postTableView) else{return}
        self.selectedIndex = indexPath.row
        self.selectedInfo = self.forcastInfoList[indexPath.row]
        let popUp = homeStoryboard.instantiateViewController(withIdentifier: "HomePopUpID") as! HomePopUpVC
        popUp.postInfo = self.forcastInfoList[indexPath.row]
        popUp.delegate = self
        popUp.modalPresentationStyle = .overCurrentContext
        setEvent(eventName: FirebaseEventName.three_dots, params: ["eventId": "timeline" as NSObject])

        if self.selectedInfo.user_id  == currentUserId(){
            
            if self.selectedInfo.is_updatable == "yes" {
            
                self.setTimeLine = .more
                
                popUp.selectPopUp = .MoreForMyPost
                
            }
            
        }else{
            
            if let is_following = self.selectedInfo.is_following{
                
                self.setTimeLine = .None
                popUp.selectPopUp = .More

                if is_following == "yes"{
                    
                    popUp.isFollow = true

                }else{
                    
                    popUp.isFollow = false

                }
            }
 
        }
        self.present(popUp, animated: true, completion: nil)
        
    }
    
    
    func userProfileTapped(_ sender: UIButton){
        
        guard let indexPath = sender.tableViewIndexPath(tableView: self.postTableView) else{return}
        let data = self.forcastInfoList[indexPath.row]
        setEvent(eventName: FirebaseEventName.user_profile_click, params: ["eventId": "timeline" as NSObject])

        if let userId = data.user_id{
            
                if userId == currentUserId(){
                    let obj = sideMenuStoryboard.instantiateViewController(withIdentifier: "MyProfileID") as! MyProfileVC
                    sharedAppdelegate.nvc.pushViewController(obj, animated: true)
                    
                }else{
                    let obj = sideMenuStoryboard.instantiateViewController(withIdentifier: "OtherUserProfileVc") as! OtherUserProfileVc
                    obj.userID = userId
                    sharedAppdelegate.nvc.pushViewController(obj, animated: true)
                }
        }
    }
}

//MARK:- Time line delegate methods
//MARK:- ================================================

extension HomePostsVC: TimeLineDelegate{
    func setDurationData(timeLength: String, timeType: String?) {
        
    }
    
    func setStockFilterType(type: String) {
        
    }
    
    
    
    func refreshTimeline(_ info: ForecastPostDetailModel?,count: Int,isComment: Bool) {
        if self.setTimeLine == .more {
            
            self.forcastInfoList.remove(at: self.selectedIndex)
            
            print_debug(object: self.forcastInfoList)

            self.forcastInfoList.insert(info!, at: self.selectedIndex)
            
            print_debug(object: self.forcastInfoList)

            //let index = IndexPath(row: self.selectedIndex, section: 0)
            print_debug(object: self.selectedIndex)
            self.postTableView.reloadData()
            
        }else if self.setTimeLine == .Comment{
            
            if isComment{
                
                self.forcastInfoList[self.selectedIndex].is_commented = "yes"

            }
            self.forcastInfoList[self.selectedIndex].post_comment = count
            
            self.postTableView.reloadData()

        }
        else{
            self.currentPage = 0
            self.getTimeLine()
        }
    }
    
    
     func setTimeLineFromDetail(info: ForecastPostDetailModel) {
        
        self.forcastInfoList.remove(at: self.selectedIndex)
        
        print_debug(object: self.forcastInfoList)
        
        self.forcastInfoList.insert(info, at: self.selectedIndex)
        
        print_debug(object: self.forcastInfoList)
        self.postTableView.reloadData()


    }
}

extension HomePostsVC : SKPhotoBrowserDelegate {
    
    func createWebPhotos() -> [SKPhotoProtocol] {
        
        let image = self.forcastInfoList[selectedIndex].image ?? ""
        let images: [String] = [image]
        
        return (0..<images.count).map { (i: Int) -> SKPhotoProtocol in
            
            let photo = SKPhoto.photoWithImageURL(image, holder: #imageLiteral(resourceName: "ic_sidemenu_about_us"))
            
            photo.caption = ""
            photo.shouldCachePhotoURLImage = false
            return photo
        }
    }
}


