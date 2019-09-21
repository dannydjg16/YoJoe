//
//  comment.swift
//  MoJoe
//
//  Created by Daniel Grant on 9/17/19.
//  Copyright © 2019 Daniel Grant. All rights reserved.
//

import Foundation
import Firebase

struct Comment {
    var comment: String
    var date: String
    var likesAmount: Int = 0
    
    var key: String
    var ref: DatabaseReference?
    
    init(comment: String, date: String, likesAmount: Int, key: String = "") {
        self.comment = comment
        self.date = date
        self.likesAmount = likesAmount
        self.key = key
        self.ref = nil
    }
    
    
        init?(snapshot: DataSnapshot){
            guard
                let value = snapshot.value as? [String: AnyObject],
                let comment = value["comment"] as? String,
                let date = value["date"] as? String,
                let likesAmount = value["likesAmount"] as? Int
        else {
            return nil
        }
        
        self.ref = snapshot.ref
        self.key = snapshot.key
        self.comment = comment
        self.date = date
        self.likesAmount = likesAmount
    }
    
    func makeDictionary() -> Any {
        return ["comment": comment,
                "date": date,
                "likesAmount": likesAmount]
    }
    
    
    
}
