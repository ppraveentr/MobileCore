//
//  UIViewController+Extension.swift
//  MobileCore-CoreComponents
//
//  Created by Praveen Prabhakar on 21/10/18.
//  Copyright © 2018 Praveen Prabhakar. All rights reserved.
//

import Foundation
import UIKit

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
    
    // MARK: Navigation Bar
    // default - left Button Actopm
    public var kleftButtonAction: Selector {
        #selector(UIViewController.leftButtonAction)
    }
    
    public var kRightButtonAction: Selector {
        #selector(UIViewController.rightButtonAction)
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
    public var defaultAlertAction: UIAlertAction {
        UIAlertAction(title: "Ok", style: .default, handler: nil)
    }
    
    public func showAlert( title: String? = nil, message: String? = nil, action: UIAlertAction? = nil, actions: [UIAlertAction]? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Add actions to alertView
        if let action = action {
            alert.addAction(action)
        }
        actions?.forEach { action in
            alert.addAction(action)
        }
        // if no actions avaialble, show default Action.
        if alert.actions.isEmpty {
            alert.addAction(defaultAlertAction)
        }
        // present alertView
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: Activity indicator
    public func showActivityIndicator() {
        LoadingIndicator.show()
    }
    
    public func hideActivityIndicator(_ completionBlock: LoadingIndicator.CompletionBlock? = nil) {
        DispatchQueue.main.async {
            LoadingIndicator.hide(completionBlock)
        }
    }
}
