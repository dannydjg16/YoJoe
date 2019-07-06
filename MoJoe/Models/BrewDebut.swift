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
    var beanLocation: String = ""
    
    var key: String
    var ref: DatabaseReference?
    
    let date: String
    let isoDate: String
    
    
    init(brew: String, roast: String, rating: Int, beanLocation: String, review: String, user: String, key: String = "", date: String, isoDate: String) {
        self.brew = brew
        self.roast = roast
        self.rating = rating
        self.beanLocation = beanLocation
        self.review = review
        self.user = user
        self.key = key
        self.ref = nil
        self.date = date
        self.isoDate = isoDate
    }
    
    init?(snapshot: DataSnapshot) {
        guard
        let value = snapshot.value as? [String: AnyObject],
        let brew = value["brew"] as? String,
        let roast = value["roast"] as? String,
        let rating = value["rating"] as? Int,
        let beanLocation = value["beanLocation"] as? String,
        let review = value["review"] as? String,
        let user = value["user"] as? String,
        let date = value["date"] as? String,
        let isoDate = value["isoDate"] as? String
            else { return nil }
        
        self.ref = snapshot.ref
        self.key = snapshot.key
        self.brew = brew
        self.roast = roast
        self.rating = rating
        self.beanLocation = beanLocation
        self.review = review
        self.user = user
        self.date = date
        self.isoDate = isoDate
        
    }
    
    func makeDictionary() -> Any {
        return [
            "brew": brew,
            "roast": roast,
            "rating": rating,
            "beanLocation": beanLocation,
            "review": review,
            "user": user,
            "date": date,
            "isoDate": isoDate
        ]
    }
    
    
}
