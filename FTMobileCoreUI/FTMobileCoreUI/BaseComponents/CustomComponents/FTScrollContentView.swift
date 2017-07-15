//
//  FTScrollContentView.swift
//  FTMobileCoreUI
//
//  Created by Praveen Prabhakar on 13/07/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation

open class FTScrollContentView: FTView {
    
    open let scrollView: FTScrollView = FTScrollView()
    open let contentView: FTView = FTView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.commonInit()
    }
    
    func commonInit() {
        self.pin(view: scrollView)
        scrollView.pin(view: contentView)
        self.pin(view: contentView, withEdgeInsets: .EqualWidth, addToSubView: false)
    }
}
