//
//  FTFloatingView.swift
//  FTMobileCoreUI
//
//  Created by Praveen Prabhakar on 25/08/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation
import UIKit

public protocol FTFloatingViewDelegate: AnyObject {
    func viewDraggingDidBegin(view: UIView, in window: UIWindow?)
    func viewDraggingDidEnd(view: UIView, in window: UIWindow?)
}

public class FloatingWindow: UIWindow {
    var topView = UIView()
    lazy var pointInsideCalled: Bool = true
    
    override public func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if self.point(inside: point, with: event) {
            self.pointInsideCalled = true
            return topView
        }
        if pointInsideCalled {
            self.pointInsideCalled = false
            return topView
        }
        return nil
    }
}

public class FTFloatingView: FTView {
    
    private var floatingWindow: FloatingWindow?
    private var appWindow: UIWindow?
    private var floatingView: UIView!

    static let sharedInstance: FTFloatingView = { FTFloatingView(with: FTView()) }()
    
    public class func configFloatingView(view: UIView) -> FTFloatingView {
        sharedInstance.configFloatingView(with: view)
        return sharedInstance
    }
    
     fileprivate func configFloatingView(with view: UIView, layer: CGFloat = 1) {
        
        self.floatingView = view

        self.appWindow = UIApplication.shared.keyWindow
        self.floatingWindow = FloatingWindow(frame: view.frame)
        self.floatingWindow?.topView = view
        self.floatingWindow?.rootViewController?.view = view
        self.floatingWindow?.windowLevel = UIWindow.Level(rawValue: layer)
        self.floatingWindow?.makeKeyAndVisible()
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(panGesture:)))
        panGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(panGesture)
    }
    
    /**
     is floating view showing
     */
    public var isShowing = false
    
    /**
     Delegate reutrn events of your floating view.
     */
    public weak var floatingViewDelegate: FTFloatingViewDelegate?
    
    /**
     Initilization of FTFloatingView
     
     - Parameter view:   A normal view that turns to floating view.
     - Parameter layer: The layer of Z that the View will be presented, by default it is 1. in case of have more windows change it.
     
     */
    public init(with view: UIView, layer: CGFloat = 1) {
        super.init(frame: view.frame)
        self.configFloatingView(with: view, layer: layer)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /**
     Showing floating view
     */
    public func show() {
        if self.isShowing {
            return
        }
        self.floatingWindow?.addSubview(self.floatingView)
        self.isShowing = true
        floatingWindow?.isHidden = false
    }
    
    /**
     Hidding floating view
     */
    public func hide() {
        self.isShowing = false
        floatingWindow?.isHidden = true
    }
    
    @objc private func handlePanGesture(panGesture: UIPanGestureRecognizer) {
        if panGesture.state == .began {
            self.floatingViewDelegate?.viewDraggingDidBegin(view: self.floatingView, in: self.floatingWindow)
        }
        
        if panGesture.state == .ended {
            self.floatingViewDelegate?.viewDraggingDidEnd(view: self.floatingView, in: self.floatingWindow)
        }
        
        if panGesture.state == .changed {
            let translation = panGesture.location(in: self.floatingView)
            self.viewDidMove(to: translation)
        }
    }
    
    // Handleing movement of view
    private func viewDidMove(to location: CGPoint) {
        guard let point = (self.floatingWindow?.convert(location, to: self.appWindow)) else {
            return
        }

        UIView.animate(
            withDuration: 0.1,
            delay: 0.0,
            options: [.beginFromCurrentState, .curveEaseInOut],
            animations: {
                switch UIDevice.current.orientation {
                case .portrait :
                    self.floatingWindow?.center = point
                case .landscapeLeft :
                    if let height = self.appWindow?.frame.size.height {
                        self.floatingWindow?.center = CGPoint(x: height - point.y, y: point.x)
                    }
                    
                case .landscapeRight :
                    if let width = self.appWindow?.frame.size.width {
                        self.floatingWindow?.center = CGPoint(x: point.y, y: width - point.x)
                    }
                default :
                    ftLog("FTError: Floating View Does not Handler This Situation")
                }
            },
            completion: nil
        )
    }
}