//
//  FTBaseScrollViewController.swift
//  FTMobileCoreUI
//
//  Created by Praveen Prabhakar on 18/08/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation

open class FTBaseScrollViewController: FTBaseViewController {
    
    public lazy var scrollView: FTScrollView = self.getScrollView()
    
    open override func loadView() {
        super.loadView()
        
        _ = self.scrollView
    }
}

extension FTBaseScrollViewController {
    
    func getScrollView() -> FTScrollView {
        
        let local = FTScrollView()
        
        self.mainView?.pin(view: local, withEdgeOffsets: .FTEdgeOffsetsZero())
        
        return local
    }
}
