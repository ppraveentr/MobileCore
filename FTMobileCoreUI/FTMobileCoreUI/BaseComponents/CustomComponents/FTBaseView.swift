//
//  FTBaseView.swift
//  FTMobileCoreUI
//
//  Created by Praveen Prabhakar on 09/07/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation

open class FTBaseView: FTView {
    
    //Set as BaseView, so that "pin'ning" subViews wont alter the base position
    public var rootView = FTView()
    
    //Top portion of view
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
        
        self.mainPinnedView.backgroundColor = .clear
        self.rootView.backgroundColor = .clear
        if self.backgroundColor == nil {
             self.backgroundColor = .white
        }

        // Set lowerPriority to avoid contraint issues with viewControllers's rootView
        self.pin(view: rootView, withLayoutPriority: FTLayoutPriorityRequiredLow)

        self.restConstraints()
    }
    
    func restConstraints() {
        // Remove all previous constrains, while resting the views
        rootView.removeSubviews()
        
        self.topPinnedView?.removeAllConstraints()
        self.mainPinnedView.removeAllConstraints()
        self.bottomPinnedView?.removeAllConstraints()
        
        var viewArray = [FTView]()
        
        // Embed in Temp view to auto-size the view layout
        if
            topPinnedView != nil,
            let tempView = FTView.embedView(contentView: topPinnedView!) as? FTView {
            viewArray.append(tempView)
        }
        
        viewArray.append(mainPinnedView)

        // Embed in Temp view to auto-size the view layout
        if
            bottomPinnedView != nil,
            let tempView = FTView.embedView(contentView: bottomPinnedView!) as? FTView {
            viewArray.append(tempView)
        }
        
        // Pin : Top and Side - margin of the firstView to Root
        rootView.pin(view: viewArray.first!, withEdgeInsets: [.Top, .Horizontal])

        if viewArray.count > 1 {
            
            //Make all subViews of sameSize, to auto-size the view layout
            rootView.stackView(views: viewArray,
                               layoutDirection: .TopToBottom,
                               edgeInsets: [.LeadingMargin, .TrailingMargin, .EqualWidth])
        }
        
        // Pin : BottomMargin of the lastView to Root
        rootView.pin(view: viewArray.last!, withEdgeInsets: .Bottom)
        
        // Pin : MainView to margin
        rootView.pin(view: self.mainPinnedView, withEdgeInsets: .Horizontal )

    }
}

extension FTBaseView {
    
    @available(*, deprecated)
    open override func addSubview(_ view: UIView) {
        if view != self.mainPinnedView, view != rootView {
            self.mainPinnedView.addSubview(view)
        } else{
            super.addSubview(view)
        }
    }
}
