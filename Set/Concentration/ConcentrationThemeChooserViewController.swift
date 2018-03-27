//
//  ConcentrationThemeChooserViewController.swift
//  SetGame
//
//  Created by Alon Shprung on 3/27/18.
//  Copyright © 2018 Alon Shprung. All rights reserved.
//

import UIKit

class ConcentrationThemeChooserViewController: UIViewController {

    override func viewDidLoad() {
        let cvc = ConcentrationViewController()
        let themeNames = cvc.emojiThemeNames
        for index in themeButtons.indices{
            themeButtons[index].setTitle(themeNames[index], for: UIControlState.normal)
        }
    }
    @IBOutlet var themeButtons: [UIButton]!
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Choose Theme" {
            if let themeButton = sender as? UIButton {
                if let themeName = themeButton.currentTitle {
                    if let cvc = segue.destination as? ConcentrationViewController {
                        cvc.updateEmojiTheme(themeName)
                    }
                }
            }
        }
    }


}
