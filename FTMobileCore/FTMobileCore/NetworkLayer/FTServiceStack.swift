//
//  FTServiceStack.swift
//  FTMobileCore
//
//  Created by Praveen Prabhakar on 12/03/18.
//  Copyright © 2018 Praveen Prabhakar. All rights reserved.
//

import Foundation

public protocol FTServiceStackProtocal {
    func serviceName() -> String
    func responseType() -> FTModelData.Type
    static func setup(modelStack: FTModelData?, completionHandler: ((FTSericeStatus) -> Swift.Void)?) -> Self
}

public protocol FTServiceRulesProtocal {
    static func configure(requestHeaders urlRequest: URLRequest)
}

open class FTServiceStack: FTServiceStackProtocal {

    open func serviceName() -> String { return "" }
    open func responseType() -> FTModelData.Type { return FTModelData.self as! FTModelData.Type }

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

    required public init(modelStack: FTModelData?, completionHandler: ((FTSericeStatus) -> Swift.Void)?) {
        self.inputStack = modelStack
        self.completionHandler = completionHandler
    }

    public static func setup(modelStack: FTModelData?, completionHandler: ((FTSericeStatus) -> Swift.Void)?) -> Self {
        return self.init(modelStack: modelStack, completionHandler: completionHandler)
    }
}

fileprivate extension FTServiceStack {

    //Service Base URL
    func getBaseURL() -> String {

        //Service App Base URL
        var baseURL = FTMobileConfig.isMockData ? FTMobileConfig.mockURL : FTMobileConfig.appBaseURL

        //If service has customeBase URL
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

extension FTServiceStack {

    func setupServiceRequest() -> FTRequestObject? {
        do {
            if
                let data = try! FTMobileConfig.schemaForClass(classKey: self.serviceName()) {
                serviceRequet = try! FTRequestObject.createModelData(json: data)
            }
        }
        return serviceRequet
    }

    func isValid() -> Bool {
        return (serviceRequet != nil)
    }

    func urlRequest() -> URLRequest {

        //Service App Base URL
        let baseURL = getBaseURL()

        //Create URL Components
        var components = URLComponents(string: baseURL)!

        //Update subPath url
        if let path = serviceRequet?.path {
            components.path.append(path)
        }

        //URL httpBody for POST type
        var httpBody: Data? = nil

        //Setup URL 'queryItems' or 'httpBody'
        if let type = serviceRequet?.type {
            switch type {
            case .GET:
                components.queryItems = self.getQueryItems()
                break
            case .POST:
                httpBody = try! inputStack?.jsonModelData()
                break
            default:
                break
            }
        }

        //Create URLRequest from 'components'
        var urlReq = URLRequest(url: components.url!)
        print("urlReq: ", urlReq.url?.absoluteString.removingPercentEncoding ?? "Empty")

        //Request 'type'
        urlReq.httpMethod = serviceRequet?.type.rawValue

        //Reqeust Body if any
        urlReq.httpBody = httpBody
        if let bodyData = httpBody {
            print("urlBody: ", String(bytes: bodyData, encoding: .utf8) ?? "Empty")
        }

        //Request headers
        self.requestHeaders?.forEach({ (key,value) in
            urlReq.setValue(value, forHTTPHeaderField: key)
        })

        
        return urlReq
    }
    
    func responseModelStack() -> FTModelData? {

        guard self.data != nil else { return nil }
        responseStack = try! self.responseType().createModelData(json: self.data!)

        return responseStack
    }

    static var i: Int = 0

    func sessionHandler() -> ((Data?, URLResponse?, Error?) -> ())? {
        
        guard completionHandler != nil else { return nil }
        
        let decodeHandler = { (data: Data?, response: URLResponse?, error: Error?) -> () in

            self.data = data
            self.error = error

            //Stub
            if FTMobileConfig.isMockData {
                let stubData = ["state": "completed", "page":"1", "totalItems": "\(FTServiceStack.i, +100)", "type": "topview", "category": "all"]
                FTServiceStack.i += 2
                self.data = stubData.jsonModelData()
                self.setupResponseStack()
                DispatchQueue.main.async {
                    self.completionHandler!(FTSericeStatus.success(self, self.statusCode ?? 500))
                }
                return
            }
            //Stub

            if let httpURLResponse = response as? HTTPURLResponse {
                self.resposne = httpURLResponse
                self.statusCode = httpURLResponse.statusCode
                self.setupResponseStack()
                DispatchQueue.main.async {
                    self.completionHandler!(FTSericeStatus.success(self, self.statusCode ?? 500))
                }
            }else {
                DispatchQueue.main.async {
                    self.completionHandler!(FTSericeStatus.failed(nil, self.statusCode ?? 500))
                }
            }

            return
        }
        
        return decodeHandler
    }
}

extension FTServiceStack {
    func setupResponseStack() {
        responseStack = try! self.responseType().createModelData(json: self.data!)
        print(responseStack?.jsonString() ?? "")
    }
}
