//
//  FTUIView.swift
//  FTMobileCoreUI
//
//  Created by Praveen Prabhakar on 05/08/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation

open class FTUIView: UIView, FTThemeProtocol {
    
    public func get_ThemeSubType() -> String? {
        if self.isUserInteractionEnabled {
            return nil
        }else{
            return "disabled"
        }
    }
}
