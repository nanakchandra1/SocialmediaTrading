//
//  ActivityIndicatorCell.swift
//  Mutadawel
//
//  Created by Appinventiv on 04/01/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import UIKit

class ActivityIndicatorCell: UITableViewCell {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.activityIndicator.startAnimating()
        self.activityIndicator.color = AppColor.navigationBarColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
