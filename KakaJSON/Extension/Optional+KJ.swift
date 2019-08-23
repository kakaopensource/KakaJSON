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
        guard let v = self else { return nil }
        return (v as? OptionalValue)?.kj_value ?? v
    }
}
