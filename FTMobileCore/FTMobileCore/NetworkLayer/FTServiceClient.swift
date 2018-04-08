//
//  FTServiceClient.swift
//  FTMobileCore
//
//  Created by Praveen Prabhakar on 10/03/18.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

public enum FTSericeStatus: Error {
    case success(FTServiceStack, Int)
    case failed(FTServiceStack?, Int)
}

open class FTServiceClient {
    
    static var sessionConfiguration: URLSessionConfiguration = .ephemeral
    static var sessionDelegate: URLSessionDelegate? = nil

    static let sharedInstance = FTServiceClient()
    static var sessionQueue = OperationQueue()
    static var defaultSession = sharedInstance.createURLSession()

    open class func make(_ serviceName: String,
                         modelStack: FTModelData? = nil,
                         completionHandler: ((FTSericeStatus) -> Swift.Void)? = nil) {

        //get class.Type from serviceName string
        let className: FTServiceStack.Type? = FTReflection.swiftClassTypeFromString(serviceName) as? FTServiceStack.Type
        //Setup 'serviceStack' from class
        let serviceStack = className?.setup(modelStack: modelStack, completionHandler: completionHandler)

        //Make sure serviceStack is non-nil
        guard serviceStack != nil else {
            DispatchQueue.main.async() { completionHandler?(FTSericeStatus.failed(nil, 500)) }
            return
        }

        let operation:FTServiceStack = serviceStack!

        //Check if operation request is valid
        if  operation.isValid() {
            let task: URLSessionDataTask

            //Setup session-dataTask with completion handler
            if completionHandler != nil {
                task = defaultSession.dataTask(with: operation.urlRequest(),
                                               completionHandler: operation.sessionHandler()!)
            }else {
                task = defaultSession.dataTask(with: operation.urlRequest())
            }

            task.resume()
        }
        else {
            //Fails, if urlRequest was not generated.
            DispatchQueue.main.async() { completionHandler?(FTSericeStatus.failed(operation, 500)) }
        }

    }
    
    open class func getContentFromURL(_ string: String,
                                 completionHandler: @escaping (_ htmlString: String,_ data: Data, _ httpURLResponse: HTTPURLResponse) -> Swift.Void) {
        
        if string.hasPrefix("http") {
            
            let myURL = URL(string: string)
            
            self.getContentFromURL(myURL!, completionHandler: { (htmlString, data, httpURLResponse) in
                
                DispatchQueue.main.async() { completionHandler(htmlString, data, httpURLResponse) }
            })
            
            return
        }
        
        let html: String = try! String(contentsOfFile: string)
        DispatchQueue.main.async() { completionHandler(html, html.data(using: .utf8)!, HTTPURLResponse()) }
    }
    
    open class func getContentFromURL(_ url: URL,
                                             completionHandler: @escaping (String, Data, HTTPURLResponse) -> Swift.Void,
                                             encodingList: [String.Encoding] = [.utf8, .unicode] ) {
        
        let decodeData = { (data: Data, httpURLResponse: HTTPURLResponse) in
            
            var html: String? = ""
            
            //Try to decode the String
            for type in encodingList {
                html = String(bytes: data, encoding: type)
                if html != nil {
                    break
                }
            }
            
            //Send it main object
            DispatchQueue.main.async() { completionHandler(html ?? "", data, httpURLResponse) }
        }
        
        //Get content from Net
        defaultSession.dataTask(with: url) { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let data = data, error == nil
                else { return }
            
            decodeData(data, httpURLResponse)
            
            }.resume()
        
    }
}

extension FTServiceClient {
    func createURLSession() -> URLSession {
        return URLSession(configuration: FTServiceClient.sessionConfiguration,
                          delegate: FTServiceClient.sessionDelegate,
                          delegateQueue: FTServiceClient.sessionQueue)
    }
}

//extension FTServiceClient: URLSessionDelegate {
//
//}

