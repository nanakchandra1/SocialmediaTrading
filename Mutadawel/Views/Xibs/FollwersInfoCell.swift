//
//  FollwersInfoCell.swift
//  Mutadawel
//
//  Created by Appinventiv on 06/02/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class FollwersInfoCell: UITableViewCell {
    
    //MARK:- ==========================================================
    //MARK:- IBOutlets
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var floatRatingView: FloatRatingView!
    @IBOutlet weak var rateLbl: UILabel!
    @IBOutlet weak var followBtn: UIButton!
    @IBOutlet weak var followWidthConstant: NSLayoutConstraint!
    @IBOutlet weak var rateViewWidthConstant: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.followBtn.setTitle(FOLLOW.localized, for: .normal)
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    
    func setLayout(){
        
        self.userImg.layer.cornerRadius = 20
        self.userImg.layer.masksToBounds = true
        self.followBtn.tintColor = UIColor.white
    }
    
    
    func populateView(index: Int, userInfo: FollowedUserModel,selectedIndexPath: [Int],userListType: UserType){
        
        if userListType == .User{
            
            self.followBtn.isHidden = true
            
        }else{
            
            if let user_id = userInfo.user_id{
                
                if user_id == currentUserId(){
                    
                    self.followBtn.isHidden = true
                    
                }else{
                    
                    self.followBtn.isHidden = false
                    
                }
            }
        }
        
        if let name = userInfo.name{
            self.userNameLbl.text = name
        }
        
        if let is_following = userInfo.is_following{
            
            if is_following.lowercased() == "yes"{
                
                self.followBtn.setImage(UIImage(named: "ic_following_tick"), for: UIControlState.normal)
                self.followBtn.setTitle("", for: UIControlState.normal)
                self.followWidthConstant.constant = 40
                
            }else{
                
                self.followBtn.setImage(UIImage(named: ""), for: UIControlState.normal)
                self.followBtn.setTitle(FOLLOW.localized, for: UIControlState.normal)
                self.followWidthConstant.constant = 70
                
            }
        }
        
        if let rating = userInfo.rating{
            
            self.setRating(rating: rating)
            
        }else{
            
            self.rateLbl.text = "0"
            //self.rateViewWidthConstant.constant = 0
        }
        
        if let img = userInfo.profile_pic{
            let imageUrl = URL(string: img)
            self.userImg.sd_setImage(with: imageUrl, placeholderImage: #imageLiteral(resourceName: "ic_following_placeholder"))
        }
        
    }
    
    
    
    func setRating(rating: Float){
        
        self.floatRatingView.rating = rating
        self.rateLbl.text = "\(rating)"
        
    }
    
}
