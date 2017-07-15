//
//  FTScrollView.swift
//  FTMobileCoreUI
//
//  Created by Praveen Prabhakar on 13/07/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation

open class FTScrollView: UIScrollView {
    
    public lazy var contentView: FTView = self.setupContentView()
    
    func setupContentView() -> FTView {
        
        let contentView = FTView()
        self.pin(view: contentView, withEdgeInsets: [.All], withLayoutPriority: UILayoutPriorityRequired)
        self.pin(view: contentView, withEdgeInsets: [.CenterMargin], withLayoutPriority: UILayoutPriorityDefaultLow)
        contentView.addSelfSizing()
        
        return contentView
    }
    
}
