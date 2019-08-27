//
//  NSObject+KJ.swift
//  KakaJSON
//
//  Created by MJ Lee on 2019/8/15.
//  Copyright © 2019 MJ Lee. All rights reserved.
//

import Foundation

extension NSObject {
    static func newConvertible() -> Convertible {
        return self.init() as! Convertible
    }
}
