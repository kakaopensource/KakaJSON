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

// MARK: - JSON -> Model
public func model<M: Convertible>(from json: [String: Any]?,
                                  _ type: M.Type) -> M? {
    return json?.kk.model(type)
}

public func model(from json: [String: Any]?,
                  anyType: Any.Type) -> Any? {
    return json?.kk.model(anyType: anyType)
}

public func model<M: Convertible>(from jsonString: String?,
                                  _ type: M.Type) -> M? {
    return jsonString?.kk.model(type)
}

public func model(from jsonString: String?,
                  anyType: Any.Type) -> Any? {
    return jsonString?.kk.model(anyType: anyType)
}

public func modelArray<M: Convertible>(from json: [Any]?,
                                       _ type: M.Type) -> [M]? {
    return json?.kk.modelArray(type)
}

public func modelArray(from json: [Any]?,
                       anyType: Any.Type) -> [Any?]? {
    return json?.kk.modelArray(anyType: anyType)
}

public func modelArray<M: Convertible>(from jsonString: String?,
                                       _ type: M.Type) -> [M]? {
    return jsonString?.kk.modelArray(type)
}

public func modelArray(from jsonString: String?,
                       anyType: Any.Type) -> [Any]? {
    return jsonString?.kk.modelArray(anyType: anyType)
}

// MARK: Model -> JSON
public func JSONObject<M: Convertible>(from model: M?) -> [String: Any]? {
    return model?.kk_JSONObject()
}

public func JSONObjectArray<M: Convertible>(from models: [M]?) -> [[String: Any]]? {
    return models?.kk.JSONObjectArray()
}

public func JSON(from value: Any?) -> Any? {
    return value.kk_JSON()
}

public func JSONString(from value: Any?,
                       prettyPrinted: Bool = false) -> String? {
    return value.kk_JSONString()
}
