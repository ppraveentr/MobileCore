//
//  LoadingIndicator.swift
//  MobileCore-CoreComponents
//
//  Created by Praveen Prabhakar on 24/09/18.
//  Copyright © 2018 Praveen Prabhakar. All rights reserved.
//

import CoreGraphics
import Foundation
import QuartzCore
import UIKit

let loaderSpinnerMarginSide: CGFloat = 35.0
let loaderSpinnerMarginTop: CGFloat = 20.0
let loaderTitleMargin: CGFloat = 5.0

// MARK: Loader config
public struct LoaderConfig {
    /// Size of loader
    public var size: CGFloat = 120.0
    /// Color of spinner view
    public var spinnerColor = UIColor.black
    /// SpinnerLine Width
    public var spinnerLineWidth: Float = 1.0
    /// Speed of the spinner
    public var speed: Int = 1
    /// Size of loader
    public var title: String?
    /// Font for title text in loader
    public var titleTextFont = UIFont.boldSystemFont(ofSize: 16.0)
    /// Color of title text
    public var titleTextColor = UIColor.black
    /// Background color for loader
    public var backgroundColor = UIColor.white
    /// Foreground color
    public var foregroundColor = UIColor.clear
    /// Foreground alpha CGFloat, between 0.0 and 1.0
    public var foregroundAlpha: CGFloat = 0.0
    /// Corner radius for loader
    public var cornerRadius: CGFloat = 10.0
    /// Corner radius for loader
    public var customConfig: [String: Any]?

    public init(_ customConfig: [String: Any]? = nil) {
        self.customConfig = customConfig
    }
}

public class LoadingIndicator: UIView {
    static let sharedInstance = LoadingIndicator(frame: CGRect(x: 0, y: 0, width: 120, height: 120))

    public typealias CompletionBlock = (_ isCompleted: Bool) -> Void

    private var baseView: UIView?
    private var titleLabel: UILabel?
    private var loadingView: LoadingView?
    private var (animated, canUpdated) = (true, false)
    private var title: String?
    private var speed = 1
    
    private var config = LoaderConfig() {
        didSet {
            self.loadingView?.config = config
        }
    }
    
    @objc func rotated(notification: NSNotification) {
        let loader = LoadingIndicator.sharedInstance
        let height: CGFloat = UIScreen.main.bounds.size.height
        let width: CGFloat = UIScreen.main.bounds.size.width
        let center = CGPoint(x: width / 2.0, y: height / 2.0)
        loader.center = center
        loader.baseView?.frame = UIScreen.main.bounds
    }
    
    override public var frame: CGRect {
        didSet {
            self.update()
        }
    }
        
    public static func show(_ animated: Bool = true) {
        self.show(title: self.sharedInstance.config.title, animated: animated)
    }
    
    public static func show(title: String?, animated: Bool = true) {
        // Will fail if window is not allocated
        guard let currentWindow: UIWindow = UIApplication.shared.keyWindow else { return }
        let loader = LoadingIndicator.sharedInstance
        loader.canUpdated = true
        loader.animated = animated
        loader.title = title
        loader.update()
        
        NotificationCenter.default.addObserver(
            loader,
            selector: #selector( loader.rotated(notification:) ),
            name: UIDevice.orientationDidChangeNotification,
            object: nil
        )
        
        let height: CGFloat = UIScreen.main.bounds.size.height
        let width: CGFloat = UIScreen.main.bounds.size.width
        let center = CGPoint(x: width / 2.0, y: height / 2.0)
        
        loader.center = center
        
        if loader.superview == nil {
            loader.baseView = UIView(frame: currentWindow.bounds)
            loader.baseView?.backgroundColor = loader.config.foregroundColor.withAlphaComponent(loader.config.foregroundAlpha)
            
            currentWindow.addSubview(loader.baseView!)
            currentWindow.addSubview(loader)
            loader.start()
        }
    }
    
    public static func hide(_ completion: CompletionBlock? = nil) {
        let loader = LoadingIndicator.sharedInstance
        NotificationCenter.default.removeObserver(loader)
        loader.stop(completion)
    }
    
    public static func setConfig(config: LoaderConfig) {
        let loader = LoadingIndicator.sharedInstance
        loader.config = config
    }
    
    func frameForSpinner() -> CGRect {
        let loadingViewSize = self.frame.size.width - (loaderSpinnerMarginSide * 2)
        
        if self.title == nil {
            let yOffset = (self.frame.size.height - loadingViewSize) / 2
            return CGRect(origin: CGPoint(x: loaderSpinnerMarginSide, y: yOffset), size: CGSize(width: loadingViewSize, height: loadingViewSize))
        }
        return CGRect(origin: CGPoint(x: loaderSpinnerMarginSide, y: loaderSpinnerMarginTop), size: CGSize(width: loadingViewSize, height: loadingViewSize))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

// MARK: Private methods
private extension LoadingIndicator {
    func setup() {
        self.alpha = 0
        self.update()
    }
    
    func start() {
        self.loadingView?.start()
        if self.animated {
            UIView.animate(withDuration: 0.3) {
                self.alpha = 1
            }
        }
        else {
            self.alpha = 1
        }
    }
    
    func stop(_ completion: CompletionBlock? = nil) {
        if self.animated {
            UIView.animate(
                withDuration: 0.3,
                animations: { self.alpha = 0 },
                completion: { _ in
                    self.removeFromSuperview()
                    self.baseView?.removeFromSuperview()
                    self.loadingView?.stop(completion)
                }
            )
        }
        else {
            self.alpha = 0
            self.removeFromSuperview()
            self.baseView?.removeFromSuperview()
            self.loadingView?.stop(completion)
        }
    }
    
    func update() {
        self.backgroundColor = self.config.backgroundColor
        self.layer.cornerRadius = self.config.cornerRadius
        let loadingViewSize = self.frame.size.width - (loaderSpinnerMarginSide * 2)
        if self.loadingView == nil {
            self.loadingView = LoadingView(frame: self.frameForSpinner())
            self.addSubview(self.loadingView!)
        }
        else {
            self.loadingView?.frame = self.frameForSpinner()
        }
        
        let labelFrame = CGRect(
            origin: CGPoint(x: loaderTitleMargin, y: loaderSpinnerMarginTop + loadingViewSize),
            size: CGSize(width: self.frame.width - loaderTitleMargin * 2, height: 42.0)
        )

        if self.titleLabel == nil {
            self.titleLabel = UILabel(frame: labelFrame)
            self.addSubview(self.titleLabel!)
            self.titleLabel?.numberOfLines = 1
            self.titleLabel?.textAlignment = NSTextAlignment.center
            self.titleLabel?.adjustsFontSizeToFitWidth = true
        }
        else {
            self.titleLabel?.frame = labelFrame
        }
        
        self.titleLabel?.font = self.config.titleTextFont
        self.titleLabel?.textColor = self.config.titleTextColor
        self.titleLabel?.text = self.title
        self.titleLabel?.isHidden = self.title == nil
    }
}

// MARK: LoadingView
private class LoadingView: UIView {
    
    private var speed: Int?
    private var lineWidth: Float?
    private var lineTintColor: UIColor?
    private var backgroundLayer: CAShapeLayer?
    private var isSpinning: Bool?
    
    var config = LoaderConfig() {
        didSet {
            self.update()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: Setup loading view
    func setup() {
        self.backgroundColor = UIColor.clear
        self.lineWidth = fmaxf(Float(self.frame.size.width) * 0.025, 1)
        
        self.backgroundLayer = CAShapeLayer()
        self.backgroundLayer?.strokeColor = self.config.spinnerColor.cgColor
        self.backgroundLayer?.fillColor = self.backgroundColor?.cgColor
        self.backgroundLayer?.lineCap = CAShapeLayerLineCap.round
        self.backgroundLayer?.lineWidth = CGFloat(self.lineWidth!)
        self.layer.addSublayer(self.backgroundLayer!)
    }
    
    func update() {
        self.frame = CGRect(x: 0, y: 0, width: config.size, height: config.size)
        self.lineWidth = self.config.spinnerLineWidth
        self.speed = self.config.speed
        
        self.backgroundLayer?.lineWidth = CGFloat(self.lineWidth!)
        self.backgroundLayer?.strokeColor = self.config.spinnerColor.cgColor
    }
    
    // MARK: Draw Circle
    override func draw(_ rect: CGRect) {
        self.backgroundLayer?.frame = self.bounds
    }
    
    func drawBackgroundCircle(partial: Bool) {
        let startAngle = CGFloat.pi / CGFloat(2.0)
        var endAngle: CGFloat = (2.0 * CGFloat.pi) + startAngle
        
        let center = CGPoint(x: self.bounds.size.width / 2, y: self.bounds.size.height / 2)
        let radius = (CGFloat(self.bounds.size.width) - CGFloat(self.lineWidth!)) / CGFloat(2.0)
        
        let processBackgroundPath = UIBezierPath()
        processBackgroundPath.lineWidth = CGFloat(self.lineWidth!)
        
        if partial {
            endAngle = (1.8 * CGFloat.pi) + startAngle
        }
        
        processBackgroundPath.addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        self.backgroundLayer?.path = processBackgroundPath.cgPath
    }
    
    // MARK: Start and stop spinning
    func start() {
        self.isSpinning? = true
        self.drawBackgroundCircle(partial: true)
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = NSNumber(value: Double.pi * 2.0)
        rotationAnimation.duration = 1
        rotationAnimation.isCumulative = true
        rotationAnimation.repeatCount = HUGE
        self.backgroundLayer?.add(rotationAnimation, forKey: "rotationAnimation")
    }
    
    func stop(_ completion: LoadingIndicator.CompletionBlock? = nil) {
        self.drawBackgroundCircle(partial: false)
        
        self.backgroundLayer?.removeAllAnimations()
        self.isSpinning? = false
        completion?(true)
    }
}
