//
//  but.swift
//  todoist
//
//  Created by Павел Тимофеев on 17.06.2021.
//

import UIKit

extension UIButton {
    func setSelectedColor() {
        self.backgroundColor = #colorLiteral(red: 0.4274509804, green: 0.737254902, blue: 0.3882352941, alpha: 0.7645596591)
        
    }
    
    func setDeselectedButton() {
        self.backgroundColor = #colorLiteral(red: 0.4274509804, green: 0.737254902, blue: 0.3882352941, alpha: 1)

    }
}