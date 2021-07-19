//
//  ConfigurableCellTests.swift
//  CoreUtilityTests
//
//  Created by Praveen Prabhakar on 05/07/20.
//  Copyright © 2020 Praveen Prabhakar. All rights reserved.
//

#if canImport(CoreUtility)
import CoreUtility
#endif
import XCTest

fileprivate final class MockViewCellWithoutNib: UIView {
}

final class ConfigurableCellTests: XCTestCase {
    // private lazy var mockCell: MockTableViewCell?
    private let bundle = CoreUtilityTestsUtility.kMobileCoreBundle
    private let mockTableView = UITableView()
    private let mockCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    private let defaultId = MockCollectionViewCell.defaultReuseIdentifier
    
    func testDefaultNib() {
        XCTAssertEqual(MockTableViewCell.defaultNibName, "MockTableViewCell")
        XCTAssertEqual(MockTableViewCell.defaultReuseIdentifier, "MockTableViewCellID")
        // Cell without nib
        do {
            let errorNib = try MockViewCellWithoutNib.loadNibFromBundle()
            XCTAssertNil(errorNib, "Should have failed to load nib")
        }
        catch {
            XCTAssertNotNil(error, "Should have failed to load nib")
        }
    }
    
    // MARK: TableView
    func testTableViewLoadNib() {
        // let
        let mockCell = try? MockTableViewCell.loadNibFromBundle(bundle: bundle)
        XCTAssertNotNil(mockCell, "Should have loaded nib")
        // Cell with nib file
        let mockNib = MockTableViewCell.getNib()
        XCTAssertNotNil(mockNib, "Should have loaded nib")
    }
    
    func testTableViewRegisterNib() {
        // let
        let indexPath = IndexPath(row: 0, section: 0)
        // when
        MockTableViewCell.registerNib(for: mockTableView, bundle: bundle)
        let cell = try? MockTableViewCell.dequeue(from: mockTableView, for: indexPath)
        // then
        XCTAssertNotNil(cell, "Should have dequeue cell")
        XCTAssertNotNil(mockTableView.dequeueReusableCell(withIdentifier: MockTableViewCell.defaultReuseIdentifier))
    }
    
    func testTableViewRegisterCell() {
        // let
        let indexPath = IndexPath(row: 0, section: 0)
        // when
        MockTableViewCell.registerClass(for: mockTableView)
        let cell = try? MockTableViewCell.dequeue(from: mockTableView, for: indexPath)
        // then
        XCTAssertNotNil(cell, "Should have dequeue cell")
        XCTAssertNotNil(mockTableView.dequeueReusableCell(withIdentifier: MockTableViewCell.defaultReuseIdentifier))
    }
    
    func testTableViewCellCustomReuseID() {
        // let
        let customReuseID = "reuseID"
        // when Register cell with Custom reuseIdentifier
        MockTableViewCell.registerClass(for: mockTableView, reuseIdentifier: customReuseID)
        // then
        let defaultCell = mockTableView.dequeueReusableCell(withIdentifier: MockTableViewCell.defaultReuseIdentifier)
        let dequeID = "Should not have dequeue cell as reuseIdentifier not found"
        XCTAssertNil(defaultCell, dequeID)
        // then
        let customTableViewCell = mockTableView.dequeueReusableCell(withIdentifier: customReuseID)
        XCTAssertNotNil(customTableViewCell, "Should have dequeue cell as with \(customReuseID) reuseIdentifier")
    }
    
    // MARK: CollectionView
    func testCollectionViewLoadNib() {
        // let
        let mockCell = try? MockCollectionViewCell.loadNibFromBundle(bundle: bundle)
        XCTAssertNotNil(mockCell, "Should have loaded nib")
        // Cell with nib file
        let mockNib = MockCollectionViewCell.getNib()
        XCTAssertNotNil(mockNib, "Should have loaded nib")
    }
    
    func testCollectionViewRegisterNib() {
        // let
        let indexPath = IndexPath(row: 0, section: 0)
        // when
        MockCollectionViewCell.registerNib(for: mockCollectionView, bundle: bundle)
        let cell = try? MockCollectionViewCell.dequeue(from: mockCollectionView, for: indexPath)
        // then
        XCTAssertNotNil(cell, "Should have dequeue cell")
        // let
        let cellMock = mockCollectionView.dequeueReusableCell(withReuseIdentifier: defaultId, for: indexPath)
        XCTAssertNotNil(cellMock, "Should have dequeue cell")
    }
    
    func testCollectionViewRegisterCell() {
        // let
        let indexPath = IndexPath(row: 0, section: 0)
        // when
        MockCollectionViewCell.registerClass(for: mockCollectionView)
        let cell = try? MockCollectionViewCell.dequeue(from: mockCollectionView, for: indexPath)
        // then
        XCTAssertNotNil(cell, "Should have dequeue cell")
        // let
        let cellMock = mockCollectionView.dequeueReusableCell(withReuseIdentifier: defaultId, for: indexPath)
        XCTAssertNotNil(cellMock, "Should have dequeue cell")
    }
    
    func testCollectionViewCellCustomReuseID() {
        // let
        let indexPath = IndexPath(row: 0, section: 0)
        let customReuseID = "reuseID"
        // when Register cell with Custom reuseIdentifier
        MockCollectionViewCell.registerClass(for: mockCollectionView, reuseIdentifier: customReuseID)
        // then
        let customCell = mockCollectionView.dequeueReusableCell(withReuseIdentifier: customReuseID, for: indexPath)
        XCTAssertNotNil(customCell, "Should have dequeue cell as with \(customReuseID) reuseIdentifier")
    }
}
