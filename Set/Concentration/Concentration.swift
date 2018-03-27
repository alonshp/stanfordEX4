//
//  Concentration.swift
//  SetGame
//
//  Created by Alon Shprung on 3/27/18.
//  Copyright © 2018 Alon Shprung. All rights reserved.
//

import Foundation

class Concentration {
    
    private(set) var cards = [ConcentrationCard]()
    var gameScore = 0
    var flipCount = 0
    var matchesLeft = 0
    var numberOfPairsOfCards = 0
    var lastDate = Date()
    private var seenIds = [Int]()
    
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            var foundIndex: Int?
            for index in cards.indices {
                if cards[index].isFaceUp  {
                    guard foundIndex == nil else { return nil }
                    foundIndex = index
                }
            }
            return foundIndex
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    private func updateScoreWhenUnmatched(index: Int, matchIndex: Int, badScoreBasedTime: Int) {
        if seenIds.contains(cards[index].identifier){
            gameScore = gameScore - 1 - badScoreBasedTime
        }
        if seenIds.contains(cards[matchIndex].identifier){
            gameScore = gameScore - 1 - badScoreBasedTime
        }
    }
    
    func chooseCard(at index: Int) {
        assert(cards.indices.contains(index), "Concentration.chooseCard(at: \(index)) : Choosen index out of range")
        if !cards[index].isMatched {
            flipCount += 1
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                
                let currTimeInterval = -lastDate.timeIntervalSinceNow
                self.lastDate = Date()
                var goodScoreBasedTime = 0
                var badScoreBasedTime = 0
                switch currTimeInterval {
                case 0..<5:
                    goodScoreBasedTime = 3
                    badScoreBasedTime = 0
                case 5..<10:
                    goodScoreBasedTime = 2
                    badScoreBasedTime = 1
                case 10..<30:
                    goodScoreBasedTime = 1
                    badScoreBasedTime = 2
                default:
                    goodScoreBasedTime = 0
                    badScoreBasedTime = 3
                }
                
                // check if cards match
                if cards[matchIndex].identifier == cards[index].identifier {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    gameScore = gameScore + 2 + goodScoreBasedTime
                    matchesLeft -= 1
                } else {
                    // cards unmatched, update score if needed
                    updateScoreWhenUnmatched(index: index, matchIndex: matchIndex,badScoreBasedTime: badScoreBasedTime)
                }
                // Insert the card Id to the seen Id's array
                seenIds.append(cards[index].identifier)
                seenIds.append(cards[matchIndex].identifier)
                cards[index].isFaceUp = true
                
            } else {
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
    
    func faceDownCard(at index: Int){
        assert(cards.indices.contains(index), "Concentration.chooseCard(at: \(index)) : Choosen index out of range")
        cards[index].isFaceUp = false
    }
    
    init(numberOfPairsOfCards: Int) {
        assert(numberOfPairsOfCards > 0, "Concentration.init(\(numberOfPairsOfCards)) : You must have at least one pair of cards")
        matchesLeft = numberOfPairsOfCards
        self.numberOfPairsOfCards = numberOfPairsOfCards
        for _ in 1...numberOfPairsOfCards {
            let card = ConcentrationCard()
            cards += [card, card]
        }
        // Shuffle the cards
        shuffleCards()
    }
    
    func shuffleCards(){
        var shuffeled = [ConcentrationCard]()
        while !cards.isEmpty {
            shuffeled.append(cards.remove(at: cards.count.arc4random))
        }
        cards = shuffeled
    }
    
    func startNewGame(){
        for cardIndex in cards.indices {
            cards[cardIndex].isFaceUp = false
            cards[cardIndex].isMatched = false
        }
        gameScore = 0
        flipCount = 0
        matchesLeft = numberOfPairsOfCards
        lastDate = Date()
        seenIds = [Int]()
        shuffleCards()
    }
}



