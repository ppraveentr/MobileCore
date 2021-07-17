//
//  BarButtonTests.swift
//  MobileCoreTests
//
//  Created by Praveen P on 16/10/19.
//  Copyright © 2019 Praveen Prabhakar. All rights reserved.
//

#if canImport(CoreComponents)
import CoreComponents
import CoreUtility
#endif
import XCTest

final class BarButtonTests: XCTestCase {
    
    private lazy var image: UIImage? = UIColor.red.generateImage()
    private let action = #selector(buttonTap)
    
    func testBarButtonCustomView() {
        guard let image = image else { return }
        // Given
        let barButton = UIBarButtonItem(title: "Test", image: image, action: action, target: self)
        // When
        let buttonView = barButton?.customView as? UIButton
        // Then
        XCTAssertNotNil(buttonView)
        XCTAssertEqual(buttonView?.titleLabel?.text, "Test")
        XCTAssertEqual(buttonView?.imageView?.image, image)
        buttonView?.sendActions(for: .touchUpInside)
    }
    
    func testDefaultBarButton() {
        // Given
        let barButton = UIBarButtonItem(action: action, target: self)
        // Then
        XCTAssertEqual(barButton?.action, action)
        XCTAssertNotNil(barButton?.target as? BarButtonTests)
    }
}

private extension BarButtonTests {
    @objc
    func buttonTap() {
        /* Do Nothing */
    }
}
