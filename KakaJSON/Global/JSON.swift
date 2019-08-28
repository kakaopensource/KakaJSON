//
//  JSON.swift
//  KakaJSON
//
//  Created by MJ Lee on 2019/8/2.
//  Copyright © 2019 MJ Lee. All rights reserved.
//

// MARK: Model -> JSON
public func JSONObject<M: Convertible>(from model: M) -> [String: Any] {
    return model.kj_JSONObject()
}

public func JSONObjectArray<M: Convertible>(from models: [M]) -> [[String: Any]] {
    return models.kj.JSONObjectArray()
}

//public func JSONArray(from value: [Any]) -> [Any] {
//    return value.kj.JSONArray()
//}
//
//public func JSON(from value: Any) -> Any? {
//    return Values.JSONValue(value)
//}

public func JSONString(from value: Any,
                       prettyPrinted: Bool = false) -> String {
    return Values.JSONString(value, prettyPrinted: prettyPrinted) ?? ""
}
