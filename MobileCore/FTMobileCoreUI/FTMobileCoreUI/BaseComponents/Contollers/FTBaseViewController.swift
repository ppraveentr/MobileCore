//
//  FTBaseViewController.swift
//  FTMobileCoreUI
//
//  Created by Praveen Prabhakar on 15/06/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import UIKit

public typealias FTAppBaseCompletionBlock = (_ isSuccess: Bool, _ modelStack: AnyObject?) -> Void

public protocol FTAppBaseProtocal {
    //Setup View
    func setupBaseView()
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

// `self.view` Should be a `FTBaseView`.
open class FTBaseViewController: UIViewController {

    @IBOutlet
    open lazy var baseView: FTBaseView? = FTBaseView()
    @IBInspectable
    open var baseViewTheme: String = FTThemeStyle.defaultStyle

    @IBOutlet
    open var topPinnedButtonView: FTView? = nil {
        didSet {
            // updated only when `isViewLoaded` is true, else will be updated during `setupBaseView`
            if isViewLoaded {
                self.baseView?.topPinnedView = topPinnedButtonView
            }
        }
    }
    @IBOutlet
    open var bottomPinnedButtonView: FTView? = nil {
        didSet {
            // updated only when `isViewLoaded` is true, else will be updated during `setupBaseView`
            if isViewLoaded {
                self.baseView?.bottomPinnedView = bottomPinnedButtonView
            }
        }
    }

    // default - left Button Actopm
    public static var kleftButtonAction = #selector(leftButtonAction)
    public static var kRightButtonAction = #selector(rightButtonAction)

    // Unquie Identifier for eachScreen
    open var screenIdentifier: String?
    // modelData that can be passed from previous controller
    open var modelStack: AnyObject?
    open var completionBlock: FTAppBaseCompletionBlock?

    private var isBaseViewAdded: Bool {
        // If baseView is not added, then retun false
        return (self.baseView?.superview != self.view && self.view != self.baseView)
    }

    deinit {
        do { // Remove all Observer in `self`
            NotificationCenter.default.removeObserver(self)
        }
    }

    public var isLoadedFromInterface = false
    
    public convenience init() {
        self.init(nibName: nil, bundle: nil)
    }
    
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        isLoadedFromInterface = true
    }

    override open func loadView() {
         super.loadView()
        // Make it as Views RooView, if forget to map it in IB.
        if self.baseView != self.view, (self.view as? FTBaseView) != nil {
            self.baseView = self.view as? FTBaseView
        }
        self.view = self.baseView
        // Set defalut theme
        self.baseView?.theme = self.baseViewTheme
        // Setup baseView's topLayoutGuide & bottomLayoutGuide
        setupBaseView()
        // To Dismiss keyboard on tap in view
        setupKeyboardTapRecognizer()
    }

    public var mainView: FTView? {
        // If baseView is not added, then retun nil
        if isBaseViewAdded {
            return nil
        }
        return self.baseView?.mainPinnedView
    }
}

extension FTBaseViewController: FTAppBaseProtocal {
    // Setup baseView's topLayoutGuide by sending true in subControllers if needed
    open func topSafeAreaLayoutGuide() -> Bool {
        return true
    }
    
    open func horizontalSafeAreaLayoutGuide() -> Bool {
        return true
    }
    
    // Will dismiss Keyboard by tapping on any non-interative part of the view.
    open func shouldDissmissKeyboardOnTap() -> Bool {
        return true
    }
    
    // MARK: Navigation Bar
    public func setupNavigationbar(title: String, leftButton: UIBarButtonItem? = nil, rightButton: UIBarButtonItem? = nil) {
        self_setupNavigationbar(title: title, leftButton: leftButton, rightButton: rightButton)
    }
    
    // MARK: Dissmiss Self model
    public func dismissSelf(_ animated: Bool = true) {
        self_dismissSelf()
    }
    
    // MARK: default Nav-bar button actions
    @IBAction open func leftButtonAction() {
        dismissSelf()
    }
    
    @IBAction open func rightButtonAction() {
        // Optional Protocal implementation: intentionally empty
    }
    
    // MARK: Keyboard
    func setupKeyboardTapRecognizer() {
        self_setupKeyboardTapRecognizer()
    }
    
    @objc open func endEditing() {
        self.view.endEditing(true)
    }
    
    // MARK: Responder
    open func makeResponder(status: Bool, textField: UITextField, text: String? = nil) {
        self_makeResponder(status: status, textField: textField, text: text)
    }
    
    // MARK: Keyboard Notifications
    // Registering for keyboard notification.
    open func registerKeyboardNotifications() {
        self_registerKeyboardNotifications()
    }
    
    open func unregisterKeyboardNotifications() {
        self_unregisterKeyboardNotifications()
    }
    
    /*  UIKeyboardWillShow. */
    @objc func keyboardWillShow(_ notification: Notification?) {
        // Optional Protocal implementation: intentionally empty
    }
    
    /*  UIKeyboardDidHide. */
    @objc func keyboardDidHide(_ notification: Notification?) {
        // Optional Protocal implementation: intentionally empty
    }
    
    // MARK: AlertViewController
    public func showAlert( title: String, message: String, action: UIAlertAction? = nil, actions: [UIAlertAction]? = nil) {
        self_showAlert(title: title, message: message, action: action, actions: actions)
    }
    
    // MARK: Activity indicator
    public func showActivityIndicator() {
        FTLoadingIndicator.show()
    }
    
    public func hideActivityIndicator() {
        DispatchQueue.main.async {
            FTLoadingIndicator.hide()
        }
    }
    
    public func topPinnedView() -> FTView? {
        // If baseView is not added, then retun nil
        if isBaseViewAdded {
            return nil
        }
        return self.baseView?.topPinnedView
    }
}

// MARK: Layout Guide for rootView
extension FTBaseViewController {
    public func setupBaseView() {
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
    
    private func setupTopSafeAreaLayoutGuide(_ local: FTView) {
        if #available(iOS 11.0, *) {
            local.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0.0).isActive = true
        }
        else {
            local.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor, constant: 0.0).isActive = true
        }
    }
}

// MARK: Notification whenever view is loaded
extension FTBaseViewController {

    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        postNotification(name: .kFTMobileCoreWillAppearViewController)
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        postNotification(name: .kFTMobileCoreDidAppearViewController)
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        postNotification(name: .kFTMobileCoreWillDisappearViewController)
    }
    
    override open func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        postNotification(name: .kFTMobileCoreDidDisappearViewController)
    }
}
