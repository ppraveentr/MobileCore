//
//  FTServiceStack.swift
//  FTMobileCore
//
//  Created by Praveen Prabhakar on 12/03/18.
//  Copyright © 2018 Praveen Prabhakar. All rights reserved.
//

import Foundation

public typealias FTServiceCompletionBlock = (FTSericeStatus) -> Swift.Void

public protocol FTServiceStackProtocol {
    var serviceName: String { get }
    var responseType: FTModelData.Type { get }
    static func setup(modelStack: FTModelData?, completionHandler: FTServiceCompletionBlock?) -> Self
}

public protocol FTServiceRulesProtocol {
    static func configure(requestHeaders urlRequest: URLRequest)
}

open class FTServiceStack1: FTServiceStackProtocol {
    open var serviceName: String { return "" }
    open var responseType: FTModelData.Type { return FTModelData.self as! FTModelData.Type }

    lazy var serviceRequet: FTRequestObject? = setupServiceRequest()
    fileprivate var inputStack: FTModelData?
    open var responseStack: FTModelData?

    /// The header values in HTTP response.
    open var requestHeaders: Dictionary<String,String>?
    open var responseHeaders: Dictionary<String,String>?
    
    /// The body data of the HTTP response.
    open var data: Data?
    
    /// The body data of the HTTP response.
    open var resposne: HTTPURLResponse?
    open var resposneString: String?

    /// The status code of the HTTP response.
    open var statusCode: Int?
    
    /// The Error of the HTTP response (if there was one).
    open var error: Error?

    ///finish closure
    var completionHandler: FTServiceCompletionBlock?

     var mockDataHandler: FTServiceCompletionBlock?
    
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

    required public init(modelStack: FTModelData?, completionHandler: FTServiceCompletionBlock?) {
        self.inputStack = modelStack
        self.completionHandler = completionHandler
    }

    public static func setup(modelStack: FTModelData?, completionHandler: FTServiceCompletionBlock?) -> Self {
        return self.init(modelStack: modelStack, completionHandler: completionHandler)
    }
}

fileprivate extension FTServiceStack {

    //Service Base URL
    func getBaseURL() -> String {

        // Service App Base URL
        var baseURL = FTMobileConfig.appBaseURL

        // If service has customeBase URL
        if ((serviceRequet?.baseURL) != nil) {
            baseURL = (serviceRequet?.baseURL)!
        }

        return baseURL
    }

    func getQueryItems() -> [URLQueryItem]? {

        let querys = inputStack?.queryItems()
        //        if let requestQuery = serviceRequet?.requestQuery {
        // 
        //        }

        return querys
    }
}

extension FTServiceStack1 {

    func setupServiceRequest() -> FTRequestObject? {
        do {
            if let data = try! FTMobileConfig.schemaForClass(classKey: self.serviceName) {
                return try! FTRequestObject.createModelData(json: data)
            }
        }
        return nil
    }

    func isValid() -> Bool {
        return (serviceRequet != nil)
    }

    func urlRequest() -> URLRequest {

        // Service App Base URL
        let baseURL = getBaseURL()

        // Create URL Components
        var components = URLComponents(string: baseURL)!

        // Update subPath url
        if let path = serviceRequet?.path {
            components.path.append(path)
        }

        // URL httpBody for POST type
        var httpBody: Data? = nil

        // Setup URL 'queryItems' or 'httpBody'
        if let type = serviceRequet?.type {
            switch type {
            case .GET:
                components.queryItems = self.getQueryItems()
                break
            case .POST:
                httpBody = inputStack?.jsonModelData()
                break
            default:
                break
            }
        }

        // Create URLRequest from 'components'
        var urlReq = URLRequest(url: components.url!)
        print("urlReq: ", urlReq.url?.absoluteString.removingPercentEncoding ?? "Empty")

        // Request 'type'
        urlReq.httpMethod = serviceRequet?.type.rawValue

        // Reqeust Body if any
        urlReq.httpBody = httpBody
        print("urlBody: ", httpBody?.decodeToString() ?? "Empty")

        // Request headers
        self.requestHeaders?.forEach({ (key,value) in
            urlReq.setValue(value, forHTTPHeaderField: key)
        })
        
        return urlReq
    }

    @discardableResult
    func responseModelStack() -> FTModelData? {
        guard self.data != nil else { return nil }
        responseStack = try? self.responseType.createModelData(json: self.data!)
        // print("jsonString:: ", responseStack?.jsonString() ?? "")
        print("rawData::",String(bytes: self.data!, encoding: .utf8) ?? "")
        return responseStack
    }

    static var i: Int = 0

    func sessionHandler() -> FTURLSessionCompletionBlock? {
        
        // guard completionHandler != nil else { return nil }

        let decodeHandler = { (data: Data?, response: URLResponse?, error: Error?) -> () in

            self.data = data
            self.error = error

            //Stub
            if FTMobileConfig.isMockData {
                return self.stubData()
            }
            //Stub

            //Decoded responseString
            self.resposneString = data?.decodeToString(forResponse: response)

            if let httpURLResponse = response as? HTTPURLResponse {
                self.resposne = httpURLResponse
                self.statusCode = httpURLResponse.statusCode
                self.buildResponseStack()
                DispatchQueue.main.async {
                    self.completionHandler?(FTSericeStatus.success(self, self.statusCode ?? 500))
                }
            } else {
                DispatchQueue.main.async {
                    self.completionHandler?(FTSericeStatus.failed(nil, self.statusCode ?? 500))
                }
            }

            return
        }
        
        return decodeHandler
    }
}

extension FTServiceStack1 {
    func buildResponseStack() {
        self.responseModelStack()
    }

    func stubData() {

        print(self.serviceName, ": is data stubbed.")
        if let data: String = FTMobileConfig.mockBundle?.path(forResource: self.serviceName, ofType: "json") {
            self.data = try! data.dataAtPath()
        }

        self.buildResponseStack()
        DispatchQueue.main.async {
            self.completionHandler!(FTSericeStatus.success(self, self.statusCode ?? 500))
        }
    }
}
