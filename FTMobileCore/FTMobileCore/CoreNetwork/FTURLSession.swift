//
//  FTURLSession.swift
//  FTMobileCore
//
//  Created by Praveen Prabhakar on 11/04/18.
//  Copyright © 2018 Praveen Prabhakar. All rights reserved.
//

import Foundation

public typealias FTURLSessionCompletionBlock = (Data?, URLResponse?, Error?) -> Swift.Void

open class FTURLSession: NSObject {

    static let sharedInstance = FTURLSession()
    static var sessionConfiguration: URLSessionConfiguration = .default
    static var sessionDelegate: URLSessionDelegate? = FTURLSession.sharedInstance
    static var sessionQueue = OperationQueue()

    static var defaultSession: URLSession = FTURLSession.createURLSession()

    // Setup urlsession-dataTask with FTServiceClient
    @discardableResult
    class open func startDataTask<T>( with operation: T) -> URLSessionDataTask where T: FTServiceClient {
        return self.startDataTask(with: operation.urlRequest(), completionHandler: operation.sessionHandler())
    }

    // Setup urlsession-dataTask with request & completionHandler
    @discardableResult
    class open func startDataTask(with request: URLRequest, completionHandler: FTURLSessionCompletionBlock?) -> URLSessionDataTask {

        let task: URLSessionDataTask

        // Setup session-dataTask with completion handler
        if completionHandler != nil {
            task = FTURLSession.defaultSession.dataTask(with: request, completionHandler: completionHandler!)
        } else {
            task = FTURLSession.defaultSession.dataTask(with: request)
        }

        task.resume()

        return task
    }
    
}

extension FTURLSession: URLSessionDelegate {
    
    static func createURLSession() -> URLSession {
        return URLSession(configuration: FTURLSession.sessionConfiguration,
                          delegate: FTURLSession.sessionDelegate,
                          delegateQueue: nil)
    }

}
