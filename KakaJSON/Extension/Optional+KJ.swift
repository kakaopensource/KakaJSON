//
//  Optional+KJ.swift
//  KakaJSON
//
//  Created by MJ Lee on 2019/8/5.
//  Copyright © 2019 MJ Lee. All rights reserved.
//

import Foundation

protocol OptionalValue {
    var kj_value: Any? { get }
}

extension Optional: OptionalValue {
    var kj_value: Any? {
        guard self != nil else { return nil }
        let value = self!
        guard let ov = value as? OptionalValue else {
            return value
        }
        return ov.kj_value
    }
}

extension Optional {
    func kj_value(_ type: Any.Type) -> Any? {
        guard let v = kj_value else { return nil }
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
            let v = kj_value(enumType.kj_valueType)
            return enumType.kj_convert(from: v)
        default: return nil
        }
    }
    
    func kj_JSON() -> Any? {
        guard let v = kj_value else { return nil }
        
        switch v {
        case let num as NumberValue: return _JSON(from: num)
        case let model as Convertible: return model.kj_JSONObject()
        case let date as Date: return date.timeIntervalSince1970
        case let array as [Any]: return _JSON(from: array)
        case let dict as [String: Any]: return _JSON(from: dict)
        case let url as URL: return url.absoluteString
        case let set as SetValue: return _JSON(from: set)
        case let `enum` as ConvertibleEnum: return `enum`.kj_value~?.kj_JSON()
        default: return v as? NSCoding
        }
    }
    
    func kj_JSONString(prettyPrinted: Bool = false) -> String? {
        if let str = JSONSerialization.kj_string(kj_JSON(),
                                                 prettyPrinted: prettyPrinted) {
            return str
        }
        Logger.error("Failed to get JSONString from JSON.")
        return nil
    }
}

private extension Optional {
    func _numberString(_ value: Any) -> String? {
        if let date = value as? Date {
            return "\(date.timeIntervalSince1970)"
        }
        let lower = "\(value)".lowercased()
        if lower == "true" || lower == "yes" { return "1" }
        if lower == "false" || lower == "no" { return "0" }
        return lower
    }
    
    func _model(_ value: Any, _ type: Any.Type) -> Any? {
        guard let json = value as? [String: Any] else { return nil }
        return json.kj.model(anyType: type)
    }
    
    func _anyArray(_ value: Any) -> [Any]? {
        guard let set = value as? SetValue else { return value as? [Any] }
        return set.kj_array()
    }
    
    func _array(_ value: Any, _ type: Any.Type) -> ArrayValue? {
        guard let json = _anyArray(value) else { return nil }
        
        let mt = Metadata.type(type)
        if let type = (mt as? NominalType)?.genericTypes?.first,
            let modelType = type~! as? Convertible.Type {
            return json.kj.modelArray(anyType: modelType)
        }
        
        return type is NSMutableArray.Type
            ? NSMutableArray(array: json) : json
    }
    
    func _set(_ value: Any, _ type: Any.Type) -> SetValue? {
        guard let arr = _array(value, type) as? [Any]
            else { return nil }
        return type is NSMutableSet.Type
            ? NSMutableSet(array: arr)
            : NSSet(array: arr)
    }
    
    func _dictionary(_ value: Any, _ type: Any.Type) -> DictionaryValue? {
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
    
    func _string(_ value: Any, _ type: Any.Type) -> StringValue? {
        var str: String
        switch value {
        case let url as URL: str = url.standardizedFileURL.absoluteString
        case let date as Date: str = "\(Int64(date.timeIntervalSince1970))"
        default: str = "\(value)"
        }
        return type is NSMutableString.Type ? NSMutableString(string: str) : str
    }
    
    func _data(_ value: Any, _ type: Any.Type) -> DataValue? {
        var data: Data?
        if let str = value as? String {
            data = str.data(using: .utf8)
        } else {
            data = value as? Data
        }
        guard let v = data else { return nil }
        return type is NSMutableData.Type ? NSMutableData(data: v) : v
    }
    
    func _date(_ value: Any) -> DateValue? {
        if let v = value as? Date { return v }
        guard let time = Double("\(value)") else { return nil }
        return Date(timeIntervalSince1970: time)
    }
    
    func _url(_ value: Any) -> URLValue? {
        guard let str = value as? String, str.contains("://")
            else { return value as? URL }
        return str.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed).flatMap { URL(string: $0) }
    }
    
    func _number(_ value: Any, _ type: Any.Type) -> NumberValue? {
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
    
    func _JSON(from set: SetValue) -> Any? {
        return _JSON(from: set.kj_array())
    }
    
    func _JSON(from array: [Any]) -> Any? {
        let newArray = array.compactMap { $0~?.kj_JSON() }
        return newArray.isEmpty ? nil : newArray
    }
    
    func _JSON(from dict: [String: Any]) -> Any? {
        let newDict = dict.compactMapValues { $0~?.kj_JSON() }
        return newDict.isEmpty ? nil : newDict
    }
    
    func _JSON(from num: NumberValue) -> Any? {
        // stay Bool\Decimal
        if num is Bool || num is Decimal { return num }
        // return NSDecimalNumber for keeping precision
        return NSDecimalNumber(string: "\(num)")
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
extension NSNumber: NumberValue {}
extension Decimal: NumberValue {}

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
postfix operator ~?

postfix func ~? (_ value: Any) -> Any? {
    return Optional.some(value)
}

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
