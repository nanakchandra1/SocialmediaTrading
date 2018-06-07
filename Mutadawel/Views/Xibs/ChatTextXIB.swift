//
//  ChatTextXIB.swift
//  Mutadawel
//
//  Created by MAC on 3/2/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class ChatTextXIB: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var textLBl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.containerView.layer.cornerRadius = 3.0
        self.containerView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
