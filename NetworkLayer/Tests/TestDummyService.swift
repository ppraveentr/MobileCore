//
//  Service.swift
//  MobileCoreTests
//
//  Created by Praveen P on 12/10/19.
//  Copyright © 2019 Praveen Prabhakar. All rights reserved.
//

import Foundation
@testable import MobileCore

final class AccountDetail: ServiceModel {
    var value: String = ""
    var name: String = ""
    
    init(value: String, name: String) {
        self.value = value
        self.name = name
    }
}

final class Account: ServiceModel {
    var name: String = ""
    var type: AccountDetail?
    var data: [String] = []
    
    init(name: String, type: AccountDetail, data: [String]) {
        self.name = name
        self.type = type
        self.data = data
    }
}

final class TestService: ServiceClient {
    var serviceName: String = "TestService"
    var request: ReqeustType = .POST
    var inputStack: Account?
    var responseStack: AccountDetail?
    var responseStackType: Any?
    
    required init(inputStack: ServiceModel?) {
        self.inputStack = inputStack as? Account
    }
}

final class TestDummyService: ServiceClient {
    var responseStack: Account?
    var inputStack: Account?
    var responseStackType: Any?
    var serviceName: String = ""
    var request: ReqeustType = .POST
    
    init(inputStack: ServiceModel? = nil) {
        self.inputStack = inputStack as? Account
    }
}
