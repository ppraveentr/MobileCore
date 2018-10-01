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
        self.pin(view: contentView, edgeInsets: [.All], priority: .required)
        self.pin(view: contentView, edgeInsets: [.CenterMargin], priority: .defaultLow)
        contentView.addSelfSizing()
        
        return contentView
    }
    
}
