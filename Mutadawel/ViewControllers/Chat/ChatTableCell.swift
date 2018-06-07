//
//  ChatTableCell.swift
//  XMPPChatDemo
//
//  Created by saurabh on 16/12/16.
//  Copyright © 2016 saurabh. All rights reserved.
//

import UIKit
import CoreGraphics

class ChatTableCell: UITableViewCell {
    
    @IBOutlet weak var message:UILabel!
    @IBOutlet weak var containerView:UIView!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var seenImgView: UIImageView!
    @IBOutlet weak var textLblWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var userImgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.containerView.layer.cornerRadius = 5.0
        self.userImgView.layer.cornerRadius = 20.0
        //self.userImgView.isHidden = true
    }
    override func draw(_ rect: CGRect) {
        
        /*
        guard self.reuseIdentifier == "cell" else {
            return
        }
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(UIColor(colorLiteralRed: 234/255.0, green: 234/255.0, blue: 234/255.0, alpha: 1).cgColor)
        
        var point = CGPoint(x: 56, y: 2)
        if sharedAppdelegate.appLanguage != .English {
            point = CGPoint(x:(SCREEN_WIDTH - 56), y: 2)
        }
        context?.move(to: point)
        if sharedAppdelegate.appLanguage == .English {
            point.x += 30
        } else {
            point.x -= 30
        }
        context?.addLine(to: point)
        point.y += 30
        context?.addLine(to: point)
        
        context?.fillPath()
        context?.strokePath()
        
        context?.setFillColor(UIColor.white.cgColor)
        let circleCenter = CGPoint(x:46, y:32)
        let circleRadius = CGFloat(30)
        let decimalInput = 1.5
        let start = CGFloat(3 * M_PI_2)
        let end = start + CGFloat(2 * M_PI * decimalInput)
        let circlePath = UIBezierPath(arcCenter: circleCenter, radius: circleRadius, startAngle: start, endAngle: end, clockwise: true)
        context?.addPath(circlePath.cgPath)
        
        context?.fillPath()
        context?.strokePath()
         */
        
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
