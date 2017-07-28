//
//  FTUtils.swift
//  FTMobileCore
//
//  Created by Praveen Prabhakar on 15/06/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation

//CGRect
extension CGRect {
    
    func getX() -> CGFloat {
        return self.origin.x
    }
    
    func getY() -> CGFloat {
        return self.origin.y
    }
    
    func getWidth() -> CGFloat {
        return self.size.width
    }
    
    func getHeight() -> CGFloat {
        return self.size.height
    }
}

