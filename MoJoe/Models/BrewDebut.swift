//
//  BrewDebut.swift
//  MoJoe
//
//  Created by Daniel Grant on 4/26/19.
//  Copyright © 2019 Daniel Grant. All rights reserved.
//

import Foundation
import Firebase

struct BrewDebut {
    var brew: String = ""
    var roast: String = ""
    var review: String = ""
    var rating: Int = 100
    var user: String
    
    var key: String
    var ref: DatabaseReference?
    
    let date: String
    
    
    init(brew: String, roast: String, rating: Int, review: String, user: String, key: String = "", date: String) {
        self.brew = brew
        self.roast = roast
        self.rating = rating
        self.review = review
        self.user = user
        self.key = key
        self.ref = nil
        self.date = date
    }
    
    init?(snapshot: DataSnapshot) {
        guard
        let value = snapshot.value as? [String: AnyObject],
        let brew = value["brew"] as? String,
        let roast = value["roast"] as? String,
        let rating = value["rating"] as? Int,
        let review = value["review"] as? String,
        let user = value["user"] as? String,
        let date = value["date"] as? String
            else { return nil }
        
        self.ref = snapshot.ref
        self.key = snapshot.key
        self.brew = brew
        self.roast = roast
        self.rating = rating
        self.review = review
        self.user = user
        self.date = date
        
    }
    
    func makeDictionary() -> Any {
        return [
            "brew": brew,
            "roast": roast,
            "rating": rating,
            "review": review,
            "user": user,
            "date": date
        ]
    }
    
    
}
