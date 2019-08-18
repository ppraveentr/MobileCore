//
//  FTBaseScrollViewController.swift
//  FTMobileCoreUI
//
//  Created by Praveen Prabhakar on 18/08/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation

open class FTBaseScrollViewController: FTBaseViewController {

    @IBOutlet
    public lazy var scrollView: UIScrollView! = self.setupScrollView()

    override open func loadView() {
        super.loadView()

        // Setup ScrollView incse, view is loaded from IB
        setupScrollView(scrollView: self.scrollView)
    }
    
}

extension FTBaseScrollViewController {

    @discardableResult
    func setupScrollView(scrollView local: UIScrollView = UIScrollView() ) -> UIScrollView {

        local.superview?.removeFromSuperview()
        self.scrollView = local

        if isLoadedFromInterface || local.superview == nil {
            self.mainView?.pin(view: local, edgeOffsets: .zero)
            local.setupContentView(local.contentView)
        }

        return local
    }
    
}
