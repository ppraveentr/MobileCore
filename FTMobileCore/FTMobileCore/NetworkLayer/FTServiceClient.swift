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

    static let sharedInstance = FTServiceClient()

    open class func make(_ serviceName: String, modelStack: FTModelData? = nil,
                         completionHandler: FTServiceCompletionBlock? = nil) {
        //get class.Type from serviceName string
        let className: FTServiceStack.Type? = FTReflection.swiftClassTypeFromString(serviceName) as? FTServiceStack.Type

        //Make sure serviceStack is non-nil
        guard let operation = className else {
            DispatchQueue.main.async() { completionHandler?(FTSericeStatus.failed(nil, 500)) }
            return
        }

        self.make(operation, modelStack: modelStack, completionHandler: completionHandler)
    }

    open class func make(_ serviceName: FTServiceStack.Type, modelStack: FTModelData? = nil,
                         completionHandler: FTServiceCompletionBlock? = nil) {

        //Setup 'serviceStack'
        let serviceStack = serviceName.setup(modelStack: modelStack, completionHandler: completionHandler)

        //Check if operation request is valid
        if  serviceStack.isValid() {
            //Setup session-dataTask with serviceStack
            FTURLSession.startDataTask(with: serviceStack)
        }
        else {
            //Fails, if urlRequest was not generated.
            DispatchQueue.main.async() { completionHandler?(FTSericeStatus.failed(serviceStack, 500)) }
        }
    }
}

