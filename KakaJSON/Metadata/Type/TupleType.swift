//
//  TupleType.swift
//  KakaJSON
//
//  Created by MJ Lee on 2019/8/1.
//  Copyright © 2019 MJ Lee. All rights reserved.
//

public class TupleType: BaseType, LayoutType {
    private(set) var layout: UnsafeMutablePointer<TupleLayout>!
    public private(set) var properties: [Property]!
    
    override func build() {
        super.build()
        
        layout = builtLayout()
        
        let elementsCount = layout.pointee.numElements
        guard elementsCount > 0 else { return }
        var names: [String]
        if layout.pointee.labels ~>> Int.self == 0 {
            names = Array(repeating: "", count: elementsCount)
        } else {
            names = String(cString: layout.pointee.labels).components(separatedBy: " ")
        }
        properties = (0..<elementsCount).map {
            let element = layout.pointee.elements.item($0)
            return Property(name: names[$0], type: element.type, isVar: true, offset: element.offset, ownerType: type)
        }
    }
    
    override public var description: String {
        return "\(name) { kind = \(kind), properties = \(properties ?? []) }"
    }
}
