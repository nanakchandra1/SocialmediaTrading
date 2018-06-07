//
//  PostInfoCell.swift
//  Mutadawel
//
//  Created by Appinventiv on 06/02/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit
import KILabel

class PostInfoCell: UITableViewCell {

    //MARK:- ==========================================================
    //MARK:- IBOutlets
	
	@IBOutlet weak var actionPostTopView: UIView!
	@IBOutlet weak var actionPostLbl: UILabel!
	
    @IBOutlet weak var lestSideView: UIView!
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var dotLbl: UILabel!
    @IBOutlet weak var distanceLbl: UILabel!
    @IBOutlet weak var forecastTimeLabel: TTTAttributedLabel!
    @IBOutlet weak var forecastTimeValue: TTTAttributedLabel!
    @IBOutlet weak var stockLabel: TTTAttributedLabel!
    @IBOutlet weak var stockValue: TTTAttributedLabel!
    @IBOutlet weak var beforeLabel: TTTAttributedLabel!
    @IBOutlet weak var beforeValue: TTTAttributedLabel!
    @IBOutlet weak var beforeImg: UIImageView!
    @IBOutlet weak var priceWhenForecast: TTTAttributedLabel!
    @IBOutlet weak var forecastPriceLabel: TTTAttributedLabel!
    @IBOutlet weak var priceWhenForecastValue: TTTAttributedLabel!
    @IBOutlet weak var forecastPriceValue: TTTAttributedLabel!
	@IBOutlet weak var CurrentPrice: TTTAttributedLabel!
	@IBOutlet weak var CurrentPriceValue: TTTAttributedLabel!
	@IBOutlet weak var currentPriceView: UIStackView!
	
	
    @IBOutlet weak var commentLabel: TTTAttributedLabel!
    @IBOutlet weak var commentValue: KILabel!
    @IBOutlet weak var userProfileBtn: UIButton!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postImageHeight: NSLayoutConstraint!
    
    @IBOutlet weak var seperatorView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var viewHeightConstant: NSLayoutConstraint!
    
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
	@IBOutlet weak var stackViewRight: NSLayoutConstraint!
	@IBOutlet weak var stackViewBottom: NSLayoutConstraint!
	@IBOutlet weak var masterViewWithActhonViewTop: NSLayoutConstraint!
	@IBOutlet weak var masterViewTop: NSLayoutConstraint!
	
	@IBOutlet weak var masterView: UIView!
	
	
	var actionPostType = ""
	var likeUsername = ""
	var commentUsername = ""
	var replayUsername = ""
	var forecastDetail = JSONDictionary()
	var params = JSONDictionary()
    var userID : Int = 0
	
    override func awakeFromNib() {
        super.awakeFromNib()
		
		
		//self.CurrentPrice.isHidden = true
		//self.CurrentPriceValue.isHidden = true
		self.currentPriceView.isHidden = true
		
        self.stockLabel.text = STOCK.localized
        self.commentLabel.text = COMMENT.localized
        self.beforeLabel.text = BEFORE.localized
        self.forecastTimeLabel.text = FORECAST_TIME.localized
        self.priceWhenForecast.text = PRICE_WHEN_FORECAST.localized
        self.forecastPriceLabel.text = "\(FORECAST_PRICE.localized)"
		self.CurrentPrice.text = CURRENT_PRICE.localized
        self.dotLbl.layer.cornerRadius = 2.5
        self.dotLbl.layer.masksToBounds = true

        if sharedAppdelegate.appLanguage == .Arabic
        {
			
			self.forecastPriceValue.textAlignment = NSTextAlignment.right
			self.forecastPriceValue.textAlignment = NSTextAlignment.right
			
			self.commentValue.textAlignment = .right
			self.likersCountBtn.contentHorizontalAlignment = .right
            self.sharesBtn.contentHorizontalAlignment = .right
            self.commentersBtn.contentHorizontalAlignment = .right
            
            
        }else{
			
			self.forecastPriceLabel.textAlignment = .left
			self.forecastPriceValue.textAlignment = .left
			
            self.commentValue.textAlignment = .left
            self.likersCountBtn.contentHorizontalAlignment = .left
            self.sharesBtn.contentHorizontalAlignment = .left
            self.commentersBtn.contentHorizontalAlignment = .left
        }
		
		// Initialization code
    }

    override func prepareForReuse() {
        
        super.prepareForReuse()

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    //MARK:- ==========================================================
    //MARK:- Private Methods
    
    func setupView(){
    
        self.userImg.layer.cornerRadius = 20
        self.userImg.layer.masksToBounds = true
        //self.lestSideView.backgroundColor = UIColor.green
    }
	
	
    
    func populateView(index: IndexPath, info: ForecastPostDetailModel){
		
			self.userID = info.user_id 
            self.userNameLbl.text = info.user_name ?? ""
            self.commentValue.text = info.caption ?? ""
			actionPostType = info.action_post_type ?? ""
			
			likeUsername = info.like_user_name ?? ""
			
			commentUsername = info.comment_user_name ?? ""
			
			replayUsername = info.reply_user_name ?? ""
        
        if let post_like = info.post_like {
            self.likersCountBtn.setTitle("\(post_like)", for: UIControlState.normal)
        }
        
        if let post_comment = info.post_comment {
            self.commentersBtn.setTitle("\(post_comment)", for: UIControlState.normal)
        }

        if let stock_name = info.stock_name  {
            self.stockValue.text = "\(stock_name)"
        }

        if let forecast_price = info.forecast_price {
            self.forecastPriceValue.text = "\(forecast_price)"
        }
		
        if let price = info.price{
            self.priceWhenForecastValue.text = "\(price)"
        }

        
        if let before1 = info.before1 {
            
            self.beforeValue.text = before1
            
        }

        if let created_date = info.created_date{
            
            self.forecastTimeValue.text = setDateFormateWithTimeZone(dateString: created_date)
            self.distanceLbl.text = setDateFormate(dateString: created_date)
            
        }
        
			if actionPostType == "1"{
				
				self.commentView.isHidden = true
				self.borderView.isHidden = true
				self.masterViewTop.constant = 30
				self.masterViewWithActhonViewTop.constant = 0
				self.postUserImgLeft.constant = 15
				self.stackViewRight.constant = 15
				self.stackViewBottom.constant = 0
				
				
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
				self.stackViewRight.constant = 40
				self.stackViewBottom.constant = 10
				
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
				self.stackViewRight.constant = 15
				self.stackViewBottom.constant = 0
				
				
				self.actionPostTopView.isHidden = false
				self.actionPostLbl.text = " \(likeOnPost.localized)"
				self.postActionUsername.text = "\(likeUsername)"
			}else{
			
			self.commentView.isHidden = true
			self.borderView.isHidden = true
			self.masterViewTop.constant = 0
			self.userImageTop.constant = 15
			self.postUserImgLeft.constant = 15
			self.stackViewRight.constant = 15
			self.stackViewBottom.constant = 0
			
			
			self.commentView.isHidden = true
			self.actionPostTopView.isHidden = true
		}
		
        if let is_commented = info.is_commented {
            
            if is_commented == "yes"{
                
                self.commentBtn.isSelected = true
                
            }else{
                
                self.commentBtn.isSelected = false
                
            }
        }

        if let img = info.profile_pic{
            
            let imageUrl = URL(string: img)
            self.userImg.sd_setImage(with: imageUrl, placeholderImage: #imageLiteral(resourceName: "ic_following_placeholder"))
        }
        
        if let is_liked = info.is_liked {
            
            if is_liked == "yes"{
                
                self.likeBtn.isSelected = true
                
            }else{
                
                self.likeBtn.isSelected = false
                
            }
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

        
        if info.user_id  == currentUserId(){
            
            self.optionBtn.isHidden = true
            //self.moreCountBtn.isHidden = true

            
        }else{
            
            self.optionBtn.isHidden = false
            //self.moreCountBtn.isHidden = false
            
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
        
            if price_mark == Status.zero{
            
                self.setStatusMark(PostStatusImages.watch!)
                
            }else if "\(price_mark)" == Status.one{
                self.setStatusMark(PostStatusImages.right_tick!)
                
                self.commentView.isHidden = true
                self.borderView.isHidden = true
                self.masterViewTop.constant = 30
                self.masterViewWithActhonViewTop.constant = 0
                self.postUserImgLeft.constant = 15
                self.stackViewRight.constant = 15
                self.stackViewBottom.constant = 0
                
                
                self.actionPostTopView.isHidden = false
                self.actionPostLbl.isHidden = true
                self.postActionUsername.text = "\(forecastSuccess.localized)"
//                self.postActionUsername.font = UIFont.init(name: "System", size: 13)
                }else if "\(price_mark)" == Status.two{
				
					self.setStatusMark(PostStatusImages.cross!)
                
                self.commentView.isHidden = true
                self.borderView.isHidden = true
                self.masterViewTop.constant = 30
                self.masterViewWithActhonViewTop.constant = 0
                self.postUserImgLeft.constant = 15
                self.stackViewRight.constant = 15
                self.stackViewBottom.constant = 0
                
                
                self.actionPostTopView.isHidden = false
                self.actionPostLbl.isHidden = true
                self.postActionUsername.text = "\(forecastFailed.localized)"
//                self.postActionUsername.font = UIFont.init(name: "System", size: 13)
				}
        }
    }
    
    func setStatusMark(_ right: UIImage){
    
        self.beforeImg.image = right
    }
}
