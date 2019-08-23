//
//  Optional+KJ.swift
//  KakaJSON
//
//  Created by MJ Lee on 2019/8/5.
//  Copyright © 2019 MJ Lee. All rights reserved.
//

import Foundation

protocol OptionalValue {
    var kj_value: Any? { get }
}

extension Optional: OptionalValue {
    var kj_value: Any? {
        guard self != nil else { return nil }
        let value = self!
        guard let ov = value as? OptionalValue else {
            return value
        }
        return ov.kj_value
    }
}
