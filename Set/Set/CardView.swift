//
//  CardXib.swift
//  SetGame
//
//  Created by Alon Shprung on 3/20/18.
//  Copyright © 2018 Alon Shprung. All rights reserved.
//

import UIKit

class CardView: UIView {
    

    @IBOutlet weak var cardLable: UILabel!
    
    @IBOutlet weak var cardInternalView: UIView!
    
    var isFaceUp: Bool = false {
        didSet { setNeedsDisplay(); setNeedsLayout() }
        
    }
    
    override func draw(_ rect: CGRect) {
        if isFaceUp {
            cardLable.isHidden = false
            cardInternalView.backgroundColor = #colorLiteral(red: 0.7156063318, green: 0.7704055309, blue: 0.9985981584, alpha: 1)
        } else {
            cardLable.isHidden = true
            cardInternalView.backgroundColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
        }
    }
    
    // storyboard initializer
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fromNib()
    }
    
    // code initializer
    override init(frame: CGRect) {
        super.init(frame: CGRect.zero)
        fromNib()
    }
    
    override func awakeFromNib() {
        cardLable.isHidden = true
        cardInternalView.backgroundColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
    }
    
}
