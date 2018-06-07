//
//  StatusOfExpectationModel.swift
//  Mutadawel
//
//  Created by Appinventiv on 26/12/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import Foundation
import SwiftyJSON

class StatusOfExpectationModel{
    
    var post: [Any]!
    var right: [Any]!
    var wrong: [Any]!
    var net_value: [Any]!

    
    init(withData data : JSON) {
        
        self.post = data["post"].arrayObject
        self.right = data["right"].arrayObject
        self.wrong = data["wrong"].arrayObject
        self.net_value = data["net_value"].arrayObject 

    }
    
    init() {
        
    }

}
