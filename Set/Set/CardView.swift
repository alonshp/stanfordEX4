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
    
}
