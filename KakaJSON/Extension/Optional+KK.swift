//
//  Optional+KK.swift
//  KakaJSON
//
//  Created by MJ Lee on 2019/8/5.
//  Copyright © 2019 MJ Lee. All rights reserved.
//

protocol OptionalValue {
    var kk_value: Any? { get }
    var kk_valueString: String { get }
}

extension Optional: OptionalValue {
    var kk_value: Any? {
        guard self != nil else { return nil }
        let value = self!
        guard let osc = value as? OptionalValue else {
            return value
        }
        return osc.kk_value
    }
    
    var kk_valueString: String {
        if let value = kk_value { return "\(value)" }
        return "nil"
    }
}

extension Optional: KKGenericCompatible {
    public typealias T = Wrapped
}

public extension KKGeneric where Base == Optional<T> {
    var value: Any? { return base.kk_value }
    var valueString: String { return base.kk_valueString }
    func print() {
        Swift.print(base.kk_valueString)
    }
}
