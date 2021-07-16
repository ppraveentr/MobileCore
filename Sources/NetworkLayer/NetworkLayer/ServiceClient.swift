//
//  ServiceClient.swift
//  FTMobileCore
//
//  Created by Praveen Prabhakar on 01/09/18.
//  Copyright © 2018 Praveen Prabhakar. All rights reserved.
//

import CoreUtility
import Foundation

// retruns ServcieResponse && Status
public typealias ServiceCompletionBlock<T: ServiceClient> = (ServiceStatus<T>) -> Swift.Void

private enum LogConstants: String {
    case errorModel = "errorModelData: "
    case responseData = "ResponseData: "
    case error = "FTError: "
}

// MARK: AssociatedKey
private extension AssociatedKey {
    static var ServiceRequest = "ServiceRequest"
    static var ResponseData = "ResponseData"
    static var ModelData = "ModelData"
}

// MARK: Service Status
public enum ServiceStatus<T: ServiceClient>: Error {
    case success(T?, Int)
    case failed(T?, Int)

    public var status: (isSuccess: Bool, responseModel: ServiceModel?) {
        switch self {
        case .success(let model, _):
            return (true, model?.responseStack)
        case .failed(let model, _):
            return (false, model?.responseStack)
        }
    }
}

// MARK: Service Rules
public protocol ServiceRulesProtocol {
    func fireBefore()
    func fireBefore(urlRequest: inout URLRequest)
    func fireAfter(modelData: inout ServiceModel?)
    func fireAfter(data: Data?, response: URLResponse?, error: Error?)
}

// MARK: Service Rules
public extension ServiceRulesProtocol {
    func fireBefore() {
        // Optional Protocol implementation: intentionally empty
    }
    func fireBefore(urlRequest: inout URLRequest) {
        // Optional Protocol implementation: intentionally empty
    }
    func fireAfter(modelData: inout ServiceModel?) {
        // Optional Protocol implementation: intentionally empty
    }
    func fireAfter(data: Data?, response: URLResponse?, error: Error?) {
        // Optional Protocol implementation: intentionally empty
    }
}

// MARK: Service Rules
public protocol ServiceClient: ServiceRulesProtocol {
    associatedtype InputDataType
    associatedtype OutputDataType

    var serviceName: String { get set }
    var requestHeaders: [String: String] { get }
    var inputStack: InputDataType? { get set }
    var responseStack: OutputDataType? { get }
    var responseStackType: Any? { get }

    init(inputStack: ServiceModel?)

//    // progress closure. Progress is between 0 and 1.
//     var progressHandler:((Float) -> Void)?
// 
//    // download closure. the URL is the file URL where the temp file has been download.
//    // This closure will be called so you can move the file where you desire.
//     var downloadHandler:((ServiceStatus, URL) -> Void)?
// 
//    // /This gets called on auth challenges. If nil, default handling is use.
//    // /Returning nil from this method will cause the request to be rejected and cancelled
//     var auth:((URLAuthenticationChallenge) -> URLCredential?)?
// 
//    // /This is for doing SSL pinning
//     var security: HTTPSecurity?
    
    static func make(modelStack: ServiceModel?, completionHandler: ServiceCompletionBlock<Self>?)
}

public extension ServiceClient {

    var requestHeaders: [String: String] {
        [:]
    }

    var inputModelStack: InputDataType? {
        self.inputStack
    }

    func isValid() -> Bool {
        (serviceRequest != nil)
    }

    // MARK: Response Generation
    var responseString: String? {
        responseData?.base64EncodedString()
    }

    var responseData: Data? {
        AssociatedObject.getAssociated(self, key: &AssociatedKey.ResponseData)
    }

    var responseStack: ServiceModel? {

        if let parsedModel: ServiceModel = AssociatedObject.getAssociated(self, key: &AssociatedKey.ModelData) {
            return parsedModel
        }

        guard let data = self.responseData else {
            ftLog("responseData is nil")
            return nil
        }
        
        guard let dataModel = responseStackType as? ServiceModel.Type,
            var responseModelData: ServiceModel = try? dataModel.makeModel(json: data),
            !responseModelData.queryItems().isEmpty else {
                // Logging
                do {
                    ftLog("responseData: decodeToString: ", LogConstants.responseData.rawValue, data.decodeToString() ?? "")
                    let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                    ftLog("responseData: rawValue: ", LogConstants.responseData.rawValue, json)
                }
                catch {
                    ftLog(LogConstants.responseData.rawValue, error)
                }
                // Logging
                return nil
        }
        
        do {
            // try parsing response model: configured by `FTServiceClient` model
            if let responseStack = try self.responseType()?.makeModel(json: data) {
                responseModelData = responseStack
            }
                // Log error message
            else {
                ftLog(LogConstants.errorModel.rawValue, try ((responseStackType as? ServiceModel.Type)?.makeModel(json: data)) ?? "")
            }

            if let errorModelData = try? ErrorModel.makeModel(json: data),
                !errorModelData.queryItems().isEmpty {
                ftLog(LogConstants.errorModel.rawValue, errorModelData)
                responseModelData = errorModelData
            }
        }
        catch {
            ftLog(LogConstants.errorModel.rawValue, error)
        }

        // Save responseModelData to service
        AssociatedObject<ServiceModel>.setAssociated(self, value: responseModelData, key: &AssociatedKey.ModelData)

        return responseModelData
    }

    // MARK: Service Call
    static func make(modelStack: ServiceModel? = nil, completionHandler: ServiceCompletionBlock<Self>? = nil) {
        let serviceStack = Self(inputStack: modelStack)
        guard let urlRequest = serviceStack.urlRequest() else {
            ftLog(LogConstants.error.rawValue, self, ": Unable to generate urlRequest.")
            return
        }
        URLSessionManager.startDataTask(with: urlRequest, completionHandler: serviceStack.sessionHandler(completionHandler))
    }
}

private extension ServiceClient {

    // MARK: Response Parsing
    func responseType() -> ServiceModel.Type? {
        guard let (_, repsModelName) = serviceRequest?.responseType?.first else {
            return nil
        }
        return Reflection.swiftClassTypeFromString(repsModelName) as? ServiceModel.Type
    }

    @discardableResult
    func processResponseData(data: Data?) -> ServiceModel? {
        AssociatedObject<Data>.setAssociated(self, value: data, key: &AssociatedKey.ResponseData)
        // Parse response model before-hand
        return self.responseStack
    }

    // MARK: URL Components
    func getBaseURL(_ requestObject: RequestObject? = nil) -> String {
        requestObject?.baseURL ?? NetworkMananger.appBaseURL
    }

    func getURLComponents(_ requestObject: RequestObject? = nil) -> URLComponents {

        // Service App Base URL
        let baseURL = getBaseURL(requestObject)
        // Create URL Components
        var components = URLComponents(string: baseURL)

        // Update subPath url
        if var path = requestObject?.path {
            // Remove extra "/"
            if baseURL.hasSuffix("/") && path.hasPrefix("/") {
                path.trimPrefix("/")
            }
                // Add missing "/"
            else if !baseURL.hasSuffix("/") && !path.hasPrefix("/") {
                path = "/" + path
            }
            components?.path.append(path)
        }

        return components ?? URLComponents()
    }
}

extension ServiceClient {

    // MARK: Service Request
    var serviceRequest: RequestObject? {
        if let request: RequestObject = AssociatedObject.getAssociated(self, key: &AssociatedKey.ServiceRequest) {
            return request
        }
        do {
            if let data = try NetworkMananger.schemaForClass(classKey: serviceName) {
                let request = try RequestObject.makeModel(json: data)
                if !request.queryItems().isEmpty {
                    AssociatedObject<RequestObject>.setAssociated(self, value: request, key: &AssociatedKey.ServiceRequest)
                }
                return request
            }
        }
        catch {
            ftLog(LogConstants.error.rawValue, error)
        }
        ftLog("serviceRequest: \(serviceName) is nil")
        return nil
    }

    func urlRequest() -> URLRequest? {

        guard let request = serviceRequest else {
            ftLog(LogConstants.error.rawValue, self, "`RequestObject` generation falied.")
            return nil
        }

        // Create URL Components
        var components = getURLComponents(request)

        // Service Rules
        self.fireBefore()

        // Setup URL 'queryItems' or 'httpBody'
        let reqstType = request.type
        if reqstType == .GET, let model = inputModelStack as? ServiceModel {
            components.queryItems = model.queryItems()
        }

        // Create URLRequest from 'components'
        guard let url = components.url else {
            return nil
        }
        var urlReq = URLRequest(url: url)
        ftLog("\nServiceRequest: \(String(describing: self)): ", urlReq.url?.absoluteString.removingPercentEncoding ?? "Empty")

        // Request 'type'
        urlReq.httpMethod = request.type.stringValue()

        // Request headers
        self.requestHeaders.forEach { key, value in
            urlReq.setValue(value, forHTTPHeaderField: key)
        }

        // Reqeust Body if any
        if let model = inputModelStack as? ServiceModel {
            urlReq.httpBody = reqstType.requestBody(model: model)
        }
        ftLog("RequestBody: ", urlReq.httpBody?.decodeToString() ?? "Empty")

        // Service Rules
        self.fireBefore(urlRequest: &urlReq)

        // Log Request headers
        ftLog("RequestHeaders: ", urlReq.allHTTPHeaderFields ?? "")

        return urlReq
    }

    // MARK: Response Handler
    func sessionHandler(_ completionHandler: ServiceCompletionBlock<Self>? = nil) -> URLSessionCompletionBlock {

        // Log Resposne
        let logError = { (_ request: RequestObject?, _ error: Error?) in
            ftLog("\nServiceResponse: \(String(describing: self)): ", self.getURLComponents(request))
            if error != nil {
                ftLog("\nError response: ", error?.localizedDescription ?? "", "\n")
            }
        }
        // Parse Response
        let failure = { statusCode in
            DispatchQueue.main.async {
                completionHandler?(ServiceStatus.failed(self, statusCode))
            }
        }
        // Parse Response
        let success = { statusCode in
            DispatchQueue.main.async {
                completionHandler?(ServiceStatus.success(self, statusCode))
            }
        }

        let handler: URLSessionCompletionBlock = { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            let request = self.serviceRequest
            // Log Resposne
            logError(request, error)
            // Service Rules
            self.fireAfter(data: data, response: response, error: error)
            
            // Stub
            if NetworkMananger.isMockData, self.mockDataHandler(completionHandler) != nil {
                return
            }
            // Stub

            // Decoded responseString
            var responseModelData: ServiceModel? = self.processResponseData(data: data)
            // ftLog("ResponseModel: ", responseModelData?.jsonModel()?.description ?? "Response ModelData is nil")

            // Service Rules
            self.fireAfter(modelData: &responseModelData)

            if let httpURLResponse = response as? HTTPURLResponse {
                let statusCode = httpURLResponse.statusCode
                ftLog("ResponseStatus: ", statusCode, "\n")
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

// MARK: Mock Service
public protocol MockServiceRulesProtocol: ServiceClient {
    func mockDataHandler(_ completionHandler: ServiceCompletionBlock<Self>?) -> ServiceModel?
}

extension ServiceClient {
    // MARK: Stub
    func mockDataHandler(_ completionHandler: ServiceCompletionBlock<Self>? = nil) -> ServiceModel? {
        ftLog(self.serviceName, ": is data stubbed.")
        if
            let path: String = NetworkMananger.mockBundle?.path(forResource: self.serviceName, ofType: "json"),
            let data = try? path.dataAtPath()
        {
            let model = self.processResponseData(data: data)
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(2)) {
                completionHandler?(ServiceStatus.success(self, (model != nil) ? 200 : 500))
            }
            return model
        }
        
        return nil
    }
}
