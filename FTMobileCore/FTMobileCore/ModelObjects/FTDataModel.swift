//
//  FTDataModel.swift
//  FTMobileCore
//
//  Created by Praveen Prabhakar on 15/06/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation
import ObjectiveC.runtime
import ObjectiveC.message

open class FTDataModel : JSONModel {
    
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
}

extension FTDataModel { //: NSObjectProtocol {

//    func updateValues() {
//        
//        self.jsonData.forEach { (key: String, value: Any) in
//            self.setValue(value, forKey: key)
//        }
//    }
}

extension FTDataModel {
 
//    public class func dataModelOfType(_ baseClass: String, withJSON dic: JSON) -> Any? {
//        
//        guard let cls = baseClass.getClassInstance() as? FTDataModel.Type else { return nil }
//        
//        guard let schema = try? FTModelConfig.schemaForClass(classKey: baseClass) else { return nil }
//        
//        return cls.init(jsonData:dic, baseClass: cls, schema:schema!)
//    }
}

extension FTDataModel {
    
//    func __setup__ ()  {
//            
//        let properties = getClassPropertyNames(self)
//
//        print(properties ?? "properties of type \(classType) are empty");
//
//    }
    
}

