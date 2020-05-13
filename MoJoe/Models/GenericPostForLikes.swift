//
//  GenericPostForLikes.swift
//  MoJoe
//
//  Created by Daniel Grant on 3/24/20.
//  Copyright © 2020 Daniel Grant. All rights reserved.
//


import Foundation
import Firebase

struct GenericPostForLikes {
    
    var date: String = ""
    var imageURL: String = ""
    var postID: String = ""
    var userID: String = ""
    var postExplanation: String = ""
    var rating: Int = 0
    var reviewType: String = ""
    var likeDate: String = ""
    
    var key: String
    var ref: DatabaseReference?
    
    
    init(date: String, imageURL: String, postID: String, key: String = "", userID: String, postExplanation: String, rating: Int, reviewType: String, likeDate: String) {
        
        self.date = date
        self.imageURL = imageURL
        self.postID = postID
        self.userID = userID
        self.postExplanation = postExplanation
        self.rating = rating
        self.reviewType = reviewType
        self.likeDate = likeDate
        
        self.key = key
        self.ref = nil
    }
    
    init?(snapshot: DataSnapshot) {
        guard
            
            let value = snapshot.value as? [String: AnyObject],
            let date = value["date"] as? String,
            let imageURL = value["imageURL"] as? String,
            let postID = value["postID"] as? String,
            let userID = value["userID"] as? String,
            let postExplanation = value["postExplanation"] as? String,
            let rating = value["rating"] as? Int,
            let reviewType = value["reviewType"] as? String,
            let likeDate = value["likeDate"] as? String
            
            else {
                return nil
        }
        
        self.ref = snapshot.ref
        self.key = snapshot.key
        
        self.date = date
        self.imageURL = imageURL
        self.postID = postID
        self.userID = userID
        self.postExplanation = postExplanation
        self.rating = rating
        self.reviewType = reviewType
        self.likeDate = likeDate
    }
    
    func makeDictionary() -> Any {
        
        return [
            "date": date,
            "postID": postID,
            "imageURL": imageURL,
            "userID": userID,
            "postExplanation": postExplanation,
            "rating": rating,
            "reviewType": reviewType,
            "likeDate": likeDate
        ]
    }
}

