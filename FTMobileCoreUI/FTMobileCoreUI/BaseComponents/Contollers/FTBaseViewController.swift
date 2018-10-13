//
//  FTBaseViewController.swift
//  FTMobileCoreUI
//
//  Created by Praveen Prabhakar on 15/06/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import UIKit

public typealias FTAppBaseCompletionBlock = (_ isSuccess: Bool,_ modelStack: AnyObject?) -> Void

public protocol FTAppBaseProtocal {

    //Setup View
    func setupBaseView() -> Void

    // MARK: Navigation Bar
    //Bydefalut leftButton action is set to 'leftButtonAction'
    func setupNavigationbar(title: String,
    leftButtonTitle: String?, leftButtonImage: UIImage?, leftButtonAction: Selector?, leftCustomView: UIView?,
    rightButtonTitle: String?, rightButtonImage: UIImage?, rightButtonAction: Selector?, rightCustomView: UIView?) -> Void
    //Config Left Navbar Button
    func leftNavigationBarButton(title: String?, image: UIImage?, buttonType: UIBarButtonItem.SystemItem, customView: UIView?, buttonAction: Selector?) -> UIBarButtonItem?
    //Config right Navbar Button
    func rightNavigationBarButton(title: String?, image: UIImage?, buttonType: UIBarButtonItem.SystemItem, customView: UIView?, buttonAction: Selector?) -> UIBarButtonItem?

    //invokes's 'popViewController' if not rootViewController or-else invokes 'dismiss'
    func dismissSelf(_ animated: Bool)

    //Navigation bar defalut Actions
    func leftButtonAction()
    func rightButtonAction()

    //MARK: Keyboard notification.
    func registerKeyboardNotifications()
    //Notifications will be unregistered in 'deinit'
    func unregisterKeyboardNotifications()

    //MARK: Alert ViewController
    func showAlert(title: String, message: String, action: UIAlertAction?, actions: [UIAlertAction]?)

    //MARK: Responder
    func makeResponder(status:Bool, textField: UITextField, text: String?)


    // MARK:  Activity indicator
    func showActivityIndicator()
    func hideActivityIndicator()
}

open class FTBaseViewController : UIViewController, FTAppBaseProtocal {


    @IBOutlet
    lazy open var baseView: FTBaseView? = FTBaseView()
    public static var kLeftButtonAction = #selector(leftButtonAction)

    //Unquie Identifier for eachScreen
    open var screenIdentifier: String? = nil
    //modelData that can be passed from previous controller
    open var modelStack: AnyObject? = nil
    open var completionBlock: FTAppBaseCompletionBlock? = nil

    // Setup baseView's topLayoutGuide by sending true in subControllers if needed
    open func shouldSetSafeAreaLayoutGuide() -> Bool {
        return true
    }

    // Will dismiss Keyboard by tapping on any non-interative part of the view.
    open func shouldDissmissKeyboardOnTap() -> Bool {
        return true
    }

    private var isBaseViewAdded: Bool {
        get {
            // If baseView is not added, then retun false
            return (self.baseView?.superview != self.view && self.view != self.baseView)
        }
    }

    deinit {
        // Remove all Observer in `self`
        do {
            NotificationCenter.default.removeObserver(self)
        }
    }

    open override func loadView() {
        // Make it as Views RooView
        self.view = self.baseView
        self.baseView?.theme = ThemeStyle.defaultStyle
        
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

        self_setupNavigationbar(title: title, leftButtonTitle: leftButtonTitle, leftButtonImage: leftButtonImage, leftButtonAction: leftButtonAction, leftCustomView: leftCustomView, rightButtonTitle: rightButtonTitle, rightButtonImage: rightButtonImage, rightButtonAction: rightButtonAction, rightCustomView: rightCustomView)
    }

    public func setupNavigationbar(title: String,
                                   leftButton: UIBarButtonItem? = nil,
                                   rightButton: UIBarButtonItem? = nil) {

        self_setupNavigationbar(title: title,
                           leftButton: leftButton,
                           rightButton: rightButton)
    }

    // Left navBar button
    @discardableResult
    public func leftNavigationBarButton(title: String? = nil,
                           image: UIImage? = nil,
                           buttonType: UIBarButtonItem.SystemItem = .stop,
                           customView: UIView? = nil,
                           buttonAction: Selector? = kLeftButtonAction) -> UIBarButtonItem? {

        return self_leftNavigationBarButton(title: title, image: image, buttonType: buttonType, customView: customView, buttonAction: buttonAction)
    }

    // Right Navbar button
    @discardableResult
    public func rightNavigationBarButton(title: String? = nil,
                               image: UIImage? = nil,
                               buttonType: UIBarButtonItem.SystemItem = .done,
                               customView: UIView? = nil,
                               buttonAction: Selector? = #selector(rightButtonAction)) -> UIBarButtonItem? {
        return self_rightNavigationBarButton(title: title, image: image,buttonType: buttonType, customView: customView, buttonAction: buttonAction)
    }

    public func navigationBarButton(title: String? = nil, image: UIImage? = nil,
                                    buttonType: UIBarButtonItem.SystemItem,
                                    customView: UIView? = nil,
                                    buttonAction: Selector? = kLeftButtonAction) -> UIBarButtonItem {
        return self_navigationBarButton(title: title, image: image, buttonType: buttonType, customView: customView, buttonAction: buttonAction)
    }

    // MARK: Dissmiss Self model
    public func dismissSelf(_ animated: Bool = true) {
        self_dismissSelf()
    }

    @objc @IBAction open func leftButtonAction() {
        dismissSelf()
    }

    @objc @IBAction open func rightButtonAction() {
    }

    // MARK: Keyboard
    func setupKeyboardTapRecognizer() {
        self_setupKeyboardTapRecognizer()
    }

    @objc open func endEditing() {
        self.view.endEditing(true)
    }

    //MARK: Responder
    open func makeResponder(status:Bool, textField: UITextField, text: String? = nil) {
        self_makeResponder(status: status, textField: textField, text: text)
    }

    // MARK: Keyboard Notifications
    //  Registering for keyboard notification.
    open func registerKeyboardNotifications() {
        self_registerKeyboardNotifications()
    }

    open func unregisterKeyboardNotifications() {
        self_unregisterKeyboardNotifications()
    }

    /*  UIKeyboardWillShow. */
    @objc func keyboardWillShow(_ notification : Notification?) -> Void {
    }

    /*  UIKeyboardDidHide. */
    @objc func keyboardDidHide(_ notification : Notification?) -> Void {
    }

    //MARK: AlertViewController
    public func showAlert(title: String, message: String, action: UIAlertAction? = nil, actions: [UIAlertAction]? = nil) {
        self_showAlert(title: title, message: message, action: action, actions: actions)
    }

    // MARK:  Activity indicator
    public func showActivityIndicator() {
        FTLoadingIndicator.show()
    }

    public func hideActivityIndicator() {
        DispatchQueue.main.async {
            FTLoadingIndicator.hide()
        }
    }

}

extension FTBaseViewController {

    // MARK: Layout Guide for rootView
    public func setupBaseView() {
        
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


// MARK: Protocal implementation
private extension FTBaseViewController {

    // MARK: Navigation Bar
    func self_setupNavigationbar(title: String,
                                   leftButtonTitle: String? = nil, leftButtonImage: UIImage? = nil, leftButtonAction: Selector? = kLeftButtonAction, leftCustomView: UIView? = nil,
                                   rightButtonTitle: String? = nil, rightButtonImage: UIImage? = nil, rightButtonAction: Selector? = #selector(rightButtonAction), rightCustomView: UIView? = nil) {
        self.title = title

        if leftButtonTitle != nil || leftButtonImage != nil || leftCustomView != nil {
            self.leftNavigationBarButton(title: leftButtonTitle, image: leftButtonImage, customView: leftCustomView, buttonAction: leftButtonAction)
        }
        if rightButtonTitle != nil || rightButtonImage != nil || rightCustomView != nil {
            self.rightNavigationBarButton(title: rightButtonTitle, image: rightButtonImage, customView: rightCustomView, buttonAction: rightButtonAction)
        }
    }

    func self_setupNavigationbar(title: String,
                                   leftButton: UIBarButtonItem? = nil,
                                   rightButton: UIBarButtonItem? = nil) {
        self.title = title
        self.navigationItem.leftBarButtonItem = leftButton
        self.navigationItem.rightBarButtonItem = rightButton
    }

    // Left navBar button
    @discardableResult
    func self_leftNavigationBarButton(title: String? = nil,
                                        image: UIImage? = nil,
                                        buttonType: UIBarButtonItem.SystemItem = .stop,
                                        customView: UIView? = nil,
                                        buttonAction: Selector? = kLeftButtonAction) -> UIBarButtonItem? {
        let backButton = self.navigationBarButton(title: title, image: image,
                                                  buttonType:buttonType,
                                                  customView: customView,
                                                  buttonAction: buttonAction)
        self.navigationItem.leftBarButtonItem = backButton
        return backButton
    }

    // Right Navbar button
    @discardableResult
    func self_rightNavigationBarButton(title: String? = nil,
                                         image: UIImage? = nil,
                                         buttonType: UIBarButtonItem.SystemItem = .done,
                                         customView: UIView? = nil,
                                         buttonAction: Selector? = #selector(rightButtonAction)) -> UIBarButtonItem? {
        let backButton = self.navigationBarButton(title: title, image: image, buttonType: buttonType, customView: customView, buttonAction: buttonAction)
        self.navigationItem.rightBarButtonItem = backButton
        return backButton
    }

    func self_navigationBarButton(title: String? = nil,
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
    func self_dismissSelf(_ animated: Bool = true) {
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

    // MARK: Keyboard
    func self_setupKeyboardTapRecognizer() {
        // To Dismiss keyboard
        if shouldDissmissKeyboardOnTap() {
            let touchAction = UITapGestureRecognizer(target: self, action: #selector(endEditing))
            touchAction.cancelsTouchesInView = false
            self.view.addGestureRecognizer(touchAction)
        }
    }

    func self_endEditing() {
        self.view.endEditing(true)
    }

    //MARK: Responder
    func self_makeResponder(status:Bool, textField: UITextField, text: String? = nil) {
        if status {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(2)) {
                if let text = text {
                    textField.text = text
                }
                textField.becomeFirstResponder()
            }
        }
    }

    // MARK: Keyboard Notifications
    func self_registerKeyboardNotifications() {
        //  Registering for keyboard notification.
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidHide(_:)), name: UIResponder.keyboardDidHideNotification, object: nil)
    }

    func self_unregisterKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
    }

    //MARK: AlertViewController
    func self_showAlert(title: String, message: String, action: UIAlertAction? = nil, actions: [UIAlertAction]? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        if let action = action {
            alert.addAction(action)
        }
        actions?.forEach { (action) in
            alert.addAction(action)
        }

        if alert.actions.count == 0 {
            return
        }

        present(alert, animated: true, completion: nil)
    }
}
