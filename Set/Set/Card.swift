//
//  Card.swift
//  Set
//
//  Created by Alon Shprung on 3/15/18.
//  Copyright © 2018 Alon Shprung. All rights reserved.
//

import Foundation

public struct Card: Equatable {
    public static func ==(lhs: Card, rhs: Card) -> Bool {
        if lhs.color == rhs.color && lhs.number == rhs.number && lhs.shading == rhs.shading && lhs.symbol == rhs.symbol {
            return true
        } else {
            return false
        }
    }
    
    var isSelected = false
    var isMatch = false
    var isAppearOnScreen = true
    var symbol: Symbol
    var number: Number
    var shading: Shading
    var color: Color
    
    enum Symbol {
        case symbol0
        case symbol1
        case symbol2
        
        static var all = [Symbol.symbol0, .symbol1, .symbol2]
    }
    
    enum Number: Int {
        case one = 1
        case two = 2
        case three = 3
        
        static var all = [Number.one, .two, .three]
    }
    
    enum Shading {
        case striped
        case filled
        case outline
        
        static var all = [Shading.striped, .filled, .outline]
    }
    
    enum Color {
        case color0
        case color1
        case color2
        
        static var all = [Color.color0, .color1, .color2]
    }
    
    init(symbol: Symbol, number: Number, shading: Shading, color: Color) {
        self.symbol = symbol
        self.number = number
        self.shading = shading
        self.color = color
    }
}
