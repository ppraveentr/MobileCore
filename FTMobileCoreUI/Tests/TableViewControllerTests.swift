//
//  TableViewControllerTests.swift
//  MobileCoreTests
//
//  Created by Praveen P on 07/10/19.
//  Copyright © 2019 Praveen Prabhakar. All rights reserved.
//

@testable import MobileCore
import XCTest

fileprivate final class MockTestTableViewHeader: UIView {
    // Temp class extending Protocol for testing
}

fileprivate final class MockDefaultTableViewController: UIViewController, TableViewControllerProtocol {
    // Temp class extending Protocol for testing
}

fileprivate final class MockTestTableViewController: UIViewController, TableViewControllerProtocol {
    var tableStyle: UITableView.Style = .grouped
    var tableViewEdgeOffsets: UIEdgeInsets = .init(40, 40, 40, 40)
}

final class TableViewControllerTests: XCTestCase {
    
    private var tableViewC: MockTestTableViewController?
    private var oldRootVC: UIViewController?
    
    override func setUp() {
        super.setUp()
        oldRootVC = UIApplication.shared.keyWindow?.rootViewController
        tableViewC = MockTestTableViewController()
        UIApplication.shared.keyWindow?.rootViewController = tableViewC
    }
    
    override func tearDown() {
        super.tearDown()
        UIApplication.shared.keyWindow?.rootViewController = oldRootVC
    }
    
    func testTableViewController() {
        XCTAssertNotNil(tableViewC)
        XCTAssertNotNil(tableViewC?.tableView)
        XCTAssertEqual(tableViewC?.tableViewController, tableViewC?.tableViewController)
        
        XCTAssertEqual(tableViewC?.tableStyle, UITableView.Style.grouped)
        XCTAssertEqual(tableViewC?.tableViewEdgeOffsets, UIEdgeInsets(40, 40, 40, 40))
    }

    func testDefaultTableViewC() {
        let defaultTableV = MockDefaultTableViewController()
        XCTAssertNotNil(defaultTableV)
        XCTAssertEqual(defaultTableV.tableStyle, UITableView.Style.plain)
        XCTAssertEqual(defaultTableV.tableViewEdgeOffsets, UIEdgeInsets.zero)
    }
    
    func testSsetupTableController() {
        let defaultTableV = MockDefaultTableViewController()
        XCTAssertNotNil(defaultTableV.tableViewController)
        
        let controller = defaultTableV.getCoreTableViewController()
        defaultTableV.tableViewController = controller
        XCTAssertEqual(defaultTableV.tableViewController, controller)
    }
    
    
    func testTableHeaderView() {
        let headerView = MockTestTableViewHeader()
        XCTAssertNotNil(headerView)
        tableViewC?.tableView.setTableHeaderView(view: headerView)
        
        let footerView = MockTestTableViewHeader()
        XCTAssertNotNil(footerView)
        tableViewC?.tableView.setTableFooterView(view: footerView)
        
        tableViewC?.postNotification(name: .kFTMobileCoreDidLayoutSubviews)
        
        let tableHeaderView = tableViewC?.tableView.tableHeaderView
        XCTAssertNotNil(tableHeaderView)
        //XCTAssertEqual(tableHeaderView?.embView, headerView)
        
        let tableFooterView = tableViewC?.tableView.tableFooterView
        XCTAssertNotNil(tableFooterView)
        //XCTAssertEqual(tableFooterView?.embView, footerView)
    }
    
     func testTableHeaderFooterView() {
        let defaultTableV = MockDefaultTableViewController()
        let headerView = UIView()
        
        defaultTableV.tableView.setTableHeaderView(view: headerView)
        
        let tableHeaderView = defaultTableV.tableView.tableHeaderView
        XCTAssertNotNil(tableHeaderView)
        //XCTAssertEqual(tableHeaderView?.embView, headerView)
    }
}
