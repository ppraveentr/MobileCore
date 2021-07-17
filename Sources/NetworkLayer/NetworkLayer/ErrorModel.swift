//
//  ErrorModel.swift
//  MobileCore-NetworkLayer
//
//  Created by Praveen Prabhakar on 28/09/18.
//  Copyright © 2018 Praveen Prabhakar. All rights reserved.
//

import Foundation

open class ErrorModel: ServiceModel {
    public var code: String?
    public var name: String?
    public var message: String?
    public var status: String?

    public var error: String?
    public var errorDescription: String?
}
