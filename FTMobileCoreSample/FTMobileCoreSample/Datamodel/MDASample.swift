//
//  MDASample.swift
//  FTMobileCoreSample
//
//  Created by Praveen Prabhakar on 15/06/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import UIKit
import FTMobileCore


class MDASample : FTDataModel {
    var identifier:String?
    var amount:Decimal = 0.0
    var isValid:Bool = false
    var date:NSDate?
    var accList:NSMutableArray?
    var dicList:NSMutableDictionary?
}

