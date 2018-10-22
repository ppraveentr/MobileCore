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
    public func setupContentView(_ view: FTView = FTView()) -> FTView {

        // Remove old contentView & update with new view
        contentView?.removeFromSuperview()
        self.contentView = view

        self.pin(view: view, edgeInsets: [.All], priority: .required)
        self.pin(view: view, edgeInsets: [.CenterMargin], priority: .defaultLow)
        view.addSelfSizing()
        
        return view
    }
    
}
