//
//  ConditionStockVC.swift
//  Mutadawel
//
//  Created by Appinventiv on 27/04/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit
import SwiftyJSON

class ConditionStockVC: UIViewController {

    
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userInfo: UILabel!
    @IBOutlet weak var pricewhenForecastLbl: TTTAttributedLabel!
    @IBOutlet weak var dotLbl: UILabel!
    @IBOutlet var closeBtn: UIButton!

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
	@IBOutlet weak var currentPriceLbl: TTTAttributedLabel!
	@IBOutlet weak var currentPriceValue: TTTAttributedLabel!
	
	
    //@IBOutlet weak var commentLbl: TTTAttributedLabel!
    @IBOutlet weak var commentValue: UITextView!
    
    @IBOutlet weak var forecastTimeLbl: TTTAttributedLabel!
    @IBOutlet weak var forecastTimeValue: TTTAttributedLabel!
    @IBOutlet weak var likeImg: UIImageView!
    
    @IBOutlet weak var likeCountLbl: UILabel!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var commentImg: UIImageView!
    @IBOutlet weak var commentCountLbl: UILabel!
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var shareImg: UIImageView!
    @IBOutlet weak var shareCountLbl: UILabel!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var optionImg: UIImageView!
    @IBOutlet weak var optionBtn: UIButton!
    @IBOutlet weak var userProfileBtn: UIButton!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postImageHeight: NSLayoutConstraint!

    var info = ForecastPostDetailModel()
    var delegate:TimeLineDelegate!
    var likeCounter = 0
    var isLiked = false
    var postDetailType = PostDetailType.Other


    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setPostInfo()
        self.dotLbl.layer.cornerRadius = 2.5
        self.dotLbl.layer.masksToBounds = true
        if sharedAppdelegate.appLanguage == .Arabic{
            
            self.commentValue.textAlignment = .right
            
        }else{
            
            self.commentValue.textAlignment = .left
            
        }
		self.getPostDetails(infoData: info)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.view.endEditing(true)
//        
//        if let view = touches.first?.view {
//            
//            if view == self.bgView && !self.bgView.subviews.contains(view) {
//                self.dismiss(animated: true, completion: nil)
//                
//            }
//        }
//    }

	
	func getPostDetails(infoData: ForecastPostDetailModel) {
		
		var params = JSONDictionary()
			params["myId"] = CurrentUser.user_id
			params["userId"] = infoData.user_id
		
			params["postId"] = infoData.forecast_id
		
		postDetailAPI(params: params) { (success, msg, data) in
			
			if success{
				
					self.currentPriceValue.text = data!["current_price"].stringValue
				
			}else{
				print_debug(object:msg)
			}
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

    
    func setPostInfo(){
        self.commentValue.delegate = self
        self.optionBtn.isEnabled = false
        self.optionImg.isHidden = true
        self.bgView.layer.cornerRadius = 3
        self.bgView.layer.masksToBounds = true
        self.closeBtn.setTitle(CLOSE.localized, for: .normal)

        self.stockLbl.text = STOCK.localized
        //self.commentLbl.text = COMMENT.localized
        self.before1Lbl.text = BEFORE.localized
        self.before2Lbl.text = BEFORE.localized
        self.shareCountLbl.text = "0"
        
        self.forecastTimeLbl.text = FORECAST_TIME.localized
        self.pricewhenForecastLbl.text = PRICE_WHEN_FORECAST.localized
        self.ifLbl.text = IF.localized
        self.thenLbl.text = THEN.localized
		self.currentPriceLbl.text = CURRENT_PRICE.localized
		self.currentPriceLbl.isHidden = false
		self.currentPriceValue.isHidden = false
		
        self.userImg.layer.cornerRadius = self.userImg.bounds.height / 2
        self.userImg.layer.masksToBounds = true

            self.userName.text = self.info.user_name
        
            self.commentValue.text = self.info.caption
            
            self.ifValue.text = self.info.condition1
        
            self.shareCountLbl.text = "\(self.info.share_count ?? 0)"
        
            self.before1date.text = self.info.before1
        
            self.before2Date.text = self.info.before2
            self.thenValue.text = self.info.condition2
        
            if self.info.is_shared == "yes"{
                self.shareImg.image = #imageLiteral(resourceName: "ic_home_share_select")
            }

        
        
            self.likeCounter = self.info.post_like

            self.likeCountLbl.text = "\(self.info.post_like ?? 0)"
            
            self.commentCountLbl.text = "\(self.info.post_comment ?? 0)"
            
            self.priceWhenForecastValue.text = self.info.price
			
			self.currentPriceValue.text = self.info.current_price
        
        
            if self.info.is_commented == "yes"{
                
                self.commentImg.image = #imageLiteral(resourceName: "ic_home_chat_select")
                self.commentBtn.isSelected = true
                
            }else{
                
                self.commentImg.image = #imageLiteral(resourceName: "ic_home_chat_deselect")
                self.commentBtn.isSelected = false
                
            }
        
            self.stockNameLbl.text = self.info.stock_name
        
            self.userInfo.text = self.info.created_at
        
            self.forecastTimeValue.text = setDateFormateWithTimeZone(dateString: self.info.created_date)
            let time = setDateFormate(dateString: self.info.created_date)
            self.userInfo.text = time
        
        if self.info.user_id == currentUserId(){
            
            self.optionBtn.isHidden = true
            
            self.optionImg.isHidden = true
            
        }
        
        if let img = self.info.profile_pic
        {
            let imageUrl = URL(string: img)
            
            self.userImg.sd_setImage(with: imageUrl, placeholderImage: #imageLiteral(resourceName: "ic_following_placeholder"))
        }
        
        if let image = self.info.image{
            
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
        
        
        if let if_mark = self.info.if_mark{
            
            if if_mark == Status.zero{
                
                self.before1Img.image = PostStatusImages.watch
            }else if if_mark == Status.one{
                self.before1Img.image = PostStatusImages.right_tick
                
            }else if if_mark == Status.two{
                self.before1Img.image = PostStatusImages.cross
                
            }
        }
        
        if let then_mark = self.info.then_mark{
            
            
            if then_mark == Status.zero{
                
                self.before2Img.image = PostStatusImages.watch
            }else if then_mark == Status.one{
                self.before2Img.image = PostStatusImages.right_tick
                
            }else if then_mark == Status.two{
                self.before2Img.image = PostStatusImages.cross
                
            }
        }

        self.setLikeUnlike()

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
        
        
        func setStatusMark(before1: UIImage, before2: UIImage){
            
            self.before1Img.image = before1
            self.before2Img.image = before2
            
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
    
    
    @IBAction func commentBtnTapped(_ sender: UIButton) {
        
        let popUp = homeStoryboard.instantiateViewController(withIdentifier: "CommentID") as! CommentVC
        popUp.userDetail = self.info
        popUp.setView = .Comment
        popUp.delegate = self
        popUp.modalPresentationStyle = .overCurrentContext
        self.navigationController?.pushViewController(popUp, animated: true)

    }
    
    
    @IBAction func shareBtnTapped(_ sender: UIButton) {
        
        var params = JSONDictionary()
        
        params["userId"] = CurrentUser.user_id as AnyObject
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
    
    
    @IBAction func moreBtnTapped(_ sender: UIButton) {
        
        
    }
    
    
}


extension ConditionStockVC : UITextViewDelegate{
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        return true
    }
}

extension ConditionStockVC : TimeLineDelegate{
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
        self.setPostInfo()
        
    }
    
}
