//
//  FTContentView.swift
//  FTMobileCoreUI
//
//  Created by Praveen Prabhakar on 13/07/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation

open class FTContentView: FTScrollView {
    
    lazy var webView: FTWebView = self.getWebView()
    
    private func getWebView() -> FTWebView {
        
        let webView = FTWebView()
        
        super.contentView.pin(view: webView)
        
        return webView
    }
}
