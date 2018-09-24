//
//  FTServiceClient.swift
//  FTMobileCore
//
//  Created by Praveen Prabhakar on 01/09/18.
//  Copyright © 2018 Praveen Prabhakar. All rights reserved.
//

import Foundation

public typealias FTServiceCompletionBlock<T: FTServiceClient> = (FTSericeStatus<T>) -> Swift.Void

public enum FTSericeStatus<T: FTServiceClient>: Error {
    case success(T?, Int)
    case failed(T?, Int)
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
    
    func stubData() -> FTModelData?
    init(inputStack: FTModelData?)
}


public extension FTServiceClient {
    var serviceName: String { return "" }
    func requestHeaders() -> [String:String] { return [:] }

    public var inputStack: FTModelData? { return nil }
    public var responseStack: FTModelData? { return nil }

    func isValid() -> Bool {
        return (setupServiceRequest() != nil)
    }

    //MARK: Response Generation
    func responseType() -> FTModelData.Type? {
        let serviceRequest = setupServiceRequest()
        if let repsType = serviceRequest?.responseType {
            return FTReflection.swiftClassTypeFromString(repsType) as? FTModelData.Type
        }
        return nil
    }


    var responseString: String? {
        get { return  responseData?.base64EncodedString() }
    }

    var responseData: Data? {
        get { return  FTAssociatedObject<Data>.getAssociated(instance: self) }
    }

    @discardableResult
    func responseModelStack() -> FTModelData? {
        guard let data = self.responseData else { return nil }
        let responseStack: FTModelData? = try! self.responseType()?.createModelData(json: data)
        //print("jsonString:: ", responseStack?.jsonString() ?? "")
        print("rawData::",String(bytes: data, encoding: .utf8) ?? "")
        return responseStack
    }

    //MARK: Stub
    func stubData() -> FTModelData? { return nil }

    //MARK: Service Call
    static public func make(modelStack: FTModelData? = nil, completionHandler: FTServiceCompletionBlock<Self>? = nil) {
        let serviceStack = Self.self.init(inputStack: modelStack)
        FTURLSession.startDataTask(with: serviceStack.urlRequest(), completionHandler: serviceStack.sessionHandler(completionHandler))
    }
}

extension FTServiceClient {

    private func updateData(data: Data?)  {
        FTAssociatedObject<Data>.setAssociated(instance: self, value: data)
    }

    func setupServiceRequest() -> FTRequestObject? {
        do {
            if let data = try! FTMobileConfig.schemaForClass(classKey: serviceName) {
                return try! FTRequestObject.createModelData(json: data)
            }
        }
        return nil
    }

    func getBaseURL(_ requestObject: FTRequestObject? = nil) -> String {
        return requestObject?.baseURL ?? FTMobileConfig.appBaseURL
    }

    func urlRequest() -> URLRequest {

        let serviceRequest = setupServiceRequest()

//        if let repsType = serviceRequest?.responseType {
//            responseType = FTReflection.swiftClassTypeFromString(repsType) as? FTModelData.Type
//        }

        //Service App Base URL
        let baseURL = getBaseURL(serviceRequest)

        //Create URL Components
        var components = URLComponents(string: baseURL)!

        //Update subPath url
        if let path = serviceRequest?.path {
            components.path.append(path)
        }

        //URL httpBody for POST type
        var httpBody: Data? = nil

        //Setup URL 'queryItems' or 'httpBody'
        if let reqstType = serviceRequest?.type {
            switch reqstType {
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

        //Create URLRequest from 'components'
        var urlReq = URLRequest(url: components.url!)
        print("urlReq: ", urlReq.url?.absoluteString.removingPercentEncoding ?? "Empty")

        //Request 'type'
        urlReq.httpMethod = serviceRequest?.type.rawValue

        //Reqeust Body if any
        urlReq.httpBody = httpBody
        print("urlBody: ", httpBody?.decodeToString() ?? "Empty")

        //Request headers
        self.requestHeaders().forEach({ (key,value) in
            urlReq.setValue(value, forHTTPHeaderField: key)
        })

        return urlReq
    }

    func getQueryItems() -> [URLQueryItem]? {
        let querys = inputStack?.queryItems()
        return querys
    }

//    @discardableResult
//    func responseModelStack() -> FTModelData? {
//        guard self.data != nil else { return nil }
//        responseStack = try? self.responseType.createModelData(json: self.data!)
//        //print("jsonString:: ", responseStack?.jsonString() ?? "")
//        print("rawData::",String(bytes: self.data!, encoding: .utf8) ?? "")
//        return responseStack
//    }

    func sessionHandler(_ completionHandler: FTServiceCompletionBlock<Self>? = nil) -> FTURLSessionCompletionBlock {

        //guard completionHandler != nil else { return nil }

        let handler: FTURLSessionCompletionBlock = { (data: Data?, response: URLResponse?, error: Error?) -> () in

            //Stub
            if FTMobileConfig.isMockData, let _ = self.stubData() {
                return
            }
            //Stub

            let failure = { (statusCode) in
                DispatchQueue.main.async {
                    completionHandler?(FTSericeStatus.failed(self, statusCode))
                }
            }

            //Update data
            self.updateData(data: data)

            //Decoded responseString
            var resposneString: FTModelData? = nil
            if let data = data {
                do {

                resposneString = try self.responseType()?.createModelData(json: data)
                print(resposneString ?? "Empty Rsposnse")
                }
                catch {
                    failure(500)
                    return
                }
            }

            if let httpURLResponse = response as? HTTPURLResponse {
                let statusCode = httpURLResponse.statusCode

                switch statusCode {
                case 400...:
                    failure(500)
                    return
                default:
                   break
                }

                DispatchQueue.main.async {
                    completionHandler?(FTSericeStatus.success(self, statusCode))
                }
                return
            }

            failure(500)
        }

        return handler
    }
}
