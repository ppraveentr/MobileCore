//
//  ViewControllerProtocolTests.swift
//  MobileCoreTests
//
//  Created by Praveen Prabhakar on 12/07/20.
//  Copyright © 2020 Praveen Prabhakar. All rights reserved.
//

#if canImport(CoreUI)
@testable import CoreUI
@testable import CoreUtility
#endif
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

    func keyboardWillShow(_ notification: Notification?) {
        isKeyboardWillShowCalled = true
    }
    
    func keyboardDidHide(_ notification: Notification?) {
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
        XCTAssertTrue(viewController.isKeyboardWillShowCalled)
        // when
        viewController.postNotification(name: UIResponder.keyboardDidHideNotification.self)
        XCTAssertTrue(viewController.isKeyboardDidHideCalled)
    }
    
    func testKeyboardNotificationFails() {
        // let
        viewController.unregisterKeyboardNotifications()
        // when
        viewController.postNotification(name: UIResponder.keyboardWillShowNotification.self)
        XCTAssertFalse(viewController.isKeyboardWillShowCalled)
        // when
        viewController.postNotification(name: UIResponder.keyboardDidHideNotification.self)
        XCTAssertFalse(viewController.isKeyboardDidHideCalled)
    }
    
    func testAlertView() {
        // when
        viewController.showAlert()
        // then
        XCTAssertTrue(viewController.isAlertViewPresented)
    }
    
    #if !canImport(CoreUI)
    // Need to be moved to UI Test
    func testShowLoadingIndicator() {
        // let
        let promise = expectation(description: "Loading Indicator Hidden")
        // when
        viewController.showActivityIndicator()
        // then
        let shownIndicator: LoadingIndicator? = UIApplication.shared.keyWindow?.findInSubView()
        XCTAssertNotNil(shownIndicator)
        // when
        viewController.hideActivityIndicator { _ in
            promise.fulfill()
        }
        // then
        wait(for: [promise], timeout: 15)
    }
    #endif
}
