//
//  ViewControllerProtocolTests.swift
//  MobileCoreTests
//
//  Created by Praveen Prabhakar on 12/07/20.
//  Copyright © 2020 Praveen Prabhakar. All rights reserved.
//

@testable import MobileCore
import UIKit
import XCTest

private final class MockModelStack {
    var title = "title"
    
    init(title: String) {
        self.title = title
    }
}

extension MockModelStack: Equatable {
    static func == (lhs: MockModelStack, rhs: MockModelStack) -> Bool {
        lhs.title == rhs.title
    }
}

private final class MockViewContoller: UIViewController {
    private (set) var isKeyboardWillShowCalled = false
    private (set) var isKeyboardDidHideCalled = false
    private (set) var isAlertViewPresented = false

    override func keyboardWillShow(_ notification: Notification?) {
        isKeyboardWillShowCalled = true
    }
    override func keyboardDidHide(_ notification: Notification?) {
        isKeyboardDidHideCalled = true
    }
    
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        if viewControllerToPresent is UIAlertController {
            isAlertViewPresented = true
        }
    }
}

final class ViewControllerProtocolTests: XCTestCase {
    private var viewController: MockViewContoller! = nil
    
    override func setUp() {
        super.setUp()
        viewController = MockViewContoller()
    }
    
    func testScreenIdentifier() {
        // let
        let mockIdentifer = "TestIdentifer"
        XCTAssertNil(viewController.screenIdentifier)
        viewController.screenIdentifier = mockIdentifer
        XCTAssertEqual(viewController.screenIdentifier, mockIdentifer)
    }
    
    func testBaseView() {
        // let
        let newView = FTView()
        XCTAssertNotNil(viewController.baseView)
        // when
        viewController.baseView = newView
        // then
        XCTAssertEqual(viewController.baseView, newView)
    }
    
    func testTopView() {
        // let
        let newView = FTView()
        XCTAssertNil(viewController.topPinnedView)
        // when
        viewController.topPinnedView = newView
        // then
        XCTAssertEqual(viewController.topPinnedView, newView)
    }
    
   func testBottomView() {
       // let
       let newView = FTView()
       XCTAssertNil(viewController.bottomPinnedView)
       // when
       viewController.bottomPinnedView = newView
       // then
       XCTAssertEqual(viewController.bottomPinnedView, newView)
   }

    func testModelStack() {
        // let
        let newModel = MockModelStack(title: "test")
        // when
        viewController.modelStack = newModel
        // then
        XCTAssertEqual(viewController.modelStack as? MockModelStack, newModel)
    }
    
    func testNavigationBar() {
        // let
        let title = "Mock Screen Title"
        let leftBar = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: nil)
        let rightBar = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
        // when
        viewController.setupNavigationbar(title: title, leftButton: leftBar, rightButton: rightBar)
        // then
        XCTAssertEqual(viewController.title, title)
        // left bar button
        XCTAssertEqual(viewController.navigationItem.leftBarButtonItem, leftBar)
        XCTAssertEqual(leftBar.target as? MockViewContoller, viewController)
        XCTAssertEqual(leftBar.action, viewController.kleftButtonAction)
        // right bar button
        XCTAssertEqual(viewController.navigationItem.rightBarButtonItem, rightBar)
        XCTAssertEqual(rightBar.target as? MockViewContoller, viewController)
        XCTAssertEqual(rightBar.action, viewController.kRightButtonAction)
    }
    
    func testKeyboardNotification() {
        // let
        viewController.registerKeyboardNotifications()
        // when
        viewController.postNotification(name: UIResponder.keyboardWillShowNotification.self)
        viewController.postNotification(name: UIResponder.keyboardDidHideNotification.self)
        // then
        XCTAssertTrue(viewController.isKeyboardWillShowCalled)
        XCTAssertTrue(viewController.isKeyboardDidHideCalled)
    }
    
    func testKeyboardNotificationFails() {
        // let
        viewController.unregisterKeyboardNotifications()
        // when
        viewController.postNotification(name: UIResponder.keyboardWillShowNotification.self)
        viewController.postNotification(name: UIResponder.keyboardDidHideNotification.self)
        // then
        XCTAssertFalse(viewController.isKeyboardWillShowCalled)
        XCTAssertFalse(viewController.isKeyboardDidHideCalled)
    }
    
    func testAlertView() {
        // when
        viewController.showAlert()
        // then
        XCTAssertTrue(viewController.isAlertViewPresented)
    }
    
    func testShowLoadingIndicator() {
        // let
        let promise = expectation(description: "Loading Indicator Hidden")
        // when
        viewController.showActivityIndicator()
        // then
        let shownIndicator: LoadingIndicator? = UIApplication.shared.keyWindow?.findInSubView()
        XCTAssertNotNil(shownIndicator)
        // when
        viewController.hideActivityIndicator { isCompleted in
            promise.fulfill()
        }
        // then
        wait(for: [promise], timeout: 15)
    }
}
