//
//  EnumCollection.swift
//  WhatToPlay
//
//  Created by Ryan LaSante on 1/28/18.
//  Copyright © 2018 rlasante. All rights reserved.
//

public protocol EnumCollection: Hashable {
    static func cases() -> AnySequence<Self>
    static var allValues: [Self] { get }
}

public extension EnumCollection {

    static func cases() -> AnySequence<Self> {
        return AnySequence { () -> AnyIterator<Self> in
            var raw = 0
            return AnyIterator {
                let current: Self = withUnsafePointer(to: &raw) { $0.withMemoryRebound(to: self, capacity: 1) { $0.pointee } }
                guard current.hashValue == raw else {
                    return nil
                }
                raw += 1
                return current
            }
        }
    }

    static var allValues: [Self] {
        return Array(self.cases())
    }
}
