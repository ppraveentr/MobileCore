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
    public static var kLeftButtonAction = #selector(leftButtonAction)

    open override func loadView() {
        // Make it as Views RooView
        self.view = self.baseView
        self.baseView?.theme = ThemeStyle.defaultStyle
        
        // Setup baseView's topLayoutGuide & bottomLayoutGuide
        setupBaseView()
    }
    
    // Setup baseView's topLayoutGuide by sending true in subControllers if needed
    open func shouldSetSafeAreaLayoutGuide() -> Bool {
        return true
    }

    private var isBaseViewAdded: Bool {
        get {
            // If baseView is not added, then retun false
            return (self.baseView?.superview != self.view && self.view != self.baseView)
        }
    }
    public var mainView: FTView? {

        // If baseView is not added, then retun nil
        if isBaseViewAdded {
            return nil
        }
        
        return self.baseView?.mainPinnedView
    }

    public func topPinnedView() -> FTView? {

        // If baseView is not added, then retun nil
        if isBaseViewAdded {
            return nil
        }

        return self.baseView?.topPinnedView
    }

    // MARK: Navigation Bar
    public func setupNavigationbar(title: String,
                            leftButtonTitle: String? = nil, leftButtonImage: UIImage? = nil, leftButtonAction: Selector? = kLeftButtonAction, leftCustomView: UIView? = nil,
                            rightButtonTitle: String? = nil, rightButtonImage: UIImage? = nil, rightButtonAction: Selector? = #selector(rightButtonAction), rightCustomView: UIView? = nil) {
        self.title = title

        if leftButtonTitle != nil || leftButtonImage != nil || leftCustomView != nil {
            self.leftButton(title: leftButtonTitle, image: leftButtonImage, customView: leftCustomView, buttonAction: leftButtonAction)
        }
        if rightButtonTitle != nil || rightButtonImage != nil || rightCustomView != nil {
            self.setRightButton(title: rightButtonTitle, image: rightButtonImage, customView: rightCustomView, buttonAction: rightButtonAction)
        }
    }

    public func setupNavigationbar(title: String,
                                   leftButton: UIBarButtonItem? = nil,
                                   rightButton: UIBarButtonItem? = nil) {
        self.title = title
        self.navigationItem.leftBarButtonItem = leftButton
        self.navigationItem.rightBarButtonItem = rightButton
    }

    @discardableResult
    public func leftButton(title: String? = nil,
                           image: UIImage? = nil,
                           buttonType: UIBarButtonItem.SystemItem = .stop,
                           customView: UIView? = nil,
                           buttonAction: Selector? = kLeftButtonAction) -> UIBarButtonItem {
        let backButton = self.navigationBarButton(title: title, image: image,
                                                  buttonType:buttonType,
                                                  customView: customView,
                                                  buttonAction: buttonAction)
        self.navigationItem.leftBarButtonItem = backButton
        return backButton
    }

    @discardableResult
    public func setRightButton(title: String? = nil,
                               image: UIImage? = nil,
                               buttonType: UIBarButtonItem.SystemItem = .done,
                               customView: UIView? = nil,
                               buttonAction: Selector? = #selector(rightButtonAction)) -> UIBarButtonItem? {
        let backButton = self.navigationBarButton(title: title, image: image, buttonType: buttonType, customView: customView, buttonAction: buttonAction)
        self.navigationItem.rightBarButtonItem = backButton
        return backButton
    }

    public func navigationBarButton(title: String? = nil,
                                    image: UIImage? = nil,
                                    buttonType: UIBarButtonItem.SystemItem,
                                    customView: UIView? = nil,
                                    buttonAction: Selector? = kLeftButtonAction) -> UIBarButtonItem {

        guard title != nil, image != nil else {
            if let customView = customView {
                return UIBarButtonItem(customView: customView)
            }
            return UIBarButtonItem(barButtonSystemItem: buttonType, target: self, action: buttonAction)
        }

        let button = FTButton(type: .custom)
        button.titleLabel?.text = title
        button.imageView?.image = image
        if let buttonAction = buttonAction {
            button.target(forAction: buttonAction, withSender: self)
        }

        let backButton = UIBarButtonItem(customView: button)
        return backButton
    }

    // MARK: Dissmiss Self model
    public func dismissSelf(_ animated: Bool = true) {
        if navigationController != nil, navigationController?.viewControllers.first != self {
            navigationController?.popViewController(animated: animated)
        }
        else if let presentedViewController = self.presentedViewController {
            presentedViewController.dismiss(animated: animated, completion: nil)
        }
        else {
            self.dismiss(animated: animated, completion: nil)
        }
    }

    @objc @IBAction open func leftButtonAction() {
        dismissSelf()
    }

    @objc @IBAction open func rightButtonAction() {
    }
    
}

extension FTBaseViewController {

    // MARK: Layout Guide for rootView
    func setupBaseView() {
        
        let local = self.baseView?.rootView
        
//       self.view.pin(view: local!, withEdgeInsets: [.Horizontal, .Bottom])

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

// MARK: Notification whenever view is loaded
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
