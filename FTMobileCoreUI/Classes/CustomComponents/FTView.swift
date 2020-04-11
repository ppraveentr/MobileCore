//
//  FTView.swift
//  FTMobileCoreUI
//
//  Created by Praveen Prabhakar on 09/07/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation

open class FTView: UIView {
    
    // Set as BaseView, so that "pin'ning" subViews wont alter the base position
    public var rootView = UIView()
    
    // Top portion of view
    @IBOutlet
    public var topPinnedView: UIView? {
        didSet {
            self.restConstraints()
        }
    }

    // Using private var, since, mainView can be set from IB.
    // On init'coder, mainView will be nil, but on loadView it will be allocated.
    // So using lazy, to make sure, mainView will not be nil, when accessed.
    private lazy var localMainPinnedView = UIView()
    
    @IBOutlet
    public var mainPinnedView: UIView! {
        set {
            localMainPinnedView = newValue
            self.restConstraints()
        }
        get {
            localMainPinnedView
        }
    }

    @IBOutlet
    public var bottomPinnedView: UIView? {
        didSet {
            self.restConstraints()
        }
    }

    var isLoadedFromInterface = false
    
    public required init?(coder aDecoder: NSCoder) {
        isLoadedFromInterface = true
        super.init(coder: aDecoder)
        // don't setupView, when loaded from IB
        isLoadedFromInterface = false
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    func setupView() {
        self.mainPinnedView.backgroundColor = .clear
        self.rootView.backgroundColor = .clear
        if self.backgroundColor == nil {
            self.backgroundColor = .white
        }
        // Set lowerPriority to avoid contraint issues with viewControllers's rootView
        self.pin(view: rootView, priority: kFTLayoutPriorityRequiredLow)
        self.restConstraints()
    }
    
    func restConstraints() {
        // Will be nil, when loaded from IB
        if self.rootView.superview == nil {
            self.removeSubviews()
            // Set lowerPriority to avoid contraint issues with viewControllers's rootView
            self.pin(view: self.rootView, priority: kFTLayoutPriorityRequiredLow)
        }

        // Remove all previous constrains, while resting the views
        self.rootView.removeSubviews()
        self.topPinnedView?.removeAllConstraints()
        self.mainPinnedView.removeAllConstraints()
        self.bottomPinnedView?.removeAllConstraints()
        
        var viewArray = [UIView]()
        // Embed in Temp view to auto-size the view layout
        if let topPinnedView = self.topPinnedView {
            let tempView = UIView.embedView(contentView: topPinnedView)
            viewArray.append(tempView)
        }
        // Embed mainView
        viewArray.append(self.mainPinnedView)
        // Embed in Temp view to auto-size the view layout
        if let bottomPinnedView = self.bottomPinnedView {
            let tempView = UIView.embedView(contentView: bottomPinnedView)
            viewArray.append(tempView)
        }
        
        // Pin : Top and Sides and Bottom
        pinToRootView(viewArray: viewArray)
        // Pin : MainView to margin
        rootView.pin(view: self.mainPinnedView, edgeInsets: .horizontal )
    }
}

extension FTView {

    @available(*, deprecated)
    override open func addSubview(_ view: UIView) {
        if view != mainPinnedView, view != rootView,
            !isLoadedFromInterface {
            self.mainPinnedView.addSubview(view)
        }
        else {
            super.addSubview(view)
        }
    }
    
    func pinToRootView(viewArray: [UIView]) {
        // Pin : Top and Side - margin of the firstView to Root
        if let firstView = viewArray.first {
            rootView.pin(view: firstView, edgeInsets: [.top, .horizontal])
        }
        
        // Make all subViews of sameSize, to auto-size the view layout
        if viewArray.count > 1 {
            rootView.stackView(
                views: viewArray,
                layoutDirection: .topToBottom,
                edgeInsets: [.leadingMargin, .trailingMargin, .equalWidth]
            )
        }
        
        // Pin : BottomMargin of the lastView to Root
        if let lastView = viewArray.last {
            rootView.pin(view: lastView, edgeInsets: .bottom)
        }
    }
}
