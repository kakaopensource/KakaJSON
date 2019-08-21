//
//  KakaJSON.swift
//  KakaJSON
//
//  Created by MJ Lee on 2019/8/2.
//  Copyright © 2019 MJ Lee. All rights reserved.
//

/*
 Reference:
 0. https://github.com/apple/swift/blob/master/docs/ABI/TypeMetadata.rst
 1. https://github.com/apple/swift/blob/master/include/swift/ABI/MetadataKind.def
 2. https://github.com/apple/swift/blob/master/include/swift/ABI/Metadata.h
 3. https://github.com/apple/swift/blob/master/include/swift/ABI/MetadataValues.h
 4. https://github.com/apple/swift/blob/master/utils/dtrace/runtime.d
 5. https://github.com/apple/swift/blob/master/include/swift/Reflection/Records.h
 */

import Foundation

// MARK: - JSON -> Model
public func model<M: Convertible>(from json: [String: Any]?,
                                  _ type: M.Type) -> M? {
    return json?.kj.model(type)
}

public func model(from json: [String: Any]?,
                  anyType: Any.Type) -> Any? {
    return json?.kj.model(anyType: anyType)
}

public func model<M: Convertible>(from json: NSDictionary?,
                                  _ type: M.Type) -> M? {
    return json?.kj.model(type)
}

public func model(from json: NSDictionary?,
                  anyType: Any.Type) -> Any? {
    return json?.kj.model(anyType: anyType)
}

public func model<M: Convertible>(from jsonString: String?,
                                  _ type: M.Type) -> M? {
    return jsonString?.kj.model(type)
}

public func model(from jsonString: String?,
                  anyType: Any.Type) -> Any? {
    return jsonString?.kj.model(anyType: anyType)
}

public func model<M: Convertible>(from jsonString: NSString?,
                                  _ type: M.Type) -> M? {
    return jsonString?.kj.model(type)
}

public func model(from jsonString: NSString?,
                  anyType: Any.Type) -> Any? {
    return jsonString?.kj.model(anyType: anyType)
}

public func model<M: Convertible>(from jsonData: Data?,
                                  _ type: M.Type) -> M? {
    return jsonData?.kj.model(type)
}

public func model(from jsonData: Data?,
                  anyType: Any.Type) -> Any? {
    return jsonData?.kj.model(anyType: anyType)
}

public func model<M: Convertible>(from jsonData: NSData?,
                                  _ type: M.Type) -> M? {
    return jsonData?.kj.model(type)
}

public func model(from jsonData: NSData?,
                  anyType: Any.Type) -> Any? {
    return jsonData?.kj.model(anyType: anyType)
}

public func modelArray<M: Convertible>(from json: [Any]?,
                                       _ type: M.Type) -> [M]? {
    return json?.kj.modelArray(type)
}

public func modelArray(from json: [Any]?,
                       anyType: Any.Type) -> [Any?]? {
    return json?.kj.modelArray(anyType: anyType)
}

public func modelArray<M: Convertible>(from json: NSArray?,
                                       _ type: M.Type) -> [M]? {
    return json?.kj.modelArray(type)
}

public func modelArray(from json: NSArray?,
                       anyType: Any.Type) -> [Any?]? {
    return json?.kj.modelArray(anyType: anyType)
}

public func modelArray<M: Convertible>(from jsonString: String?,
                                       _ type: M.Type) -> [M]? {
    return jsonString?.kj.modelArray(type)
}

public func modelArray(from jsonString: String?,
                       anyType: Any.Type) -> [Any]? {
    return jsonString?.kj.modelArray(anyType: anyType)
}

public func modelArray<M: Convertible>(from jsonString: NSString?,
                                       _ type: M.Type) -> [M]? {
    return jsonString?.kj.modelArray(type)
}

public func modelArray(from jsonString: NSString?,
                       anyType: Any.Type) -> [Any]? {
    return jsonString?.kj.modelArray(anyType: anyType)
}

public func modelArray<M: Convertible>(from jsonData: Data?,
                                       _ type: M.Type) -> [M]? {
    return jsonData?.kj.modelArray(type)
}

public func modelArray(from jsonData: Data?,
                       anyType: Any.Type) -> [Any]? {
    return jsonData?.kj.modelArray(anyType: anyType)
}

public func modelArray<M: Convertible>(from jsonData: NSData?,
                                       _ type: M.Type) -> [M]? {
    return jsonData?.kj.modelArray(type)
}

public func modelArray(from jsonData: NSData?,
                       anyType: Any.Type) -> [Any]? {
    return jsonData?.kj.modelArray(anyType: anyType)
}

// MARK: Model -> JSON
public func JSONObject<M: Convertible>(from model: M?) -> [String: Any]? {
    return model?.kj_JSONObject()
}

public func JSONObjectArray<M: Convertible>(from models: [M]?) -> [[String: Any]]? {
    return models?.kj.JSONObjectArray()
}

public func JSONArray(from value: [Any]?) -> [Any]? {
    return value.kj_JSON() as? [Any]
}

public func JSON(from value: Any?) -> Any? {
    return value.kj_JSON()
}

public func JSONString(from value: Any?,
                       prettyPrinted: Bool = false) -> String? {
    return value.kj_JSONString()
}
