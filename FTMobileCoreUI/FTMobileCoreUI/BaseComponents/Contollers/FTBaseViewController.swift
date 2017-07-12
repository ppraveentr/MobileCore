//
//  FTBaseViewController.swift
//  FTMobileCoreUI
//
//  Created by Praveen Prabhakar on 15/06/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import UIKit

open class FTBaseViewController : UIViewController {
    
    public lazy var baseView: FTBaseView = FTBaseView()
    
    open override func loadView() {
        super.loadView()
        
        self.view.pin(view: self.baseView, withEdgeInsets: [.Horizontal, .Bottom])
        
        //Pin view bellow status bar
        self.baseView.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor,
                                    constant: 0.0).isActive = true
    }
    
    public var mainView: FTView? { return self.baseView.mainPinnedView }

}
