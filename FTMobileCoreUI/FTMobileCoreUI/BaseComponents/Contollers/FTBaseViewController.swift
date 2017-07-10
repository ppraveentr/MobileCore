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
    
    public var mainView: FTView! { return (self.view as! FTBasePinnedView).mainPinnedView }

}
