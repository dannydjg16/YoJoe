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
    var shopTags: String = ""
    var rating: Int = 100
    var review: String = ""
    var user: String
    let date: String
    let readableDate: String
    var likesAmount: Int = 0
    var postID: String
    var imageURL: String
    
    
    var key: String
    var ref: DatabaseReference?
    
   
    
    init(shop: String, coffeeType: String, shopTags: String, rating: Int, review: String, user: String, key: String = "", date: String, readableDate: String, likesAmount: Int, postID: String, imageURL: String){
        self.shop = shop
        self.coffeeType = coffeeType
        self.shopTags = shopTags
        self.rating = rating
        self.review = review
        self.user = user
        self.key = key
        self.ref = nil
        self.date = date
        self.readableDate = readableDate
        self.likesAmount = likesAmount
        self.postID = postID
        self.imageURL = imageURL
     
        
    }
    
    
    init?(snapshot: DataSnapshot){
        guard
        let value = snapshot.value as? [String: AnyObject],
        let shop = value["shop"] as? String,
        let coffeeType = value["coffeeType"] as? String,
        let shopTags = value["shopTags"] as? String,
        let rating = value["rating"] as? Int,
        let review = value["review"] as? String,
        let user = value["user"] as? String,
        let date = value["date"] as? String,
        let readableDate = value["readableDate"] as? String,
        let likesAmount = value["likesAmount"] as? Int,
        let postID = value["postID"] as? String,
        let imageURL = value["imageURL"] as? String
       
            
            else { return nil }
       
        self.ref = snapshot.ref
        self.key = snapshot.key
        self.shop = shop
        self.coffeeType = coffeeType
        self.shopTags = shopTags
        self.rating = rating
        self.review = review
        self.user = user
        self.date = date
        self.readableDate = readableDate
        self.likesAmount = likesAmount
        self.postID = postID
        self.imageURL = imageURL
       
        
    }
    
    
    func makeDictionary() -> Any {
        return [
            "shop": shop,
            "coffeeType": coffeeType,
            "shopTags": shopTags,
            "rating": rating,
            "review": review,
            "user": user,
            "date": date,
            "readableDate": readableDate,
            "likesAmount": likesAmount,
            "postID": postID,
            "imageURL": imageURL
        ]
    }
}
