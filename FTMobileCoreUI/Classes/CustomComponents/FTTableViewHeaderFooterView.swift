//
//  FTTableView.swift
//  FTMobileCoreUI
//
//  Created by Praveen Prabhakar on 20/08/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation

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
