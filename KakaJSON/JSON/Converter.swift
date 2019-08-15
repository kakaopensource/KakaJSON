//
//  Converter.swift
//  KakaJSON
//
//  Created by MJ Lee on 2019/8/4.
//  Copyright © 2019 MJ Lee. All rights reserved.
//

struct Converter {
    static func modelValue(from jsonValue: Any?,
                           _ propertyType: Any.Type) -> Any? {
        let mt = Metadata.type(propertyType)
        
        if propertyType is Convertible.Type,
            let json = jsonValue as? JSONObject {
            // e.g. JSONObject\NSDictionry\NSMutableDictionry
            // model contains model
            return json.kk.model(anyType: propertyType)
        } else if propertyType is ArrayValue.Type {
            guard let json = _anyArray(jsonValue) else { return nil }
            
            if let type = (mt as? NominalType)?.genericTypes?.first,
                let modelType = type~! as? Convertible.Type {
                // model contains model array
                return json.kk.modelArray(anyType: modelType)
            }
            
            return propertyType is NSMutableArray.Type
                ? NSMutableArray(array: json) : json
        } else if propertyType is SetValue.Type {
            guard let json = _anyArray(jsonValue) else { return nil }
            
            return propertyType is NSMutableSet.Type
                ? NSMutableSet(array: json) : NSSet(array: json)
        } else if propertyType is DictionaryValue.Type,
            let dict = jsonValue as? JSONObject {
            // dict contains model
            if propertyType is SwiftDictionaryValue.Type,
            let json = jsonValue as? [String: JSONObject?],
            let type = (mt as? NominalType)?.genericTypes?.last,
            let modelType = type~! as? Convertible.Type {
                var modelDict = JSONObject()
                for (k, v) in json {
                    guard let m = v?.kk.model(anyType: modelType) else { continue }
                    modelDict[k] = m
                }
                return modelDict.isEmpty ? nil : modelDict
            }
            
            // normal dict
            return propertyType is NSMutableDictionary.Type
                ? NSMutableDictionary(dictionary: dict) : dict
        } else if propertyType is StringValue.Type {
            return _string(jsonValue, propertyType)
        } else if propertyType is NumberValue.Type {
            return _number(jsonValue, propertyType)
        } else if propertyType is URLValue.Type {
            return _url(jsonValue, propertyType)
        } else if propertyType is DataValue.Type {
            return _data(jsonValue, propertyType)
        } else if let enumType = propertyType as? ConvertibleEnum.Type {
            let v = modelValue(from: jsonValue, enumType.kk_valueType)
            return enumType.kk_convert(from: v)
        }
        return jsonValue
    }
    
    static func JSONValue(from modelValue: Any?) -> Any? {
        if let json = (modelValue as? Convertible)?.kk_JSON() {
            // model contains model
            return json
        } else if let json = (modelValue as? [Convertible?])?.kk.JSON() {
            // model contains model array
            return json
        } else if let modelDict = modelValue as? [String: Convertible?] {
            var jsonDict = JSONObject()
            for (k, model) in modelDict {
                guard let json = model?.kk_JSON() else { continue }
                jsonDict[k] = json
            }
            return jsonDict.isEmpty ? nil : jsonDict
        } else if let v = modelValue as? NumberValue {
            // stay Bool\Decimal
            if v is Bool || v is Decimal { return v }
            return NSDecimalNumber(string: _numberString(v))
        } else if let v = modelValue as? URL {
            return v.absoluteString
        } else if let v = modelValue as? ConvertibleEnum {
            return JSONValue(from: v.kk_value)
        } else if let c = modelValue as? CollectionValue,
            let v = c.kk_JSONValue() {
            return v
        }
        return modelValue as? NSCoding
    }
    
    private static func _anyArray(_ value: Any?) -> [Any]? {
        var json: [Any]?
        if let array = value as? [Any] {
            json = array
        } else if let set = value as? NSSet {
            json = [Any]()
            json!.append(contentsOf: set)
        }
        return json
    }
    
    private static func _data(_ value: Any?, _ type: Any.Type) -> DataValue? {
        guard let vv = value.kk_value else { return nil }
        var data = vv as? Data
        if data == nil {
            data = (vv as? String)?.data(using: String.Encoding.utf8)
        }
        guard let d = data else { return nil }
        return type == Data.self ? d : NSData(data: d)
    }
    
    private static func _url(_ value: Any?, _ type: Any.Type) -> URLValue? {
        guard let vv = value.kk_value else { return nil }
        let urlType = type as! URLValue.Type
        if let str = vv as? String, str.contains("://") {
            return str.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                .flatMap { urlType.init(string: $0) }
        } else if let url = vv as? URL {
            return type == NSURL.self ? NSURL(string: url.absoluteString) : url
        }
        return nil
    }
    
    private static func _string(_ value: Any?, _ type: Any.Type) -> StringValue? {
        guard let vv = value.kk_value else { return nil }
        if let url = value as? URL { return url.absoluteString }
        let str = "\(vv)"
        return type is NSMutableString.Type ? NSMutableString(string: str) : str
    }
    
    private static func _numberString(_ value: Any?) -> String? {
        guard let vv = value.kk_value else { return nil }
        let lower = "\(vv)".lowercased()
        if lower == "true" || lower == "yes" { return "1" }
        if lower == "false" || lower == "no" { return "0" }
        return lower
    }
    
    private static func _number(_ value: Any?, _ type: Any.Type) -> NumberValue? {
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
        return Double("\(decimal)").map { NSNumber(value: $0) }
    }
}

// MARK: - Types
protocol CollectionValue {
    func kk_JSONValue() -> Any?
}

extension CollectionValue {
    func kk_JSONValue() -> Any? {
        return self as? NSCoding
    }
}

protocol DictionaryValue: CollectionValue {}
extension NSDictionary: DictionaryValue {}
protocol SwiftDictionaryValue: DictionaryValue {}
extension Dictionary: SwiftDictionaryValue {}

protocol ArrayValue: CollectionValue {}
extension NSArray: ArrayValue {}
protocol SwiftArrayValue: ArrayValue {}
extension Array: SwiftArrayValue {}

protocol SetValue: CollectionValue {}
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
extension CGFloat: FloatValue {}

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

protocol URLValue {
    init(fileURLWithPath: String)
    init?(string: String)
}
extension NSURL: URLValue {}
extension URL: URLValue {}

protocol DataValue {}
extension NSData: DataValue {}
extension Data: DataValue {}

// MARK: - operators
postfix operator ~!

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
