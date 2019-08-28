//
//  FTTableView.swift
//  FTMobileCoreUI
//
//  Created by Praveen Prabhakar on 20/08/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation

open class FTTableViewHeaderFooterView: FTView {
    var embView: UIView? {
        willSet {
            self.embView?.removeSubviews()
        }
        didSet {
            if let embView = embView {
                self.addSubview(embView)
                self.pin( view: embView, edgeInsets: [.all, .equalSize], priority: kFTLayoutPriorityRequiredLow )
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
        self.tableHeaderView = embededView(view: view)
    }
    
    func setTableFooterView(view: UIView?) {
        self.tableFooterView = embededView(view: view)
    }

    func embededView(view: UIView?) -> FTTableViewHeaderFooterView? {
        return view as? FTTableViewHeaderFooterView ?? FTTableViewHeaderFooterView.embedView(view: view)
    }
}
