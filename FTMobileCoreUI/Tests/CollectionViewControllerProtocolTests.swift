//
//  CollectionViewControllerProtocolTests.swift
//  FTMobileCoreTests
//
//  Created by Praveen P on 30/06/20.
//  Copyright © 2020 Praveen Prabhakar. All rights reserved.
//

@testable import MobileCore
import UIKit
import XCTest

private final class MockDefaultCollectionViewContoller: UIViewController, FTCollectionViewControllerProtocol { }

private final class MockCollectionViewContoller: UIViewController, FTCollectionViewControllerProtocol {
    let mocklayout = UICollectionViewLayout()
    let mockestimatedItemSize = CGSize(width: 20.0, height: 20.0)
    let mocksectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)

    func estimatedItemSize() -> CGSize {
        mockestimatedItemSize
    }
    
    func sectionInset() -> UIEdgeInsets {
        mocksectionInset
    }
    
    var flowLayout: UICollectionViewLayout {
        mocklayout
    }
}

final class CollectionViewControllerProtocolTests: XCTestCase {

    func testDefaultValues() {
        let viewController = MockDefaultCollectionViewContoller()
        XCTAssertEqual(viewController.estimatedItemSize(), .zero)
        XCTAssertEqual(viewController.sectionInset(), .zero)
    }
    
    func testFlowLayout() {
        let viewController = MockCollectionViewContoller()
        XCTAssertEqual(viewController.estimatedItemSize(), viewController.mockestimatedItemSize)
        XCTAssertEqual(viewController.sectionInset(), viewController.mocksectionInset)
        XCTAssertEqual(viewController.flowLayout, viewController.mocklayout)
        XCTAssertNotNil(viewController.collectionView)
        XCTAssertEqual(viewController.collectionView, viewController.collectionViewController.collectionView)
    }
    
    func testCustomCollectionView() {
        let viewController = MockCollectionViewContoller()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: viewController.flowLayout)
        viewController.collectionView = collectionView
        XCTAssertEqual(collectionView, viewController.collectionViewController.collectionView)
        XCTAssertEqual(viewController.collectionViewController.collectionView.collectionViewLayout, viewController.mocklayout)
    }
}
