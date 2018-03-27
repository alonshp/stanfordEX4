//
//  ConcentrationCard.swift
//  SetGame
//
//  Created by Alon Shprung on 3/27/18.
//  Copyright © 2018 Alon Shprung. All rights reserved.
//

import Foundation

struct ConcentrationCard {
    var isFaceUp = false
    var isMatched = false
    var identifier: Int
    
    private static var identifierFactory = 0
    
    private static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
    
    init() {
        self.identifier = ConcentrationCard.getUniqueIdentifier()
    }
}

