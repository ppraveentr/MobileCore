//
//  FTBaseViewController.swift
//  FTMobileCoreUI
//
//  Created by Praveen Prabhakar on 15/06/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import UIKit

open class FTBaseViewController : UIViewController {
    
    open override func loadView() {
        super.view = FTBasePinnedView()
        
        self.edgesForExtendedLayout = .all
        
        self.extendedLayoutIncludesOpaqueBars = false;
        self.automaticallyAdjustsScrollViewInsets = false;
    }
    
    public var mainView: FTBasePinnedView! { return self.view as! FTBasePinnedView }
    
    open override func loadViewIfNeeded() {
        self.edgesForExtendedLayout = UIRectEdge(rawValue: 0)
    }

}
