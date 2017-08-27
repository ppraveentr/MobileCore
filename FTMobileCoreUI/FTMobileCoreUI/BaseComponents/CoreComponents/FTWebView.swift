//
//  FTWebView.swift
//  FTMobileCoreUI
//
//  Created by Praveen Prabhakar on 13/07/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation
import WebKit

open class FTWebView: WKWebView {
    
//    public override func addSelfSizing() {
//        self.addSelfSizing()
//    }
//    
//    public func resizeToFitSubviews() {
//        
//    }
    
    public func setScrollEnabled(enabled: Bool) {
        
        self.scrollView.isScrollEnabled = enabled
        self.scrollView.panGestureRecognizer.isEnabled = enabled
        self.scrollView.bounces = enabled
        
        for subview in self.subviews {
            if let subview = subview as? UIScrollView {
                subview.isScrollEnabled = enabled
                subview.bounces = enabled
                subview.panGestureRecognizer.isEnabled = enabled
            }
            
            for subScrollView in subview.subviews {
                if type(of: subScrollView) == NSClassFromString("WKContentView")! {
                    for gesture in subScrollView.gestureRecognizers! {
                        subScrollView.removeGestureRecognizer(gesture)
                    }
                }
            }
        }
    }
}
