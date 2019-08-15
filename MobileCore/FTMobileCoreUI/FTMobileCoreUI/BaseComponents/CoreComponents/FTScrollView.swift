//
//  FTScrollView.swift
//  FTMobileCoreUI
//
//  Created by Praveen Prabhakar on 13/07/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation

open class FTScrollView: UIScrollView {

    @IBOutlet
    public lazy var contentView: FTView! = self.setupContentView()

    @discardableResult
    public func setupContentView(_ view: FTView? = nil) -> FTView {

        // Remove old contentView & update with new view
        if view == nil {
            self.contentView = FTView()
        } else {
            contentView?.removeFromSuperview()
            self.contentView = view
        }

        self.pin(view: self.contentView, edgeInsets: [.All], priority: .required)
        self.pin(view: self.contentView, edgeInsets: [.CenterMargin], priority: .defaultLow)
        self.contentView.addSelfSizing()
        
        return self.contentView
    }
    
}
