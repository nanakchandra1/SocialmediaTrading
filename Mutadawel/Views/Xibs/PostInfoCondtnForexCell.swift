//
//  PostInfoCondtnForexCell.swift
//  Mutadawel
//
//  Created by Appinventiv on 19/04/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit
import KILabel

class PostInfoCondtnForexCell: UITableViewCell {
    
    @IBOutlet weak var actionPostTopView: UIView!
    @IBOutlet weak var actionPostLbl: UILabel!
    
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var dotLbl: UILabel!
    @IBOutlet weak var userInfo: UILabel!
    @IBOutlet weak var priceWhenForecastLbl: TTTAttributedLabel!
    @IBOutlet weak var lestSideView: UIView!
    @IBOutlet weak var priceWhenForecastValue: TTTAttributedLabel!
    @IBOutlet weak var currencveLbl: TTTAttributedLabel!
    @IBOutlet weak var currwncyName: TTTAttributedLabel!
    @IBOutlet weak var priceLbl: TTTAttributedLabel!
    @IBOutlet weak var priceValue: TTTAttributedLabel!
    @IBOutlet weak var priceImg: UIImageView!
    @IBOutlet weak var beforeLbl: TTTAttributedLabel!
    @IBOutlet weak var beforeDate: TTTAttributedLabel!
    @IBOutlet weak var beforeImg: UIImageView!
    @IBOutlet weak var buyLbl: TTTAttributedLabel!
    @IBOutlet weak var stopLossLbl: TTTAttributedLabel!
    @IBOutlet weak var stopLossvalue: TTTAttributedLabel!
    @IBOutlet weak var stoplossImg: UIImageView!
    @IBOutlet weak var takeProfitLbl: TTTAttributedLabel!
    @IBOutlet weak var takeProfitValue: TTTAttributedLabel!
    @IBOutlet weak var takeProfitImg: UIImageView!
    @IBOutlet weak var commentLbl: TTTAttributedLabel!
    @IBOutlet weak var commentValue: KILabel!
    @IBOutlet weak var forecastTimeLbl: TTTAttributedLabel!
    @IBOutlet weak var forecastValueLbl: TTTAttributedLabel!
    @IBOutlet weak var userProfileBtn: UIButton!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postImageHeight: NSLayoutConstraint!
    @IBOutlet weak var seperatorView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var likersViewHeight: NSLayoutConstraint!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var optionBtn: UIButton!
    @IBOutlet weak var likersCountBtn: UIButton!
    @IBOutlet weak var commentersBtn: UIButton!
    @IBOutlet weak var sharesBtn: UIButton!
    // @IBOutlet weak var moreCountBtn: UIButton!
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
        self.currencveLbl.text = CURRENCY.localized
        self.commentLbl.text = COMMENT.localized
        self.beforeLbl.text = BEFORE.localized
        self.forecastTimeLbl.text = "\(FORECAST_TIME.localized)"
        
        self.priceWhenForecastLbl.text = PRICE_WHEN_FORECAST.localized
        self.stopLossLbl.text = STOP_LOSS.localized
        self.takeProfitLbl.text = TAKE_PROFIT.localized
        self.buyLbl.text = BUY.localized
        self.priceLbl.text = FORECASTED_PRICE.localized
        self.dotLbl.layer.cornerRadius = 2.5
        self.dotLbl.layer.masksToBounds = true
        
        
        if sharedAppdelegate.appLanguage == .Arabic
        {
            self.forecastTimeLbl.textAlignment = .left
            self.commentValue.textAlignment = .right
            self.likersCountBtn.contentHorizontalAlignment = .right
            self.sharesBtn.contentHorizontalAlignment = .right
            self.commentersBtn.contentHorizontalAlignment = .right
            
            
        }else{
            self.forecastTimeLbl.textAlignment = .right
            self.commentValue.textAlignment = .left
            self.likersCountBtn.contentHorizontalAlignment = .left
            self.sharesBtn.contentHorizontalAlignment = .left
            self.commentersBtn.contentHorizontalAlignment = .left
            
        }
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
        
        if let userId = info.user_id{
            
            if userId == currentUserId(){
                
                if let is_updatable = info.is_updatable{
                    
                    if is_updatable == "yes"{
                        
                        self.optionBtn.isHidden = false
                        //self.moreCountBtn.isHidden = false
                        
                        
                    }else{
                        
                        self.optionBtn.isHidden = true
                        // self.moreCountBtn.isHidden = true
                        
                        
                    }
                }
            }else{
                self.optionBtn.isHidden = false
                //self.moreCountBtn.isHidden = false
                
            }
        }
        
        if let user_name = info.user_name {
            self.userName.text = user_name
        }
        
        if let before1 = info.before1 {
            self.beforeDate.text = before1
        }
        
        if let caption = info.caption {
            //            if caption == ""{
            //                self.commentLbl.text = ""
            //                self.commentValue.text = ""
            //
            //            }else{
            self.commentValue.text = caption
            
            //}
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
        
        if let is_commented = info.is_commented  {
            
            if is_commented == "yes"{
                
                self.commentBtn.isSelected = true
                
            }else{
                
                self.commentBtn.isSelected = false
            }
        }
        
        
        if let buyORsell = info.buyORsell {
            
            if "\(buyORsell)" == "1"{
                
                self.buyLbl.text = BUY.localized
                self.buyLbl.textColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
                
            }else{
                
                self.buyLbl.text = SELL.localized
                self.buyLbl.textColor = #colorLiteral(red: 0.9137254902, green: 0.1215686275, blue: 0.3882352941, alpha: 1)
                
            }
        }
        
        if let forecast_price = info.forecast_price {
            self.priceValue.text = "\(forecast_price)"
        }
        
        if let price = info.price{
            self.priceWhenForecastValue.text = "\(price)"
        }
        
        
        if let currency = info.currency {
            self.currwncyName.text = "\(currency)"
        }
        
        
        if let stop_loss = info.stop_loss{
            self.stopLossvalue.text = "\(stop_loss)"
        }
        
        if let take_profit = info.take_profit {
            self.takeProfitValue.text = "\(take_profit)"
        }
        
        if let created_at = info.created_at {
            self.userInfo.text = created_at
        }
        if let created_date = info.created_date{
            self.forecastValueLbl.text = setDateFormateWithTimeZone(dateString: created_date)
            self.userInfo.text = setDateFormate(dateString: created_date)
        }
        
        if let img = info.profile_pic{
            let imageUrl = URL(string: img)
            self.userImg.sd_setImage(with: imageUrl, placeholderImage: #imageLiteral(resourceName: "ic_following_placeholder"))
        }
        
        if let is_liked = info.is_liked{
            
            if is_liked == "yes"{
                
                self.likeBtn.isSelected = true
                
            }else{
                
                self.likeBtn.isSelected = false
                
            }
        }
        
        if let is_share = info.is_shared{
            if is_share == "yes"{
                self.shareBtn.isSelected = true
            }else{
                self.shareBtn.isSelected = false
            }
        }
        
        if let share_count = info.share_count {
            
            self.sharesBtn.setTitle("\(share_count)", for: .normal)
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
        
        if let price_mark = info.entry_price_mark{
            
            if "\(price_mark)" == Status.zero{
                
                self.priceImg.image = PostStatusImages.watch
            }else if "\(price_mark)" == Status.one{
                self.priceImg.image = PostStatusImages.right_tick
                
            }else if "\(price_mark)" == Status.two{
                self.priceImg.image = PostStatusImages.cross
                
            }
        }
        
        if let before_mark = info.before_mark{
            
            if "\(before_mark)" == Status.zero{
                
                self.beforeImg.image = PostStatusImages.watch
            }else if "\(before_mark)" == Status.one{
                self.beforeImg.image = PostStatusImages.right_tick
                
            }else if "\(before_mark)" == Status.two{
                self.beforeImg.image = PostStatusImages.cross
                
            }
        }
        
        if let take_profit_mark = info.take_profit_mark{
            
            if "\(take_profit_mark)" == Status.zero{
                
                self.takeProfitImg.image = PostStatusImages.watch
            }else if "\(take_profit_mark)" == Status.one{
                self.takeProfitImg.image = PostStatusImages.right_tick
                
            }else if "\(take_profit_mark)" == Status.two{
                self.takeProfitImg.image = PostStatusImages.cross
                
            }
        }
        
        if let stop_loss_mark = info.stop_loss_mark{
            
            if "\(stop_loss_mark)" == Status.zero{
                
                self.stoplossImg.image = PostStatusImages.watch
            }else if "\(stop_loss_mark)" == Status.one{
                self.stoplossImg.image = PostStatusImages.right_tick
                
            }else if "\(stop_loss_mark)" == Status.two{
                self.stoplossImg.image = PostStatusImages.cross
                
            }
        }
        
        
    }
    
    
}
