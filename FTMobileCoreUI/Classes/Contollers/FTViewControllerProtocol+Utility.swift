//
//  FTViewControllerProtocol+Utility.swift
//  FTMobileCoreUI
//
//  Created by Praveen Prabhakar on 21/10/18.
//  Copyright © 2018 Praveen Prabhakar. All rights reserved.
//

import Foundation

// MARK: Protocol implementation
extension UIViewController {

    var isBaseViewAdded: Bool {
        // If baseView is not added, then retun false
        return (self.baseView?.superview != self.view && self.view != self.baseView)
    }

    // MARK: Utility
    public var mainView: UIView? {
        // If baseView is not added, then retun nil
        if isBaseViewAdded {
            return nil
        }
        return self.baseView?.mainPinnedView
    }
    
    public func topPinnedView() -> UIView? {
        // If baseView is not added, then retun nil
        if isBaseViewAdded {
            return nil
        }
        return self.baseView?.topPinnedView
    }
    
    // MARK: Navigation Bar
    // default - left Button Actopm
    public var kleftButtonAction: Selector {
        return #selector(UIViewController.leftButtonAction)
    }
    
    public var kRightButtonAction: Selector {
        return #selector(UIViewController.rightButtonAction)
    }

    func configureBarButton(button: UIBarButtonItem?, defaultAction action: Selector) {
        guard let button = button else { return }
        
        if button.action == nil {
            button.action = action
        }
        if button.target == nil {
            button.target = self
        }
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
}

extension UIViewController {
    // MARK: Keyboard
    func setupKeyboardTapRecognizer() {
        // To Dismiss keyboard
        if shouldDissmissKeyboardOnTap() {
            let touchAction = UITapGestureRecognizer(target: self, action: #selector(UIViewController.endEditing))
            touchAction.cancelsTouchesInView = false
            self.view.addGestureRecognizer(touchAction)
        }
    }
    
    @objc
    public func endEditing() {
        self.view.endEditing(true)
    }
    
    // MARK: Responder
    public func makeResponder(status: Bool, textField: UITextField, text: String? = nil) {
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
    // Registering for keyboard notification.
    public func registerKeyboardNotifications() {
        //  Registering for keyboard notification.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: self)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide(_:)), name: UIResponder.keyboardDidHideNotification, object: self)
    }
    
    public func unregisterKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    /*  UIKeyboardWillShow. */
    @objc
    func keyboardWillShow(_ notification: Notification?) {
        // Optional Protocol implementation: intentionally empty
    }
    
    /*  UIKeyboardDidHide. */
    @objc
    func keyboardDidHide(_ notification: Notification?) {
        // Optional Protocol implementation: intentionally empty
    }
}

extension UIViewController {
    // MARK: AlertViewController
    public func showAlert( title: String, message: String, action: UIAlertAction? = nil, actions: [UIAlertAction]? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if let action = action {
            alert.addAction(action)
        }
        actions?.forEach { action in
            alert.addAction(action)
        }
        if alert.actions.isEmpty {
            return
        }
        present(alert, animated: true, completion: nil)
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
}
