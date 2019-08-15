//
//  JSONSerialization+KK.swift
//  KakaJSON
//
//  Created by MJ Lee on 2019/8/2.
//  Copyright © 2019 MJ Lee. All rights reserved.
//

extension JSONSerialization {
    static func kk_JSON<T>(_ string: String?, _ type: T.Type) -> T? {
        guard let str = string,
            let data = str.data(using: String.Encoding.utf8)
            else { return nil }
        return try? jsonObject(with: data,
                               options: .allowFragments) as? T
    }
    
    static func kk_string(_ jsonObject: Any?,
                          prettyPrinted: Bool = false) -> String? {
        guard let json = jsonObject,
            let data = try? data(withJSONObject: json,
                                 options: prettyPrinted ? [.prettyPrinted] : [])
            else { return nil }
        return String(data: data, encoding: String.Encoding.utf8)
    }
}
