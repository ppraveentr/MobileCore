//
//  FTTableView.swift
//  FTMobileCoreUI
//
//  Created by Praveen Prabhakar on 20/08/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation

open class FTTableViewHeaderFooterView: UITableViewHeaderFooterView {
    var embView: UIView? {
        willSet {
            self.embView?.removeSubviews()
        }
        didSet {
            if let embView = embView {
                self.pin(view: embView)
                self.addSelfSizing()
            }
        }
    }
    
    static func embedView(view: UIView?) -> FTTableViewHeaderFooterView {
        let local = FTTableViewHeaderFooterView()
        local.embView = view
        view?.addSelfSizing()
        return local
    }
}

public extension UITableView {

    func setTableHeaderView(view: UIView?) {
        self.tableHeaderView = FTTableViewHeaderFooterView.embedView(view: view)
    }
    
    func setTableFooterView(view: UIView?) {
        self.tableFooterView = FTTableViewHeaderFooterView.embedView(view: view)
    }
}

/*
 public protocol FTTableViewHeaderFooterProtocol {
 static func embededView(view: UIView?) -> UIView?
 }
 
 extension UIView: FTTableViewHeaderFooterProtocol {
 public static func embededView(view: UIView?) -> UIView? {
 guard let view = view else {
 return nil
 }
 
 let local = UIView()
 local.pin(view: view, edgeInsets: [.all, .equalSize], priority: kFTLayoutPriorityRequiredLow)
 view.addSelfSizing()
 return local
 }
 }
 
 public extension UITableView {
 
 func setTableHeaderView(view: UIView?) {
 self.tableHeaderView = UIView.embededView(view: view)
 }
 
 func setTableFooterView(view: UIView?) {
 self.tableFooterView = UIView.embededView(view: view)
 }
 }

 */
