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
    case GET
    case POST
    case PUT
   /* case HEAD
    case DELETE
    case PATCH
    case OPTIONS
    case TRACE
    case CONNECT
     */
    case UNKNOWN
}

open class FTServiceOperation {
    
    let serviceName: String
    fileprivate var serviceSchema: JSON? = nil

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
    
//    //progress closure. Progress is between 0 and 1.
//    var progressHandler:((Float) -> Void)?
//
//    //download closure. the URL is the file URL where the temp file has been download.
//    //This closure will be called so you can move the file where you desire.
//    var downloadHandler:((FTSericeStatus, URL) -> Void)?
//
//    ///This gets called on auth challenges. If nil, default handling is use.
//    ///Returning nil from this method will cause the request to be rejected and cancelled
//    var auth:((URLAuthenticationChallenge) -> URLCredential?)?
//
//    ///This is for doing SSL pinning
//    var security: HTTPSecurity?
    
    init(name: String, modelStack: FTModelStack, completionHandler: ((FTSericeStatus) -> Swift.Void)?) {
        self.serviceName = name
        self.inputStack = modelStack
        self.completionHandler = completionHandler
        
        do {
            self.serviceSchema = try FTMobileConfig.schemaForClass(classKey: self.serviceName)
        } catch {
            completionHandler?(FTSericeStatus.failed(self.responseStack, 500))
        }
    }
    
}

extension FTServiceOperation {
    
    func isValid() -> Bool {
        return (self.serviceSchema != nil)
    }
    
    func urlRequest() -> URLRequest {
        print("serviceSchema: ", self.serviceSchema ?? "Empty")
        
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
