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
    var likesAmount: Int = 0
    var postID: String
    var imageURL: String
    var comments: Int
    
    var key: String
    var ref: DatabaseReference?
    
    let date: String
    
    
    
    init(brew: String, roast: String, rating: Int, beanLocation: String, review: String, user: String, key: String = "", date: String, likesAmount: Int, postID: String, imageURL: String, comments: Int) {
        self.brew = brew
        self.roast = roast
        self.rating = rating
        self.beanLocation = beanLocation
        self.review = review
        self.user = user
        self.key = key
        self.ref = nil
        self.date = date
        self.likesAmount = likesAmount
        self.postID = postID
        self.imageURL = imageURL
        self.comments = comments
        
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
        let likesAmount = value["likesAmount"] as? Int,
        let postID = value["postID"] as? String,
        let imageURL = value["imageURL"] as? String,
        let comments = value["comments"] as? Int
            
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
        self.likesAmount = likesAmount
        self.postID = postID
        self.imageURL = imageURL
        self.comments = comments
        
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
            "likesAmount": likesAmount,
            "postID": postID,
            "imageURL": imageURL,
            "comments": comments
        ]
    }
    
    
}
