//
//  FTMobileCoreTestClasses.swift
//  MobileCoreTests
//
//  Created by Praveen P on 12/10/19.
//  Copyright © 2019 Praveen Prabhakar. All rights reserved.
//

@testable import MobileCore
import Foundation

final class AccountDetail: FTServiceModel {
    var value: String = ""
    var name: String = ""
    
    init(value: String, name: String) {
        self.value = value
        self.name = name
    }
}

final class Account: FTServiceModel {
    var name: String = ""
    var type: AccountDetail?
    var data: [String] = []
    
    init(name: String, type: AccountDetail, data: [String]) {
        self.name = name
        self.type = type
        self.data = data
    }
}

final class TestService: FTServiceClient {
    var serviceName: String = "TestService"
    var request: FTReqeustType = .POST
    var inputStack: Account?
    var responseStack: AccountDetail?
    var responseStackType: Any?
    
    required init(inputStack: FTServiceModel?) {
        self.inputStack = inputStack as? Account
    }
}

final class TestDummyService: FTServiceClient {
    var responseStack: Account?
    var inputStack: Account?
    var responseStackType: Any?
    
    init(inputStack: FTServiceModel? = nil) {
        self.inputStack = inputStack as? Account
    }
    var serviceName: String = ""
    var request: FTReqeustType = .POST
}
