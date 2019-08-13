//
//  FunctionLayout.swift
//  KakaJSON
//
//  Created by MJ Lee on 2019/8/1.
//  Copyright © 2019 MJ Lee. All rights reserved.
//

struct FunctionLayout: Layout {
    let kind: UnsafeRawPointer
    var flags: Int
    var parameters: FieldList<Any.Type>
}
