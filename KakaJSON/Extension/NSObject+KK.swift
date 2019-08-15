//
//  NSObject+KK.swift
//  KakaJSON
//
//  Created by MJ Lee on 2019/8/15.
//  Copyright © 2019 MJ Lee. All rights reserved.
//

extension NSObject {
    static func new() -> Self {
        return self.init()
    }
    
    static func newConvertible() -> Convertible? {
        return self.init() as? Convertible
    }
}
