//
//  FTTableViewControllerProtocol.swift
//  MobileCore
//
//  Created by Praveen P on 10/09/19.
//  Copyright © 2019 Praveen P. All rights reserved.
//

import Foundation

private var kAOTableVC = "k.FT.AO.TableViewController"

public protocol FTTableViewControllerProtocol: FTBaseViewControllerProtocol {
    var tableStyle: UITableView.Style { get }
    var tableView: UITableView { get }
    var tableViewController: UITableViewController { get set }
    var tableViewEdgeOffsets: FTEdgeOffsets { get }
    
    func getCoreTableViewController() -> UITableViewController
}

public extension FTTableViewControllerProtocol {
    
    // TableView style, defalut: .plain
    var tableStyle: UITableView.Style {
        return .plain
    }
    
    var tableViewEdgeOffsets: FTEdgeOffsets {
        return .zero
    }
    
    var tableView: UITableView {
        return self.tableViewController.tableView
    }
    
    func getCoreTableViewController() -> UITableViewController {
        let controller = UITableViewController(style: self.tableStyle)
        controller.tableView.estimatedRowHeight = UITableView.automaticDimension
        return controller
    }
    
    var tableViewController: UITableViewController {
        get {
            guard let table = FTAssociatedObject<UITableViewController>.getAssociated(self, key: &kAOTableVC) else {
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
        
        if let table = FTAssociatedObject<UITableViewController>.getAssociated(self, key: &kAOTableVC) {
            table.tableView.removeSubviews()
            FTAssociatedObject<Any>.resetAssociated(self, key: &kAOTableVC)
        }
        
        // Create tableView based on user provided style
        let local = controller ?? getCoreTableViewController()
        local.tableView.removeSubviews()

        // Add as child view controller
        self.addChild(local)
        self.mainView?.pin(view: local.view, edgeOffsets: self.tableViewEdgeOffsets)
        // Set default Cell
        local.tableView.register(UITableViewCell.self, forCellReuseIdentifier: kAOTableVC)

        // Register for 'updateTableViewHeaderViewHeight'
        _ = NotificationCenter.default.addObserver(forName: .kFTMobileCoreDidLayoutSubviews, object: nil, queue: .main) { [weak self]_ in
            self?.updateTableViewHeaderViewHeight()
        }
        
        FTAssociatedObject<UITableViewController>.setAssociated(self, value: local, key: &kAOTableVC)

        return local
    }
    
    private func updateFrame(view: UIView) {
        var originalFrame = view.frame
        view.resizeToFitSubviews()
        originalFrame.size.height = (view.frame.height)
        originalFrame.size.width = self.tableView.frame.width
        view.frame = originalFrame
    }
    
    /**
     tableView's tableViewHeaderView contains wrapper view, which height is evaluated
     with Auto Layout. Here I use evaluated height and update tableView's
     tableViewHeaderView's frame.
     
     New height for tableViewHeaderView is applied not without magic, that's why
     I call -updateTableViewHeaderViewHeight.
     And again, this doesn't work due to some internals of UITableView,
     so -updateTableViewHeaderViewHeight call is scheduled in the main run loop.
     */
    func updateTableViewHeaderViewHeight() {
        
        // get height of the wrapper and apply it to a header
        if let view = self.tableView.tableHeaderView {
            updateFrame(view: view)
        }
        
        if let view = self.tableView.tableFooterView {
            updateFrame(view: view)
        }
        
        DispatchQueue.main.async {
            // whew, this could be animated!
            UIView.beginAnimations("tableHeaderView", context: nil)
            let header = self.tableView.tableHeaderView
            self.tableView.tableHeaderView = header
            UIView.commitAnimations()
            
            UIView.beginAnimations("tableFooterView", context: nil)
            let footer = self.tableView.tableFooterView
            self.tableView.tableFooterView = footer
            UIView.commitAnimations()
        }
    }
}
