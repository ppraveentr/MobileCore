//
//  TableViewControllerProtocolTests.swift
//  MobileCoreTests
//
//  Created by Praveen P on 07/10/19.
//  Copyright © 2019 Praveen Prabhakar. All rights reserved.
//

import CoreUtility
import CoreUI
import XCTest

fileprivate final class MockTableViewHeader: UIView {
    // Temp class extending Protocol for testing
}

fileprivate final class MockTableViewController: UIViewController, TableViewControllerProtocol {
    // Temp class extending Protocol for testing
}

fileprivate final class MockCustomTableViewController: UIViewController, TableViewControllerProtocol {
    var tableStyle: UITableView.Style = .grouped
    var tableViewEdgeOffsets: UIEdgeInsets = .init(40, 40, 40, 40)
}

final class TableViewControllerProtocolTests: XCTestCase {
    
    private var tableViewC: MockCustomTableViewController?
    private var oldRootVC: UIViewController?
    
    override func setUp() {
        super.setUp()
        oldRootVC = UIApplication.shared.keyWindow?.rootViewController
        tableViewC = MockCustomTableViewController()
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
        let defaultTableV = MockTableViewController()
        XCTAssertNotNil(defaultTableV)
        XCTAssertEqual(defaultTableV.tableStyle, UITableView.Style.plain)
        XCTAssertEqual(defaultTableV.tableViewEdgeOffsets, UIEdgeInsets.zero)
    }
    
    func testSsetupTableController() {
        let defaultTableV = MockTableViewController()
        XCTAssertNotNil(defaultTableV.tableViewController)
        
        let controller = defaultTableV.getCoreTableViewController()
        defaultTableV.tableViewController = controller
        XCTAssertEqual(defaultTableV.tableViewController, controller)
    }
    
    func testTableHeaderView() {
        let headerView = MockTableViewHeader()
        XCTAssertNotNil(headerView)
        tableViewC?.tableView.setTableHeaderView(view: headerView)
        let tableHeaderView = tableViewC?.tableView.tableHeaderView
        XCTAssertNotNil(tableHeaderView)
    }
    
    func testTableFooterView() {
        let footerView = MockTableViewHeader()
        XCTAssertNotNil(footerView)
        tableViewC?.tableView.setTableFooterView(view: footerView)
        let tableFooterView = tableViewC?.tableView.tableFooterView
        XCTAssertNotNil(tableFooterView)
    }
    
     func testTableHeaderFooterView() {
        let defaultTableV = MockTableViewController()
        let headerView = UIView()
        defaultTableV.tableView.setTableHeaderView(view: headerView)
        let tableHeaderView = defaultTableV.tableView.tableHeaderView
        XCTAssertNotNil(tableHeaderView)
    }
}
