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
}

open class FTServiceStack: FTServiceStackProtocal {
    open func serviceName() -> String { return "" }
    open func responseType() -> FTModelData.Type { return FTModelData.self as! FTModelData.Type }

    fileprivate var serviceRequet: FTRequestObject? = nil
    fileprivate func serviceSchema() -> Bool {
        do {
            if
                serviceRequet == nil,
                let data = try! FTMobileConfig.schemaForClass(classKey: self.serviceName()) {
                self.serviceRequet = try! FTRequestObject.createModelData(json: data)
            }
        }
        return serviceRequet != nil
    }

    fileprivate var inputStack: FTModelData?
    fileprivate var responseStack: FTModelData?

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
        _ = self.serviceSchema() //= try FTMobileConfig.schemaForClass(classKey: self.serviceName)
    }

//    required public init(modelStack: FTModelData?, completionHandler: ((FTSericeStatus) -> Swift.Void)?) {
//        self.inputStack = modelStack
//        self.completionHandler = completionHandler
//
//        do {
//            _ = try self.serviceSchema() //= try FTMobileConfig.schemaForClass(classKey: self.serviceName)
//        } catch {
//            completionHandler?(FTSericeStatus.failed(self.responseStack, 500))
//        }
//    }

}

extension FTServiceStack {
    
    func isValid() -> Bool {
        return (self.serviceSchema())
    }
    
    func urlRequest() -> URLRequest {

        //Service App Base URL
        var baseURL = FTMobileConfig.isMockData ? FTMobileConfig.mockURL : FTMobileConfig.appBaseURL

        //If service has customeBase URL
        if ((serviceRequet?.baseURL) != nil) {
            baseURL = (serviceRequet?.baseURL)!
        }

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
                components.queryItems = inputStack?.queryItems()
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
        urlReq.httpMethod = serviceRequet?.type.rawValue
        urlReq.httpBody = httpBody
        
        return urlReq
    }
    
    func responseModelStack() -> FTModelData? {
        guard self.data != nil else { return nil }
        return try! self.responseType().createModelData(json: self.data!)
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
                print(self.responseModelStack() ?? "")
                DispatchQueue.main.async {
                    self.completionHandler!(FTSericeStatus.success(self.responseModelStack(), self.statusCode ?? 500))
                }
                return
            }
            //Stub

            if let httpURLResponse = response as? HTTPURLResponse {
                self.resposne = httpURLResponse
                self.statusCode = httpURLResponse.statusCode
                DispatchQueue.main.async {
                    self.completionHandler!(FTSericeStatus.success(self.responseModelStack(), self.statusCode ?? 500))
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
