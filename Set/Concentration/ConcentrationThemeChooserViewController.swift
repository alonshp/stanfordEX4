//
//  ConcentrationThemeChooserViewController.swift
//  SetGame
//
//  Created by Alon Shprung on 3/27/18.
//  Copyright © 2018 Alon Shprung. All rights reserved.
//

import UIKit

class ConcentrationThemeChooserViewController: UIViewController, UISplitViewControllerDelegate {

    override func viewDidLoad() {
        let cvc = ConcentrationViewController()
        let themeNames = cvc.emojiThemeNames
        for index in themeButtons.indices{
            themeButtons[index].setTitle(themeNames[index], for: UIControlState.normal)
        }
    }
    
    override func awakeFromNib() {
        splitViewController?.delegate = self
    }
    
    func splitViewController(_ splitViewController: UISplitViewController,
                             collapseSecondary secondaryViewController: UIViewController,
                             onto primaryViewController: UIViewController) -> Bool {
        if let cvc = secondaryViewController as? ConcentrationViewController{
            if cvc.currTheme == nil {
                return true
            }
        }
        return false
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
