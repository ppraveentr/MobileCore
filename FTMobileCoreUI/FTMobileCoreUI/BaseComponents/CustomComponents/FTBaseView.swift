//
//  FTBaseView.swift
//  FTMobileCoreUI
//
//  Created by Praveen Prabhakar on 09/07/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation

open class FTBaseView: FTView {
    
    public var topPinnedView: FTView? {
        didSet {
            self.restConstraints()
        }
    }
    
    public var mainPinnedView = FTView() {
        didSet {
            self.restConstraints()
        }
    }
    
    public var bottomPinnedView: FTView? {
        didSet {
            self.restConstraints()
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }
    
    func setupView() {
        self.backgroundColor = .clear
        self.restConstraints()
    }
    
    open override var backgroundColor: UIColor?{
        didSet {
            self.mainPinnedView.backgroundColor = self.backgroundColor
        }
    }
    
    func restConstraints() {
        var cont: [NSLayoutConstraint] = self.mainPinnedView.constraints
        cont.removeAll()
        
        self.pin(view: self.mainPinnedView)
    }
}

extension FTBaseView {
    
    @available(*, deprecated)
    open override func addSubview(_ view: UIView) {
        if view != self.mainPinnedView {
            self.mainPinnedView.addSubview(view)
        }else{
            super.addSubview(view)
        }
    }
}
