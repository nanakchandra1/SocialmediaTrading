//
//  CommentReplyModel.swift
//  Mutadawel
//
//  Created by Appinventiv on 21/12/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import Foundation
import SwiftyJSON

class CommentModel{
    
    var profile_pic: String!
    var name: String!
    var comment: String!
    var created_date: String!
    var reply : [ReplyModel] = []
    var user_id: Int!
    var comment_id: String!


    
    init(with info : JSON) {
        
        self.profile_pic = info[""].stringValue
        self.name = info["name"].stringValue
        self.comment = info["comment"].stringValue
        self.created_date = info["created_date"].stringValue
        self.user_id = info["user_id"].intValue
        self.comment_id = info["comment_id"].stringValue

        self.reply = []
        let replyList = info["reply"].arrayValue
        
        for res in replyList{
            
            let reply = ReplyModel(with: res)

            self.reply.append(reply)
            
        }
    }
    
    init() {
        
    }

    
}



class ReplyModel{
    
    var profile_pic: String!
    var name: String!
    var comment: String!
    var created_date: String!
    var user_id: Int!
    
    init(with info : JSON) {
        
        self.profile_pic = info[""].stringValue
        self.name = info["name"].stringValue
        self.comment = info["comment"].stringValue
        self.created_date = info["created_date"].stringValue
        self.user_id = info["user_id"].intValue

    }
    
    init() {
        
    }
}
