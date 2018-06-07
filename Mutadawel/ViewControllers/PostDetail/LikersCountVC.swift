////
////  LikersCountVC.swift
////  Mutadawel
////
////  Created by apple on 03/05/17.
////  Copyright © 2017 Appinventiv. All rights reserved.
////
//
//import UIKit
//
//class LikersCountVC: UIViewController {
//
//    //MARK:-  IBOutlets
//    //MARK:- ================================
//
//    @IBOutlet weak var likersTableView: UITableView!
//    @IBOutlet weak var bgView: UIView!
//    
//    
//    //MARK:-  Properties
//    //MARK:- ================================
//
//    var likersInfoList = JSONDictionaryArray()
//    var postId = ""
//    
//    
//    //MARK:-  View life cycle
//    //MARK:- ================================
//
//    
//    override func viewDidLoad() {
//        
//        super.viewDidLoad()
//        
//        self.getLikersList()
//        self.bgView.layer.cornerRadius = 3
//        self.bgView.layer.masksToBounds = true
//
//        self.likersTableView.delegate = self
//        
//        self.likersTableView.dataSource = self
//        self.likersTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
//        // Do any additional setup after loading the view.
//    }
//
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//    
//    
//    //MARK:-  Methods
//    //MARK:- ================================
//
//    
//    func getLikersList(){
//    
//        var params = JSONDictionary()
//        
//        if CurrentUser.user_id != nil{
//            params["userId"] = CurrentUser.user_id as AnyObject
//        }
//        params["postId"] = self.postId as AnyObject
//        
//        likersListAPI(params: params) { (success, msg, data) in
//            
//            if success{
//                
//                self.likersInfoList = data!
//                
//                self.likersTableView.reloadData()
//                
//            }
//            self.showNodata()
//        }
//    }
//    
//    
//    func showNodata(){
//        
//        if self.likersInfoList.isEmpty{
//            
//            self.likersTableView.backgroundView = makeLbl(view: self.likersTableView, msg: No_Likes_on_this_post_yet.localized)
//            
//            self.likersTableView.backgroundView?.isHidden = false
//            
//        }else{
//            
//            self.likersTableView.backgroundView?.isHidden = true
//        }
//    }
//    
//    //MARK:-  IBActions
//    //MARK:- ================================
//    
//    @IBAction func closeBtnTapped(_ sender: UIButton) {
//        sharedAppdelegate.nvc.popViewController(animated: true)
//    }
//
//
//}
//
//
////MARK:- Table view delegate and datasource
////MARK:- ================================
//
//extension LikersCountVC: UITableViewDelegate,UITableViewDataSource{
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.likersInfoList.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "LikersCell", for: indexPath) as! LikersCell
//        cell.populateData(info: self.likersInfoList[indexPath.row])
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        
//        return 55
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let data = self.likersInfoList[indexPath.row]
//        
//        guard let user_id = data["user_id"] else {return}
//        self.gotoProfile(user_id: "\(user_id)")
//    }
//    
//    func gotoProfile(user_id: String){
//        
//        if CurrentUser.user_id != nil{
//            
//            if "\(user_id)" == CurrentUser.user_id{
//                
//                let obj = sideMenuStoryboard.instantiateViewController(withIdentifier: "MyProfileID") as! MyProfileVC
//                
//                sharedAppdelegate.nvc.pushViewController(obj, animated: true)
//                
//            }else{
//                
//                let obj = sideMenuStoryboard.instantiateViewController(withIdentifier: "OtherUserProfileVc") as! OtherUserProfileVc
//                
//                obj.userID = "\(user_id)"
//                
//                sharedAppdelegate.nvc.pushViewController(obj, animated: true)
//            }
//        }
//        
//    }
//
//}
//
//
//
//class LikersCell: UITableViewCell {
//    
//    @IBOutlet weak var userImg: UIImageView!
//    @IBOutlet weak var userName: UILabel!
//    
//    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        self.userImg.layer.cornerRadius = 20
//        self.userImg.layer.masksToBounds = true
//    }
//    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//    }
//    
//    
//    func populateData(info: JSONDictionary){
//    
//        
//        if let name = info["user_name"] as? String{
//            
//            self.userName.text = name
//            
//        }
//        
//        if let img = info["profile_pic"] as? String{
//            
//            let imageUrl = URL(string: img)
//            
//            self.userImg.sd_setImage(with: imageUrl, placeholderImage: #imageLiteral(resourceName: "ic_following_placeholder"))
//        }
//
//    }
//}

