//
//  UserDefaultsExtension.swift
//  WhatToPlay
//
//  Created by Ryan LaSante on 5/9/21.
//  Copyright © 2021 rlasante. All rights reserved.
//

import Foundation

extension UserDefaults {
    private static var usernameKey = "com.lasante.whattoplay.username"

    /// currently selected username
    var username: String? {
        get {
            return string(forKey: UserDefaults.usernameKey)
        }
        set {
            setValue(newValue, forKey: UserDefaults.usernameKey)
        }
    }
}
