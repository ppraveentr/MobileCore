//
//  FTBaseViewController.swift
//  FTMobileCoreUI
//
//  Created by Praveen Prabhakar on 15/06/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import UIKit

open class FTBaseViewController : UIViewController {
    
    @IBOutlet
    public lazy var baseView: FTBaseView? = self.getBaseView()
    
    open override func loadView() {
        super.loadView()
        
        //SetupBase by invoking it
        _ = self.baseView
    }
    
    public var mainView: FTView? {

        //If baseView is not added, then retun nil
        if self.baseView?.superview != self.view { return nil }
        
        return self.baseView?.mainPinnedView
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.post(name: .FTMobileCoreUI_ViewController_DidLoad, object: self)
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.post(name: .FTMobileCoreUI_ViewController_WillAppear, object: self)
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.post(name: .FTMobileCoreUI_ViewController_DidAppear, object: self)
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.post(name: .FTMobileCoreUI_ViewController_WillDisappear, object: self)
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.post(name: .FTMobileCoreUI_ViewController_DidDisappear, object: self)
    }
}

extension FTBaseViewController {
    
    func getBaseView() -> FTBaseView {
        
        let local = FTBaseView()
        
        self.view.pin(view: local, withEdgeInsets: [.Horizontal, .Bottom])
        
        //Pin view bellow status bar
        local.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor,
                                   constant: 0.0).isActive = true
        
        local.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.topAnchor,
                                   constant: 0.0).isActive = true
        
        return local
    }
}
