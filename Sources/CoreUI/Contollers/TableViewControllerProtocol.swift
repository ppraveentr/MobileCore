//
//  TableViewControllerProtocol.swift
//  MobileCore
//
//  Created by Praveen P on 10/09/19.
//  Copyright © 2019 Praveen P. All rights reserved.
//

#if canImport(CoreUtility)
import CoreUtility
#endif
import Foundation
import UIKit

public protocol TableViewControllerProtocol: ViewControllerProtocol {
    var tableStyle: UITableView.Style { get }
    var tableView: UITableView { get }
    var tableViewController: UITableViewController { get set }
    var tableViewEdgeOffsets: UIEdgeInsets { get }
    
    func getCoreTableViewController() -> UITableViewController
}

// MARK: FTAssociatedKey
private extension AssociatedKey {
    static var kAOTableVC = "k.FT.AO.TableViewController"
    static var kAOTableHeader = "k.FT.AO.TableViewController"
    static var kAOTableFooter = "k.FT.AO.TableViewController"
}

public extension TableViewControllerProtocol {
    // TableView style, defalut: .plain
    var tableStyle: UITableView.Style { .plain }
    var tableViewEdgeOffsets: UIEdgeInsets { .zero }
    var tableView: UITableView { self.tableViewController.tableView }
    
    func getCoreTableViewController() -> UITableViewController {
        let controller = UITableViewController(style: self.tableStyle)
        controller.tableView.estimatedRowHeight = UITableView.automaticDimension
        return controller
    }
    
    var tableViewController: UITableViewController {
        get {
            guard let table = AssociatedObject<UITableViewController>.getAssociated(self, key: &AssociatedKey.kAOTableVC) else {
                return self.setupCoreTableViewController()
            }
            return table
        }
        set {
           setupCoreTableViewController(newValue)
        }
    }
    
    @discardableResult
    private func setupCoreTableViewController(_ controller: UITableViewController? = nil) -> UITableViewController {
        // Load Base view
        setupCoreView()
        if let table = AssociatedObject<UITableViewController>.getAssociated(self, key: &AssociatedKey.kAOTableVC) {
            table.tableView.removeSubviews()
            AssociatedObject<Any>.resetAssociated(self, key: &AssociatedKey.kAOTableVC)
        }
        // Create tableView based on user provided style
        let local = controller ?? getCoreTableViewController()
        local.tableView.removeSubviews()
        // Add as child view controller
        self.addChild(local)
        self.mainView?.pin(view: local.view, edgeOffsets: self.tableViewEdgeOffsets)
        // Retain UITableViewController
        AssociatedObject<UITableViewController>.setAssociated(self, value: local, key: &AssociatedKey.kAOTableVC)
        return local
    }
}

// MARK: UITableView
public extension UITableView {
    func setTableHeaderView(view: UIView?) {
        self.tableHeaderView = view // UIView.embededView(view: view)
        self.resizeSubviews(view: self.tableHeaderView)
    }
    
    func setTableFooterView(view: UIView?) {
        self.tableFooterView = view // UIView.embededView(view: view)
        self.resizeSubviews(view: self.tableFooterView)
    }
    
    private func resizeSubviews(view: UIView?) {
        view?.layoutIfNeeded()
        view?.frame.size = view?.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize) ?? .zero
    }
}
