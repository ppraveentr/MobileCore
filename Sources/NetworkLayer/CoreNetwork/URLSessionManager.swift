//
//  URLSessionManager.swift
//  MobileCore-NetworkLayer
//
//  Created by Praveen Prabhakar on 11/04/18.
//  Copyright © 2018 Praveen Prabhakar. All rights reserved.
//

import Foundation

public typealias URLSessionCompletionBlock = (Data?, URLResponse?, Error?) -> Swift.Void

open class URLSessionManager: NSObject {
    public static let sharedInstance = URLSessionManager()
    public static var sessionConfiguration: URLSessionConfiguration = .default
    public static var sessionDelegate: URLSessionDelegate? = URLSessionManager.sharedInstance
    public static var sessionQueue = OperationQueue()
    public static var urlSession: URLSession = URLSessionManager.createURLSession()

    // Setup urlsession-dataTask with request & completionHandler
    @discardableResult
    open class func startDataTask(with request: URLRequest, completionHandler: URLSessionCompletionBlock? = nil) -> URLSessionDataTask {

        let task: URLSessionDataTask

        // Setup session-dataTask with completion handler
        if let completionHandler = completionHandler {
            task = Self.urlSession.dataTask(with: request, completionHandler: completionHandler)
        }
        else {
            task = Self.urlSession.dataTask(with: request)
        }
        // start task
        task.resume()

        return task
    }
}

extension URLSessionManager: URLSessionDelegate {
    public static func createURLSession() -> URLSession {
        // default values
        let config = URLSessionManager.sessionConfiguration
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 30

        return URLSession(
            configuration: URLSessionManager.sessionConfiguration,
            delegate: URLSessionManager.sessionDelegate,
            delegateQueue: nil
        )
    }
}
