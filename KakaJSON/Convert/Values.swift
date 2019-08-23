//
//  Values.swift
//  KakaJSON
//
//  Created by MJ Lee on 2019/8/23.
//  Copyright © 2019 MJ Lee. All rights reserved.
//

import Foundation
#if canImport(CoreGraphics)
import CoreGraphics
#endif

public struct Values {
    static func kj_value(_ value: Any?, _ type: Any.Type) -> Any? {
        guard let v = value.kj_value else { return nil }
        if Swift.type(of: v) == type { return v }
        
        switch type {
        case is NumberValue.Type: return _number(v, type)
        case is StringValue.Type: return _string(v, type)
        case is Convertible.Type: return _model(v, type)
        case is DateValue.Type: return _date(v)
        case is ArrayValue.Type: return _array(v, type)
        case is DictionaryValue.Type: return _dictionary(v, type)
        case is URLValue.Type: return _url(v)
        case is DataValue.Type: return _data(v, type)
        case is SetValue.Type: return _set(v, type)
        case let enumType as ConvertibleEnum.Type:
            let vv = kj_value(v, enumType.kj_valueType)
            return enumType.kj_convert(from: vv as Any)
        default: return nil
        }
    }
    
    static func kj_JSON(_ value: Any?) -> Any? {
        guard let v = value.kj_value else { return nil }
        
        switch v {
        case let num as NumberValue: return _JSON(from: num)
        case let model as Convertible: return model.kj_JSONObject()
        case let date as Date: return date.timeIntervalSince1970
        case let array as [Any]: return _JSON(from: array)
        case let dict as [String: Any]: return _JSON(from: dict)
        case let url as URL: return url.absoluteString
        case let set as SetValue: return _JSON(from: set)
        case let `enum` as ConvertibleEnum: return kj_JSON(`enum`.kj_value)
        default: return v as? NSCoding
        }
    }
    
    static func kj_JSONString(_ value: Any?,
                              prettyPrinted: Bool = false) -> String? {
        if let str = JSONSerialization.kj_string(kj_JSON(value),
                                                 prettyPrinted: prettyPrinted) {
            return str
        }
        Logger.error("Failed to get JSONString from JSON.")
        return nil
    }
}

private extension Values {
    static func _numberString(_ value: Any) -> String? {
        if let date = value as? Date {
            return "\(date.timeIntervalSince1970)"
        }
        let lower = "\(value)".lowercased()
        if lower == "true" || lower == "yes" { return "1" }
        if lower == "false" || lower == "no" { return "0" }
        return lower
    }
    
    static func _model(_ value: Any, _ type: Any.Type) -> Any? {
        guard let json = value as? [String: Any] else { return nil }
        return json.kj.model(anyType: type)
    }
    
    static func _anyArray(_ value: Any) -> [Any]? {
        guard let set = value as? SetValue else { return value as? [Any] }
        return set.kj_array()
    }
    
    static func _array(_ value: Any, _ type: Any.Type) -> ArrayValue? {
        guard let json = _anyArray(value) else { return nil }
        
        let mt = Metadata.type(type)
        if let type = (mt as? NominalType)?.genericTypes?.first,
            let modelType = type~! as? Convertible.Type {
            return json.kj.modelArray(anyType: modelType)
        }
        
        return type is NSMutableArray.Type
            ? NSMutableArray(array: json) : json
    }
    
    static func _set(_ value: Any, _ type: Any.Type) -> SetValue? {
        guard let arr = _array(value, type) as? [Any]
            else { return nil }
        return type is NSMutableSet.Type
            ? NSMutableSet(array: arr)
            : NSSet(array: arr)
    }
    
    static func _dictionary(_ value: Any, _ type: Any.Type) -> DictionaryValue? {
        guard let dict = value as? [String: Any] else { return nil }
        
        let mt = Metadata.type(type)
        if type is SwiftDictionaryValue.Type,
            let json = value as? [String: [String: Any]?],
            let type = (mt as? NominalType)?.genericTypes?.last,
            let modelType = type~! as? Convertible.Type {
            
            var modelDict = [String: Any]()
            for (k, v) in json {
                guard let m = v?.kj.model(anyType: modelType) else { continue }
                modelDict[k] = m
            }
            return modelDict.isEmpty ? nil : modelDict
        }
        
        return type is NSMutableDictionary.Type
            ? NSMutableDictionary(dictionary: dict) : dict
    }
    
    static func _string(_ value: Any, _ type: Any.Type) -> StringValue? {
        var str: String
        switch value {
        case let url as URL: str = url.standardizedFileURL.absoluteString
        case let date as Date: str = "\(Int64(date.timeIntervalSince1970))"
        default: str = "\(value)"
        }
        return type is NSMutableString.Type ? NSMutableString(string: str) : str
    }
    
    static func _data(_ value: Any, _ type: Any.Type) -> DataValue? {
        var data: Data?
        if let str = value as? String {
            data = str.data(using: .utf8)
        } else {
            data = value as? Data
        }
        guard let v = data else { return nil }
        return type is NSMutableData.Type ? NSMutableData(data: v) : v
    }
    
    static func _date(_ value: Any) -> DateValue? {
        if let v = value as? Date { return v }
        guard let time = Double("\(value)") else { return nil }
        return Date(timeIntervalSince1970: time)
    }
    
    static func _url(_ value: Any) -> URLValue? {
        guard let str = value as? String, str.contains("://")
            else { return value as? URL }
        return str.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed).flatMap { URL(string: $0) }
    }
    
    static func _number(_ value: Any, _ type: Any.Type) -> NumberValue? {
        guard let str = _numberString(value) else { return nil }
        guard let decimal = Decimal(string: str) else { return nil }
        
        // decimal
        if type is Decimal.Type { return decimal }
        
        // digit
        if let digitType = type as? DigitValue.Type {
            guard let double = Double("\(decimal)") else { return nil }
            let number = NSNumber(value: double)
            return digitType.init(truncating: number)
        }
        
        // decimal number
        if type is NSDecimalNumber.Type {
            return NSDecimalNumber(decimal: decimal)
        }
        
        // number
        return Double("\(decimal)").flatMap { NSNumber(value: $0) }
    }
    
    static func _JSON(from set: SetValue) -> Any? {
        return _JSON(from: set.kj_array())
    }
    
    static func _JSON(from array: [Any]) -> Any? {
        let newArray = array.compactMap { kj_JSON($0) }
        return newArray.isEmpty ? nil : newArray
    }
    
    static func _JSON(from dict: [String: Any]) -> Any? {
        let newDict = dict.compactMapValues { kj_JSON($0) }
        return newDict.isEmpty ? nil : newDict
    }
    
    static func _JSON(from num: NumberValue) -> Any? {
        // stay Bool\IntegerValue
        if num is Bool || num is IntegerValue { return num }
        // return string for keeping precision
        if num is DecimalValue { return "\(num)" }
        // return NSDecimalNumber for keeping precision
        return NSDecimalNumber(string: "\(num)")
    }
}

public extension Values {
    /// get the most inner value
    static func value<T>(_ val: Any?, _ type: T.Type)-> T? {
        return kj_value(val, type) as? T
    }
    
    /// convert value to String
    static func string(_ value: Any?)-> String? {
        return kj_value(value, String.self) as? String
    }
    
    /// convert value to Bool
    static func bool(_ value: Any?)-> Bool? {
        return kj_value(value, Bool.self) as? Bool
    }
    
    /// convert value to Int
    static func int(_ value: Any?)-> Int? {
        return kj_value(value, Int.self) as? Int
    }
    
    /// convert value to Int8
    static func int8(_ value: Any?)-> Int8? {
        return kj_value(value, Int8.self) as? Int8
    }
    
    /// convert value to Int16
    static func int16(_ value: Any?)-> Int16? {
        return kj_value(value, Int16.self) as? Int16
    }
    
    /// convert value to Int32
    static func int32(_ value: Any?)-> Int32? {
        return kj_value(value, Int32.self) as? Int32
    }
    
    /// convert value to Int64
    static func int64(_ value: Any?)-> Int64? {
        return kj_value(value, Int64.self) as? Int64
    }
    
    /// convert value to UInt
    static func uInt(_ value: Any?)-> UInt? {
        return kj_value(value, UInt.self) as? UInt
    }
    
    /// convert value to UInt8
    static func uInt8(_ value: Any?)-> UInt8? {
        return kj_value(value, UInt8.self) as? UInt8
    }
    
    /// convert value to UInt16
    static func uInt16(_ value: Any?)-> UInt16? {
        return kj_value(value, UInt16.self) as? UInt16
    }
    
    /// convert value to UInt32
    static func uInt32(_ value: Any?)-> UInt32? {
        return kj_value(value, UInt32.self) as? UInt32
    }
    
    /// convert value to UInt64
    static func uInt64(_ value: Any?)-> UInt64? {
        return kj_value(value, UInt64.self) as? UInt64
    }
    
    /// convert value to Float
    static func float(_ value: Any?)-> Float? {
        return kj_value(value, Float.self) as? Float
    }
    
    /// convert value to Double
    static func double(_ value: Any?)-> Double? {
        return kj_value(value, Double.self) as? Double
    }
    
    #if canImport(CoreGraphics)
    /// convert value to CGFloat
    static func cgFloat(_ value: Any?)-> CGFloat? {
        return kj_value(value, CGFloat.self) as? CGFloat
    }
    #endif
    
    /// convert value to Decimal
    static func decimal(_ value: Any?)-> Decimal? {
        return kj_value(value, Decimal.self) as? Decimal
    }
    
    /// convert value to NSNumber
    static func number(_ value: Any?)-> NSNumber? {
        return kj_value(value, NSNumber.self) as? NSNumber
    }
    
    /// convert value to NSDecimalNumber
    static func decimalNumber(_ value: Any?)-> NSDecimalNumber? {
        return kj_value(value, NSDecimalNumber.self) as? NSDecimalNumber
    }
}

// MARK: - Types
protocol CollectionValue {}

protocol DictionaryValue: CollectionValue {}
extension NSDictionary: DictionaryValue {}
protocol SwiftDictionaryValue: DictionaryValue {}
extension Dictionary: SwiftDictionaryValue {}

protocol ArrayValue: CollectionValue {}
extension NSArray: ArrayValue {}
protocol SwiftArrayValue: ArrayValue {}
extension Array: SwiftArrayValue {}

protocol SetValue: CollectionValue {
    func kj_array() -> [Any]
}
extension SetValue where Self: Sequence {
    func kj_array() -> [Any] {
        return map { $0 }
    }
}

extension NSSet: SetValue {}
protocol SwiftSetValue: SetValue {}
extension Set: SwiftSetValue {}

protocol StringValue {}
extension String: StringValue {}
extension NSString: StringValue {}

protocol NumberValue {}
protocol DecimalValue {}
extension NSNumber: NumberValue {}
extension Decimal: NumberValue, DecimalValue {}
extension NSDecimalNumber: DecimalValue {}

protocol DigitValue: NumberValue {
    init?(truncating: NSNumber)
}

protocol FloatValue: DigitValue { }
extension Double: FloatValue {}
extension Float: FloatValue {}
#if canImport(CoreGraphics)
import CoreGraphics
extension CGFloat: FloatValue {}
#endif

extension Bool: DigitValue {}

protocol IntegerValue: DigitValue { }
extension Int: IntegerValue {}
extension Int64: IntegerValue {}
extension Int32: IntegerValue {}
extension Int16: IntegerValue {}
extension Int8: IntegerValue {}
extension UInt: IntegerValue {}
extension UInt64: IntegerValue {}
extension UInt32: IntegerValue {}
extension UInt16: IntegerValue {}
extension UInt8: IntegerValue {}

protocol URLValue {}
extension NSURL: URLValue {}
extension URL: URLValue {}

protocol DataValue {}
extension NSData: DataValue {}
extension Data: DataValue {}

protocol DateValue {}
extension NSDate: DateValue {}
extension Date: DateValue {}

// MARK: - operators
postfix operator ~!

/// get the real inner type
///
///     var type: Any.Type = Int???.self
///     print(type~!) // Int
postfix func ~! (_ type: Any.Type) -> Any.Type {
    guard let ot = Metadata.type(type) as? OptionalType else { return type }
    return ot.wrapType
}

/// get the real inner value
///
/// A value came from ptr.pointee need to ~!
///
///     var data: Int???? = 10
///     var value: Any = data as Any
///     print(value~!) // Optional(10)
postfix func ~! (_ value: Any) -> Any? {
    guard let ov = value as? OptionalValue else { return value }
    return ov.kj_value
}

postfix func ~! (_ value: Any?) -> Any? {
    return (value as OptionalValue).kj_value
}

