//
//  URLSessionManager.swift
//  FTMobileCore
//
//  Created by Praveen Prabhakar on 11/04/18.
//  Copyright © 2018 Praveen Prabhakar. All rights reserved.
//

import Foundation

public typealias URLSessionCompletionBlock = (Data?, URLResponse?, Error?) -> Swift.Void

open class URLSessionManager: NSObject {

    static let sharedInstance = URLSessionManager()
    static var sessionConfiguration: URLSessionConfiguration = .default
    static var sessionDelegate: URLSessionDelegate? = URLSessionManager.sharedInstance
    static var sessionQueue = OperationQueue()
    static var defaultSession: URLSession = URLSessionManager.createURLSession()

    // Setup urlsession-dataTask with request & completionHandler
    @discardableResult
    open class func startDataTask(with request: URLRequest, completionHandler: URLSessionCompletionBlock? = nil) -> URLSessionDataTask {

        let task: URLSessionDataTask

        // Setup session-dataTask with completion handler
        if let completionHandler = completionHandler {
            task = Self.defaultSession.dataTask(with: request, completionHandler: completionHandler)
        }
        else {
            task = Self.defaultSession.dataTask(with: request)
        }

        task.resume()

        return task
    }
}

extension URLSessionManager: URLSessionDelegate {
    
    static func createURLSession() -> URLSession {
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