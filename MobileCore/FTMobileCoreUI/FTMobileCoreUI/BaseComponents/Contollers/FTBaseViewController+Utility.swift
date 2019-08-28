//
//  FTBaseViewController+Utility.swift
//  FTMobileCoreUI
//
//  Created by Praveen Prabhakar on 21/10/18.
//  Copyright © 2018 Praveen Prabhakar. All rights reserved.
//

import Foundation

// MARK: Protocal implementation
extension FTBaseViewController {

    // MARK: Navigation Bar
    func self_setupNavigationbar(title: String, leftButton: FTNavigationBarItem?, rightButton: FTNavigationBarItem?) {
        self.title = title
        self.navigationItem.leftBarButtonItem = leftButton?.barButton(sender: self)
        self.navigationItem.rightBarButtonItem = rightButton?.barButton(sender: self)
    }

    func self_setupNavigationbar(title: String, leftButton: UIBarButtonItem? = nil, rightButton: UIBarButtonItem? = nil) {
        self.title = title
        self.navigationItem.leftBarButtonItem = leftButton
        self.navigationItem.rightBarButtonItem = rightButton
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

    // MARK: Responder
    func self_makeResponder(status: Bool, textField: UITextField, text: String? = nil) {
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
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardDidHide(_:)),
            name: UIResponder.keyboardDidHideNotification,
            object: nil
        )
    }

    func self_unregisterKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
    }

    // MARK: AlertViewController
    func self_showAlert(title: String, message: String, action: UIAlertAction? = nil, actions: [UIAlertAction]? = nil) {
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
}
