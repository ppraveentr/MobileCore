//
//  FTServiceClient.swift
//  FTMobileCore
//
//  Created by Praveen Prabhakar on 01/09/18.
//  Copyright © 2018 Praveen Prabhakar. All rights reserved.
//

import Foundation

// retruns ServcieResponse && Status
public typealias FTServiceCompletionBlock<T: FTServiceClient> = (FTSericeStatus<T>) -> Swift.Void

public enum FTSericeStatus<T: FTServiceClient>: Error {
    case success(T?, Int)
    case failed(T?, Int)

    public var status: (isSuccess: Bool, responseModel: FTServiceModel?) {
        get {
            switch self {
            case .success(let model, _):
                let dataModel = model?.responseModel()
                return (true, dataModel)
            case .failed(let model, _):
                let dataModel = model?.responseModel()
                return (false, dataModel)
            }
        }
    }
    
}

public protocol FTServiceRulesProtocol {
    static func configure(requestHeaders urlRequest: URLRequest)
}

public protocol FTServiceClient {
    associatedtype InputDataType
    associatedtype OutputDataType

    var serviceName: String { get set }
    func requestHeaders() -> [String:String]

    var inputStack: InputDataType? { get set }
    var responseStack: OutputDataType? { get }

    var responseModelType: Any? { get }

    //    // progress closure. Progress is between 0 and 1.
    //     var progressHandler:((Float) -> Void)?
    // 
    //    // download closure. the URL is the file URL where the temp file has been download.
    //    // This closure will be called so you can move the file where you desire.
    //     var downloadHandler:((FTSericeStatus, URL) -> Void)?
    // 
    //    // /This gets called on auth challenges. If nil, default handling is use.
    //    // /Returning nil from this method will cause the request to be rejected and cancelled
    //     var auth:((URLAuthenticationChallenge) -> URLCredential?)?
    // 
    //    // /This is for doing SSL pinning
    //     var security: HTTPSecurity?
    
    func mockDataHandler(_ completionHandler: FTServiceCompletionBlock<Self>?) -> FTServiceModel?
    init(inputStack: FTServiceModel?)

    static func make(modelStack: FTServiceModel?, completionHandler: FTServiceCompletionBlock<Self>?)

    // Service Rules
    func fireBefore()
    func fireBefore(urlRequest: inout URLRequest)
    func fireAfter(modelData: inout FTServiceModel?)
    func fireAfter(data: Data?, response: URLResponse?, error: Error?)
}


public extension FTServiceClient {
    var serviceName: String { return "" }

    func requestHeaders() -> [String:String] { return [:] }

    public var inputStack: FTServiceModel? { return nil }

    public var responseStack: FTServiceModel? { return nil }

    func isValid() -> Bool {
        return (serviceRequest() != nil)
    }

    // MARK: Response Generation
    private func responseType() -> FTServiceModel.Type? {
        let request = serviceRequest()
        if let (repsType,repsModelName) = request?.responseType?.first {
            print(repsType)
            return FTReflection.swiftClassTypeFromString(repsModelName) as? FTServiceModel.Type
        }
        return nil
    }


    var responseString: String? {
        get {
            return  responseData?.base64EncodedString()
        }
    }

    var responseData: Data? {
        get {
            return  FTAssociatedObject<Data>.getAssociated(instance: self)
        }
    }

    @discardableResult
    func responseModel() -> FTServiceModel? {

        if let parsedModel: FTServiceModel = FTAssociatedObject.getAssociated(instance: self) {
            return parsedModel
        }

        guard let data = self.responseData else { return nil }

        var responseModelData: FTServiceModel?
        do {
            if let dataModel = responseModelType as? FTServiceModel.Type, let model: FTServiceModel = try? dataModel.makeModel(json: data), model.queryItems().count != 0 {
                responseModelData = model
            }
            // try parsing actual response model
            else if responseModelData?.queryItems().count == 0, let responseStack = try self.responseType()?.makeModel(json: data) {
                responseModelData = responseStack
            }
            if responseModelData?.queryItems().count == 0, let errorModelData = try? FTErrorModel.makeModel(json: data), errorModelData.queryItems().count != 0 {
                print("errorModelData: ", errorModelData)
                responseModelData = errorModelData
            }
        } catch {
            print("errorModelData: ", error)
        }

        if responseModelData != nil {
            FTAssociatedObject<FTServiceModel>.setAssociated(instance: self, value: responseModelData)
        }

        // Logging
        if responseModelData == nil || responseModelData?.queryItems().count == 0 {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                print("ResponseData: ", json)
                dump(json)
            } catch {
                print("ResponseData: ", error)
            }
            print("ResponseData: ",data.decodeToString() ?? "")
        }
        // Logging

        return responseModelData
    }

    // MARK: Stub
    func mockDataHandler(_ completionHandler: FTServiceCompletionBlock<Self>? = nil) -> FTServiceModel? {

        print(self.serviceName, ": is data stubbed.")
        if let path: String = FTMobileConfig.mockBundle?.path(forResource: self.serviceName, ofType: "json") {
            let data = try! path.dataAtPath()

            let model = self.updateData(data: data)

            DispatchQueue.main.async {
                completionHandler?(FTSericeStatus.success(self, (model != nil) ? 200 : 500))
            }

            return model
        }

        return nil
    }

    // MARK: Service Call
    static public func make(modelStack: FTServiceModel? = nil, completionHandler: FTServiceCompletionBlock<Self>? = nil) {
        let serviceStack = Self.self.init(inputStack: modelStack)
        FTURLSession.startDataTask(with: serviceStack.urlRequest(), completionHandler: serviceStack.sessionHandler(completionHandler))
    }

    // Service Rules
    func fireBefore() {
    }

    func fireBefore(urlRequest: inout URLRequest) {
    }

    func fireAfter(modelData: inout FTServiceModel?) {
    }

    func fireAfter(data: Data?, response: URLResponse?, error: Error?) {
    }
}

extension FTServiceClient {

    @discardableResult
    private func updateData(data: Data?) -> FTServiceModel? {
        if let data = data {
            print("rawData::",String(bytes: data, encoding: .utf8) ?? "")
        }

        FTAssociatedObject<Data>.setAssociated(instance: self, value: data)
        return self.responseModel()
    }

    func serviceRequest() -> FTRequestObject? {
        do {
            if let data = try FTMobileConfig.schemaForClass(classKey: serviceName) {
                return try FTRequestObject.makeModel(json: data)
            }
        } catch {
            print(error)
        }
        print("serviceRequest: \(serviceName) is nil")
        return nil
    }

    func getBaseURL(_ requestObject: FTRequestObject? = nil) -> String {
        return requestObject?.baseURL ?? FTMobileConfig.appBaseURL
    }

    fileprivate func getURLComponents(_ requestObject: FTRequestObject? = nil) -> URLComponents {

        //Service App Base URL
        let baseURL = getBaseURL(requestObject)

        //Create URL Components
        var components = URLComponents(string: baseURL)!

        //Update subPath url
        if var path = requestObject?.path {

            //Remove extra "/"
            if baseURL.hasSuffix("/") && path.hasPrefix("/") {
                path.trimPrefix("/")
            }
                //Add missing "/"
            else if !baseURL.hasSuffix("/") && !path.hasPrefix("/") {
                path = "/" + path
            }

            components.path.append(path)
        }
        
        return components
    }

    func urlRequest() -> URLRequest {

        let request = serviceRequest()

        // Create URL Components
        var components = getURLComponents(request)

        // URL httpBody for POST type
        var httpBody: Data? = nil

        //Service Rules
        self.fireBefore()

        //Create URLRequest from 'components'
        var urlReq = URLRequest(url: components.url!)
        print("\nCAServiceRequest: \(String(describing: self)): ", urlReq.url?.absoluteString.removingPercentEncoding ?? "Empty")

        // Setup URL 'queryItems' or 'httpBody'
        if let reqstType = request?.type {
            switch reqstType {
            case .GET:
                components.queryItems = inputStack?.queryItems()
            case .POST:
                httpBody = inputStack?.jsonModelData()
            case .FORM:
                httpBody = inputStack?.formData()
                print(httpBody ?? "Form Data empty")
            default:
                break
            }
        }

        // Request 'type'
        urlReq.httpMethod = request?.type.stringValue()

        // Request headers
        self.requestHeaders().forEach { (key,value) in
            urlReq.setValue(value, forHTTPHeaderField: key)
        }

        // Reqeust Body if any
        urlReq.httpBody = httpBody
        print("RequestBody: ", httpBody?.decodeToString() ?? "Empty")

        // Service Rules
        self.fireBefore(urlRequest: &urlReq)

        // Log Request headers
        print("RequestHeaders: ",urlReq.allHTTPHeaderFields ?? "")

        return urlReq
    }

    func sessionHandler(_ completionHandler: FTServiceCompletionBlock<Self>? = nil) -> FTURLSessionCompletionBlock {

        // guard completionHandler != nil else { return nil }

        let handler: FTURLSessionCompletionBlock = { (data: Data?, response: URLResponse?, error: Error?) -> () in

            let request = self.serviceRequest()

            // Log Resposne
            print("\nFTServiceResponse: \(String(describing: self)): ", self.getURLComponents(request))
            if error != nil {
                print("\nError response: ", error?.localizedDescription ?? "", "\n")
            }

            // Service Rules
            self.fireAfter(data: data, response: response, error: error)

            // Stub
            if FTMobileConfig.isMockData, let _ = self.mockDataHandler() {
                return
            }
            // Stub

            // Decoded responseString
            var responseModelData: FTServiceModel? = self.updateData(data: data)
            print("ResponseModel: ", responseModelData?.jsonModel() ?? "Response ModelData is nil")

            // Parse Response
            let failure = { (statusCode) in
                DispatchQueue.main.async {
                    completionHandler?(FTSericeStatus.failed(self, statusCode))
                }
            }

            // Parse Response
            let success = { (statusCode) in
                DispatchQueue.main.async {
                    completionHandler?(FTSericeStatus.success(self, statusCode))
                }
            }

            // Service Rules
            self.fireAfter(modelData: &responseModelData)

            if let httpURLResponse = response as? HTTPURLResponse {
                let statusCode = httpURLResponse.statusCode
                print("ResponseStatus: ", statusCode, "\n")

                if statusCode > 400 {
                    failure(statusCode)
                    return
                }

                success(statusCode)
                return
            }

            failure(500)
        }

        return handler
    }
    
}
