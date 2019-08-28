//
//  FTBaseView.swift
//  FTMobileCoreUI
//
//  Created by Praveen Prabhakar on 09/07/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation

open class FTBaseView: FTView {
    
    // Set as BaseView, so that "pin'ning" subViews wont alter the base position
    public var rootView = FTView()
    
    // Top portion of view
    @IBOutlet
    public var topPinnedView: FTView? {
        didSet {
            self.restConstraints()
        }
    }

    // Using private var, since, mainView can be set from IB.
    // On init'coder, mainView will be nil, but on loadView it will be allocated.
    // So using lazy, to make sure, mainView will not be nil, when accessed.
    private lazy var localMainPinnedView = FTView()
    
    @IBOutlet
    public var mainPinnedView: FTView! {
        set {
            localMainPinnedView = newValue
            self.restConstraints()
        }
        get {
            return localMainPinnedView
        }
    }

    @IBOutlet
    public var bottomPinnedView: FTView? {
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
        if rootView.superview == nil {
            self.removeSubviews()
            // Set lowerPriority to avoid contraint issues with viewControllers's rootView
            self.pin(view: rootView, priority: kFTLayoutPriorityRequiredLow)
        }

        // Remove all previous constrains, while resting the views
        rootView.removeSubviews()
        
        self.topPinnedView?.removeAllConstraints()
        self.mainPinnedView.removeAllConstraints()
        self.bottomPinnedView?.removeAllConstraints()
        
        var viewArray = [FTView]()
        
        // Embed in Temp view to auto-size the view layout
        if
            let topPinnedView = topPinnedView,
            let tempView = FTView.embedView(contentView: topPinnedView) as? FTView {
            viewArray.append(tempView)
        }
        
        viewArray.append(mainPinnedView)

        // Embed in Temp view to auto-size the view layout
        if
            let bottomPinnedView = bottomPinnedView,
            let tempView = FTView.embedView(contentView: bottomPinnedView) as? FTView {
            viewArray.append(tempView)
        }
        
        // Pin : Top and Sides and Bottom
        pinToRootView(viewArray: viewArray)
        
        // Pin : MainView to margin
        rootView.pin(view: self.mainPinnedView, edgeInsets: .horizontal )
    }
}

extension FTBaseView {

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
    
    func pinToRootView(viewArray: [FTView]) {
        // Pin : Top and Side - margin of the firstView to Root
        if let firstView = viewArray.first {
            rootView.pin(view: firstView, edgeInsets: [.top, .horizontal])
        }
        
        if viewArray.count > 1 {
            // Make all subViews of sameSize, to auto-size the view layout
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
