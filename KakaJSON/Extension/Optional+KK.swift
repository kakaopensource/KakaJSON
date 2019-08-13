//
//  Optional+KK.swift
//  KakaJSON
//
//  Created by MJ Lee on 2019/8/5.
//  Copyright © 2019 MJ Lee. All rights reserved.
//

protocol OptionalValue {
    var _value: Any? { get }
    var _valueString: String { get }
}

extension Optional: OptionalValue {
    var _value: Any? {
        guard self != nil else { return nil }
        let value = self!
        guard let osc = value as? OptionalValue else {
            return value
        }
        return osc._value
    }
    
    var _valueString: String {
        if let value = _value { return "\(value)" }
        return "nil"
    }
}

extension Optional: KKGenericCompatible {
    public typealias T = Wrapped
}
public extension KKGeneric where Base == Optional<T> {
    var valueString: String { base._valueString }
    func print() {
        Swift.print(base._valueString)
    }
}
