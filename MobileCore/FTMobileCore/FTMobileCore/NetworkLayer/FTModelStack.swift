//
//  FTModelStack.swift
//  FTMobileCore
//
//  Created by Praveen Prabhakar on 15/06/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation

//open class FTModelStack {
//    
//    fileprivate var serviceName: String?
//    
//    open var _modelStack: [FTModelData] = []
//    
//    /// The header values in HTTP response.
//    open var requestHeaders: Dictionary<String,String>?
//    open var responseHeaders: Dictionary<String,String>?
//    
//    /// The mime type of the HTTP response.
//    fileprivate var mimeType: String?
//    
//    /// The body data of the HTTP response.
//    open var data: Data?
//    
//    /// The status code of the HTTP response.
//    open var statusCode: Int?
//    /// The URL of the HTTP response.
//    open var URL: Foundation.URL?
//    
//    /// The Error of the HTTP response (if there was one).
//    open var error: Error?
//    
//    ///Returns the response as a string
//    open var responseString: String?
//    
//    public func addModelData(_ data: FTModelData) {
//        _modelStack.append(data)
//    }
//}

//open class FTModelData : JSONModel {

//    var jsonData: JSON = [:]
//    var classType: AnyClass = FTDataModel.self
//    var schemaType: JSON = [:]

//    public override required init(){
//        super.init()
//        self.jsonData = [:]
//    }
//    
//    public required convenience init(jsonData: JSON, baseClass: AnyClass, schema: JSON) {
//        self.init()
//        
//        self.classType = baseClass
//        self.schemaType = schema
//
//        self.__setup__()
//
//        self.jsonData = jsonData
//        
//        self.updateValues()
//    }
    
//    open override func setValue(_ value: Any?, forKey key: String) {
//        
//        if let schemaKey = self.schemaType[key] as? String {
//            
//            print("schemaKey: \(schemaKey) :: key : \(key) value: \(String(describing: value))")
//            
//            super.setValue(value, forKey: schemaKey)
//        }else {
//            
//            print("schemaKey not avaialble ::key : \(key) value: \(String(describing: value))")
//        }
//    }
//}

//extension FTDataModel { //: NSObjectProtocol {

//    func updateValues() {
//        
//        self.jsonData.forEach { (key: String, value: Any) in
//            self.setValue(value, forKey: key)
//        }
//    }
//}
//
//extension FTDataModel {

//    public class func dataModelOfType(_ baseClass: String, withJSON dic: JSON) -> Any? {
//        
//        guard let cls = baseClass.getClassInstance() as? FTDataModel.Type else { return nil }
//        
//        guard let schema = try? FTModelConfig.schemaForClass(classKey: baseClass) else { return nil }
//        
//        return cls.init(jsonData:dic, baseClass: cls, schema:schema!)
//    }
//}
//
//extension FTDataModel {

//    func __setup__ ()  {
//            
//        let properties = getClassPropertyNames(self)
//
//        print(properties ?? "properties of type \(classType) are empty");
//
//    }
    
//}
