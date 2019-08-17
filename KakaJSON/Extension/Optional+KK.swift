//
//  Optional+KK.swift
//  KakaJSON
//
//  Created by MJ Lee on 2019/8/5.
//  Copyright © 2019 MJ Lee. All rights reserved.
//

import Foundation
#if canImport(CoreGraphics)
import CoreGraphics
#endif

protocol OptionalValue {
    var kk_value: Any? { get }
}

extension Optional: OptionalValue {
    var kk_value: Any? {
        guard self != nil else { return nil }
        let value = self!
        guard let ov = value as? OptionalValue else {
            return value
        }
        return ov.kk_value
    }
}

extension Optional: KKGenericCompatible {
    public typealias T = Wrapped
}

public extension KKGeneric where Base == Optional<T> {
    var value: Any? { return base.kk_value }
    
    var string: String? {
        return base.kk_value(String.self) as? String
    }
    
    var bool: Bool? {
        return base.kk_value(Bool.self) as? Bool
    }
    
    var int: Int? {
        return base.kk_value(Int.self) as? Int
    }
    
    var int8: Int8? {
        return base.kk_value(Int8.self) as? Int8
    }
    
    var int16: Int16? {
        return base.kk_value(Int16.self) as? Int16
    }
    
    var int32: Int32? {
        return base.kk_value(Int32.self) as? Int32
    }
    
    var int64: Int64? {
        return base.kk_value(Int64.self) as? Int64
    }
    
    var uInt: UInt? {
        return base.kk_value(UInt.self) as? UInt
    }
    
    var uInt8: UInt8? {
        return base.kk_value(UInt8.self) as? UInt8
    }
    
    var uInt16: UInt16? {
        return base.kk_value(UInt16.self) as? UInt16
    }
    
    var uInt32: UInt32? {
        return base.kk_value(UInt32.self) as? UInt32
    }
    
    var uInt64: UInt64? {
        return base.kk_value(UInt64.self) as? UInt64
    }
    
    var float: Float? {
        return base.kk_value(Float.self) as? Float
    }
    
    var double: Double? {
        return base.kk_value(Double.self) as? Double
    }
    
    #if canImport(CoreGraphics)
    var cgFloat: CGFloat? {
        return base.kk_value(CGFloat.self) as? CGFloat
    }
    #endif
    
    var decimal: Decimal? {
        return base.kk_value(Decimal.self) as? Decimal
    }
    
    var number: NSNumber? {
        return base.kk_value(NSNumber.self) as? NSNumber
    }
    
    var decimalNumber: NSDecimalNumber? {
        return base.kk_value(NSDecimalNumber.self) as? NSDecimalNumber
    }
}

extension Optional {
    func kk_value(_ type: Any.Type) -> Any? {
        guard let v = kk_value else { return nil }
        if Swift.type(of: v) == type { return v }
        
        switch type {
        case is Convertible.Type: return _model(v, type)
        case is ArrayValue.Type: return _array(v, type)
        case is SetValue.Type: return _set(v, type)
        case is DictionaryValue.Type: return _dictionary(v, type)
        case is StringValue.Type: return _string(v, type)
        case is DataValue.Type: return _data(v, type)
        case is NumberValue.Type: return _number(v, type)
        case is URLValue.Type: return _url(v)
        case is DateValue.Type: return _date(v)
        case let enumType as ConvertibleEnum.Type:
            let v = kk_value(enumType.kk_valueType)
            return enumType.kk_convert(from: v)
        default: return nil
        }
    }
    
    func kk_JSON() -> Any? {
        guard let v = kk_value else { return nil }
        
        switch v {
        case let model as Convertible: return model.kk_JSON()
        case let array as [Any]: return _JSON(from: array)
        case let dict as JSONObject: return _JSON(from: dict)
        case let set as SetValue: return _JSON(from: set)
        case let num as NumberValue: return _JSON(from: num)
        case let url as URL: return url.absoluteString
        case let date as Date: return date.timeIntervalSince1970
        case let `enum` as ConvertibleEnum: return `enum`.kk_value~?.kk_JSON()
        default: return v as? NSCoding
        }
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
        guard let json = value as? JSONObject else { return nil }
        return json.kk.model(anyType: type)
    }
    
    func _anyArray(_ value: Any) -> [Any]? {
        guard let set = value as? NSSet else { return value as? [Any] }
        return [Any](set)
    }
    
    func _array(_ value: Any, _ type: Any.Type) -> ArrayValue? {
        guard let json = _anyArray(value) else { return nil }
        
        let mt = Metadata.type(type)
        if let type = (mt as? NominalType)?.genericTypes?.first,
            let modelType = type~! as? Convertible.Type {
            return json.kk.modelArray(anyType: modelType)
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
        guard let dict = value as? JSONObject else { return nil }
        
        let mt = Metadata.type(type)
        if type is SwiftDictionaryValue.Type,
            let json = value as? [String: JSONObject?],
            let type = (mt as? NominalType)?.genericTypes?.last,
            let modelType = type~! as? Convertible.Type {
            var modelDict = JSONObject()
            for (k, v) in json {
                guard let m = v?.kk.model(anyType: modelType) else { continue }
                modelDict[k] = m
            }
            return modelDict.isEmpty ? nil : modelDict
        }
        
        return type is NSMutableDictionary.Type
            ? NSMutableDictionary(dictionary: dict) : dict
    }
    
    func _string(_ value: Any, _ type: Any.Type) -> StringValue? {
        var str: String
        if let url = value as? URL {
            str = url.absoluteString
        } else if let date = value as? Date {
            str = "\(Int64(date.timeIntervalSince1970))"
        } else {
            str = "\(value)"
        }
        return type is NSMutableString.Type ? NSMutableString(string: str) : str
    }
    
    func _data(_ value: Any, _ type: Any.Type) -> DataValue? {
        var data: Data?
        if let str = value as? String {
            data = str.data(using: String.Encoding.utf8)
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
        return _JSON(from: set.kk_array())
    }
    
    func _JSON(from array: [Any]) -> Any? {
        let newArray = array.compactMap {
            $0~?.kk_JSON()
        }
        return newArray.isEmpty ? nil : newArray
    }
    
    func _JSON(from dict: JSONObject) -> Any? {
        let newDict = dict.compactMapValues {
            $0~?.kk_JSON()
        }
        return newDict.isEmpty ? nil : newDict
    }
    
    func _JSON(from modelDict: [String: Convertible?]) -> Any? {
        var jsonDict = JSONObject()
        for (k, model) in modelDict {
            guard let json = model?.kk_JSON() else { continue }
            jsonDict[k] = json
        }
        return jsonDict.isEmpty ? nil : jsonDict
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
//    func kk_map<T>(_ transform: (Any) throws -> T) rethrows -> [T]
//    func kk_compactMap<T>(_ transform: (Any) throws -> T?) rethrows -> [T]
    func kk_array() -> [Any]
}
extension NSSet: SetValue {
//    func kk_map<T>(_ transform: (Any) throws -> T) rethrows -> [T] {
//        return map { try! transform($0) }
//    }
//    func kk_compactMap<T>(_ transform: (Any) throws -> T?) rethrows -> [T] {
//        return compactMap { try! transform($0) }
//    }
    func kk_array() -> [Any] {
        return [Any](self)
    }
}
protocol SwiftSetValue: SetValue {}
extension Set: SwiftSetValue {
//    func kk_map<T>(_ transform: (Any) throws -> T) rethrows -> [T] {
//        return map { try! transform($0) }
//    }
//    func kk_compactMap<T>(_ transform: (Any) throws -> T?) rethrows -> [T] {
//        return compactMap { try! transform($0) }
//    }
    func kk_array() -> [Any] {
        return map { $0 }
    }
}

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

public postfix func ~? (_ value: Any) -> Any? {
    return Optional.some(value)
}

/// get the real inner type
///
///     var type: Any.Type = Int???.self
///     print(type~!) // Int
public postfix func ~! (_ type: Any.Type) -> Any.Type {
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
public postfix func ~! (_ value: Any) -> Any? {
    guard let ov = value as? OptionalValue else { return value }
    return ov.kk_value
}

public postfix func ~! (_ value: Any?) -> Any? {
    return (value as OptionalValue).kk_value
}
