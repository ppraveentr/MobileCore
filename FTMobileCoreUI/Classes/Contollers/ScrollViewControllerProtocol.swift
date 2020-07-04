//
//  ScrollViewControllerProtocol.swift
//  CoreUIExtensions
//
//  Created by Praveen Prabhakar on 18/08/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation

private var kAOScrollVC = "k.FT.AO.ScrollViewController"

public protocol ScrollViewControllerProtocol: ViewControllerProtocol {
    var scrollView: UIScrollView { get }
}

public extension ScrollViewControllerProtocol {
    
    var scrollView: UIScrollView {
        get {
            guard let scroll = AssociatedObject<UIScrollView>.getAssociated(self, key: &kAOScrollVC) else {
                return self.setupScrollView()
            }
            return scroll
        }
        set {
            setupScrollView(newValue)
        }
    }
}

private extension ScrollViewControllerProtocol {
    
    @discardableResult
    func setupScrollView(_ local: UIScrollView = UIScrollView() ) -> UIScrollView {
        
        // Load Base view
        setupCoreView()
        
        if let scroll: UIScrollView = AssociatedObject<UIScrollView>.getAssociated(self, key: &kAOScrollVC) {
            scroll.removeSubviews()
            AssociatedObject<Any>.resetAssociated(self, key: &kAOScrollVC)
        }
        
        if local.superview == nil {
            self.mainView?.pin(view: local, edgeOffsets: .zero)
            local.setupContentView(local.contentView)
        }
        
        AssociatedObject<UIScrollView>.setAssociated(self, value: local, key: &kAOScrollVC)
        
        return local
    }
}
