//
//  ChatTableImageCell.swift
//  XMPPChatDemo
//
//  Created by saurabh on 16/12/16.
//  Copyright © 2016 saurabh. All rights reserved.
//

import UIKit

class ChatTableImageCell: UITableViewCell {
    
    @IBOutlet weak var imgView:UIImageView!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var seenImgView: UIImageView!
    @IBOutlet weak var userImgView: UIImageView!
    
    @IBOutlet weak var activityLoader: UIActivityIndicatorView!
    @IBOutlet weak var imageBackGroundView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.imgView?.layer.borderColor = UIColor.lightGray.cgColor
        //self.imgView.layer.cornerRadius = 13.0
        self.imgView?.layer.borderWidth = 1.0
        self.userImgView.layer.cornerRadius = 20.0
        self.imageBackGroundView.layer.cornerRadius = 3.0
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setMessageStatusImage(status : NSNumber) {
        if status == 1 {
            self.seenImgView.image = UIImage(named: "ic_chat_attached_dtick_deselect")
            self.seenImgView.isHidden = false
            
        }else if status == 2 {
            self.seenImgView.image = UIImage(named: "ic_chat_attached_dtick_select")
            self.seenImgView.isHidden = false
            
        }else if status == 0 {
            self.seenImgView.image = UIImage(named: "ic_chat_one_tick_")
            self.seenImgView.isHidden = false
        }
        
    }
}
