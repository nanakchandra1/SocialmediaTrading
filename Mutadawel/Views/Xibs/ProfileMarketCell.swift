//
//  ProfileMarketCell.swift
//  Mutadawel
//
//  Created by Appinventiv on 19/04/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class ProfileMarketCell: UITableViewCell {

    @IBOutlet weak var marketNameLbl: UILabel!
    @IBOutlet weak var marketValueLbl: UILabel!
    @IBOutlet weak var marketSymbol: UIImageView!
    @IBOutlet weak var forwordArrowImg: UIImageView!
    @IBOutlet weak var marketSymbolWidthConstant: NSLayoutConstraint!
    @IBOutlet weak var moreMarketLbl: UILabel!
    @IBOutlet weak var seperatorView: UIView!
    @IBOutlet weak var selectMarketBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if sharedAppdelegate.appLanguage == .Arabic
        {
            self.forwordArrowImg.image = #imageLiteral(resourceName: "ic_settings_backarrow")
        }else{
            
            self.forwordArrowImg.image = #imageLiteral(resourceName: "ic_settings_nextarrow")
        }

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
