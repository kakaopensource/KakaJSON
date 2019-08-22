//
//  Value.swift
//  KakaJSON
//
//  Created by MJ Lee on 2019/8/22.
//  Copyright © 2019 MJ Lee. All rights reserved.
//

import Foundation
#if canImport(CoreGraphics)
import CoreGraphics
#endif

/// get the most inner value
public func value<T>(_ val: Any?, _ type: T.Type)-> T? {
    return val.kj_value(type) as? T
}

/// convert value to String
public func string(_ value: Any?)-> String? {
    return value.kj_value(String.self) as? String
}

/// convert value to Bool
public func bool(_ value: Any?)-> Bool? {
    return value.kj_value(Bool.self) as? Bool
}

/// convert value to Int
public func int(_ value: Any?)-> Int? {
    return value.kj_value(Int.self) as? Int
}

/// convert value to Int8
public func int8(_ value: Any?)-> Int8? {
    return value.kj_value(Int8.self) as? Int8
}

/// convert value to Int16
public func int16(_ value: Any?)-> Int16? {
    return value.kj_value(Int16.self) as? Int16
}

/// convert value to Int32
public func int32(_ value: Any?)-> Int32? {
    return value.kj_value(Int32.self) as? Int32
}

/// convert value to Int64
public func int64(_ value: Any?)-> Int64? {
    return value.kj_value(Int64.self) as? Int64
}

/// convert value to UInt
public func uInt(_ value: Any?)-> UInt? {
    return value.kj_value(UInt.self) as? UInt
}

/// convert value to UInt8
public func uInt8(_ value: Any?)-> UInt8? {
    return value.kj_value(UInt8.self) as? UInt8
}

/// convert value to UInt16
public func uInt16(_ value: Any?)-> UInt16? {
    return value.kj_value(UInt16.self) as? UInt16
}

/// convert value to UInt32
public func uInt32(_ value: Any?)-> UInt32? {
    return value.kj_value(UInt32.self) as? UInt32
}

/// convert value to UInt64
public func uInt64(_ value: Any?)-> UInt64? {
    return value.kj_value(UInt64.self) as? UInt64
}

/// convert value to Float
public func float(_ value: Any?)-> Float? {
    return value.kj_value(Float.self) as? Float
}

/// convert value to Double
public func double(_ value: Any?)-> Double? {
    return value.kj_value(Double.self) as? Double
}

#if canImport(CoreGraphics)
/// convert value to CGFloat
public func cgFloat(_ value: Any?)-> CGFloat? {
    return value.kj_value(CGFloat.self) as? CGFloat
}
#endif

/// convert value to Decimal
public func decimal(_ value: Any?)-> Decimal? {
    return value.kj_value(Decimal.self) as? Decimal
}

/// convert value to NSNumber
public func number(_ value: Any?)-> NSNumber? {
    return value.kj_value(NSNumber.self) as? NSNumber
}

/// convert value to NSDecimalNumber
public func decimalNumber(_ value: Any?)-> NSDecimalNumber? {
    return value.kj_value(NSDecimalNumber.self) as? NSDecimalNumber
}

