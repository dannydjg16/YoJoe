//
//  Review.swift
//  MoJoe
//
//  Created by Daniel Grant on 1/7/19.
//  Copyright © 2019 Daniel Grant. All rights reserved.
//

import Foundation
import Firebase

struct Review {
    
    let description: String
    let reviewer: String
    let ref: DatabaseReference?
    let key: String
    
    init(description: String, reviewer: String, key: String = "") {
        self.description = description
        self.reviewer = reviewer
        self.ref = nil
        self.key = key
        
    }
    
    
    
    
    init?(snapshot: DataSnapshot) {
        guard
        let value = snapshot.value as? [String: AnyObject],
        let description = value["description"] as? String,
        let reviewer = value["reviewer"] as? String
        
            else {
                return nil
        }
      
        self.ref = snapshot.ref
        self.key = snapshot.key
        self.description = description
        self.reviewer = reviewer
        
    }
    
    func toDictionary() -> Any {
        return [
            "description" : description,
            "reviewer": reviewer
        ]
    }
    
    
    
}
