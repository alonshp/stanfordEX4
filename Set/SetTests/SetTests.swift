//
//  SetTests.swift
//  SetTests
//
//  Created by Alon Shprung on 3/15/18.
//  Copyright © 2018 Alon Shprung. All rights reserved.
//

import XCTest
@testable import SetGame

class SetTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        let x = 9
        let y = 8
        let result = x + y
        XCTAssertEqual(result, 17)
        XCTAssertTrue(result == 17)
    }
    
    func testMatchedSet() {
        let game = SetGame()
        let card1 = Card(symbol: .symbol0, number: .one, shading: .filled, color: .color0)
        let card2 = Card(symbol: .symbol1, number: .one, shading: .filled, color: .color1)
        let card3 = Card(symbol: .symbol2, number: .one, shading: .filled, color: .color2)
        
        XCTAssertTrue(game.isCardsMatch(cards: [card1,card2,card3]))
    }
    
    func testUnMatchedSet() {
        let game = SetGame()
        let card1 = Card(symbol: .symbol0, number: .one, shading: .filled, color: .color0)
        let card2 = Card(symbol: .symbol0, number: .one, shading: .filled, color: .color1)
        let card3 = Card(symbol: .symbol2, number: .one, shading: .filled, color: .color2)
        
        XCTAssertFalse(game.isCardsMatch(cards: [card1,card2,card3]))
    }
    
    func testFindSet() {
        let game = SetGame()
        if let set = game.findSet() {
            XCTAssertNotNil(game.cardsBeingPlayed.index(of: set[0]))
            XCTAssertNotNil(game.cardsBeingPlayed.index(of: set[1]))
            XCTAssertNotNil(game.cardsBeingPlayed.index(of: set[2]))
            XCTAssertTrue(game.isCardsMatch(cards: set))
        }
    }
    
    func testEmptyDeck() {
        var game = SetGame()
        XCTAssertFalse(game.deck.isNoMoreCardsInDeck())
        game.takeCardsFromDeck(numberOfCards: 81 - 13)
        XCTAssertFalse(game.deck.isNoMoreCardsInDeck())
        game.takeCardsFromDeck(numberOfCards: 1)
        XCTAssertTrue(game.deck.isNoMoreCardsInDeck())
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
