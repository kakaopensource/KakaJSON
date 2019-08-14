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
public func model<M: Convertible>(from json: JSONObject?,
                                  _ type: M.Type) -> M? {
    return json?.kk.model(type)
}

public func model(from json: JSONObject?,
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
public func JSON<M: Convertible>(from model: M?) -> JSONObject? {
    return model?.kk_JSON()
}

public func JSON(from models: [Any]?) -> JSONArray? {
    return models?.kk.JSON()
}

public func JSONString<M: Convertible>(from model: M?,
                                       prettyPrinted: Bool = false) -> String? {
    return model?.kk_JSONString(prettyPrinted: prettyPrinted)
}

public func JSONString(from models: [Any]?,
                       prettyPrinted: Bool = false) -> String? {
    return models?.kk.JSONString(prettyPrinted: prettyPrinted)
}
