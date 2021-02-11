//
//  DataRequest+Promise.swift
//  WhatToPlay
//
//  Created by Ryan LaSante on 2/10/21.
//  Copyright © 2021 rlasante. All rights reserved.
//

import Alamofire
import PromiseKit
import UIKit

extension DataRequest {
    func responseString() -> Promise<(String, AFDataResponse<String>)> {
        let requestPromise: Promise<(String, AFDataResponse<String>)> = Promise { resolver in
            responseString { response in
                switch response.result {
                case let .success(value):
                    resolver.fulfill((value, response))
                case let .failure(error):
                    resolver.reject(error)
                }
            }
        }
        return requestPromise
    }

    func responseDecodable<Value: Decodable>() -> Promise<(Value, AFDataResponse<Value>)> {
        let requestPromise: Promise<(Value, AFDataResponse<Value>)> = Promise { resolver in
            responseDecodable(of: Value.self) { response in
                switch response.result {
                case let .success(value):
                    resolver.fulfill((value, response))
                case let .failure(error):
                    resolver.reject(error)
                }
            }
        }
        return requestPromise
    }
}
