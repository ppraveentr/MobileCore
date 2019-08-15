//
//  FTUIView.swift
//  FTMobileCoreUI
//
//  Created by Praveen Prabhakar on 05/08/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation

// Used for UIView subclasses Type
protocol FTUIViewThemeProtocol: FTThemeProtocol {
    // Used for View
   func get_ThemeSubType() -> String?
}

open class FTUIView: UIView, FTUIViewThemeProtocol {
    
    public func get_ThemeSubType() -> String? {
        if self.isUserInteractionEnabled {
            return nil
        }else{
            return "disabled"
        }
    }
    
    // Force update theme attibute
    public func updateTheme(_ theme: FTThemeModel) {

    }
}
