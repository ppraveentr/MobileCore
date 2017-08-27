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
        willSet{
            self.embView?.removeSubviews()
        }
        didSet{
            if (embView != nil) {
                self.addSubview(embView!)
                self.pin(view: embView!, withEdgeInsets: [.All, .EqualSize], withLayoutPriority: 999)                
            }
        }
    }
    
    class func embedView(view: UIView?) -> FTTableViewHeaderFooterView{
        
        let local = FTTableViewHeaderFooterView()
        local.embView = view
        view?.addSelfSizing()
        
        return local
    }
}


open class FTTableView: UITableView {
    
    open func setTableHeaderView(view: UIView?) {
        
        guard (view != nil || (view?.isKind(of: UIView.self))! ) else { return }
        
        var view = view
        if (view as? FTTableViewHeaderFooterView) == nil {
            view = FTTableViewHeaderFooterView.embedView(view: view)
        }
        
        self.tableHeaderView = view
    }
    
    open func setTableFooterView(view: UIView?) {
        
        guard (view != nil || (view?.isKind(of: UIView.self))! ) else { return }
        
        var view = view
        if (view as? FTTableViewHeaderFooterView) == nil {
            view = FTTableViewHeaderFooterView.embedView(view: view)
        }
        
        self.tableFooterView = view
    }
}
