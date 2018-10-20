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

    // MARK: Responder
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

    // MARK: AlertViewController
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
