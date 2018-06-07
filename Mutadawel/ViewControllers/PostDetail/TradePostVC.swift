//
//  TradePostVC.swift
//  Mutadawel
//
//  Created by MOMO on 9/15/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class TradePostVC: UIViewController {
	
	
	@IBOutlet weak var userImg: UIImageView!
	@IBOutlet weak var usernameLbl: UILabel!
	@IBOutlet weak var DistanceLbl: UILabel!
	
	@IBOutlet weak var usernameBtn: UIButton!

	@IBOutlet weak var stockNameLbl: UILabel!
	@IBOutlet weak var buyOrSellMessageLbl: UILabel!
	@IBOutlet weak var quantityOfStocks: UILabel!
	@IBOutlet weak var priceOfOneStockLbl: UILabel!
	
	@IBOutlet weak var bgView: UIView!
	
	@IBOutlet weak var lastQuantityLbl: UILabel!
	@IBOutlet weak var numberOfLastQuantity: UILabel!
	
	@IBOutlet weak var likeImg: UIImageView!
	@IBOutlet weak var likeBtn: UIButton!
	@IBOutlet weak var likeCountLbl: UILabel!
	
	@IBOutlet weak var commentImg: UIImageView!
	@IBOutlet weak var commentCountLbl: UILabel!
	@IBOutlet weak var commentBtn: UIButton!
	
	@IBOutlet weak var shareImg: UIImageView!
	@IBOutlet weak var shareCountLbl: UILabel!
	@IBOutlet weak var shareBtn: UIButton!
	
	@IBOutlet weak var optionBtn: UIButton!
	@IBOutlet weak var optionImg: UIImageView!
	
	@IBOutlet weak var closeBtn: UIButton!
	
	@IBOutlet weak var stockLbl: UILabel!
	@IBOutlet weak var numOfStocksLbl: UILabel!
	@IBOutlet weak var priceOfStockLbl: UILabel!
	
	@IBOutlet weak var succeededMark: UIImageView!
	
	var stock_name_en = ""
	var stock_name_ar = ""
	var buyOrSell = 0
	
	var info = ForecastPostDetailModel()
	var delegate: TimeLineDelegate!
	var likeCounter = 0
	var isLiked = false
	var postDetailType = PostDetailType.Other
	var walletIncrease :Double = 0.0
	
    override func viewDidLoad() {
		
        super.viewDidLoad()
		
		self.setPostData()
		
		
		self.stockLbl.text = "\(STOCK.localized): "
		self.numOfStocksLbl.text = "\(NUMBER_OF_STOCKS.localized): "
		self.priceOfStockLbl.text = "\(PRICE_OF_ONE_STOCK.localized): "
		self.lastQuantityLbl.text = "\(LAST_QUANTITY.localized)"
		
		if sharedAppdelegate.appLanguage == .Arabic
		{
			self.quantityOfStocks.textAlignment = .right
			
		}else{
			
			self.quantityOfStocks.textAlignment = .left
		}
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
		
        self.usernameLbl.text = self.info.user_name
		
        self.stock_name_en = self.info.trade_stock_name_en
		
        self.stock_name_ar = self.info.trade_stock_name_ar
		
		if sharedAppdelegate.appLanguage == .Arabic{
			
            self.stockNameLbl.text = " \(stock_name_ar)"
            
		}else{
			
			self.stockNameLbl.text = " \(stock_name_en)"
		}
		
			self.priceOfOneStockLbl.text = "\(self.info.trade_stock_price ?? 0)"
		
			self.quantityOfStocks.text = "\(self.info.trade_stock_quantity ?? 0)"
		
			self.buyOrSell = self.info.trade_stock_buy_or_sell
		
		if buyOrSell != 0{
			
			if buyOrSell == 2{
				
                self.walletIncrease = self.info.trade_stock_total_wallet_increase
				
				self.lastQuantityLbl.text = "\(DATE_OF_FIRST_BUYING.localized)"
				self.buyOrSellMessageLbl.text = "\(SELLING_SUCCEEDED.localized) \(walletIncrease) \(REAL_S.localized)"
				
                self.numberOfLastQuantity.text = self.info.trade_stock_date
				
				self.buyOrSellMessageLbl.textColor = self.lastQuantityLbl.textColor
				let img = #imageLiteral(resourceName: "ic_tick_")
				self.succeededMark.image = img
				
			}else{
				
                self.numberOfLastQuantity.text = self.info.previous_quantity
				self.lastQuantityLbl.text = "\(LAST_QUANTITY.localized)"
				self.buyOrSellMessageLbl.text = "\(BUYING_SUCCEEDED.localized)"
				self.buyOrSellMessageLbl.textColor = self.usernameLbl.textColor
				let img = #imageLiteral(resourceName: "ic_tick_")
				self.succeededMark.image = img
			}
		}
		
			
			self.DistanceLbl.text = setDateFormate(dateString: self.info.created_date)
		
			self.commentCountLbl.text = "\(self.info.post_comment ?? 0)"

			if self.info.is_commented == "yes"{
				
				//self.commentImg.image = #imageLiteral(resourceName: "ic_home_chat_select")
				self.commentBtn.isSelected = true
				
			}else{
				
				//self.commentImg.image = #imageLiteral(resourceName: "ic_home_chat_deselect")
				self.commentBtn.isSelected = false
			}
		
		if let img = self.info.profile_pic{
			
			let imageUrl = URL(string: img)
			self.userImg.sd_setImage(with: imageUrl, placeholderImage: #imageLiteral(resourceName: "ic_following_placeholder"))
		}
			
			self.likeCounter = self.info.post_like
			self.likeCountLbl.text = "\(self.info.post_like ?? 0)"
			
		
			if self.info.is_liked == "yes"{
				
				self.likeBtn.isSelected = true
				
			}else{
				
				self.likeBtn.isSelected = false
				
			}
		
			self.shareCountLbl.text = "\(self.info.share_count ?? 0)"
		
			if self.info.is_shared == "yes"{
                
				self.shareBtn.isSelected = true
			}else{
                
				self.shareBtn.isSelected = false
			}
		
		if self.info.user_id == currentUserId(){
			
			self.optionBtn.isHidden = true
			//self.moreCountBtn.isHidden = true
		}else{
			self.optionBtn.isHidden = false
			//self.moreCountBtn.isHidden = false
		}
	}
	
	func setLikeUnlike(){
		
			
			if self.info.is_liked == "yes"{
				
				self.isLiked = true
				
				self.likeImg.image = #imageLiteral(resourceName: "ic_home_like_select")
				
				self.likeBtn.isSelected = true
			}else{
				
				self.isLiked = false
				
				self.likeImg.image = #imageLiteral(resourceName: "ic_home_like_deselect")
				
				self.likeBtn.isSelected = false
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
    
    // dismiss with animate effect
    
    func animatedDisapper(_ complete: @escaping () -> Void){
        
        UIView.animate(withDuration: 0.3) {
            
            self.bgView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            
            self.view.alpha = 0
        }
        delay(0.2) {
            
            self.dismiss(animated: false, completion: nil)
            
        }
    }

	//MARK:- IBAction
	//MARK:- =====================
	
	@IBAction func closeBtnTapped(_ sender: Any) {
		
		if self.postDetailType == .Other{
			
            self.delegate.setTimeLineFromDetail(info: self.info)
		}
        self.dismiss(animated: false, completion: nil)
	}
	
	@IBAction func userBtnTapped(_ sender: Any) {
		
//        self.gotoProfile(user_id: self.info.user_id)
	}
	
	@IBAction func likeBtnTapped(_ sender: Any) {
		
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
				
					if self.info.is_liked == "yes"{
						
						self.info.is_liked = "no"
						
						self.likeCounter -= 1
						
					}else{
						
						self.likeCounter += 1
						
						self.info.is_liked = "yes"
						
					}
				
				self.info.post_like = self.likeCounter
				
				self.likeCountLbl.text = "\(self.likeCounter)"
				
				self.setLikeUnlike()
				
			}
		}
	}
	
	@IBAction func commentBtnTapped(_ sender: Any) {
		
		let popUp = homeStoryboard.instantiateViewController(withIdentifier: "CommentID") as! CommentVC
		popUp.userDetail = self.info
		popUp.setView = .Comment
		popUp.delegate = self
		popUp.modalPresentationStyle = .overCurrentContext
        self.navigationController?.pushViewController(popUp, animated: true)
	}
	
	@IBAction func shareBtnTapped(_ sender: Any) {
		
		var params = JSONDictionary()
        params["userId"] = CurrentUser.user_id
        params["postId"] = self.info.forecast_id
			
		showLoader()
		
		sharePostAPI(params: params) { (success, msg, data) in
			
			hideLoader()
			
			if success{
				
				var count = 0
					
					count = self.info.share_count
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
	
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
//Mark:=====================================
//MARK: - timelineDelegate

extension TradePostVC : UITextViewDelegate{
	
	func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
		return true
	}
}


extension TradePostVC : TimeLineDelegate{
    
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
