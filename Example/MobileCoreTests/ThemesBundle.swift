//
//  ThemesBundle.swift
//  MobileCoreTests
//
//  Created by Praveen Prabhakar on 11/07/21.
//  Copyright © 2021 Praveen Prabhakar. All rights reserved.
//

import Foundation

private final class ThemesBundle {
}

public var kMobileCoreBundle = Bundle(for: ThemesBundle.self)
public var kThemePath = kMobileCoreBundle.path(forResource: "Themes", ofType: "json")
