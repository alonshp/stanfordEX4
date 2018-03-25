//
//  Deck.swift
//  Set
//
//  Created by Alon Shprung on 3/15/18.
//  Copyright © 2018 Alon Shprung. All rights reserved.
//

import Foundation

public struct Deck {
    
    private var cards = [Card]()
    
    init() {
        for symbol in Card.Symbol.all {
            for number in Card.Number.all {
                for color in Card.Color.all {
                    for shading in Card.Shading.all {
                        cards.append(Card(symbol: symbol, number: number, shading: shading, color: color))
                    }
                }
            }
        }
        
        cards.shuffle()
    }
    
    func isNoMoreCardsInDeck() -> Bool {
        return cards.isEmpty
    }
    
    mutating func takeAcard() -> Card? {
        if cards.isEmpty {
            return nil
        }
        return cards.remove(at: 0)
    }
}

extension Array where Element: Equatable{
    mutating func shuffle(){
        var shuffeled = [Element]()
        while !self.isEmpty {
            shuffeled.append(self.remove(at: self.count.arc4random))
        }
        self = shuffeled
    }
}
