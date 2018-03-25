//
//  Set.swift
//  Set
//
//  Created by Alon Shprung on 3/15/18.
//  Copyright © 2018 Alon Shprung. All rights reserved.
//

import Foundation

public struct SetGame {
    
    var deck = Deck()
    var cardsBeingPlayed = [Card]()
    private(set) var score = 0
    private(set) var selectedCardsIndex = Set<Int>()
    private(set) var alreadyMatchedCards = [Card]()
    
    private mutating func checkCardsMatchingWhenThreeCardsSelected() {
        if checkIfSelectedCardsAreMatch() {
            for cardIndex in selectedCardsIndex {
                cardsBeingPlayed[cardIndex].isMatch = true
            }
            increaseScoreAccordingToNumberOfCardsBeingPlayed()
        } else {
            score -= 5
        }
    }
    
    private mutating func increaseScoreAccordingToNumberOfCardsBeingPlayed() {
        switch cardsBeingPlayed.count {
        case 13...15:
            score += 4
        case 16...18:
            score += 3
        case 19...21:
            score += 2
        case 22...24:
            score += 1
        default:
            score += 5
        }
    }
    
    mutating func updateCardsAfterThreeSelected() {
        var matchCards = [Card]()
        for cardIndex in selectedCardsIndex {
            cardsBeingPlayed[cardIndex].isSelected = false
            if cardsBeingPlayed[cardIndex].isMatch {
                if let newCard = deck.takeAcard() {
                    cardsBeingPlayed[cardIndex] = newCard
                } else {
                    cardsBeingPlayed[cardIndex].isAppearOnScreen = false
                    matchCards.append(cardsBeingPlayed[cardIndex])
                }
                // add the match card to alreadyMatchedCards array
                alreadyMatchedCards.append(cardsBeingPlayed[cardIndex])
            }
        }
        
        for card in matchCards {
            cardsBeingPlayed.remove(at: cardsBeingPlayed.index(of: card)!)
        }
        // reset selected cards set
        selectedCardsIndex = Set<Int>()
    }
    
    mutating func dealThreeMoreCards(){
        if selectedCardsIndex.count == 3 {
            updateCardsAfterThreeSelected()
        } else if !deck.isNoMoreCardsInDeck() {
            // if there is a set in the visivle cards - decrease score
            if findSet() != nil {
                score -= 3
            }
            
            // there is more place on the screen
            takeCardsFromDeck(numberOfCards: 3)
        }
    }
    
    mutating func chooseCard(at index: Int) {
        assert(cardsBeingPlayed.indices.contains(index), "SetGame.chooseCard(at: \(index)) : Choosen index out of range")
        
        guard cardsBeingPlayed[index].isAppearOnScreen else {
            return
        }
        
        switch selectedCardsIndex.count {
        case 2:
            selectOrUnselectCard(at: index)
            if selectedCardsIndex.count == 3{
                checkCardsMatchingWhenThreeCardsSelected()
            }
        case 3:
            let isAnotherCardSelected = !selectedCardsIndex.contains(index)
            updateCardsAfterThreeSelected()
            
            // select the another card if selected
            if isAnotherCardSelected {
                selectOrUnselectCard(at: index)
            }
        default:
            selectOrUnselectCard(at: index)
        }
        
    }
    
    private mutating func selectOrUnselectCard(at index: Int){
        if cardsBeingPlayed[index].isSelected {
            cardsBeingPlayed[index].isSelected = false
            selectedCardsIndex.remove(index)
            score -= 1
        } else {
            cardsBeingPlayed[index].isSelected = true
            selectedCardsIndex.insert(index)
        }
    }
    
    private func checkIfSelectedCardsAreMatch() -> Bool{
        var selectedCards = [Card]()
        for index in selectedCardsIndex {
            let currCard = cardsBeingPlayed[index]
            selectedCards.append(currCard)
        }
        return isCardsMatch(cards: selectedCards)
    }
    
    private func getCardsAttributesCount(cards: [Card]) -> SelectedCardsAttributes{
        var cardsColor = Set<Card.Color>()
        var cardsShading = Set<Card.Shading>()
        var cardsNumber = Set<Card.Number>()
        var cardsSymbol = Set<Card.Symbol>()
        
        for currCard in cards {
            cardsColor.insert(currCard.color)
            cardsSymbol.insert(currCard.symbol)
            cardsNumber.insert(currCard.number)
            cardsShading.insert(currCard.shading)
        }
        return SelectedCardsAttributes(cardsColorCount: cardsColor.count, cardsShadingCount: cardsShading.count, cardsNumberCount: cardsNumber.count, cardsSymbolCount: cardsSymbol.count)
    }
    
    public func isCardsMatch(cards: [Card]) -> Bool{
//        let cardsAttributesCount = getCardsAttributesCount(cards: cards)
//
//        let cardsColorCount = cardsAttributesCount.cardsColorCount
//        let cardsShadingCount = cardsAttributesCount.cardsShadingCount
//        let cardsNumberCount = cardsAttributesCount.cardsNumberCount
//        let cardsSymbolCount = cardsAttributesCount.cardsSymbolCount
//
//        if (cardsColorCount == 1 || cardsColorCount == Card.Color.all.count)
//            && (cardsShadingCount == 1 || cardsShadingCount == Card.Shading.all.count)
//            && (cardsNumberCount == 1 || cardsNumberCount == Card.Number.all.count)
//            && (cardsSymbolCount == 1 || cardsSymbolCount == Card.Symbol.all.count) {
//            return true
//        } else {
//            return false
//        }
        return true
    }
    
    mutating func newGame(){
        deck = Deck()
        cardsBeingPlayed = [Card]()
        score = 0
        selectedCardsIndex = Set<Int>()
        alreadyMatchedCards = [Card]()
        takeCardsFromDeck(numberOfCards: 12)
    }
    
    public mutating func takeCardsFromDeck(numberOfCards: Int){
        for _ in 1...numberOfCards {
            if let card = deck.takeAcard() {
                cardsBeingPlayed.append(card)
            } else {
                print("No more cards in deck")
            }
        }
    }
    
    public func findSet() -> [Card]?{
        for cardOne in cardsBeingPlayed {
            for cardTwo in cardsBeingPlayed {
                for cardThree in cardsBeingPlayed {
                    if cardOne != cardTwo && cardOne != cardThree && cardTwo != cardThree
                        && !cardOne.isMatch && !cardTwo.isMatch && !cardThree.isMatch {
                        let possibleSet = [cardOne, cardTwo, cardThree]
                        if isCardsMatch(cards: possibleSet){
                            return possibleSet
                        }
                    }
                }
            }
        }
        return nil
    }
    
    mutating func findAndMatchSet() {
        if let set = findSet() {
        resetSelectedCardsIndexArray()
            for card in set {
                if let cardIndex = cardsBeingPlayed.index(of: card){
                    cardsBeingPlayed[cardIndex].isMatch = true
                    selectedCardsIndex.insert(cardIndex)
                }
            }
        }
    }
    
    private mutating func resetSelectedCardsIndexArray(){
        for cardIndex in selectedCardsIndex{
            cardsBeingPlayed[cardIndex].isSelected = false
        }
        selectedCardsIndex = Set<Int>()
    }
    
    init() {
        takeCardsFromDeck(numberOfCards: 12)
    }
    
    mutating func shuffleCardsBiengPlayed(){
        cardsBeingPlayed.shuffle()
    }
}


extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self))) }
        else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}
