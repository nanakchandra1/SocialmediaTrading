//
//  MyFollowersVC.swift
//  Mutadawel
//
//  Created by Appinventiv on 07/02/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit
import SDWebImage


class MyFollowersVC: MutadawelBaseVC {
    
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var navigationTitle: UILabel!
    @IBOutlet weak var followersTableView: UITableView!
    
    var selectedIndexPath = [Int]()
    var folowersList = [FollowedUserModel]()
    var userID:Int!
    var userType = UserType.Following
    var eventId = "followers"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialViewStup()
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    func initialViewStup(){
        
        self.backBtn.rotateBackImage()
        self.navigationTitle.text = FOLLOWERS.localized
        self.followersTableView.delegate = self
        self.followersTableView.dataSource = self
        if #available(iOS 10.0, *) {
            self.followersTableView.prefetchDataSource = self
        } else {
            // Fallback on earlier versions
        }
        self.followersTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.navigationTitle.font = setNavigationTitleFont()
        self.navigationView.backgroundColor = AppColor.navigationBarColor
        self.followersTableView.register(UINib(nibName: "FollwersInfoCell", bundle: nil), forCellReuseIdentifier: "FollwersInfoCell")
        self.getFollowersList()
        
    }
    
    
    private func getFollowersList(){
        
        var params = JSONDictionary()
        
        params["myId"] = CurrentUser.user_id ?? ""
        params["userId"] = self.userID
        
        showLoader()
        
        followerListAPI(params: params) { (success, msg, data) in
            hideLoader()
            
            if success{
                
                self.folowersList = data!.map({ (user) -> FollowedUserModel in
                    FollowedUserModel(withData: user)
                })
            }
            
            self.shownoData()
            self.followersTableView.reloadData()
            
        }
        
    }
    
    
    
    
    func follow_UnFollow_Friend(index: Int,url:String){
        
        var params = JSONDictionary()
        
        
        params["follower_id"] = CurrentUser.user_id ?? ""
        
        params["following_id"] = self.folowersList[index].user_id ?? ""
        
        showLoader()
        
        chooseFriendAPI(params: params,url:url) { (success, msg, data) in
            
            hideLoader()
            
            if success{
                
                if let is_following =  self.folowersList[index].is_following{
                    
                    if is_following.lowercased() == "yes"{
                        
                        self.folowersList[index].is_following = "no"
                        
                    }else{
                        
                        self.folowersList[index].is_following = "yes"
                    }
                    
                    self.followersTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
                    
                }
            }
        }
    }
    
    
    func shownoData(){
        
        if self.folowersList.isEmpty{
            self.followersTableView.backgroundView = makeLbl(view: self.view, msg: No_follewers_yet.localized)
            self.followersTableView.backgroundView?.isHidden = false
        }else{
            self.followersTableView.backgroundView?.isHidden = true
        }
    }
    
    //MARK:- ================================================
    //MARK:- IBActions
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    
}


//MARK:- ================================================
//MARK:- UItable view delegate and datasource

extension MyFollowersVC: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.folowersList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 80
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FollwersInfoCell", for: indexPath) as! FollwersInfoCell
        
        cell.followBtn.addTarget(self, action: #selector(ChoosePeopleVC.followBtnTappedBtnTapped), for: .touchUpInside)
        let data = self.folowersList[indexPath.row]
        cell.populateView(index: indexPath.row, userInfo: data, selectedIndexPath: self.selectedIndexPath, userListType: self.userType)
        
        cell.setLayout()
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let data = self.folowersList[indexPath.row]
        setEvent(eventName: FirebaseEventName.click_on_user_picture, params: ["eventId": self.eventId as NSObject])
        if data.user_id == currentUserId(){
            
            let obj = sideMenuStoryboard.instantiateViewController(withIdentifier: "MyProfileID") as! MyProfileVC
            sharedAppdelegate.nvc.pushViewController(obj, animated: true)
            
        }else{
            let obj = sideMenuStoryboard.instantiateViewController(withIdentifier: "OtherUserProfileVc") as! OtherUserProfileVc
            obj.userID = data.user_id
            sharedAppdelegate.nvc.pushViewController(obj, animated: true)
        }
    }
    
    //Target methods
    
    func followBtnTappedBtnTapped(_ sender: UIButton){
        
        guard let indexPath = sender.tableViewIndexPath(tableView: self.followersTableView) else{return}
        
        if let is_following =  self.folowersList[indexPath.row].is_following{
            
            if is_following.lowercased() == "yes"{
                setEvent(eventName: FirebaseEventName.unfollow_user, params: ["eventId": self.eventId as NSObject])
                
                self.follow_UnFollow_Friend(index: indexPath.row, url: EndPoint.unfollowFriendURL)
                
            }else{
                setEvent(eventName: FirebaseEventName.follow_user, params: ["eventId": self.eventId as NSObject])
                
                self.follow_UnFollow_Friend(index: indexPath.row, url: EndPoint.chooseFriendURL)
                
            }
        }    }
}

extension MyFollowersVC: UITableViewDataSourcePrefetching {
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        let urls = indexPaths.map { URL(string : self.folowersList[$0.row].profile_pic) }
        SDWebImagePrefetcher.shared().prefetchURLs(urls as? [URL])
    }
}
