//
//  ConvertibleEnum.swift
//  KakaJSON
//
//  Created by MJ Lee on 2019/8/13.
//  Copyright © 2019 MJ Lee. All rights reserved.
//

public protocol ConvertibleEnum {
    static func kk_convert(from value: Any?) -> Self?
    var kk_value: Any { get }
    static var kk_valueType: Any.Type { get }
}

public extension RawRepresentable where Self: ConvertibleEnum {
    static func kk_convert(from value: Any?) -> Self? {
        return (value as? RawValue).flatMap { Self.init(rawValue: $0) }
    }
    var kk_value: Any { return rawValue }
    static var kk_valueType: Any.Type { return RawValue.self }
}
