//
//  PostsVC.swift
//  Mutadawel
//
//  Created by Appinventiv on 07/02/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class PostsVC: MutadawelBaseVC {
    
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var navigationTitle: UILabel!
    @IBOutlet weak var postTableView: UITableView!
    
    var postList = [ForecastPostDetailModel]()
    var userId : Int!
    var setTimeLine = SetTimeline.None
    var selectedIndex:Int!
    var selectedInfo = ForecastPostDetailModel()
    var likeCounter = 0
    var eventID = "post"
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.initialViewStup()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initialViewStup(){
        
        self.backBtn.rotateBackImage()
        self.navigationTitle.text = POSTS.localized
        self.navigationTitle.font = setNavigationTitleFont()
        self.navigationView.backgroundColor = AppColor.navigationBarColor
        self.postTableView.delegate = self
        self.postTableView.dataSource = self
        self.postTableView.register(UINib(nibName: "GeneralPostInfoCell", bundle: nil), forCellReuseIdentifier: "GeneralPostInfoCell")
        self.postTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.getPostList()
    }
    
    func showNodata(){
        
        if self.postList.isEmpty{
            self.postTableView.backgroundView = makeLbl(view: self.view, msg: data_not_available.localized)
            self.postTableView.backgroundView?.isHidden = false
        }else{
            self.postTableView.backgroundView?.isHidden = true
        }
    }
    
    
    
    func getPostList(){
        
        var params = JSONDictionary()
        
        params["userId"] = self.userId
        params["myId"] = CurrentUser.user_id  
        
        showLoader()
        
        postListAPI(params: params) { (success, msg, data) in
            
            hideLoader()
            
            if success{
                
                self.postList = data!.map({ (post) -> ForecastPostDetailModel in
                    ForecastPostDetailModel(with: post)
                })
                
                self.postTableView.reloadData()
                
                self.showNodata()
                
            }
            
            self.showNodata()
            
        }
    }
    
    
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        
        _ = self.navigationController?.popViewController(animated: true)
        
    }
    
    
}


extension PostsVC: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.postList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GeneralPostInfoCell", for: indexPath) as! GeneralPostInfoCell
        
        cell.likersCountBtn.addTarget(self, action: #selector(self.likeBtnTapped(_:)), for: .touchUpInside)
        cell.commentersBtn.addTarget(self, action: #selector(self.commentBtnTapped(_:)), for: .touchUpInside)
        cell.sharesBtn.addTarget(self, action: #selector(self.shareBtnTapped(_:)), for: .touchUpInside)
        
        cell.likeBtn.addTarget(self, action: #selector(self.likeBtnTapped(_:)), for: .touchUpInside)
        cell.commentBtn.addTarget(self, action: #selector(self.commentBtnTapped(_:)), for: .touchUpInside)
        cell.shareBtn.addTarget(self, action: #selector(self.shareBtnTapped(_:)), for: .touchUpInside)
        cell.userProfileBtn.addTarget(self, action: #selector(self.userProfileTapped(_:)), for: .touchUpInside)
        
        //cell.optionBtn.addTarget(self, action: #selector(HomePostsVC.moreBtnTapped(_:)), for: .touchUpInside)
        cell.optionBtn.isHidden = true
        //        cell.viewHeightCostant.constant = 0
        cell.bottomView.isHidden = false
        cell.lestSideView.isHidden = true
        let data = self.postList[indexPath.row]
        cell.populateView(index: indexPath, info: data)
        
        //cell.moreCountBtn.isHidden = true
        cell.optionBtn.isHidden = true
        cell.commentValue.urlLinkTapHandler = { label, url, range in
            NSLog("URL \(url) tapped")
            openUrlLink(url)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let data = self.postList[indexPath.row]
        self.selectedIndex = indexPath.row
        let popUp = postDetailStoryboard.instantiateViewController(withIdentifier: "GeneralPostID") as! GeneralPostVC
        popUp.delegate = self
        popUp.info = data
        let navigationController = UINavigationController(rootViewController: popUp)
        navigationController.isNavigationBarHidden = true
        navigationController.modalPresentationStyle = .overCurrentContext
        sharedAppdelegate.nvc.present(navigationController, animated: true, completion: nil)
        
    }
    
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        return UITableViewAutomaticDimension
    }
    
    //MARK:-  target methods
    
    
    func likeBtnTapped(_ sender: UIButton){
        setEvent(eventName: FirebaseEventName.like, params: ["eventId": self.eventID as NSObject])
        
        guard let indexPath = sender.tableViewIndexPath(tableView: self.postTableView) else{return}
        
        let info = self.postList[indexPath.row]
        
        if let post_like = info.post_like{
            
            self.likeCounter = post_like
            
        }
        
        
        
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
                        
                        self.postList[indexPath.row].is_liked = "no"
                        
                    }else{
                        
                        self.likeCounter += 1
                        
                        self.postList[indexPath.row].is_liked = "yes"
                        
                    }
                }
                
                self.postList[indexPath.row].post_like = self.likeCounter
                
            }
            self.postTableView.reloadData()
        }
    }
    
    
    func commentBtnTapped(_ sender: UIButton){
        setEvent(eventName: FirebaseEventName.comment, params: ["eventId": self.eventID as NSObject])
        
        guard let indexPath = sender.tableViewIndexPath(tableView: self.postTableView) else{return}
        self.selectedIndex = indexPath.row
        let popUp = homeStoryboard.instantiateViewController(withIdentifier: "CommentID") as! CommentVC
        popUp.userDetail = self.postList[indexPath.row]
        popUp.setView = .Comment
        popUp.delegate = self
        popUp.modalPresentationStyle = .overCurrentContext
        sharedAppdelegate.nvc.pushViewController(popUp, animated: true)
    }
    
    
    func shareBtnTapped(_ sender: UIButton){
        setEvent(eventName: FirebaseEventName.share, params: ["eventId": self.eventID as NSObject])
        
        guard let indexPath = sender.tableViewIndexPath(tableView: self.postTableView) else{return}
        
        let info = self.postList[indexPath.row]
        
        var params = JSONDictionary()
        
        params["userId"] = CurrentUser.user_id ?? ""
        params["postId"] = info.forecast_id ?? ""
        
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
                    
                    self.postList[indexPath.row].is_shared = "yes"
                    self.postList[indexPath.row].share_count = count
                    
                    self.postTableView.reloadRows(at: [indexPath as IndexPath], with: .none)
                    
                }
            }
        }
    }
    
    func userProfileTapped(_ sender: UIButton){
        setEvent(eventName: FirebaseEventName.user_profile_click, params: ["eventId": self.eventID as NSObject])
        
        guard let indexPath = sender.tableViewIndexPath(tableView: self.postTableView) else{return}
        
        let data = self.postList[indexPath.row]
        
        
        if data.user_id == currentUserId(){
            
            let obj = sideMenuStoryboard.instantiateViewController(withIdentifier: "MyProfileID") as! MyProfileVC
            sharedAppdelegate.nvc.pushViewController(obj, animated: true)
            
        }else{
            
            let obj = sideMenuStoryboard.instantiateViewController(withIdentifier: "OtherUserProfileVc") as! OtherUserProfileVc
            obj.userID = userId
            sharedAppdelegate.nvc.pushViewController(obj, animated: true)
        }
    }
}



extension PostsVC: TimeLineDelegate{
    
    func setDurationData(timeLength: String, timeType: String?) {
        
    }
    
    func setStockFilterType(type: String) {
        
    }
    
    
    
    func refreshTimeline(_ info: ForecastPostDetailModel?,count: Int,isComment: Bool) {
        
        if isComment{
            
            self.postList[self.selectedIndex].is_commented = "yes"
            
        }
        
        self.postList[self.selectedIndex].post_comment = count 
        self.postTableView.reloadData()
    }
    
    
    func setTimeLineFromDetail(info: ForecastPostDetailModel) {
        
        self.postList.remove(at: self.selectedIndex)
        
        print_debug(object: self.postList)
        
        self.postList.insert(info, at: self.selectedIndex)
        
        print_debug(object: self.postList)
        self.postTableView.reloadData()
        
    }
    
}

