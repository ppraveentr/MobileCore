//
//  FTBaseScrollViewController.swift
//  FTMobileCoreUI
//
//  Created by Praveen Prabhakar on 18/08/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation

private var kAOScrollVC = "k.FT.AO.ScrollViewController"

public protocol FTScrollViewControllerProtocol: FTBaseViewController {
    var scrollView: UIScrollView { get }
}

public extension FTScrollViewControllerProtocol {
    
    var scrollView: UIScrollView {
        get {
            guard let scroll = FTAssociatedObject<UIScrollView>.getAssociated(instance: self, key: &kAOScrollVC) else {
                return self.setupScrollView()
            }
            return scroll
        }
        set {
            setupScrollView(newValue)
        }
    }
}

private extension FTScrollViewControllerProtocol {
    
    @discardableResult
    func setupScrollView(_ local: UIScrollView = UIScrollView() ) -> UIScrollView {
        
        if let scroll = FTAssociatedObject<UIScrollView>.getAssociated(instance: self, key: &kAOScrollVC) {
            scroll.removeSubviews()
            FTAssociatedObject<Any>.resetAssociated(instance: self, key: &kAOScrollVC)
        }
        
        if isLoadedFromInterface || local.superview == nil {
            self.mainView?.pin(view: local, edgeOffsets: .zero)
            local.setupContentView(local.contentView)
        }
        
        FTAssociatedObject<UIScrollView>.setAssociated(instance: self, value: local, key: &kAOScrollVC)
        
        return local
    }
}

