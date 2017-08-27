//
//  FTBaseTableViewController.swift
//  FTMobileCoreUI
//
//  Created by Praveen Prabhakar on 13/07/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation

open class FTCoreTableViewController: UITableViewController {
    
    var tableViewStyle: UITableViewStyle = .plain
    
    public override init(style: UITableViewStyle) {
        super.init(style: style)
        self.tableViewStyle = style
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    final override public func loadView() {
        self.setupCustomeTableView()
    }
    
    //override self's view and tableView with the 'getCustomeTableView()' value
    open func setupCustomeTableView() {
        
        let local = self.getFTTableView()
        local.dataSource = self;
        local.delegate = self;
        
        self.view = local
        self.tableView = local
    }
    
    open func getFTTableView() -> FTTableView {
        let local = FTTableView(frame: .zero, style: self.tableViewStyle)
        local.estimatedRowHeight = UITableViewAutomaticDimension
        return local
    }
}

open class FTBaseTableViewController: FTBaseViewController {
    
    public lazy var tableViewController: FTCoreTableViewController = self.getTableView()
    public var tableView: FTTableView {
        get { return self.tableViewController.tableView as! FTTableView }
    }
    
    open func class_TableViewController() -> FTCoreTableViewController {
        return FTCoreTableViewController(style: self.class_TableViewStyle())
    }
    
    open func class_TableViewStyle() -> UITableViewStyle { return .plain }
    
    open func class_TableViewEdgeOffsets() -> FTEdgeOffsets { return .FTEdgeOffsetsZero() }
    
    open override func loadView() {
        super.loadView()
        
        //Setup tableView by invoking it
        _ = self.tableView
    }
}

extension FTBaseTableViewController {
    
    func getTableView() -> FTCoreTableViewController {
        
        let local = self.class_TableViewController()
        
        self.addChildViewController(local)
        
        self.mainView?.pin(view: local.view, withEdgeOffsets: self.class_TableViewEdgeOffsets())
        
        //Set default Cell
        local.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "kCellIdentifer")

        local.tableView.dataSource = self
        local.tableView.delegate = self
        
        return local
    }
    
    override open func viewDidLayoutSubviews() {
        
        self.updateTableViewHeaderViewHeight()
        
        super.viewDidLayoutSubviews()
        
        DispatchQueue.main.async {
            if self.tableView.tableHeaderView != nil || self.tableView.tableFooterView != nil {
                self.updateTableViewHeaderViewHeight()
            }
        }
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
            var Frame = self.tableView.tableHeaderView?.frame
            view.resizeToFitSubviews()
            Frame?.size.height = (view.frame.size.height)
            Frame?.size.width = self.tableView.frame.width
            self.tableView.tableHeaderView?.frame = Frame!
        }
        
        if let view = self.tableView.tableFooterView {
            var Frame = self.tableView.tableFooterView?.frame
            view.resizeToFitSubviews()
            Frame?.size.height = (view.frame.size.height)
            Frame?.size.width = self.tableView.frame.width
            self.tableView.tableFooterView?.frame = Frame!
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
    
    //For calculating TableCell height
    open func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "kCellIdentifer", for: indexPath)
        
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

