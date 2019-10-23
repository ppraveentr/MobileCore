//
//  FTViewControllerProtocol.swift
//  FTMobileCoreUI
//
//  Created by Praveen Prabhakar on 15/06/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import UIKit

public typealias FTViewControllerCompletionBlock = (_ isSuccess: Bool, _ modelStack: AnyObject?) -> Void

public protocol FTViewControllerProtocol where Self: UIViewController {
    //Setup View
    func setupCoreView()
    // MARK: Navigation Bar
    //Bydefalut leftButton action is set to 'leftButtonAction'
    func setupNavigationbar(title: String, leftButton: UIBarButtonItem?, rightButton: UIBarButtonItem?)
    //invokes's 'popViewController' if not rootViewController or-else invokes 'dismiss'
    func dismissSelf(_ animated: Bool)
    //Navigation bar defalut Actions
    func leftButtonAction()
    func rightButtonAction()
    // MARK: Keyboard notification.
    func registerKeyboardNotifications()
    //Notifications will be unregistered in 'deinit'
    func unregisterKeyboardNotifications()
    // MARK: Alert ViewController
    func showAlert(title: String, message: String, action: UIAlertAction?, actions: [UIAlertAction]?)
    // MARK: Responder
    func makeResponder(status: Bool, textField: UITextField, text: String?)
    // MARK: Activity indicator
    func showActivityIndicator()
    func hideActivityIndicator()
}

private extension FTAssociatedKey {
    static var baseView = "baseView"
    static var baseViewTheme = "baseViewTheme"
    static var screenIdentifier = "screenIdentifier"
    static var modelStack = "modelStack"
    static var completionBlock = "completionBlock"
}

extension UIViewController: FTViewControllerProtocol {

    @IBOutlet
    public var baseView: FTView? {
        get {
            return FTAssociatedObject.getAssociated(self, key: &FTAssociatedKey.baseView) { FTView() }
        }
        set {
            FTAssociatedObject<FTView>.setAssociated(self, value: newValue, key: &FTAssociatedKey.baseView)
        }
    }
    
    @IBInspectable
    public var baseViewTheme: String {
        get {
            return FTAssociatedObject.getAssociated(self, key: &FTAssociatedKey.baseViewTheme) ?? FTThemeStyle.defaultStyle
        }
        set {
            FTAssociatedObject<String>.setAssociated(self, value: newValue, key: &FTAssociatedKey.baseViewTheme)
        }
    }
    
    @IBOutlet
    public var topPinnedButtonView: UIView? {
        get {
            return self.baseView?.topPinnedView
        }
        set {
           self.baseView?.topPinnedView = newValue
        }
    }
    
    @IBOutlet
    public var bottomPinnedButtonView: UIView? {
        get {
            return self.baseView?.bottomPinnedView
        }
        set {
           self.baseView?.bottomPinnedView = newValue
        }
    }
    
    // Unquie Identifier for eachScreen
    public var screenIdentifier: String? {
        get {
            return FTAssociatedObject<String>.getAssociated(self, key: &FTAssociatedKey.screenIdentifier)
        }
        set {
            FTAssociatedObject<String>.setAssociated(self, value: newValue, key: &FTAssociatedKey.screenIdentifier)
        }
    }
    
    // modelData that can be passed from previous controller
    public var modelStack: AnyObject? {
        get {
            return FTAssociatedObject<AnyObject>.getAssociated(self, key: &FTAssociatedKey.modelStack)
        }
        set {
            FTAssociatedObject<AnyObject>.setAssociated(self, value: newValue, key: &FTAssociatedKey.modelStack)
        }
    }
    
    public var completionBlock: FTViewControllerCompletionBlock? {
        get {
            return FTAssociatedObject<FTViewControllerCompletionBlock>.getAssociated(self, key: &FTAssociatedKey.completionBlock)
        }
        set {
            FTAssociatedObject<FTViewControllerCompletionBlock>.setAssociated(self, value: newValue, key: &FTAssociatedKey.completionBlock)
        }
    }

    // Setup baseView's topLayoutGuide by sending true in subControllers if needed
    public func topSafeAreaLayoutGuide() -> Bool {
        return true
    }
    
    public func horizontalSafeAreaLayoutGuide() -> Bool {
        return true
    }
    
    // Will dismiss Keyboard by tapping on any non-interative part of the view.
    public func shouldDissmissKeyboardOnTap() -> Bool {
        return true
    }
    
    public func setupCoreView() {
        if self.view == self.baseView {
            return
        }
        guard let rootView = self.view else { return }
        var isValidBaseView = false
        
        // Make it as Views RooView, if forget to map it in IB.
        if self.baseView != rootView, (rootView as? FTView) != nil {
            self.baseView = rootView as? FTView
            isValidBaseView = true
        }
        
        self.view = self.baseView
        // Set defalut theme
        self.baseView?.theme = baseViewTheme
        // Setup baseView's topLayoutGuide & bottomLayoutGuide
        setupLayoutGuide()
        // To Dismiss keyboard on tap in view
        setupKeyboardTapRecognizer()
        
        // Reset rootView
        if !isValidBaseView {
            rootView.removeFromSuperview()
            self.mainView?.pin(view: rootView, edgeOffsets: .zero)
        }
    }
}

extension UIViewController {
    // MARK: Navigation Bar
    public func setupNavigationbar(title: String, leftButton: UIBarButtonItem? = nil, rightButton: UIBarButtonItem? = nil) {
        self.title = title
        configureBarButton(button: leftButton, defaultAction: kleftButtonAction)
        configureBarButton(button: rightButton, defaultAction: kRightButtonAction)
        self.navigationItem.leftBarButtonItem = leftButton
        self.navigationItem.rightBarButtonItem = rightButton
    }
    
    // MARK: Dissmiss Self model
    public func dismissSelf(_ animated: Bool = true) {
        self_dismissSelf(animated)
    }
    
    // MARK: default Nav-bar button actions
    @IBAction
    open func leftButtonAction() {
        dismissSelf()
    }
    
    @IBAction
    open func rightButtonAction() {
        // Optional Protocol implementation: intentionally empty
    }
}

// MARK: Layout Guide for rootView
private extension UIViewController {
    
    func setupLayoutGuide() {
        // Update: topPinnedButtonView
        if let topView = self.topPinnedButtonView {
           self.baseView?.topPinnedView = topView
        }

        // Update: bottomPinnedButtonView
        if let bottomView = self.bottomPinnedButtonView {
           self.baseView?.bottomPinnedView = bottomView
        }

        // Pin: rootView
        let local = self.baseView?.rootView

        /* Pin view bellow status bar */
        // Pin - rootView's topAnchor
        if topSafeAreaLayoutGuide(), let local = local {
            setupTopSafeAreaLayoutGuide(local)
        }

        // Pin - rootView's topAnchor
        if #available(iOS 11.0, *), horizontalSafeAreaLayoutGuide() {
            local?.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 0.0).isActive = true
            local?.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: 0.0).isActive = true
        }

        // Pin - rootView's bottomAnchor
        if #available(iOS 11.0, *) {
            local?.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0.0).isActive = true
        }
        else {
            local?.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.topAnchor, constant: 0.0).isActive = true
        }
    }
    
    func setupTopSafeAreaLayoutGuide(_ local: UIView) {
        if #available(iOS 11.0, *) {
            local.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0.0).isActive = true
        }
        else {
            local.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor, constant: 0.0).isActive = true
        }
    }
}
