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
    var coffeeType: String = ""
    var shopTags: String = ""
    var rating: Int = 100
    var review: String = ""
    var user: String
    let date: String
    
    var key: String
    var ref: DatabaseReference?
    
   
    
    init(shop: String, coffeeType: String, shopTags: String, rating: Int, review: String, user: String, key: String = "", date: String){
        self.shop = shop
        self.coffeeType = coffeeType
        self.shopTags = shopTags
        self.rating = rating
        self.review = review
        self.user = user
        self.key = key
        self.ref = nil
        self.date = date
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
        let date = value["date"] as? String
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
        ]
    }
}
