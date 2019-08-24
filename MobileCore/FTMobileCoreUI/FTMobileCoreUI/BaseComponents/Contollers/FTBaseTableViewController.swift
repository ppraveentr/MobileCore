//
//  FTBaseTableViewController.swift
//  FTMobileCoreUI
//
//  Created by Praveen Prabhakar on 13/07/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation

private let kFTCellIdentifier = "FT.kCellIdentifier"

open class FTCoreTableViewController: UITableViewController {
    var tableStyle: UITableView.Style = .plain
    
    override public init(style: UITableView.Style) {
        super.init(style: style)
        self.tableStyle = style
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    var ftTableView: UITableView {
        let local = UITableView(frame: .zero, style: self.tableStyle)
        local.estimatedRowHeight = UITableView.automaticDimension
        local.dataSource = self
        local.delegate = self
        
        self.view = local
        self.tableView = local
        
        return local
    }

    final override public func loadView() {
        _ = self.ftTableView
    }
}

open class FTBaseTableViewController: FTBaseViewController {

    // TableView style, defalut: .plain
    open func tableStyle() -> UITableView.Style {
        return .plain
    }

    public var tableView: UITableView {
        get {
            return self.tableViewController.tableView
        }
    }

    public lazy var tableViewController: FTCoreTableViewController = self.getCoreTableViewController()

    open func tableViewEdgeOffsets() -> FTEdgeOffsets {
        return .zero
    }
    
    override open func loadView() {
        super.loadView()
        
        // Setup tableView by invoking it
        _ = self.tableView
    }
    
    override open func viewDidLayoutSubviews() {
        
        self.updateTableViewHeaderViewHeight()
        
        super.viewDidLayoutSubviews()
        
        if self.tableView.tableHeaderView != nil || self.tableView.tableFooterView != nil {
            DispatchQueue.main.async {
                self.updateTableViewHeaderViewHeight()
            }
        }
    }
}

extension FTBaseTableViewController {

    fileprivate func getCoreTableViewController() -> FTCoreTableViewController {
        // Create tableView based on user provided style
        let local = FTCoreTableViewController(style: self.tableStyle())
        // Add as child view controller
        self.addChild(local)
        self.mainView?.pin(view: local.view, edgeOffsets: self.tableViewEdgeOffsets())
        // Set default Cell
        local.tableView.register(UITableViewCell.self, forCellReuseIdentifier: kFTCellIdentifier)
        local.tableView.dataSource = self
        local.tableView.delegate = self
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
     I call -resetTableViewHeaderView.
     And again, this doesn't work due to some internals of UITableView,
     so -resetTableViewHeaderView call is scheduled in the main run loop.
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
            self.tableView.tableHeaderView = self.tableView.tableHeaderView
            UIView.commitAnimations()
            
            UIView.beginAnimations("tableFooterView", context: nil)
            self.tableView.tableFooterView = self.tableView.tableFooterView
            UIView.commitAnimations()
        }
    }
}

extension FTBaseTableViewController: UITableViewDataSource {
    // For calculating TableCell height
    open func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kFTCellIdentifier, for: indexPath)
        return cell
    }
}

extension FTBaseTableViewController: UITableViewDelegate {
    open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    open func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
}
