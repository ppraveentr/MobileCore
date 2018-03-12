//
//  FTServiceOperation.swift
//  FTMobileCore
//
//  Created by Praveen Prabhakar on 12/03/18.
//  Copyright © 2018 Praveen Prabhakar. All rights reserved.
//

import Foundation

/**
 The standard HTTP Verbs
 */
public enum HTTPVerb: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
   /* case HEAD = "HEAD"
    case DELETE = "DELETE"
    case PATCH = "PATCH"
    case OPTIONS = "OPTIONS"
    case TRACE = "TRACE"
    case CONNECT = "CONNECT"
     */
    case UNKNOWN = "UNKNOWN"
}

open class FTServiceOperation {
    
    var serviceName: String
    fileprivate var inputStack: FTModelStack
    fileprivate var responseStack: FTModelStack = FTModelStack()

    /// The body data of the HTTP response.
    open var data: Data?
    
    /// The body data of the HTTP response.
    open var resposne: HTTPURLResponse?
    
    /// The status code of the HTTP response.
    open var statusCode: Int?
    
    /// The Error of the HTTP response (if there was one).
    open var error: Error?
    
//    ///holds the collected data
//    var collectData = NSMutableData()
    
    ///finish closure
    var completionHandler:((FTSericeStatus) -> Void)?
    
    //progress closure. Progress is between 0 and 1.
    var progressHandler:((Float) -> Void)?
    
    //download closure. the URL is the file URL where the temp file has been download.
    //This closure will be called so you can move the file where you desire.
    var downloadHandler:((FTSericeStatus, URL) -> Void)?
    
    ///This gets called on auth challenges. If nil, default handling is use.
    ///Returning nil from this method will cause the request to be rejected and cancelled
    var auth:((URLAuthenticationChallenge) -> URLCredential?)?
    
    ///This is for doing SSL pinning
    //    var security: HTTPSecurity?
    
    init(serviceName: String, modelStack: FTModelStack, completionHandler: @escaping (FTSericeStatus) -> Swift.Void) {
        self.serviceName = serviceName
        self.inputStack = modelStack
        self.completionHandler = completionHandler
    }
    
}

extension FTServiceOperation {
    
    func isValid() -> Bool {
        return true
    }
    
    func urlRequest() -> URLRequest {
        return URLRequest(url: URL(fileURLWithPath: serviceName))
    }
    
    func responseModelStack() -> FTModelStack {
        return responseStack
    }
    
    func sessionHandler() -> (Data?, URLResponse?, Error?) -> () {
        
        let decodeHandler = { [unowned self] (data: Data?, response: URLResponse?, error: Error?) -> () in
            
             self.data = data
            self.error = error
            
            if let httpURLResponse = response as? HTTPURLResponse {
                self.resposne = httpURLResponse
                self.statusCode = httpURLResponse.statusCode
            }
            
            return
        }
        
        return decodeHandler
    }
}
