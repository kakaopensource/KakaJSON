//
//  Set+KK.swift
//  KakaJSON
//
//  Created by MJ Lee on 2019/8/13.
//  Copyright © 2019 MJ Lee. All rights reserved.
//

extension NSSet {
    func _JSONValue() -> Any? {
        var arr: [Any] = []
        arr.append(contentsOf: self)
        return arr._JSONValue()
    }
}

extension Set {
    func _JSONValue() -> Any? {
        var arr: [Any] = []
        arr.append(contentsOf: self as NSSet)
        return arr._JSONValue()
    }
}
