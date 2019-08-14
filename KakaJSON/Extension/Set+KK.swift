//
//  Set+KK.swift
//  KakaJSON
//
//  Created by MJ Lee on 2019/8/13.
//  Copyright © 2019 MJ Lee. All rights reserved.
//

extension NSSet {
    func kk_JSONValue() -> Any? {
        var arr: [Any] = []
        arr.append(contentsOf: self)
        return arr.kk_JSONValue()
    }
}

extension Set {
    func kk_JSONValue() -> Any? {
        var arr: [Any] = []
        arr.append(contentsOf: self as NSSet)
        return arr.kk_JSONValue()
    }
}
