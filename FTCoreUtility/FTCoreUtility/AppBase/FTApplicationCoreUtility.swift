//
//  FTApplicationCoreUtility.swift
//  FTCoreUtility
//
//  Created by Praveen Prabhakar on 19/08/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation

//+ (BOOL)isRegisteredURLScheme:(NSString *)urlScheme {
//    static dispatch_once_t fetchBundleOnce;
//    static NSArray *urlTypes = nil;
//    
//    dispatch_once(&fetchBundleOnce, ^{
//    urlTypes = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleURLTypes"];
//    });
//    for (NSDictionary *urlType in urlTypes) {
//        NSArray *urlSchemes = [urlType valueForKey:@"CFBundleURLSchemes"];
//        if ([urlSchemes containsObject:urlScheme]) {
//            return YES;
//        }
//    }
//    return NO;
//}

//+ (unsigned long)currentTimeInMilliseconds
//    {
//        struct timeval time;
//        gettimeofday(&time, NULL);
//        return (time.tv_sec * 1000) + (time.tv_usec / 1000);
//}
