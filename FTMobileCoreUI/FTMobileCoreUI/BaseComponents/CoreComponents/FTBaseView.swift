//
//  FTBaseView.swift
//  FTMobileCoreUI
//
//  Created by Praveen Prabhakar on 09/07/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation

open class FTBasePinnedView: UIView {
    
    public var topPinnedView: UIView? {
        didSet {
            self.restConstraints()
        }
    }
    
    public var mainPinnedView: UIView = UIView() {
        didSet {
            self.restConstraints()
        }
    }
    
    public var bottomPinnedView: UIView? {
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
        self.backgroundColor = UIColor.white
        self.mainPinnedView.backgroundColor = UIColor.white
        
        self.restConstraints()
    }
    
    func restConstraints() {
        var cont: [NSLayoutConstraint] = self.mainPinnedView.constraints
        cont.removeAll()
        
        self.pin(view: self.mainPinnedView)
    }
    
//    open override func addSubview(_ view: UIView) {
//        if view != self.mainPinnedView {
//            self.mainPinnedView.addSubview(view)
//        }else{
//            super.addSubview(view)
//        }
//    }
    
}
