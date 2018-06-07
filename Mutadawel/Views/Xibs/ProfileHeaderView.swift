//
//  MarkerInfoWindow.swift
//  CannAlignUser
//
//  Created by Ravi on 20/01/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import Foundation
import UIKit

class ProfileHeaderView: UIView {
    
    
    @IBOutlet weak var expectationView: UIView!
    @IBOutlet weak var expectationCountLbl: UILabel!
    @IBOutlet weak var expectationLbl: UILabel!
    @IBOutlet weak var expectationBtn: UIButton!
	
	@IBOutlet weak var pendingExpectationView: UIView!
	@IBOutlet weak var pendingExpectationCountLbl: UILabel!
	@IBOutlet weak var pendingExpectationLbl: UILabel!
	@IBOutlet weak var pendingExpectationBtn: UIButton!
	
	
    @IBOutlet weak var wrongExpectationView: UIView!
    @IBOutlet weak var wrongExpectationCountLbl: UILabel!
    @IBOutlet weak var wrongExpectationLbl: UILabel!
    @IBOutlet weak var wrongExpectationBtn: UIButton!
    
    @IBOutlet weak var rightExpectationView: UIView!
    @IBOutlet weak var rightExpectationCountLbl: UILabel!
    @IBOutlet weak var rightExpectationLbl: UILabel!
    @IBOutlet weak var rightExpectationBtn: UIButton!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        self.expectationLbl.text = FORECAST.localized
		self.pendingExpectationLbl.text = PENDING_EXPECTATION.localized
        self.rightExpectationLbl.text = RIGHT_EXPECTATION.localized
        self.wrongExpectationLbl.text = WRONG_EXPECTATION.localized
        
    }
    
}
