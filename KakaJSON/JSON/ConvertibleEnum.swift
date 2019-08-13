//
//  ConvertibleEnum.swift
//  KakaJSON
//
//  Created by MJ Lee on 2019/8/13.
//  Copyright © 2019 MJ Lee. All rights reserved.
//

public protocol ConvertibleEnum {
    static func _convert(from value: Any?) -> Self?
    var _value: Any { get }
}

public extension RawRepresentable where Self: ConvertibleEnum {
    static func _convert(from value: Any?) -> Self? {
        guard let v = value else { return nil }
        guard let rv = v as? RawValue else { return nil }
        return Self.init(rawValue: rv)
    }
    var _value: Any { rawValue }
}
