//
//  ViewControllerProtocol.swift
//  CoreUIExtensions
//
//  Created by Praveen Prabhakar on 15/06/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import UIKit

public protocol ViewControllerProtocol where Self: UIViewController {
    var modelStack: AnyObject? { get set }
    
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
    func showAlert(title: String?, message: String?, action: UIAlertAction?, actions: [UIAlertAction]?)
    // MARK: Activity indicator
    func showActivityIndicator()
    func hideActivityIndicator(_ completionBlock: LoadingIndicator.CompletionBlock?)
}

private extension AssociatedKey {
    static var baseView = "baseView"
    static var screenIdentifier = "screenIdentifier"
    static var modelStack = "modelStack"
    static var completionBlock = "completionBlock"
}

extension UIViewController: ViewControllerProtocol {

    @IBOutlet
    public var baseView: FTView? {
        get {
            AssociatedObject.getAssociated(self, key: &AssociatedKey.baseView) { FTView() }
        }
        set {
            AssociatedObject<FTView>.setAssociated(self, value: newValue, key: &AssociatedKey.baseView)
        }
    }
    
    @IBOutlet
    public var topPinnedView: UIView? {
        get {
            self.baseView?.topPinnedView
        }
        set {
            self.baseView?.topPinnedView = newValue
        }
    }
    
    @IBOutlet
    public var bottomPinnedView: UIView? {
        get {
            self.baseView?.bottomPinnedView
        }
        set {
            self.baseView?.bottomPinnedView = newValue
        }
    }
    
    // Unquie Identifier for eachScreen
    public var screenIdentifier: String? {
        get {
            AssociatedObject<String>.getAssociated(self, key: &AssociatedKey.screenIdentifier)
        }
        set {
            AssociatedObject<String>.setAssociated(self, value: newValue, key: &AssociatedKey.screenIdentifier)
        }
    }
    
    // modelData that can be passed from previous controller
    public var modelStack: AnyObject? {
        get {
            AssociatedObject<AnyObject>.getAssociated(self, key: &AssociatedKey.modelStack)
        }
        set {
            AssociatedObject<AnyObject>.setAssociated(self, value: newValue, key: &AssociatedKey.modelStack)
        }
    }
    
    // Setup baseView's topLayoutGuide by sending true in subControllers if needed
    public func topSafeAreaLayoutGuide() -> Bool { true }
    
    public func horizontalSafeAreaLayoutGuide() -> Bool { true }
    
    // Will dismiss Keyboard by tapping on any non-interative part of the view.
    public func shouldDissmissKeyboardOnTap() -> Bool { true }
    
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
        if let topView = self.topPinnedView {
           self.baseView?.topPinnedView = topView
        }

        // Update: bottomPinnedButtonView
        if let bottomView = self.bottomPinnedView {
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
