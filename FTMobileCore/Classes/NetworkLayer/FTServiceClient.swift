//
//  FTServiceClient.swift
//  FTMobileCore
//
//  Created by Praveen Prabhakar on 01/09/18.
//  Copyright © 2018 Praveen Prabhakar. All rights reserved.
//

import Foundation

// retruns ServcieResponse && Status
public typealias FTServiceCompletionBlock<T: FTServiceClient> = (FTServiceStatus<T>) -> Swift.Void

private enum FTLogConstants: String {
    case errorModel = "errorModelData: "
    case responseData = "ResponseData: "
    case error = "FTError: "
}

// MARK: FTAssociatedKey
private extension FTAssociatedKey {
    static var ServiceRequest = "ServiceRequest"
    static var ResponseData = "ResponseData"
    static var ModelData = "ModelData"
}

// MARK: Service Status
public enum FTServiceStatus<T: FTServiceClient>: Error {
    case success(T?, Int)
    case failed(T?, Int)

    public var status: (isSuccess: Bool, responseModel: FTServiceModel?) {
        switch self {
        case .success(let model, _):
            return (true, model?.responseStack)
        case .failed(let model, _):
            return (false, model?.responseStack)
        }
    }
}

// MARK: Service Rules
public protocol FTServiceRulesProtocol {
    func fireBefore()
    func fireBefore(urlRequest: inout URLRequest)
    func fireAfter(modelData: inout FTServiceModel?)
    func fireAfter(data: Data?, response: URLResponse?, error: Error?)
}

// MARK: Service Rules
public extension FTServiceRulesProtocol {
    func fireBefore() {}
    func fireBefore(urlRequest: inout URLRequest) {}
    func fireAfter(modelData: inout FTServiceModel?) {}
    func fireAfter(data: Data?, response: URLResponse?, error: Error?) {}
}

// MARK: Service Rules
public protocol FTServiceClient: FTServiceRulesProtocol {
    associatedtype InputDataType
    associatedtype OutputDataType

    var serviceName: String { get set }
    var requestHeaders: [String: String] { get }
    var inputStack: InputDataType? { get set }
    var responseStack: OutputDataType? { get }
    var responseStackType: Any? { get }

    init(inputStack: FTServiceModel?)

//    // progress closure. Progress is between 0 and 1.
//     var progressHandler:((Float) -> Void)?
// 
//    // download closure. the URL is the file URL where the temp file has been download.
//    // This closure will be called so you can move the file where you desire.
//     var downloadHandler:((FTServiceStatus, URL) -> Void)?
// 
//    // /This gets called on auth challenges. If nil, default handling is use.
//    // /Returning nil from this method will cause the request to be rejected and cancelled
//     var auth:((URLAuthenticationChallenge) -> URLCredential?)?
// 
//    // /This is for doing SSL pinning
//     var security: HTTPSecurity?
    
    func mockDataHandler(_ completionHandler: FTServiceCompletionBlock<Self>?) -> FTServiceModel?
    static func make(modelStack: FTServiceModel?, completionHandler: FTServiceCompletionBlock<Self>?)
}

public extension FTServiceClient {

    var requestHeaders: [String: String] {
        return [:]
    }

    var inputModelStack: InputDataType? {
        return self.inputStack
    }

    func isValid() -> Bool {
        return (serviceRequest != nil)
    }

    // MARK: Response Generation
    var responseString: String? {
        return  responseData?.base64EncodedString()
    }

    var responseData: Data? {
        return  FTAssociatedObject.getAssociated(self, key: &FTAssociatedKey.ResponseData)
    }

    var responseStack: FTServiceModel? {

        if let parsedModel: FTServiceModel = FTAssociatedObject.getAssociated(self, key: &FTAssociatedKey.ModelData) {
            return parsedModel
        }

        guard let data = self.responseData else {
            ftLog("responseData is nil")
            return nil
        }
        
        guard let dataModel = responseStackType as? FTServiceModel.Type,
            var responseModelData: FTServiceModel = try? dataModel.makeModel(json: data),
            !responseModelData.queryItems().isEmpty else {
                // Logging
                do {
                    ftLog("responseData: decodeToString: ", FTLogConstants.responseData.rawValue, data.decodeToString() ?? "")
                    let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                    ftLog("responseData: rawValue: ", FTLogConstants.responseData.rawValue, json)
                }
                catch {
                    ftLog(FTLogConstants.responseData.rawValue, error)
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
                ftLog(FTLogConstants.errorModel.rawValue, try ((responseStackType as? FTServiceModel.Type)?.makeModel(json: data)) ?? "")
            }

            if let errorModelData = try? FTErrorModel.makeModel(json: data),
                !errorModelData.queryItems().isEmpty {
                ftLog(FTLogConstants.errorModel.rawValue, errorModelData)
                responseModelData = errorModelData
            }
        }
        catch {
            ftLog(FTLogConstants.errorModel.rawValue, error)
        }

        // Save responseModelData to service
        FTAssociatedObject<FTServiceModel>.setAssociated(self, value: responseModelData, key: &FTAssociatedKey.ModelData)

        return responseModelData
    }

    // MARK: Stub
    func mockDataHandler(_ completionHandler: FTServiceCompletionBlock<Self>? = nil) -> FTServiceModel? {
        ftLog(self.serviceName, ": is data stubbed.")
        if
            let path: String = FTMobileConfig.mockBundle?.path(forResource: self.serviceName, ofType: "json"),
            let data = try? path.dataAtPath()
        {
            let model = self.processResponseData(data: data)
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(2)) {
               completionHandler?(FTServiceStatus.success(self, (model != nil) ? 200 : 500))
            }
            return model
        }

        return nil
    }

    // MARK: Service Call
    static func make(modelStack: FTServiceModel? = nil, completionHandler: FTServiceCompletionBlock<Self>? = nil) {
        let serviceStack = Self(inputStack: modelStack)
        guard let urlRequest = serviceStack.urlRequest() else {
            ftLog(FTLogConstants.error.rawValue, self, ": Unable to generate urlRequest.")
            return
        }
        FTURLSession.startDataTask(with: urlRequest, completionHandler: serviceStack.sessionHandler(completionHandler))
    }

    // MARK: Service Rules
    func fireBefore() {
        // Optional Protocol implementation: intentionally empty
    }

    func fireBefore(urlRequest: inout URLRequest) {
        // Optional Protocol implementation: intentionally empty
    }

    func fireAfter(modelData: inout FTServiceModel?) {
        // Optional Protocol implementation: intentionally empty
    }

    func fireAfter(data: Data?, response: URLResponse?, error: Error?) {
        // Optional Protocol implementation: intentionally empty
    }
}

private extension FTServiceClient {

    // MARK: Response Parsing
    func responseType() -> FTServiceModel.Type? {
        guard let (_, repsModelName) = serviceRequest?.responseType?.first else {
            return nil
        }
        return FTReflection.swiftClassTypeFromString(repsModelName) as? FTServiceModel.Type
    }

    @discardableResult
    func processResponseData(data: Data?) -> FTServiceModel? {
        FTAssociatedObject<Data>.setAssociated(self, value: data, key: &FTAssociatedKey.ResponseData)
        // Parse response model before-hand
        return self.responseStack
    }

    // MARK: URL Components
    func getBaseURL(_ requestObject: FTRequestObject? = nil) -> String {
        return requestObject?.baseURL ?? FTMobileConfig.appBaseURL
    }

    func getURLComponents(_ requestObject: FTRequestObject? = nil) -> URLComponents {

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

extension FTServiceClient {

    // MARK: Service Request
    var serviceRequest: FTRequestObject? {
        if let request: FTRequestObject = FTAssociatedObject.getAssociated(self, key: &FTAssociatedKey.ServiceRequest) {
            return request
        }
        do {
            if let data = try FTMobileConfig.schemaForClass(classKey: serviceName) {
                let request = try FTRequestObject.makeModel(json: data)
                if !request.queryItems().isEmpty {
                    FTAssociatedObject<FTRequestObject>.setAssociated(self, value: request, key: &FTAssociatedKey.ServiceRequest)
                }
                return request
            }
        }
        catch {
            ftLog(FTLogConstants.error.rawValue, error)
        }
        ftLog("serviceRequest: \(serviceName) is nil")
        return nil
    }

    func urlRequest() -> URLRequest? {

        guard let request = serviceRequest else {
            ftLog(FTLogConstants.error.rawValue, self, "`FTRequestObject` generation falied.")
            return nil
        }

        // Create URL Components
        var components = getURLComponents(request)

        // Service Rules
        self.fireBefore()

        // Setup URL 'queryItems' or 'httpBody'
        let reqstType = request.type
        if reqstType == .GET, let model = inputModelStack as? FTServiceModel {
            components.queryItems = model.queryItems()
        }

        // Create URLRequest from 'components'
        guard let url = components.url else {
            return nil
        }
        var urlReq = URLRequest(url: url)
        ftLog("\nCAServiceRequest: \(String(describing: self)): ", urlReq.url?.absoluteString.removingPercentEncoding ?? "Empty")

        // Request 'type'
        urlReq.httpMethod = request.type.stringValue()

        // Request headers
        self.requestHeaders.forEach { key, value in
            urlReq.setValue(value, forHTTPHeaderField: key)
        }

        // Reqeust Body if any
        if let model = inputModelStack as? FTServiceModel {
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
    func sessionHandler(_ completionHandler: FTServiceCompletionBlock<Self>? = nil) -> FTURLSessionCompletionBlock {

        // Log Resposne
        let logError = { (_ request: FTRequestObject?, _ error: Error?) in
            ftLog("\nFTServiceResponse: \(String(describing: self)): ", self.getURLComponents(request))
            if error != nil {
                ftLog("\nError response: ", error?.localizedDescription ?? "", "\n")
            }
        }
        // Parse Response
        let failure = { statusCode in
            DispatchQueue.main.async {
                completionHandler?(FTServiceStatus.failed(self, statusCode))
            }
        }
        // Parse Response
        let success = { statusCode in
            DispatchQueue.main.async {
                completionHandler?(FTServiceStatus.success(self, statusCode))
            }
        }

        let handler: FTURLSessionCompletionBlock = { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            let request = self.serviceRequest
            // Log Resposne
            logError(request, error)
            // Service Rules
            self.fireAfter(data: data, response: response, error: error)
            
            // Stub
            if FTMobileConfig.isMockData, self.mockDataHandler(completionHandler) != nil {
                return
            }
            // Stub

            // Decoded responseString
            var responseModelData: FTServiceModel? = self.processResponseData(data: data)
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
