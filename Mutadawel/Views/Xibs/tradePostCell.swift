//
//  tradePostCell.swift
//  Mutadawel
//
//  Created by MOMO on 9/15/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit
import KILabel

class tradePostCell: UITableViewCell {
	
	@IBOutlet weak var userImg: UIImageView!
	@IBOutlet weak var usernameLbl: UILabel!
	@IBOutlet weak var distanceLbl: UILabel!
	@IBOutlet weak var userProfileBtn: UIButton!

	
	@IBOutlet weak var stockName: UILabel!
	@IBOutlet weak var BuyOrSellMessageLbl: UILabel!
	@IBOutlet weak var numberOfStocks: UILabel!
	
	@IBOutlet weak var numOfStocksLbl: UILabel!
	@IBOutlet weak var stockLbl: UILabel!
	@IBOutlet weak var priceOfOneStock: UILabel!
	@IBOutlet weak var priceOfStockLbl: UILabel!
	
	@IBOutlet weak var lastQuantity: UILabel!
	@IBOutlet weak var numberOfLastQuantity: UILabel!
	
	
	@IBOutlet weak var likeBtn: UIButton!
	@IBOutlet weak var commentBtn: UIButton!
	@IBOutlet weak var shareBtn: UIButton!
	@IBOutlet weak var optionBtn: UIButton!
	
	@IBOutlet weak var likersCountBtn: UIButton!
	@IBOutlet weak var commentersBtn: UIButton!
	@IBOutlet weak var sharesBtn: UIButton!
	
	@IBOutlet weak var actionPostTopView: UIView!
	@IBOutlet weak var postActionUsername: UILabel!
	@IBOutlet weak var actionPostLbl: UILabel!
	@IBOutlet weak var userImageTop: NSLayoutConstraint!
	
	@IBOutlet weak var commentView: UIView!
	
	@IBOutlet weak var commentUsernameLbl: UILabel!
	@IBOutlet weak var followerCommentLbl: UILabel!
	@IBOutlet weak var commentCommentBtn: UIButton!
	
	@IBOutlet weak var borderView: UIView!
	
	@IBOutlet weak var postUserImgLeft: NSLayoutConstraint!
	@IBOutlet weak var stackViewRight: NSLayoutConstraint!
	@IBOutlet weak var stackViewBottom: NSLayoutConstraint!
	@IBOutlet weak var masterViewWithActhonViewTop: NSLayoutConstraint!
	
	@IBOutlet weak var followerUserImg: UIImageView!
	
	@IBOutlet weak var masterViewTop: NSLayoutConstraint!
	
	@IBOutlet weak var masterView: UIView!
	
	@IBOutlet weak var succeededMark: UIImageView!
	
	var stock_name_en = ""
	var stock_name_ar = ""
	var buyOrSell = 0
	
	var actionPostType = ""
	var likeUsername = ""
	var commentUsername = ""
	var replayUsername = ""
	var walletIncrease :Double = 0
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		
		self.userImg.layer.cornerRadius = 20
		self.userImg.layer.masksToBounds = true
		self.stockLbl.text = "\(STOCK.localized): "
		self.numOfStocksLbl.text = "\(NUMBER_OF_STOCKS.localized) "
		self.priceOfStockLbl.text = "\(PRICE_OF_ONE_STOCK.localized):"
		self.lastQuantity.text = "\(LAST_QUANTITY.localized)"
		
		if sharedAppdelegate.appLanguage == .Arabic
		{
			self.numberOfStocks.textAlignment = .right
			self.likersCountBtn.contentHorizontalAlignment = .right
			self.sharesBtn.contentHorizontalAlignment = .right
			self.commentersBtn.contentHorizontalAlignment = .right
			
			
		}else{
			self.numberOfStocks.textAlignment = .left
			self.likersCountBtn.contentHorizontalAlignment = .left
			self.sharesBtn.contentHorizontalAlignment = .left
			self.commentersBtn.contentHorizontalAlignment = .left
			
		}
		
    }
	
	override func prepareForReuse() {
		
		super.prepareForReuse()
		
	}

	func setupView(){
		
		self.userImg.layer.cornerRadius = 20
		self.userImg.layer.masksToBounds = true
	}
	
	func populateView(index: IndexPath, info: ForecastPostDetailModel){
		
			self.usernameLbl.text = info.user_name ?? ""
		
		if let post_like = info.post_like {
			self.likersCountBtn.setTitle("\(post_like)", for: UIControlState.normal)
		}
		
		if let post_comment = info.post_comment {
			self.commentersBtn.setTitle("\(post_comment)", for: UIControlState.normal)
		}
		
		if let stock_name = info.trade_stock_name_en{
			
			self.stock_name_en = stock_name
		}
		
		if let stock_name = info.trade_stock_name_ar{
			
			self.stock_name_ar = stock_name
		}
		
		if sharedAppdelegate.appLanguage == .Arabic{
			
			self.stockName.text = stock_name_ar
		}else{
		
			self.stockName.text = stock_name_en
		}
		
		if let stock_price = info.trade_stock_price{
			
			self.priceOfOneStock.text = "\(stock_price)"
		}
		
		if let quantityOfStocks = info.trade_stock_quantity{
			
			self.numberOfStocks.text = "\(quantityOfStocks)"
		}
		
		if let sell_or_buy = info.trade_stock_buy_or_sell{
		
			self.buyOrSell = sell_or_buy
		}
		
		if buyOrSell != 0{
		
			if buyOrSell == 2{
			
				if let wallet_increase = info.trade_stock_total_wallet_increase {
					
					walletIncrease = wallet_increase
				}
				
				self.lastQuantity.text = "\(DATE_OF_FIRST_BUYING.localized)"
				
				
				
				if walletIncrease > 0 {
					
					self.BuyOrSellMessageLbl.text = "\(SELLING_SUCCEEDED.localized) \(walletIncrease) \(REAL_S.localized)"
					self.BuyOrSellMessageLbl.textColor = #colorLiteral(red: 0.1764705882, green: 0.8235294118, blue: 0.231372549, alpha: 1)
					
				}else if walletIncrease < 0 {
					
					self.BuyOrSellMessageLbl.text = "\(SELLING_WITH_LOSS.localized) \(abs(walletIncrease)) \(REAL_S.localized)"
					self.BuyOrSellMessageLbl.textColor = self.lastQuantity.textColor
					
				}else{
					
					self.BuyOrSellMessageLbl.textColor = #colorLiteral(red: 0.7719748432, green: 0.2767672807, blue: 0.3290739721, alpha: 1)
					self.BuyOrSellMessageLbl.text = "\(JUST_SELLING.localized)"
					
				}
				
				if let stockDate = info.trade_stock_date{
					
					self.numberOfLastQuantity.text = stockDate
				}
				
				//self.BuyOrSellMessageLbl.textColor = self.lastQuantity.textColor
				let img = #imageLiteral(resourceName: "ic_tick_")
				self.succeededMark.image = img
				
			}else if buyOrSell == 1{
			
				if let previous_quantity = info.previous_quantity {
				
					self.numberOfLastQuantity.text = "\(previous_quantity)"
				}
				
				self.lastQuantity.text = "\(LAST_QUANTITY.localized)"
				self.BuyOrSellMessageLbl.text = "\(BUYING_SUCCEEDED.localized)"
				self.BuyOrSellMessageLbl.textColor = self.usernameLbl.textColor
				let img = #imageLiteral(resourceName: "ic_tick_")
				self.succeededMark.image = img
			}
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
					self.followerUserImg.sd_setImage(with: imageUrl, placeholderImage: #imageLiteral(resourceName: "ic_following_placeholder"))
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
		
		if let created_date = info.created_date {
			
			self.distanceLbl.text = setDateFormate(dateString: created_date)
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
		
		
		if info.user_id == currentUserId(){
			
			self.optionBtn.isHidden = true
			//self.moreCountBtn.isHidden = true
			
			
		}else{
			
			self.optionBtn.isHidden = false
			//self.moreCountBtn.isHidden = false
			
			
		}
		
	}
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
