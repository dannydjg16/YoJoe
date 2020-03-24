//
//  Date.swift
//  MoJoe
//
//  Created by Daniel Grant on 7/6/19.
//  Copyright © 2019 Daniel Grant. All rights reserved.
//

import Foundation
extension Date {
    
    func timeSinceBrewDebut(debut: BrewDebut) -> String {
        let dateOfPostString = debut.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        dateFormatter.isLenient = true
        
        let dateOfPost = dateFormatter.date(from: dateOfPostString)
        
        guard let postDate = dateOfPost else {
            return ""
        }
        
        let timeAgo = Int(Date().timeIntervalSince(postDate))
        
        if timeAgo < 60 {
            //one minute
            
            return "\(timeAgo)s ago"
            
        } else if timeAgo < 3600 {
            //one hour
            
            return "\(timeAgo / 60)m ago"
            
        } else if timeAgo < 86400 {
            //one day
            
            return "\(timeAgo / (3600))hr ago"
            
        } else if timeAgo < 604800 {
            //one week
            
            return "\(timeAgo / (86400))d ago"
            
        } else if timeAgo < 2592000 {
            //one month
            
            return "\(timeAgo / (604800))w ago"
            
        } else if timeAgo < (2592000 * 12) {
            //one year
            return "\(timeAgo / (604800))mon  ago"
        }
        else {
            return "\(timeAgo / (2592000 * 12)) yr ago"
        }
    }
    
    func timeSinceShopReview(theShop: ShopReivew) -> String {
        let dateOfPostString = theShop.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        dateFormatter.isLenient = true
        
        let dateOfPost = dateFormatter.date(from: dateOfPostString)
        
        guard let postDate = dateOfPost else {
            return ""
        }
        
        let timeAgo = Int(Date().timeIntervalSince(postDate))
        
        if timeAgo < 60 {
            //one minute
            
            return "\(timeAgo)s ago"
            
        } else if timeAgo < 3600 {
           //one hour
            
            return "\(timeAgo / 60)m ago"
            
        } else if timeAgo < 86400 {
           //one day
            
            return "\(timeAgo / (3600))hr ago"
            
        } else if timeAgo < 604800 {
           //one week
            
            return "\(timeAgo / (86400))d ago"
            
        } else if timeAgo < 2592000 {
            //one month
            
            return "\(timeAgo / (604800))w ago"
            
        } else if timeAgo < (2592000 * 12) {
            //one year
            return "\(timeAgo / (604800))mon  ago"
        }
        else {
            return "\(timeAgo / (2592000 * 12)) yr ago"
        }
    }
    
    
    func timeSincePost(post: UserGenericPost) -> String {
        let dateOfPostString = post.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        dateFormatter.isLenient = true
        
        let dateOfPost = dateFormatter.date(from: dateOfPostString)
        
        guard let postDate = dateOfPost else {
            return ""
        }
        
        let timeAgo = Int(Date().timeIntervalSince(postDate))
        
        if timeAgo < 60 {
            //one minute
            
            return "\(timeAgo)s ago"
            
        } else if timeAgo < 3600 {
           //one hour
            
            return "\(timeAgo / 60)m ago"
            
        } else if timeAgo < 86400 {
           //one day
            
            return "\(timeAgo / (3600))hr ago"
            
        } else if timeAgo < 604800 {
           //one week
            
            return "\(timeAgo / (86400))d ago"
            
        } else if timeAgo < 2592000 {
            //one month
            
            return "\(timeAgo / (604800))w ago"
            
        } else if timeAgo < (2592000 * 12) {
            //one year
            return "\(timeAgo / (604800))mon  ago"
        }
        else {
            return "\(timeAgo / (2592000 * 12)) yr ago"
        }
    }
    
    func timeSincePostFromString(postDate: String) -> String {
        let dateOfPostString = postDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        dateFormatter.isLenient = true
        
        let dateOfPost = dateFormatter.date(from: dateOfPostString)
        
        guard let postDate = dateOfPost else {
            return ""
        }
        
        let timeAgo = Int(Date().timeIntervalSince(postDate))
        
        if timeAgo < 60 {
            //one minute
            
            return "\(timeAgo)s ago"
            
        } else if timeAgo < 3600 {
           //one hour
            
            return "\(timeAgo / 60)m ago"
            
        } else if timeAgo < 86400 {
           //one day
            
            return "\(timeAgo / (3600))hr ago"
            
        } else if timeAgo < 604800 {
           //one week
            
            return "\(timeAgo / (86400))d ago"
            
        } else if timeAgo < 2592000 {
            //one month
            
            return "\(timeAgo / (604800))w ago"
            
        } else if timeAgo < (2592000 * 12) {
            //one year
            return "\(timeAgo / (604800))mon  ago"
        }
        else {
            return "\(timeAgo / (2592000 * 12)) yr ago"
        }
    }
}
