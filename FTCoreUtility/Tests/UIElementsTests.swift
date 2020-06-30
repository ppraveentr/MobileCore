//
//  UIElementsTests.swift
//  FTMobileCoreTests
//
//  Created by Praveen P on 30/06/20.
//  Copyright © 2020 Praveen Prabhakar. All rights reserved.
//

@testable import MobileCore
import XCTest

final class UIElementsTests: XCTestCase {

    func testView_findShadowImage() {
        // let
        let view = UIView()
        let image1 = UIImageView(frame: .zero)
        let image2 = UIImageView(frame: .zero)
        let image3 = UIImageView(frame: CGRect(x: 20, y: 20, width: 20, height: 20))
        // when
        view.addSubview(image1)
        view.addSubview(image2)
        view.addSubview(image3)
        // then
        XCTAssertEqual(view.findShadowImage()?.count, 2)
    }
    
    func testView_findInSubView() {
        // let
        let view = UIView()
        let view1 = UIView(frame: .zero)
        let image = UIImageView(frame: .zero)
        // when
        view.addSubview(view1)
        view.addSubview(image)
        // then
        let foundView: UIImageView? = view.findInSubView()
        XCTAssertNotNil(foundView)
        XCTAssertEqual(foundView, image)
    }
}
