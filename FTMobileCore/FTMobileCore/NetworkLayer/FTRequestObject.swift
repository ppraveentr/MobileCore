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
public enum FTReqeustPathType: String, Codable {
    case GET
    case POST
    case PUT
    /* case HEAD
     case DELETE
     case PATCH
     case OPTIONS
     case TRACE
     case CONNECT
     */
    case UNKNOWN
}

final class FTRequestBase: FTModelData {
    var timeOut: Int?

//    /* Coding Keys */
//    enum CodingKeys: String, CodingKey  {
//        case timeOut
//    }
}

final class FTRequestObject: FTModelData {
    var type: FTReqeustPathType = .POST
    var path: String?
    var baseURL: String?
    var requestQuery: [String:String]?
    var request: [String:String]?
    var responseType: String?

//    /* Coding Keys */
//    enum CodingKeys: String, CodingKey  {
//        case type, path, baseURL, requestQuery, request //, response
//    }
}

