//
//  FTThemesManager.swift
//  FTCoreUtility
//
//  Created by Praveen Prabhakar on 29/07/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation

open class FTThemesManager {
    
    public class func setupThemes() {
        UIView.__setupThemes__()
    }
}

public extension UIView {
    
    private static let aoThemes = FTAssociatedObject<String>()
    
    private static let aoThemesNeedsUpdate = FTAssociatedObject<Bool>()
    
    public final var Themes: String? {
        get { return UIView.aoThemes[self] }
        set {
            UIView.aoThemes[self] = newValue
            self.needsThemesUpdate = true
        }
    }
    
    public final var needsThemesUpdate: Bool {
        get { return UIView.aoThemesNeedsUpdate[self] ?? false }
        set { UIView.aoThemesNeedsUpdate[self] = newValue }
    }
    
    fileprivate final func __updateVisualThemes__() {
        self.needsThemesUpdate = false
        self.updateVisualThemes()
    }
    
    func updateVisualThemes() { }
}

extension UIView {
        
    class func __setupThemes__() {
        FTInstanceSwizzling(self, #selector(layoutSubviews), #selector(swizzled_layoutSubviews))
    }
    
    func swizzled_layoutSubviews() {
        if self.needsThemesUpdate {
            self.__updateVisualThemes__()
        }
        self.swizzled_layoutSubviews()
    }
}
