//
//  FTRequestObject.swift
//  FTMobileCore
//
//  Created by Praveen Prabhakar on 14/03/18.
//  Copyright © 2018 Praveen Prabhakar. All rights reserved.
//

import Foundation

/**
 The standard HTTP Verbs
 */
public enum FTReqeustType: String, Codable {
    case GET
    case POST
    case PUT
    case FORM
    /* case HEAD
     case DELETE
     case PATCH
     case OPTIONS
     case TRACE
     case CONNECT
     */
    case UNKNOWN

    func stringValue() -> String {
        if self == .FORM {
            return FTReqeustType.POST.rawValue
        }
        return self.rawValue
    }

    func requestBody(model: FTServiceModel?) -> Data? {
        guard let model = model else {
            return nil
        }
        
        switch self {
        case .POST:
            return model.jsonModelData()
        case .FORM:
            return model.formData()
        default:
            break
        }
        return nil
    }
}

final class FTRequestBase: FTServiceModel {
    var timeOut: Int?
}

final class FTRequestObject: FTServiceModel {
    var type: FTReqeustType = .POST
    var path: String?
    var baseURL: String?
    var requestQuery: [String: String]?
    var request: [String: String]?
    var responseType: [String: String]?
}
