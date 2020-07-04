//
//  CollectionViewProtocolTests.swift
//  MobileCoreTests
//
//  Created by Praveen P on 09/11/19.
//  Copyright © 2019 Praveen Prabhakar. All rights reserved.
//

@testable import MobileCore
import XCTest

fileprivate final class MockCollectionViewController: UIViewController, CollectionViewControllerProtocol {
}

final class CollectionViewProtocolTests: XCTestCase {
    
    private let collectionVC = MockCollectionViewController()
    
    func testCollectionViewDefaults() {
        XCTAssertNotNil(collectionVC)
        XCTAssertEqual(collectionVC.estimatedItemSize(), CGSize.zero)
        XCTAssertEqual(collectionVC.sectionInset(), UIEdgeInsets.zero)
        XCTAssertEqual(collectionVC.collectionViewController, collectionVC.collectionViewController)
        XCTAssertEqual(collectionVC.collectionView, collectionVC.collectionView)
        
        // Custom CollectionView
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        collectionVC.collectionView = collectionView
        XCTAssertEqual(collectionVC.collectionView, collectionView)
    }
}
