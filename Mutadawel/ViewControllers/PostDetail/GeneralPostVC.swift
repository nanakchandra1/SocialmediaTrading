//
//  GeneralPostVC.swift
//  Mutadawel
//
//  Created by Appinventiv on 27/04/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit
import SwiftyJSON

class GeneralPostVC: UIViewController {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var dotLbl: UILabel!
    @IBOutlet var closeBtn: UIButton!
    @IBOutlet weak var distanceLbl: UILabel!
    @IBOutlet weak var likeCountLbl: UILabel!
    @IBOutlet weak var likeImg: UIImageView!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var commentImg: UIImageView!
    @IBOutlet weak var commentCountLbl: UILabel!
    @IBOutlet weak var shareImg: UIImageView!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var shareCountLbl: UILabel!
    @IBOutlet weak var optionBtn: UIButton!
    @IBOutlet weak var optionImg: UIImageView!
    @IBOutlet weak var userProfileBtn: UIButton!
    @IBOutlet weak var commentValue: UITextView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postImageHeight: NSLayoutConstraint!
    // @IBOutlet weak var commentLbl: UILabel!
    
    
    var info = ForecastPostDetailModel()
    var delegate: TimeLineDelegate!
    var likeCounter = 0
    var isLiked = false
    var postDetailType = PostDetailType.Other
    //var naigation: UINavigationController!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.setPostData()
        self.dotLbl.layer.cornerRadius = 2.5
        self.dotLbl.layer.masksToBounds = true
        self.commentValue.delegate = self
        if sharedAppdelegate.appLanguage == .Arabic{
            
            self.commentValue.textAlignment = .right
        }else{
            
            self.commentValue.textAlignment = .left
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    
    func setPostData(){
        
        self.optionBtn.isEnabled = false
        self.optionImg.isHidden = true
        self.bgView.layer.cornerRadius = 3
        self.bgView.layer.masksToBounds = true
        
        // self.commentLbl.text = COMMENT.localized
        self.closeBtn.setTitle(CLOSE.localized, for: .normal)
        self.userImg.layer.cornerRadius = self.userImg.bounds.height / 2
        self.userImg.layer.masksToBounds = true
        
        if let user_name = self.info.user_name{
            self.userNameLbl.text = user_name
        }
        if let caption = self.info.caption {
            self.commentValue.text = caption
        }
        
        if let post_like = self.info.post_like {
            
            self.likeCounter = post_like
            self.likeCountLbl.text = "\(post_like)"
            
        }
        
        if let post_comment = self.info.post_comment {
            self.commentCountLbl.text = "\(post_comment)"
        }
        
        if let img = self.info.profile_pic{
            
            let imageUrl = URL(string: img)
            
            self.userImg.sd_setImage(with: imageUrl, placeholderImage: #imageLiteral(resourceName: "ic_following_placeholder"))
        }
        
        if let share_count = self.info.share_count {
            
            self.shareCountLbl.text = "\(share_count)"
        }
        
        if let is_share = self.info.is_shared {
            
            if is_share == "yes"{
                self.shareImg.image = #imageLiteral(resourceName: "ic_home_share_select")
            }
        }
        
        if let is_commented = self.info.is_commented{
            
            if is_commented == "yes"{
                
                self.commentImg.image = #imageLiteral(resourceName: "ic_home_chat_select")
                self.commentBtn.isSelected = true
                
            }else{
                
                self.commentImg.image = #imageLiteral(resourceName: "ic_home_chat_deselect")
                self.commentBtn.isSelected = false
            }
        }
        
        if let created_date = self.info.created_date {
            self.distanceLbl.text = setDateFormate(dateString: created_date)
        }
        
        if self.info.user_id  == currentUserId(){
            
            self.optionBtn.isHidden = true
            self.optionImg.isHidden = true
        }
        
        if let image = self.info.image{
            
            if !image.isEmpty{
                
                let url = URL(string: image)
                
                if url != nil{
                    
                    //TODO: change assign the url to UIImage and use the hight and the width to post image constrans
                    
                    self.postImageHeight.constant = 330
                    
                    self.postImage.contentMode = UIViewContentMode.scaleAspectFill
                    self.postImage.sd_setImage(with: url)
                }
                
            }else{
                self.postImageHeight.constant = 0
            }
        }else{
            
            self.postImageHeight.constant = 0
        }
        
        self.setLikeUnlike()
        
    }
    
    
    
    
    func setLikeUnlike(){
        
        if let is_liked = self.info.is_liked {
            
            if is_liked == "yes"{
                
                self.isLiked = true
                
                self.likeImg.image = #imageLiteral(resourceName: "ic_home_like_select")
                
                self.likeBtn.isSelected = true
            }else{
                
                self.isLiked = false
                
                self.likeImg.image = #imageLiteral(resourceName: "ic_home_like_deselect")
                
                self.likeBtn.isSelected = false
            }
        }
    }
    
    
    func gotoProfile(user_id: Int){
        
        if user_id == currentUserId(){
            let obj = sideMenuStoryboard.instantiateViewController(withIdentifier: "MyProfileID") as! MyProfileVC
            self.navigationController?.pushViewController(obj, animated: true)
            
        }else{
            let obj = sideMenuStoryboard.instantiateViewController(withIdentifier: "OtherUserProfileVc") as! OtherUserProfileVc
            obj.userID = user_id
            self.navigationController?.pushViewController(obj, animated: true)
        }
    }
    
    //MARK:- IBActions
    //MARK:- ====================
    
    @IBAction func closeBtnTapped(_ sender: UIButton) {
        if self.postDetailType == .Other{
            
            self.delegate.setTimeLineFromDetail(info: self.info)
        }
        self.dismiss(animated: false, completion: nil)
    }
    
    
    @IBAction func userBtnTapped(_ sender: UIButton) {
        //        self.gotoProfile(user_id: self.info.user_id)
    }
    
    
    
    @IBAction func likeBtnTapped(_ sender: UIButton) {
        
        var params = JSONDictionary()
        
        params["userId"] = CurrentUser.user_id
        params["forecastId"] = self.info.forecast_id
        
        if self.isLiked{
            
            params["action"] = 2
            
        }else{
            
            params["action"] = 1
        }
        
        showLoader()
        
        saveLikeAPI(params: params) { (success, msg, data) in
            
            hideLoader()
            
            if success{
                
                if let is_liked = self.info.is_liked{
                    
                    if is_liked == "yes"{
                        
                        self.info.is_liked = "no"
                        
                        self.likeCounter -= 1
                        
                    }else{
                        
                        self.likeCounter += 1
                        
                        self.info.is_liked = "yes"
                        
                    }
                }
                
                self.info.post_like = self.likeCounter
                
                self.likeCountLbl.text = "\(self.likeCounter)"
                
                self.setLikeUnlike()
                
            }
        }
    }
    
    
    @IBAction func commentBtnTapped(_ sender: UIButton) {
        
        let popUp = homeStoryboard.instantiateViewController(withIdentifier: "CommentID") as! CommentVC
        popUp.userDetail = self.info
        popUp.setView = .Comment
        popUp.delegate = self
        //        popUp.modalPresentationStyle = .overCurrentContext
        self.navigationController?.pushViewController(popUp, animated: true)
        
    }
    
    
    @IBAction func shareBtnTapped(_ sender: UIButton) {
        
        var params = JSONDictionary()
        
        params["userId"] = CurrentUser.user_id
        
        params["postId"] = self.info.forecast_id 
        
        showLoader()
        
        sharePostAPI(params: params) { (success, msg, data) in
            
            hideLoader()
            
            if success{
                
                var count = 0
                
                count = self.info.share_count ?? 0
                count = count + 1
                
                if let html = data?["content"].string{
                    
                    let str = html.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
                    
                    displayShareSheet(shareContent: str, viewController: self)
                    
                    self.info.is_shared = "yes"
                    self.shareImg.image = #imageLiteral(resourceName: "ic_home_share_select")
                    self.info.share_count = count
                    self.shareCountLbl.text = "\(count)"
                    
                    
                }
            }
        }
        
    }
    
    
    @IBAction func moreBtnTapped(_ sender: UIButton) {
        
        
    }
    
    
}


extension GeneralPostVC : UITextViewDelegate{
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        return true
    }
}


extension GeneralPostVC : TimeLineDelegate{
    func setDurationData(timeLength: String, timeType: String?) {
        
    }
    
    func setStockFilterType(type: String) {
        
    }
    
    func setTimeLineFromDetail(info: ForecastPostDetailModel) {
        
    }
    
    
    func refreshTimeline(_ info: ForecastPostDetailModel?,count: Int,isComment: Bool) {
        
        if isComment{
            
            self.info.is_commented = "yes"
            
        }
        
        self.info.post_comment = count
        self.setPostData()
        
    }
    
}






//{
//    "action_post_type" = 1;
//    before1 = "";
//    before2 = "";
//    "before_mark" = 0;
//    buyORsell = 0;
//    caption = "\U062a\U0639\U0644\U0645\U0648 \n\nhttps://youtu.be/Lkj9UqhJ7Yc";
//    "comment_user_name" = "\U0628\U0648\U0644\U0646\U0642\U0631\U0628\U0627\U0646\U062f \U0627\U0644\U0623\U0633\U0647\U0645";
//    "comment_user_profile_pic" = "https://s3-us-west-2.amazonaws.com/tridder/android/1506690079553_image.jpg";
//    condition1 = 0;
//    condition2 = 0;
//    "created_at" = "2018-03-23 02:02";
//    "created_date" = "2018-03-23 02:02 PM";
//    currency = "";
//    duration = 0;
//    email = "fsa3009@yahoo.com";
//    "entry_price_mark" = 0;
//    "follower_comment" = "\U0627\U0644\U0627\U0633\U0645\U0627\U0643 \U062b\U0628\U0627\U062a 29 \U0647\U062f\U0641 33";
//    "follower_reply" = "";
//    "forecast_id" = 18264;
//    "forecast_price" = 0;
//    "forecast_status" = 0;
//    "from_time" = "";
//    "if_mark" = 0;
//    image = "";
//    "is_commented" = yes;
//    "is_following" = yes;
//    "is_liked" = yes;
//    "is_my_post" = no;
//    "is_shared" = no;
//    "is_updatable" = no;
//    "like_user_name" = "";
//    "parent_reply" = "";
//    "parent_reply_profile_pic" = "";
//    "parent_reply_user_name" = "";
//    "post_comment" = 3;
//    "post_like" = 2;
//    "post_type" = 1;
//    "previous_quantity" = 0;
//    price = 0;
//    "profile_pic" = "https://s3-us-west-2.amazonaws.com/tridder/android/1506690079553_image.jpg";
//    "reply_user_name" = "";
//    "share_count" = 0;
//    "stock_name" = "";
//    "stop_loss" = 0;
//    "stop_loss_mark" = 0;
//    "take_profit" = 0;
//    "take_profit_mark" = 0;
//    "then_mark" = 0;
//    "to_time" = "";
//    "trade_stock_buy_or_sell" = 0;
//    "trade_stock_date" = "";
//    "trade_stock_name_ar" = "";
//    "trade_stock_name_en" = "";
//    "trade_stock_price" = 0;
//    "trade_stock_quantity" = 0;
//    "trade_stock_total_wallet_increase" = 0;
//    type = 0;
//    "user_id" = 724;
//    "user_name" = "\U0628\U0648\U0644\U0646\U0642\U0631\U0628\U0627\U0646\U062f \U0627\U0644\U0623\U0633\U0647\U0645";
//    within1 = "";
//    within2 = "";
//},

