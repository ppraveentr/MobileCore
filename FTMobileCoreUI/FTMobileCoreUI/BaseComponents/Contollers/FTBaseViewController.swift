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
    lazy open var baseView: FTBaseView? = FTBaseView()
    
    open override func loadView() {
        //Make it as Views RooView
        self.view = self.baseView
        self.baseView?.theme = ThemeStyle.defaultStyle
        
        //Setup baseView's topLayoutGuide & bottomLayoutGuide
        setupBaseView()
    }
    
    //Setup baseView's topLayoutGuide by sending true in subControllers if needed
    public func shouldSetSafeAreaLayoutGuide() -> Bool {
        return true
    }
    
    public var mainView: FTView? {

        //If baseView is not added, then retun nil
        if self.baseView?.superview != self.view, self.view != self.baseView { return nil }
        
        return self.baseView?.mainPinnedView
    }
}

//MARK: Layout Guide for rootView
extension FTBaseViewController {
    
    func setupBaseView() {
        
        let local = self.baseView?.rootView
        
//        self.view.pin(view: local!, withEdgeInsets: [.Horizontal, .Bottom])

        /* Pin view bellow status bar */
        if shouldSetSafeAreaLayoutGuide() {
            if #available(iOS 11.0, *) {
                local?.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                            constant: 0.0).isActive = true
                local?.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor,
                                            constant: 0.0).isActive = true
                local?.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor,
                                            constant: 0.0).isActive = true
            } else {
                local?.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor,
                                            constant: 0.0).isActive = true
            }
        }
        
        if #available(iOS 11.0, *) {
            local?.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                           constant: 0.0).isActive = true
        } else {
            local?.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.topAnchor,
                                           constant: 0.0).isActive = true
        }
        
    }
}

//MARK: Notification whenever view is loaded
extension FTBaseViewController {
    
    open override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        postNotification(name: .FTMobileCoreUI_ViewController_WillAppear)
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        postNotification(name: .FTMobileCoreUI_ViewController_DidAppear)
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        postNotification(name: .FTMobileCoreUI_ViewController_WillDisappear)
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        postNotification(name: .FTMobileCoreUI_ViewController_DidDisappear)
    }
}
