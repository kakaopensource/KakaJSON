//
//  TupleLayout.swift
//  KakaJSON
//
//  Created by MJ Lee on 2019/8/1.
//  Copyright © 2019 MJ Lee. All rights reserved.
//

struct TupleLayout: Layout {
    let kind: UnsafeRawPointer
    let numElements: Int
    let labels: UnsafeMutablePointer<CChar>
    var elements: FieldList<TupleElement>
}

struct TupleElement {
    let type: Any.Type
    let offset: Int
}
