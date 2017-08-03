//
//  FTButton.swift
//  FTMobileCoreUI
//
//  Created by Praveen Prabhakar on 13/07/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation

class FTButton: UIButton, FTThemeProtocol {
    
    func updateVisualThemes() {
            
        if let textColor = self.generatedTheme?.textColor {
            self.setTitleColor(textColor, for: .selected)
        }
    }
    
}
