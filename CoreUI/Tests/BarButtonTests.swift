//
//  BarButtonTests.swift
//  MobileCoreTests
//
//  Created by Praveen P on 16/10/19.
//  Copyright © 2019 Praveen Prabhakar. All rights reserved.
//

@testable import MobileCore
import XCTest

final class BarButtonTests: XCTestCase {
    
    private lazy var image = UIImage(named: "Pixel")
    private let action = #selector(buttonTap)
    private lazy var promise = expectation(description: "Button tapped.")

    func testBarButtonCustomView() {
        // Given
        let barButton = UIBarButtonItem(title: "Test", image: image, action: action, target: self)
        // When
        let buttonView = barButton?.customView as? UIButton
        // Then
        XCTAssertNotNil(buttonView)
        XCTAssertEqual(buttonView?.titleLabel?.text, "Test")
        XCTAssertEqual(buttonView?.imageView?.image, image)
        
        // When
        buttonView?.sendActions(for: .touchUpInside)
        
        wait(for: [promise], timeout: 5)
    }
    
    func buttonTap() {
        promise.fulfill()
    }
    
    func testDefaultBarButton() {
        // Given
        let barButton = UIBarButtonItem(action: action, target: self)
        // Then
        XCTAssertEqual(barButton?.action, action)
        XCTAssertNotNil(barButton?.target as? BarButtonTests)
    }
}
