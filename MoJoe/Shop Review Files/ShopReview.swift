//
//  ShopReview.swift
//  MoJoe
//
//  Created by Daniel Grant on 4/28/19.
//  Copyright © 2019 Daniel Grant. All rights reserved.
//

import Foundation
import Firebase

struct ShopReivew {
   
    var shop: String = ""
    var coffeeType: String
    var rating: Int = 100
    var review: String = ""
    var user: String
    let date: String
    var likesAmount: Int = 0
    var postID: String
    var imageURL: String
    var comments: Int
    var city: String = ""
    var state: String = ""
    
    
    var key: String
    var ref: DatabaseReference?
    
   
    
    init(shop: String, coffeeType: String,  rating: Int, review: String, user: String, key: String = "", date: String, likesAmount: Int, postID: String, imageURL: String, comments: Int, city: String, state: String) {
        
        self.shop = shop
        self.coffeeType = coffeeType
        self.rating = rating
        self.review = review
        self.user = user
        self.key = key
        self.ref = nil
        self.date = date
        self.likesAmount = likesAmount
        self.postID = postID
        self.imageURL = imageURL
        self.comments = comments
        self.city = city
        self.state = state
     
    }
    
    
    init?(snapshot: DataSnapshot){
        guard
        let value = snapshot.value as? [String: AnyObject],
        let shop = value["shop"] as? String,
        let coffeeType = value["coffeeType"] as? String,
        let rating = value["rating"] as? Int,
        let review = value["review"] as? String,
        let user = value["user"] as? String,
        let date = value["date"] as? String,
        let likesAmount = value["likesAmount"] as? Int,
        let postID = value["postID"] as? String,
        let imageURL = value["imageURL"] as? String,
        let comments = value["comments"] as? Int,
        let city = value["city"] as? String,
        let state = value["state"] as? String
       
            
            else { return nil }
       
        self.ref = snapshot.ref
        self.key = snapshot.key
        self.shop = shop
        self.coffeeType = coffeeType
        self.rating = rating
        self.review = review
        self.user = user
        self.date = date
        self.likesAmount = likesAmount
        self.postID = postID
        self.imageURL = imageURL
        self.comments = comments
        self.city = city
        self.state = state
    }
    
    
    func makeDictionary() -> Any {
        return [
            "shop": shop,
            "coffeeType": coffeeType,
            "rating": rating,
            "review": review,
            "user": user,
            "date": date,
            "likesAmount": likesAmount,
            "postID": postID,
            "imageURL": imageURL,
            "comments": comments,
            "city": city,
            "state": state
        ]
    }
}
