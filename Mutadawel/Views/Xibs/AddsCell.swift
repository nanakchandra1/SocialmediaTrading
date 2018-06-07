//
//  AddsCell.swift
//  Mutadawel
//
//  Created by Appinventiv on 19/12/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import Foundation
import UIKit
import KILabel

class AddsCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var sponserName: UILabel!
    @IBOutlet weak var addsImg: UIImageView!
    @IBOutlet weak var infoLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        self.bgView.layer.borderColor = AppColor.appPinkColor.cgColor
        
        self.bgView.layer.borderWidth = 1
        
        if sharedAppdelegate.appLanguage == .Arabic{

            self.sponserName.textAlignment = .right
            self.infoLbl.textAlignment = .right

        }else{
            self.sponserName.textAlignment = .left
            self.infoLbl.textAlignment = .left
        }

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func populateData(with data: ForecastPostDetailModel){
        
        let image = data.image ?? ""
        if !image.isEmpty {
            self.addsImg.isHidden = false

            let imageUrl = URL(string: image)
            self.addsImg.sd_setImage(with: imageUrl, placeholderImage: #imageLiteral(resourceName: "ic_following_placeholder"))
        }else{
            
             self.addsImg.isHidden = true
        }
        let add_description = data.add_description ?? ""
        let sponsor_by = data.sponsor_by ?? ""
        
        self.infoLbl.text = add_description
        self.sponserName.text = sponsor_by

    }
    

}
