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
    //I think i can use different combinations of the inits of review paired with the cells that will take be able to handle all of the information that goes in each type of review. I need to make those cells and inits though
    let description: String
    let reviewer: String
    let ref: DatabaseReference?
    let key: String
    

    
    //Im not sure, but i think that this may really only need to be done in the review vc. the whole get/set thing but I can look  into that later. As long as its a string here i feel like it doesnt really matter how it gets to that point, which is why that can be taken care of in the other vc.
    var date: String {
        get {
        let postDate = Date()
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "YYYY-MM-dd HH:mm:ss"
        let stringDate = dateFormat.string(from: postDate)
            return stringDate
        }
        
        set {
            let postDate = Date()
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "YYYY-MM-dd HH:mm:ss"
            var stringDate = dateFormat.string(from: postDate)
            return stringDate = newValue
        }
    }
    
    
    init(description: String, reviewer: String, key: String = "", date: String) {
        self.description = description
        self.reviewer = reviewer
        self.ref = nil
        self.key = key
        self.date = date
        
    }

    
    
    init?(snapshot: DataSnapshot) {
        guard
        let value = snapshot.value as? [String: AnyObject],
        let description = value["description"] as? String,
        let reviewer = value["reviewer"] as? String,
        let date = value["date"] as? String
            else {
                return nil
        }
      
        self.ref = snapshot.ref
        self.key = snapshot.key
        self.description = description
        self.reviewer = reviewer
        self.date = date
        
    }
    
    func makeDictionary() -> Any {
        return [
            "description" : description,
            "reviewer": reviewer,
            "date": date
        ]
    }
    
    
    
}
