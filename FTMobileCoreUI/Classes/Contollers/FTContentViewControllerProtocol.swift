//
//  FTContentViewControllerProtocol.swift
//  FTMobileCoreUI
//
//  Created by Praveen Prabhakar on 18/08/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import WebKit

private var kContentVC = "k.FT.AO.ContentViewController"

public protocol FTContentViewControllerProtocol: FTViewControllerProtocol {
    var contentView: WKWebView { get }
}

public extension FTContentViewControllerProtocol {
    
    var contentView: WKWebView {
        get {
            FTAssociatedObject<WKWebView>.getAssociated(self, key: &kContentVC) { self.setupContentView() }!
        }
        set {
            setupContentView(newValue)
        }
    }
}

private extension FTContentViewControllerProtocol {
    
    @discardableResult
    func setupContentView(_ local: WKWebView = WKWebView() ) -> WKWebView {
        
        // Load Base view
        setupCoreView()
        
        if let scroll: WKWebView = FTAssociatedObject<WKWebView>.getAssociated(self, key: &kContentVC) {
            scroll.removeFromSuperview()
            FTAssociatedObject<Any>.resetAssociated(self, key: &kContentVC)
        }
        
        if local.superview == nil {
            self.mainView?.pin(view: local, edgeOffsets: .zero)
        }
        
        FTAssociatedObject<WKWebView>.setAssociated(self, value: local, key: &kContentVC)
        
        return local
    }
}
