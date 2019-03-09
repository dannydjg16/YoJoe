//
//  ReviewPost.swift
//  MoJoe
//
//  Created by Daniel Grant on 2/14/19.
//  Copyright © 2019 Daniel Grant. All rights reserved.
//

import Foundation
import Firebase

struct ReviewPost {
    
    
    
    
    
    
    let detail: String
    let poster: String
    let brew: String
    let roast: String
    let rating: Int
    let key: String
    let ref: DatabaseReference?
    
    let date: String
    

// Might also needa date as it is in the review file. Im not sure where it needs to get made into a dateformat and shit. for now, imm gonna try and do it all in the other file and if that doesnt work im gonna try and do it all in this file. I actually want to put a date on the acutal post, which requires me to format it differently. right not i dont know if i need to make another date constant and have one for storing and one for the post but ill figure that out when i have more time
  
    
    
    
    
    
    init(detail: String, poster: String, brew: String, roast: String, rating: Int, key: String = "", date: String) {
        self.detail = detail
        self.poster = poster
        self.brew = brew
        self.roast = roast
        self.rating = rating
        self.key = key
        self.date = date
        self.ref = nil
    }
    
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let detail = value["detail"] as? String,
            let poster = value["poster"] as? String,
            let brew = value["brew"] as? String,
            let roast = value["roast"] as? String,
            let rating = value["rating"] as? Int,
            let date = value["date"] as? String
            else {
                return nil
        }
        self.ref = snapshot.ref
        self.key = snapshot.key
        self.detail = detail
        self.poster = poster
        self.brew = brew
        self.roast = roast
        self.rating = rating
        self.date = date
    }
    
    func makeDictionary() -> Any {
        return [
            "detail": detail,
            "poster": poster,
            "brew": brew,
            "roast": roast,
            "rating": rating,
            "date": date  
        ]
    }
}
