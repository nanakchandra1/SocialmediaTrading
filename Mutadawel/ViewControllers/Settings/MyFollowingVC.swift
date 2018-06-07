//
//  MyFollowingVC.swift
//  Mutadawel
//
//  Created by Appinventiv on 07/02/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

enum UserType {
    
    case User,Following
    
}

class MyFollowingVC: UIViewController {
    
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var navigationTitle: UILabel!
    @IBOutlet weak var followingTableView: UITableView!
    
    
    var selectedIndexPath = [Int]()
    var followingList = [FollowedUserModel]()
    var userID: Int!
    var userType = UserType.Following
    var eventId = "following"
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.initialViewStup()
        // Do any additional setup after loading the view.
        
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
    }
    
    
    func initialViewStup(){
        
        self.backBtn.rotateBackImage()
        //self.navigationTitle.text = MY_FOLLOWING.localized
        
        if self.userType == .Following{
            
            self.navigationTitle.text = MY_FOLLOWING.localized
            
        }else{
            
            self.navigationTitle.text = USER_LIST.localized
            
        }
        
        
        self.followingTableView.delegate = self
        self.followingTableView.dataSource = self
        self.followingTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.navigationTitle.font = setNavigationTitleFont()
        self.navigationView.backgroundColor = AppColor.navigationBarColor
        self.followingTableView.register(UINib(nibName: "FollwersInfoCell", bundle: nil), forCellReuseIdentifier: "FollwersInfoCell")
        self.getFollowingList()
        
    }
    
    
    private func getFollowingList(){
        
        var params = JSONDictionary()
        
        params["myId"] = CurrentUser.user_id ?? ""
        params["userId"] = self.userID
        
        showLoader()
        followingListAPI(params: params) { (success, msg, data) in
            
            hideLoader()
            if success{
                
                self.followingList = data!.map({ (user) -> FollowedUserModel in
                    FollowedUserModel(withData: user)
                })
            }
            
            self.shownoData()
            self.followingTableView.reloadData()
            
            
        }
    }
    
    
    func shownoData(){
        
        if self.followingList.isEmpty{
            self.followingTableView.backgroundView = makeLbl(view: self.view, msg: Your_are_not_following_anyone.localized)
            self.followingTableView.backgroundView?.isHidden = false
        }else{
            self.followingTableView.backgroundView?.isHidden = true
        }
        
    }
    
    
    
    func follow_UnFollow_Friend(index: Int,url:String){
        
        var params = JSONDictionary()
        
        
        params["follower_id"] = CurrentUser.user_id ?? ""
        
        params["following_id"] = self.followingList[index].user_id
        
        showLoader()
        chooseFriendAPI(params: params,url:url) { (success, msg, data) in
            hideLoader()
            if success{
                
                if let is_following =  self.followingList[index].is_following{
                    
                    if is_following.lowercased() == "yes"{
                        
                        self.followingList[index].is_following = "no"
                        
                    }else{
                        
                        self.followingList[index].is_following = "yes"
                    }
                    self.followingTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
                    
                }
                
            }
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

extension MyFollowingVC: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.followingList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 80
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FollwersInfoCell", for: indexPath) as! FollwersInfoCell
        cell.followBtn.addTarget(self, action: #selector(ChoosePeopleVC.followBtnTappedBtnTapped), for: .touchUpInside)
        let data = self.followingList[indexPath.row]
        cell.populateView(index: indexPath.row, userInfo: data, selectedIndexPath: self.selectedIndexPath, userListType: self.userType)
        
        cell.setLayout()
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedUserInfo = self.followingList[indexPath.row]
        setEvent(eventName: FirebaseEventName.click_on_user_picture, params: ["eventId": self.eventId as NSObject])
        
        if self.userType == .Following{
            
            
            if selectedUserInfo.user_id == currentUserId() {
                
                let obj = sideMenuStoryboard.instantiateViewController(withIdentifier: "MyProfileID") as! MyProfileVC
                
                sharedAppdelegate.nvc.pushViewController(obj, animated: true)
                
            }else{
                
                let obj = sideMenuStoryboard.instantiateViewController(withIdentifier: "OtherUserProfileVc") as! OtherUserProfileVc
                
                obj.userID = selectedUserInfo.user_id
                
                sharedAppdelegate.nvc.pushViewController(obj, animated: true)
                
            }
        }else{
            
            let vc = AppStoryboard.ChatView.instance.instantiateViewController(withIdentifier: "ChatViewControllerSwift") as! ChatViewControllerSwift
            
            vc.user_id = CurrentUser.user_id ?? ""
            vc.other_user_id = "\(selectedUserInfo.user_id!)"
            vc.otherUserName = selectedUserInfo.name ?? ""
            vc.otherUserProfileImageUrl = selectedUserInfo.profile_pic ?? ""
            
            _ = self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    
    //Target methods
    
    func followBtnTappedBtnTapped(_ sender: UIButton){
        
        guard let indexPath = sender.tableViewIndexPath(tableView: self.followingTableView) else{return}
        
        if let is_following =  self.followingList[indexPath.row].is_following{
            
            if is_following.lowercased() == "yes"{
                setEvent(eventName: FirebaseEventName.unfollow_user, params: ["eventId": self.eventId as NSObject])
                
                self.follow_UnFollow_Friend(index: indexPath.row, url: EndPoint.unfollowFriendURL)
                
            }else{
                setEvent(eventName: FirebaseEventName.follow_user, params: ["eventId": self.eventId as NSObject])
                
                self.follow_UnFollow_Friend(index: indexPath.row, url: EndPoint.chooseFriendURL)
                
            }
        }
    }
    
    
}
