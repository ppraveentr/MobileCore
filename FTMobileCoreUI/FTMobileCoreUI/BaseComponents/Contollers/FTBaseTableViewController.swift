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
        
        self.mainView?.pin(view: local.view)
        
        return local
    }
}
