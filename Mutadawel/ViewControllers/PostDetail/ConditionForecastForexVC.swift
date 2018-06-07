//
//  ConditionForecastForexVC.swift
//  Mutadawel
//
//  Created by Appinventiv on 27/04/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit
import SwiftyJSON

class ConditionForecastForexVC: UIViewController {

    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userInfo: UILabel!
    @IBOutlet weak var dotLbl: UILabel!
    @IBOutlet weak var priceWhenForecastLbl: TTTAttributedLabel!
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
    @IBOutlet weak var stopLossImg: UIImageView!
    @IBOutlet var closeBtn: UIButton!

    @IBOutlet weak var stopLossvalue: TTTAttributedLabel!
    
    @IBOutlet weak var takeProfitLbl: TTTAttributedLabel!
    @IBOutlet weak var takeProfitValue: TTTAttributedLabel!
    @IBOutlet weak var takeProfitImg: UIImageView!
//    @IBOutlet weak var commentLbl: TTTAttributedLabel!
    @IBOutlet weak var commentValue: UITextView!
    @IBOutlet weak var forecastTimeLbl: TTTAttributedLabel!
    @IBOutlet weak var forecastValueLbl: TTTAttributedLabel!
    @IBOutlet weak var likeImg: UIImageView!
    @IBOutlet weak var likeCountLbl: UILabel!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var commentImg: UIImageView!
    @IBOutlet weak var commentCount: UILabel!
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var shareImg: UIImageView!
    @IBOutlet weak var shareCountLbl: UILabel!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var optionImg: UIImageView!
    @IBOutlet weak var optionBtn: UIButton!
    @IBOutlet weak var userProfileBtn: UIButton!
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var fromTimeValue: UILabel!
    @IBOutlet weak var fromTimeLbl: UILabel!
    
    @IBOutlet weak var toTimeLbl: UILabel!
    
    @IBOutlet weak var toTimeValue: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postImageHeight: NSLayoutConstraint!

    
    var info = ForecastPostDetailModel()
    var delegate:TimeLineDelegate!
    var likeCounter = 0
    var isLiked = false
    var postDetailType = PostDetailType.Other



    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.dotLbl.layer.cornerRadius = 2.5
        self.dotLbl.layer.masksToBounds = true
        if sharedAppdelegate.appLanguage == .Arabic{
            
            self.commentValue.textAlignment = .right
            
        }else{
            
            self.commentValue.textAlignment = .left
            
        }


        self.setPostData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
        
    // dismiss with animate effect
    
    func animatedDisapper(_ complete: @escaping () -> Void){
        
        UIView.animate(withDuration: 0.3) {
            
            self.bgView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            
            self.view.alpha = 1
        }
        delay(0.2) {
            
            self.dismiss(animated: false, completion: nil)
            
        }
    }


    func setPostData(){
        
        self.optionBtn.isEnabled = false
        self.optionImg.isHidden = true
        self.commentValue.delegate = self
        self.bgView.layer.cornerRadius = 3
        self.bgView.layer.masksToBounds = true
        self.currencveLbl.text = CURRENCY.localized
        //self.commentLbl.text = COMMENT.localized
        self.closeBtn.setTitle(CLOSE.localized, for: .normal)
        self.beforeLbl.text = BEFORE.localized
        self.forecastTimeLbl.text = FORECAST_TIME.localized
        self.priceWhenForecastLbl.text = PRICE_WHEN_FORECAST.localized
        self.stopLossLbl.text = STOP_LOSS.localized
        self.takeProfitLbl.text = TAKE_PROFIT.localized
        self.buyLbl.text = BUY.localized
        self.priceLbl.text = FORECASTED_PRICE.localized
        self.fromTimeLbl.text = FROM_TIME.localized
        self.toTimeLbl.text = TO_TIME.localized

        self.userImg.layer.cornerRadius = self.userImg.bounds.height / 2
        self.userImg.layer.masksToBounds = true
        
            if info.user_id == currentUserId(){
                
            }else{
                
                self.optionBtn.isHidden = false
                
            }
        
            if self.info.is_commented == "yes"{
                
                self.commentImg.image = #imageLiteral(resourceName: "ic_home_chat_select")
                
                self.commentBtn.isSelected = true
                
            }else{
                
                self.commentImg.image = #imageLiteral(resourceName: "ic_home_chat_deselect")
                
                self.commentBtn.isSelected = false
            }
        
            self.userName.text = self.info.user_name
        
            self.beforeDate.text = self.info.before1
        
            self.commentValue.text = self.info.caption
        
            self.priceWhenForecastValue.text = self.info.price

        
            self.likeCounter = self.info.post_like

            self.likeCountLbl.text = "\(self.info.post_like ?? 0)"
        
            if self.info.buyORsell == "1"{
                
                self.buyLbl.text = BUY.localized
                
                self.buyLbl.textColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
                
            }else{
                
                self.buyLbl.text = SELL.localized
                
                self.buyLbl.textColor = #colorLiteral(red: 0.9137254902, green: 0.1215686275, blue: 0.3882352941, alpha: 1)
            }
        
            self.priceValue.text = self.info.forecast_price
            
            self.commentCount.text = "\(self.info.post_comment ?? 0)"
            
            self.currwncyName.text = self.info.currency
            
            self.stopLossvalue.text = self.info.stop_loss
            
            self.takeProfitValue.text = self.info.take_profit
            
            self.fromTimeValue.text = self.info.from_time
            
            self.toTimeValue.text = self.info.to_time
        
            self.userInfo.text = self.info.created_at
            
            self.forecastValueLbl.text = setDateFormateWithTimeZone(dateString: self.info.created_date ?? "")
            
            self.userInfo.text = setDateFormate(dateString: self.info.created_date)
        
        if let img = self.info.profile_pic{
            
            let imageUrl = URL(string: img)
            
            self.userImg.sd_setImage(with: imageUrl, placeholderImage: #imageLiteral(resourceName: "ic_following_placeholder"))
        }
        
            self.shareCountLbl.text = "\(self.info.share_count ?? 0)"

        
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
        
        if let price_mark = self.info.entry_price_mark{
            
            if price_mark == Status.zero{
                
                self.priceImg.image = PostStatusImages.watch
            }else if price_mark == Status.one{
                self.priceImg.image = PostStatusImages.right_tick
                
            }else if price_mark == Status.two{
                self.priceImg.image = PostStatusImages.cross
                
            }
        }
        
        if let before_mark = self.info.before_mark{
            
            if before_mark == Status.zero{
                
                self.beforeImg.image = PostStatusImages.watch
                
            }else if before_mark == Status.one{
                
                self.beforeImg.image = PostStatusImages.right_tick
                
            }else if before_mark == Status.two{
                
                self.beforeImg.image = PostStatusImages.cross
                
            }
        }

        
        if let take_profit_mark = self.info.take_profit_mark{
            
            if take_profit_mark == Status.zero{
                
                self.takeProfitImg.image = PostStatusImages.watch
                
            }else if take_profit_mark == Status.one{
                
                self.takeProfitImg.image = PostStatusImages.right_tick
                
            }else if take_profit_mark == Status.two{
                
                self.takeProfitImg.image = PostStatusImages.cross
                
            }
        }
        
        if let stop_loss_mark = self.info.stop_loss_mark{
            
            if stop_loss_mark == Status.zero{
                
                self.stopLossImg.image = PostStatusImages.watch
                
            }else if stop_loss_mark == Status.one{
                
                self.stopLossImg.image = PostStatusImages.right_tick
                
            }else if stop_loss_mark == Status.two{
                
                self.stopLossImg.image = PostStatusImages.cross
                
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
        
    }
    
    func setStatusMark(price: UIImage, before: UIImage, stopLoss: UIImage, takeProfit: UIImage){
        
        self.priceImg.image = price
        self.beforeImg.image = before
        self.stopLossImg.image = stopLoss
        self.takeProfitImg.image = takeProfit
        
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
                
                    if self.info.is_shared == "yes"{
                        
                        self.shareImg.image = #imageLiteral(resourceName: "ic_home_share_select")
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
    
    
    @IBAction func moreBtnTapped(_ sender: UIButton) {
        
        
    }
    
    
}


extension ConditionForecastForexVC : UITextViewDelegate{
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        return true
    }
}



extension ConditionForecastForexVC : TimeLineDelegate{
    
    
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
