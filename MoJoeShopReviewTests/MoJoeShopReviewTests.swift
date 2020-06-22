//
//  MoJoeShopReviewTests.swift
//  MoJoeShopReviewTests
//
//  Created by Daniel Grant on 6/18/20.
//  Copyright © 2020 Daniel Grant. All rights reserved.
//

import XCTest
@testable import MoJoe


class MoJoeShopReviewTests: XCTestCase {
    
    var sut: Date!
    
    override func setUpWithError() throws {
        
        super.setUp()
        sut = Date()
        
    }
    
    override func tearDownWithError() throws {
        
        sut = nil
        super.tearDown()
    }
    
    func testTimeSincePostFromString() {
         // Given
         let guess = "2mon ago"
         
         // When
         let timeString = "2020-04-14 12:28:51"
         
         // Then
         XCTAssertEqual(guess, sut.timeSincePostFromString(postDate: timeString), "Guess is wrong")
     }
    
    
    func testTimeSinceUserGenericPost() {
        
        // Given
        let guess = "2mon ago"
        
        // When
        let timeString = "2020-04-14 12:28:51"
        let post = UserGenericPost(date: timeString, imageURL: "", postID: "", key: "", userID: "", postExplanation: "", rating: 0, reviewType: "")
        
        
        // Then
        XCTAssertEqual(guess, sut.timeSincePost(post: post), "Guess is wrong")
    }
    
    
    func testTimeSinceBrewDebut() {
        
        // Given
        let guess = "2mon ago"
        
        // When
        let timeString = "2020-04-14 12:28:51"
        let post = BrewDebut(brew: "", roast: "", rating: 0, beanLocation: "", review: "", user: "", date: timeString, likesAmount: 0, postID: "", imageURL: "", comments: 0)
        
        
        // Then
        XCTAssertEqual(guess, sut.timeSinceBrewDebut(debut: post), "Guess is wrong")
    }
    
    func testTimeSinceShopReview() {
        
        // Given
        let guess = "2mon ago"
        
        // When
        let timeString = "2020-04-14 12:28:51"
        let post = ShopReivew(shop: "", coffeeType: "", rating: 9, review: "", user: "", date: timeString, likesAmount: 8, postID: "", imageURL: "", comments: 5, city: "", state: "")
        
        // Then
        XCTAssertEqual(guess, sut.timeSinceShopReview(theShop: post), "Guess is wrong")
    }
    
    func testTimeSince() {
        
        // Given
        let guess = "2mon ago"
        
        //When
        let timeString = "2020-04-14 12:28:51"
        let post = GenericPostForLikes(date: timeString, imageURL: "", postID: "", key: "", userID: "", postExplanation: "", rating: 4, reviewType: "", likeDate: "")
        
        //Then
        XCTAssertEqual(guess, sut.timeSinceLikedGenericPost(post: post), "Guess is wrong")
    }
    
}
