//
//  URLValueTransformer.swift
//  WhatToPlay
//
//  Created by Ryan LaSante on 7/10/18.
//  Copyright © 2018 rlasante. All rights reserved.
//

import UIKit

extension ValueTransformer {
    static func registerTransformers() {
        let transformers: [Registerable.Type] = [
            URLValueTransformer.self
        ]
        transformers.forEach { $0.register() }
    }
}

protocol Registerable {
    static func register()
}

class URLValueTransformer: ValueTransformer, Registerable {
    static func register() {
        let valueName = NSValueTransformerName(rawValue: String(describing: URLValueTransformer.self))
        ValueTransformer.setValueTransformer(URLValueTransformer(), forName: valueName)
    }

    override func transformedValue(_ value: Any?) -> Any? {
        guard let url = value as? URL else { return nil }
        return url.absoluteString.data(using: .utf8)
    }

    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let rawUrlData = value as? Data, let rawUrl = String(data: rawUrlData, encoding: .utf8) else { return nil }
        return URL(string: rawUrl)
    }
}
