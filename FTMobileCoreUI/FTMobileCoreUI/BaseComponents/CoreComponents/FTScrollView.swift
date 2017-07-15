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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.commonInit()
    }
    
    func setupContentView() -> FTView {
        
        let contentView = FTView()
        self.addSubview(contentView)
        self.pin(view: contentView, withEdgeInsets: [.Left, .Top, .CenterMargin], withLayoutPriority: UILayoutPriorityRequired)
//        contentView.rightAnchor.constraint(greaterThanOrEqualTo: self.rightAnchor)
//        contentView.bottomAnchor.constraint(greaterThanOrEqualTo: self.bottomAnchor)
        
        contentView.addSelfSizing()
        
        return contentView
    }
    
    func commonInit() {
        
    }

    open override func layoutSubviews() {
        contentView.resizeView()
        super.layoutSubviews()
    }
}
