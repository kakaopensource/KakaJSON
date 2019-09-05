//
//  JSONSerialization+KJ.swift
//  KakaJSON
//
//  Created by MJ Lee on 2019/8/2.
//  Copyright © 2019 MJ Lee. All rights reserved.
//

import Foundation

extension JSONSerialization {
    static func kj_JSON<T>(_ string: String, _ type: T.Type) -> T? {
        return string.data(using: .utf8).flatMap { kj_JSON($0, type) }
    }
    
    static func kj_JSON<T>(_ data: Data, _ type: T.Type) -> T? {
        return try? jsonObject(with: data,
                               options: .allowFragments) as? T
    }
    
    static func kj_string(_ json: Any?,
                          prettyPrinted: Bool = false) -> String? {
        guard let value = json.kj_value else { return nil }
        guard value is [Any] || value is [String: Any] else {
            return "\(value)"
        }
        guard let data = try? data(withJSONObject: value,
                                   options: prettyPrinted ? [.prettyPrinted] : [])
            else { return nil }
        return String(data: data, encoding: .utf8)
    }
}
