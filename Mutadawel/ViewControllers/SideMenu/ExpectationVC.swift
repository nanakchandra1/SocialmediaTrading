//
//  ExpectationVC.swift
//  Mutadawel
//
//  Created by Appinventiv on 07/02/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

enum ExpectationState{
    
    case Right, Wrong, All, pending , ProfitLoss,None
}

class ExpectationVC: MutadawelBaseVC {
    
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var navigationTitle: UILabel!
    @IBOutlet weak var postTableView: UITableView!
    
    var expectationState = ExpectationState.None
    var selectedIndexPath = [IndexPath]()
    var forcastList = [ForecastPostDetailModel]()
    var currentPage:Int = 1
    var userId : Int!
    var selectedIndex:Int!
    var likeCounter = 0
    var eventID = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initialSetup(){
        
        self.postTableView.delegate = self
        self.postTableView.dataSource = self
        self.navigationTitle.font = setNavigationTitleFont()
        self.navigationView.backgroundColor = AppColor.navigationBarColor
        self.postTableView.register(UINib(nibName: "PostInfoCell", bundle: nil), forCellReuseIdentifier: "PostInfoCell")
        self.postTableView.register(UINib(nibName: "GeneralPostInfoCell", bundle: nil), forCellReuseIdentifier: "GeneralPostInfoCell")
        self.postTableView.register(UINib(nibName: "PostInfoCondtnForexCell", bundle: nil), forCellReuseIdentifier: "PostInfoCondtnForexCell")
        self.postTableView.register(UINib(nibName: "PostInfoCondtnStockCell", bundle: nil), forCellReuseIdentifier: "PostInfoCondtnStockCell")
        self.postTableView.register(UINib(nibName: "PostInfoCondtnForexTwoCell", bundle: nil), forCellReuseIdentifier: "PostInfoCondtnForexTwoCell")
        
        self.backBtn.rotateBackImage()
        
        self.getDetailList()
        
        self.postTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        
    }
    
    
    func getDetailList(){
        
        if self.expectationState == .All{
            
            self.navigationTitle.text = FORECAST.localized
            self.getforecastList(EndPoint.forecastListURL)
            self.eventID = "forecast"
            
        }else if self.expectationState == .Right{
            self.eventID = "right forecast"
            self.navigationTitle.text = RIGHT_EXPECTATION.localized
            self.getforecastList(EndPoint.rightForecastListURL)
            
        }else if self.expectationState == .pending{
            self.eventID = "pending forecast"
            self.navigationTitle.text = PENDING_EXPECTATION.localized
            self.getforecastList(EndPoint.pendingForecastListURL)
            
        }else if self.expectationState == .Wrong{
            self.eventID = "wrong forecast"
            self.navigationTitle.text = WRONG_EXPECTATION.localized
            self.getforecastList(EndPoint.wrongForecastListURL)
            
        }else if self.expectationState == .ProfitLoss{
            self.eventID = "profit loss"
            self.navigationTitle.text = PROFIT_AND_LOST.localized
            self.getforecastList(EndPoint.profitLossListURL)
        }
        
    }
    
    
    func showNodata(){
        
        if self.forcastList.isEmpty{
            
            self.postTableView.backgroundView = makeLbl(view: self.postTableView, msg: No_forecast_is_posted.localized)
            
            self.postTableView.backgroundView?.isHidden = false
            
        }else{
            
            self.postTableView.backgroundView?.isHidden = true
            
        }
        
    }
    
    
    func getforecastList(_ url : String){
        
        var params = JSONDictionary()
        
        
        params["myId"] = CurrentUser.user_id
        
        params["userId"] = self.userId
        
        params["pageNumber"] = self.currentPage
        
        if self.currentPage == 1{
            
            showLoader()
            
        }
        
        rightForecastListAPI(params: params, url: url) { (success, msg, data) in
            hideLoader()
            
            if success{
                
                print_debug(object: data!)
                
                if self.currentPage == 1{
                    
                    self.forcastList = data!.map({ (postData) -> ForecastPostDetailModel in
                        ForecastPostDetailModel(with: postData)
                    })
                    
                }else{
                    
                    for res in data!{
                        
                        let postData = ForecastPostDetailModel(with: res)
                        self.forcastList.append(postData)
                        
                    }
                }
            }
            self.postTableView.reloadData()
            self.showNodata()
        }
    }
    
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
}


extension ExpectationVC: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.forcastList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let data = self.forcastList[indexPath.row]
        let post_type = data.post_type ?? ""
        
        switch post_type {
            
        case Status.one:
            let cell = tableView.dequeueReusableCell(withIdentifier: "GeneralPostInfoCell", for: indexPath) as! GeneralPostInfoCell
            //cell.setupView()
            
            cell.likeBtn.addTarget(self, action: #selector(self.likeBtnTapped(_:)), for: .touchUpInside)
            cell.commentBtn.addTarget(self, action: #selector(self.commentBtnTapped(_:)), for: .touchUpInside)
            cell.shareBtn.addTarget(self, action: #selector(self.shareBtnTapped(_:)), for: .touchUpInside)
            cell.userProfileBtn.addTarget(self, action: #selector(self.userProfileTapped(_:)), for: .touchUpInside)
            
            cell.populateView(index: indexPath, info: data)
            
            if self.expectationState == .Right{
                cell.lestSideView.backgroundColor = AppColor.blue
            }else if self.expectationState == .Wrong{
                cell.lestSideView.backgroundColor = AppColor.appButtonColor
            }else if self.expectationState == .ProfitLoss{
                cell.lestSideView.backgroundColor = UIColor.white
            }else if self.expectationState == .All{
                
                if let status = data.forecast_status{
                    
                    if status == Status.zero{
                        
                        cell.lestSideView.backgroundColor = UIColor.yellow
                        
                    }else if status == Status.one{
                        cell.lestSideView.backgroundColor = AppColor.blue
                        
                    }else if status == Status.two{
                        cell.lestSideView.backgroundColor = AppColor.appButtonColor
                        
                    }else{
                        cell.lestSideView.backgroundColor = UIColor.yellow
                    }
                }
                
            }
            cell.commentValue.urlLinkTapHandler = { label, url, range in
                NSLog("URL \(url) tapped")
                openUrlLink(url)
            }
            
            //cell.bottomView.isHidden = true
            
            return cell
            
        case Status.two:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostInfoCell", for: indexPath) as! PostInfoCell
            cell.setupView()
            cell.likersCountBtn.addTarget(self, action: #selector(self.likeBtnTapped(_:)), for: .touchUpInside)
            cell.commentersBtn.addTarget(self, action: #selector(self.commentBtnTapped(_:)), for: .touchUpInside)
            cell.sharesBtn.addTarget(self, action: #selector(self.shareBtnTapped(_:)), for: .touchUpInside)
            
            cell.likeBtn.addTarget(self, action: #selector(self.likeBtnTapped(_:)), for: .touchUpInside)
            cell.commentBtn.addTarget(self, action: #selector(self.commentBtnTapped(_:)), for: .touchUpInside)
            cell.shareBtn.addTarget(self, action: #selector(self.shareBtnTapped(_:)), for: .touchUpInside)
            cell.userProfileBtn.addTarget(self, action: #selector(self.userProfileTapped(_:)), for: .touchUpInside)
            
            
            cell.populateView(index: indexPath, info: data)
            
            //cell.moreCountBtn.isHidden = true
            cell.optionBtn.isHidden = true
            
            if self.expectationState == .Right{
                cell.lestSideView.backgroundColor = AppColor.blue
            }else if self.expectationState == .Wrong{
                cell.lestSideView.backgroundColor = AppColor.appButtonColor
            }else if self.expectationState == .ProfitLoss{
                cell.lestSideView.backgroundColor = UIColor.white
            }else if self.expectationState == .All{
                
                if let status = data.forecast_status{
                    
                    if status == Status.zero{
                        
                        cell.lestSideView.backgroundColor = UIColor.yellow
                        
                    }else if status == Status.one{
                        cell.lestSideView.backgroundColor = AppColor.blue
                        
                    }else if status == Status.two{
                        cell.lestSideView.backgroundColor = AppColor.appButtonColor
                        
                    }else{
                        cell.lestSideView.backgroundColor = UIColor.yellow
                    }
                }
                
                
            }else if self.expectationState == .pending{
                
                cell.lestSideView.backgroundColor = UIColor.yellow
            }
            
            cell.commentValue.urlLinkTapHandler = { label, url, range in
                NSLog("URL \(url) tapped")
                openUrlLink(url)
            }
            
            //cell.bottomView.isHidden = true
            return cell
            
        case Status.three:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostInfoCondtnForexCell", for: indexPath) as! PostInfoCondtnForexCell
            cell.setupView()
            cell.likersCountBtn.addTarget(self, action: #selector(self.likeBtnTapped(_:)), for: .touchUpInside)
            cell.commentersBtn.addTarget(self, action: #selector(self.commentBtnTapped(_:)), for: .touchUpInside)
            cell.sharesBtn.addTarget(self, action: #selector(self.shareBtnTapped(_:)), for: .touchUpInside)
            
            cell.likeBtn.addTarget(self, action: #selector(self.likeBtnTapped(_:)), for: .touchUpInside)
            cell.commentBtn.addTarget(self, action: #selector(self.commentBtnTapped(_:)), for: .touchUpInside)
            cell.shareBtn.addTarget(self, action: #selector(self.shareBtnTapped(_:)), for: .touchUpInside)
            cell.userProfileBtn.addTarget(self, action: #selector(self.userProfileTapped(_:)), for: .touchUpInside)
            
            cell.populateView(index: indexPath, info: data)
            
            // cell.moreCountBtn.isHidden = true
            cell.optionBtn.isHidden = true
            
            if self.expectationState == .Right{
                cell.lestSideView.backgroundColor = AppColor.blue
            }else if self.expectationState == .Wrong{
                cell.lestSideView.backgroundColor = AppColor.appButtonColor
            }else if self.expectationState == .ProfitLoss{
                cell.lestSideView.backgroundColor = UIColor.white
            }else if self.expectationState == .All{
                
                if let status = data.forecast_status{
                    
                    if status == Status.zero{
                        
                        cell.lestSideView.backgroundColor = UIColor.yellow
                        
                    }else if status == Status.one{
                        cell.lestSideView.backgroundColor = AppColor.blue
                        
                    }else if status == Status.two{
                        cell.lestSideView.backgroundColor = AppColor.appButtonColor
                        
                    }else{
                        cell.lestSideView.backgroundColor = UIColor.yellow
                    }
                }
                
                
            }
            cell.commentValue.urlLinkTapHandler = { label, url, range in
                NSLog("URL \(url) tapped")
                openUrlLink(url)
            }
            
            //cell.bottomView.isHidden = true
            return cell
            
        case Status.four:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostInfoCondtnStockCell", for: indexPath) as! PostInfoCondtnStockCell
            cell.setupView()
            
            cell.likersCountBtn.addTarget(self, action: #selector(self.likeBtnTapped(_:)), for: .touchUpInside)
            cell.commentersBtn.addTarget(self, action: #selector(self.commentBtnTapped(_:)), for: .touchUpInside)
            cell.sharesBtn.addTarget(self, action: #selector(self.shareBtnTapped(_:)), for: .touchUpInside)
            
            cell.likeBtn.addTarget(self, action: #selector(self.likeBtnTapped(_:)), for: .touchUpInside)
            cell.commentBtn.addTarget(self, action: #selector(self.commentBtnTapped(_:)), for: .touchUpInside)
            cell.shareBtn.addTarget(self, action: #selector(self.shareBtnTapped(_:)), for: .touchUpInside)
            cell.userProfileBtn.addTarget(self, action: #selector(self.userProfileTapped(_:)), for: .touchUpInside)
            
            cell.populateView(index: indexPath, info: data)
            
            //cell.moreCountBtn.isHidden = true
            cell.optionBtn.isHidden = true
            
            
            if self.expectationState == .Right{
                
                cell.lestSideView.backgroundColor = AppColor.blue
                
            }else if self.expectationState == .Wrong{
                
                cell.lestSideView.backgroundColor = AppColor.appButtonColor
                
            }else if self.expectationState == .ProfitLoss{
                
                cell.lestSideView.backgroundColor = UIColor.white
                
            }else if self.expectationState == .All{
                
                if let status = data.forecast_status{
                    
                    if status == Status.zero{
                        
                        cell.lestSideView.backgroundColor = UIColor.yellow
                        
                    }else if status == Status.one{
                        cell.lestSideView.backgroundColor = AppColor.blue
                        
                    }else if status == Status.two{
                        cell.lestSideView.backgroundColor = AppColor.appButtonColor
                        
                    }else{
                        cell.lestSideView.backgroundColor = UIColor.yellow
                    }
                }
                
                
            }
            cell.commentValue.urlLinkTapHandler = { label, url, range in
                NSLog("URL \(url) tapped")
                openUrlLink(url)
            }
            
            //cell.bottomView.isHidden = true
            
            return cell
            
        case Status.five:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostInfoCondtnForexTwoCell", for: indexPath) as! PostInfoCondtnForexTwoCell
            // cell.setupView()
            cell.likersCountBtn.addTarget(self, action: #selector(self.likeBtnTapped(_:)), for: .touchUpInside)
            cell.commentersBtn.addTarget(self, action: #selector(self.commentBtnTapped(_:)), for: .touchUpInside)
            cell.sharesBtn.addTarget(self, action: #selector(self.shareBtnTapped(_:)), for: .touchUpInside)
            
            
            cell.likeBtn.addTarget(self, action: #selector(self.likeBtnTapped(_:)), for: .touchUpInside)
            cell.commentBtn.addTarget(self, action: #selector(self.commentBtnTapped(_:)), for: .touchUpInside)
            cell.shareBtn.addTarget(self, action: #selector(self.shareBtnTapped(_:)), for: .touchUpInside)
            cell.userProfileBtn.addTarget(self, action: #selector(self.userProfileTapped(_:)), for: .touchUpInside)
            cell.populateView(index: indexPath, info: data)
            
            //cell.moreCountBtn.isHidden = true
            cell.optionBtn.isHidden = true
            
            if self.expectationState == .Right{
                
                cell.lestSideView.backgroundColor = AppColor.blue
                
            }else if self.expectationState == .Wrong{
                
                cell.lestSideView.backgroundColor = AppColor.appButtonColor
                
            }else if self.expectationState == .ProfitLoss{
                
                cell.lestSideView.backgroundColor = UIColor.white
                
            }else if self.expectationState == .All{
                
                if let status = data.forecast_status{
                    
                    if status == Status.zero{
                        
                        cell.lestSideView.backgroundColor = UIColor.yellow
                        
                    }else if status == Status.one{
                        cell.lestSideView.backgroundColor = AppColor.blue
                        
                    }else if status == Status.two{
                        cell.lestSideView.backgroundColor = AppColor.appButtonColor
                        
                    }else{
                        cell.lestSideView.backgroundColor = UIColor.yellow
                    }
                }
                
            }else if self.expectationState == .pending{
                
                cell.lestSideView.backgroundColor = UIColor.yellow
                
            }
            cell.commentValue.urlLinkTapHandler = { label, url, range in
                NSLog("URL \(url) tapped")
                openUrlLink(url)
            }
            
            //cell.bottomView.isHidden = true
            
            return cell
        default:
            fatalError()
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        return UITableViewAutomaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let data = self.forcastList[indexPath.row]
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
            navigationController.isNavigationBarHidden = true

            navigationController.modalPresentationStyle = .overCurrentContext
            sharedAppdelegate.nvc.present(navigationController, animated: true, completion: nil)

        case Status.three:
            let popUp = postDetailStoryboard.instantiateViewController(withIdentifier: "ForecastForexID") as! ForecastForexVC
            popUp.delegate = self
            popUp.info = data
            let navigationController = UINavigationController(rootViewController: popUp)
            navigationController.isNavigationBarHidden = true

            navigationController.modalPresentationStyle = .overCurrentContext
            sharedAppdelegate.nvc.present(navigationController, animated: true, completion: nil)

        case Status.four:
            
            let popUp = postDetailStoryboard.instantiateViewController(withIdentifier: "ConditionStockID") as! ConditionStockVC
            popUp.delegate = self
            popUp.info = data
            let navigationController = UINavigationController(rootViewController: popUp)
            navigationController.isNavigationBarHidden = true

            navigationController.modalPresentationStyle = .overCurrentContext
            sharedAppdelegate.nvc.present(navigationController, animated: true, completion: nil)

        case Status.five:
            
            let popUp = postDetailStoryboard.instantiateViewController(withIdentifier: "ConditionForecastForexID") as! ConditionForecastForexVC
            popUp.delegate = self
            popUp.info = data
            let navigationController = UINavigationController(rootViewController: popUp)
            navigationController.isNavigationBarHidden = true

            navigationController.modalPresentationStyle = .overCurrentContext
            sharedAppdelegate.nvc.present(navigationController, animated: true, completion: nil)

        default:
            
            fatalError()
        }
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let endScrolling = scrollView.contentOffset.y + scrollView.contentSize.height
        if endScrolling > scrollView.contentSize.height {
            
            self.currentPage += 1
            if self.expectationState == .Right {
                self.getforecastList(EndPoint.rightForecastListURL)
            }else if self.expectationState == .Wrong{
                self.getforecastList(EndPoint.wrongForecastListURL)
            }else if self.expectationState == .All{
                self.getforecastList(EndPoint.forecastListURL)
            }
        }
        
    }
    //MARK:-  target methods
    
    
    
    
    func likeBtnTapped(_ sender: UIButton){
        
        setEvent(eventName: FirebaseEventName.like, params: ["eventId": self.eventID as NSObject])
        
        guard let indexPath = sender.tableViewIndexPath(tableView: self.postTableView) else{return}
        
        let info = self.forcastList[indexPath.row]
        
        if let post_like = info.post_like{
            
            self.likeCounter = post_like
            
        }
        
        
        if let indexPath = sender.tableViewIndexPath(tableView: self.postTableView){
            
            var params = JSONDictionary()
            
            params["userId"] = CurrentUser.user_id ?? ""
            
            params["forecastId"] = info.forecast_id ?? ""
            
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
                            
                            self.forcastList[indexPath.row].is_liked = "no"
                            
                        }else{
                            
                            self.likeCounter += 1
                            
                            self.forcastList[indexPath.row].is_liked = "yes"
                            
                        }
                    }
                    
                    self.forcastList[indexPath.row].post_like = self.likeCounter
                    
                }
                self.postTableView.reloadData()
            }
        }
    }
    
    
    func commentBtnTapped(_ sender: UIButton){
        setEvent(eventName: FirebaseEventName.comment, params: ["eventId": self.eventID as NSObject])
        
        guard let indexPath = sender.tableViewIndexPath(tableView: self.postTableView) else{return}
        self.selectedIndex = indexPath.row
        let popUp = homeStoryboard.instantiateViewController(withIdentifier: "CommentID") as! CommentVC
        popUp.userDetail = self.forcastList[indexPath.row]
        popUp.setView = .Comment
        popUp.delegate = self
        popUp.modalPresentationStyle = .overCurrentContext
        sharedAppdelegate.nvc.pushViewController(popUp, animated: true)
    }
    
    func shareBtnTapped(_ sender: UIButton){
        
        setEvent(eventName: FirebaseEventName.share, params: ["eventId": self.eventID as NSObject])
        
        guard let indexPath = sender.tableViewIndexPath(tableView: self.postTableView) else{return}
        
        let info = self.forcastList[indexPath.row]
        
        var params = JSONDictionary()
        
        params["userId"] = CurrentUser.user_id ?? ""
        
        params["postId"] = info.forecast_id
        
        showLoader()
        
        sharePostAPI(params: params) { (success, msg, data) in
            
            hideLoader()
            
            if success{
                
                var count = 0
                
                if let share_count = info.share_count{
                    
                    count = share_count
                    
                    count = count + 1
                    
                }
                
                if let html = data?["content"].string{
                    
                    let str = html.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
                    
                    displayShareSheet(shareContent: str, viewController: self)
                    
                    self.forcastList[indexPath.row].is_shared = "yes"
                    
                    self.forcastList[indexPath.row].share_count = count
                    
                    self.postTableView.reloadRows(at: [indexPath as IndexPath], with: .none)
                }
            }
        }
    }
    
    
    func userProfileTapped(_ sender: UIButton){
        setEvent(eventName: FirebaseEventName.user_profile_click, params: ["eventId": self.eventID as NSObject])
        
        guard let indexPath = sender.tableViewIndexPath(tableView: self.postTableView) else{return}
        
        let data = self.forcastList[indexPath.row]
        
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


extension ExpectationVC: TimeLineDelegate{
    
    func setDurationData(timeLength: String, timeType: String?) {
        
    }
    
    func setStockFilterType(type: String) {
        
    }
    
    func refreshTimeline(_ info: ForecastPostDetailModel?,count: Int,isComment: Bool) {
        
        if isComment{
            self.forcastList[self.selectedIndex].is_commented = "yes"
        }
        self.forcastList[self.selectedIndex].post_comment = count
        self.postTableView.reloadData()
    }
    
    func setTimeLineFromDetail(info: ForecastPostDetailModel) {
        
        self.forcastList.remove(at: self.selectedIndex)
        
        print_debug(object: self.forcastList)
        
        self.forcastList.insert(info, at: self.selectedIndex)
        
        print_debug(object: self.forcastList)
        self.postTableView.reloadData()
        
    }
    
}
