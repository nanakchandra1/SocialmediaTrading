//
//  PostInfoCondtnStockCell.swift
//  Mutadawel
//
//  Created by Appinventiv on 19/04/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit
import KILabel

class PostInfoCondtnStockCell: UITableViewCell {
    
    
    @IBOutlet weak var actionPostTopView: UIView!
    @IBOutlet weak var actionPostLbl: UILabel!
    
    @IBOutlet weak var lestSideView: UIView!
    
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var dotLbl: UILabel!
    
    @IBOutlet weak var userInfo: UILabel!
    @IBOutlet weak var pricewhenForecastLbl: TTTAttributedLabel!
    
    @IBOutlet weak var priceWhenForecastValue: TTTAttributedLabel!
    @IBOutlet weak var stockLbl: TTTAttributedLabel!
    
    @IBOutlet weak var stockNameLbl: TTTAttributedLabel!
    @IBOutlet weak var ifLbl: TTTAttributedLabel!
    @IBOutlet weak var ifValue: TTTAttributedLabel!
    @IBOutlet weak var before1Lbl: TTTAttributedLabel!
    @IBOutlet weak var before1date: TTTAttributedLabel!
    @IBOutlet weak var before1Img: UIImageView!
    @IBOutlet weak var thenLbl: TTTAttributedLabel!
    
    @IBOutlet weak var thenValue: TTTAttributedLabel!
    
    @IBOutlet weak var before2Lbl: TTTAttributedLabel!
    @IBOutlet weak var before2Date: TTTAttributedLabel!
    @IBOutlet weak var before2Img: UIImageView!
    @IBOutlet weak var commentLbl: TTTAttributedLabel!
    
    @IBOutlet weak var commentValue: KILabel!
    @IBOutlet weak var forecastTimeLbl: TTTAttributedLabel!
    @IBOutlet weak var forecastTimeValue: TTTAttributedLabel!
    
    @IBOutlet weak var userProfileBtn: UIButton!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postImageHeight: NSLayoutConstraint!
    
    
    @IBOutlet weak var seperatorView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var viewHeightCostant: NSLayoutConstraint!
    
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var optionBtn: UIButton!
    
    @IBOutlet weak var likersCountBtn: UIButton!
    @IBOutlet weak var commentersBtn: UIButton!
    @IBOutlet weak var sharesBtn: UIButton!
    //@IBOutlet weak var moreCountBtn: UIButton!
    @IBOutlet weak var userImageTop: NSLayoutConstraint!
    @IBOutlet weak var postActionUsername: UILabel!
    
    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var commentUserImg: UIImageView!
    @IBOutlet weak var commentUsernameLbl: UILabel!
    @IBOutlet weak var followerCommentLbl: UILabel!
    @IBOutlet weak var commentCommentBtn: UIButton!
    
    @IBOutlet weak var borderView: UIView!
    
    @IBOutlet weak var postUserImgLeft: NSLayoutConstraint!
    @IBOutlet weak var constViewRight: NSLayoutConstraint!
    @IBOutlet weak var constViewBottom: NSLayoutConstraint!
    @IBOutlet weak var masterViewWithActhonViewTop: NSLayoutConstraint!
    @IBOutlet weak var masterViewTop: NSLayoutConstraint!
    @IBOutlet weak var masterView: UIView!
    
    var actionPostType = ""
    var likeUsername = ""
    var commentUsername = ""
    var replayUsername = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.stockLbl.text = STOCK.localized
        self.commentLbl.text = COMMENT.localized
        self.before1Lbl.text = BEFORE.localized
        self.before2Lbl.text = BEFORE.localized
        self.forecastTimeLbl.text = FORECAST_TIME.localized
        self.pricewhenForecastLbl.text = PRICE_WHEN_FORECAST.localized
        self.ifLbl.text = IF.localized
        self.thenLbl.text = THEN.localized
        self.dotLbl.layer.cornerRadius = 2.5
        self.dotLbl.layer.masksToBounds = true
        
        if sharedAppdelegate.appLanguage == .Arabic{
            self.commentValue.textAlignment = .right
            self.likersCountBtn.contentHorizontalAlignment = .right
            self.sharesBtn.contentHorizontalAlignment = .right
            self.commentersBtn.contentHorizontalAlignment = .right
        }else{
            self.commentValue.textAlignment = .left
            self.likersCountBtn.contentHorizontalAlignment = .left
            self.sharesBtn.contentHorizontalAlignment = .left
            self.commentersBtn.contentHorizontalAlignment = .left
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    
    func setupView(){
        self.userImg.layer.cornerRadius = 20
        self.userImg.layer.masksToBounds = true
        //self.lestSideView.backgroundColor = UIColor.green
    }
    
    
    func populateView(index: IndexPath, info: ForecastPostDetailModel){
        
        if let user_name = info.user_name {
            self.userName.text = user_name
        }
        
        if let caption = info.caption {
            
            //            if caption == ""{
            //                self.commentLbl.text = ""
            //                self.commentValue.text = ""
            //
            //            }else{
            self.commentValue.text = caption
            
            //            }
        }
        
        if let actionPostType1 = info.action_post_type{
            actionPostType = actionPostType1
        }
        if let username1 = info.like_user_name{
            likeUsername = username1
        }
        if let comment_username = info.comment_user_name{
            commentUsername = comment_username
        }
        if let replay_username = info.reply_user_name{
            replayUsername = replay_username
        }
        
        if actionPostType == "1"{
            
            self.commentView.isHidden = true
            self.borderView.isHidden = true
            self.masterViewTop.constant = 30
            self.masterViewWithActhonViewTop.constant = 0
            self.postUserImgLeft.constant = 15
            self.constViewRight.constant = 15
            self.constViewBottom.constant = 0
            self.actionPostTopView.isHidden = false
            self.actionPostLbl.text = " \(commentOnPost.localized)"
            self.postActionUsername.text = "\(commentUsername)"
            
        }else if actionPostType == "2"{
            
            self.actionPostTopView.isHidden = false
            self.commentView.isHidden = false
            self.borderView.isHidden = false
            self.masterViewTop.constant = 110
            self.masterViewWithActhonViewTop.constant = 80
            self.postUserImgLeft.constant = 60
            self.constViewRight.constant = 40
            self.constViewBottom.constant = 10
            self.borderView.layer.borderWidth = 1
            self.borderView.layer.borderColor = UIColor.gray.cgColor
            self.borderView.layer.opacity = 8
            self.actionPostLbl.text = " \(replyOnComment.localized)"
            self.postActionUsername.text = "\(replayUsername)"
            
            if let img = info.reply_user_img{
                let imageUrl = URL(string: img)
                self.commentUserImg.sd_setImage(with: imageUrl, placeholderImage: #imageLiteral(resourceName: "ic_following_placeholder"))
            }
            
            if let username = info.reply_user_name{
                self.commentUsernameLbl.text = username
            }
            
            if let reply = info.follower_reply{
                self.followerCommentLbl.text = reply
            }
            
        }else if actionPostType == "3"{
            
            self.commentView.isHidden = true
            self.borderView.isHidden = true
            self.masterViewTop.constant = 30
            self.masterViewWithActhonViewTop.constant = 0
            self.postUserImgLeft.constant = 15
            self.constViewRight.constant = 15
            self.constViewBottom.constant = 0
            self.actionPostTopView.isHidden = false
            self.actionPostLbl.text = " \(likeOnPost.localized)"
            self.postActionUsername.text = "\(likeUsername)"
            
        }else{
            
            self.commentView.isHidden = true
            self.borderView.isHidden = true
            self.masterViewTop.constant = 0
            self.userImageTop.constant = 15
            self.postUserImgLeft.constant = 15
            self.constViewRight.constant = 15
            self.constViewBottom.constant = 0
            self.actionPostTopView.isHidden = true
            self.commentView.isHidden = true
        }
        
        if let post_like = info.post_like {
            self.likersCountBtn.setTitle("\(post_like)", for: UIControlState.normal)
        }
        
        if let post_comment = info.post_comment {
            self.commentersBtn.setTitle("\(post_comment)", for: UIControlState.normal)
        }
        
        if let condition1 = info.condition1 {
            self.ifValue.text = "\(condition1)"
        }
        
        if let before1 = info.before1 {
            self.before1date.text = "\(before1)"
        }
        
        if let before2 = info.before2 {
            self.before2Date.text = "\(before2)"
        }
        
        if let condition2 = info.condition2 {
            self.thenValue.text = "\(condition2)"
        }
        
        if let is_share = info.is_shared {
            if is_share == "yes"{
                self.shareBtn.isSelected = true
            }else{
                self.shareBtn.isSelected = false
            }
        }
        
        if let share_count = info.share_count {
            self.sharesBtn.setTitle("\(share_count)", for: .normal)
        }
        
        if let is_commented = info.is_commented {
            if is_commented == "yes"{
                self.commentBtn.isSelected = true
            }else{
                self.commentBtn.isSelected = false
            }
        }
        
        if let price = info.price {
            self.priceWhenForecastValue.text = "\(price)"
        }
        
        if let stock_name = info.stock_name {
            self.stockNameLbl.text = "\(stock_name)"
        }
        
        if let created_at = info.created_at {
            self.userInfo.text = created_at
        }
        if let created_date = info.created_date {
            self.forecastTimeValue.text = setDateFormateWithTimeZone(dateString: created_date)
            let time = setDateFormate(dateString: created_date)
            self.userInfo.text = time
        }
        
        if let is_liked = info.is_liked {
            if is_liked == "yes"{
                self.likeBtn.isSelected = true
            }else{
                self.likeBtn.isSelected = false
            }
        }
        
        if info.user_id == currentUserId(){
            self.optionBtn.isHidden = true
        }else{
            self.optionBtn.isHidden = false
        }
        
        if let img = info.profile_pic{
            let imageUrl = URL(string: img)
            self.userImg.sd_setImage(with: imageUrl, placeholderImage: #imageLiteral(resourceName: "ic_following_placeholder"))
        }
        
        if let image = info.image{
            
            if image != ""{
                
                let url = URL(string: image)
                
                if url != nil{
                    
                    self.postImageHeight.constant = 155
                    
                    self.postImage.sd_setImage(with: url)
                }
            }else{
                self.postImageHeight.constant = 0
            }
        }else{
            self.postImageHeight.constant = 0
        }
        
        if let if_mark = info.if_mark{
            if "\(if_mark)" == Status.zero{
                self.before1Img.image = PostStatusImages.watch
            }else if "\(if_mark)" == Status.one{
                self.before1Img.image = PostStatusImages.right_tick
            }else if "\(if_mark)" == Status.two{
                self.before1Img.image = PostStatusImages.cross
            }
        }
        
        if let then_mark = info.then_mark{
            if "\(then_mark)" == Status.zero{
                self.before2Img.image = PostStatusImages.watch
            }else if "\(then_mark)" == Status.one{
                self.before2Img.image = PostStatusImages.right_tick
            }else if "\(then_mark)" == Status.two{
                self.before2Img.image = PostStatusImages.cross
            }
        }
    }
}
