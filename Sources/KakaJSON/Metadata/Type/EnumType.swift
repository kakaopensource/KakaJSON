//
//  EnumType.swift
//  KakaJSON
//
//  Created by MJ Lee on 2019/7/31.
//  Copyright © 2019 MJ Lee. All rights reserved.
//

public class EnumType: BaseType, NominalType, LayoutType {
    private(set) var layout: UnsafeMutablePointer<EnumLayout>!
    public private(set) var genericTypes: [Any.Type]?
    public private(set) var cases: [String]?
    
    override func build() {
        super.build()
        
        layout = builtLayout()
        genericTypes = builtGenericTypes()
        
        let description = layout.pointee.description
        let count = Int(description.pointee.numEmptyCases)
        guard count > 0 else { return }
        let descriptor = description.pointee.fields.advanced()
        cases = (0..<count).map {
            let recordPtr = descriptor.pointee.fieldRecords.ptr($0)
            return recordPtr.pointee.fieldName()
        }
    }
    
    override public var description: String {
        return "\(name) { kind = \(kind), genericTypes = \(genericTypes ?? []), cases = \(cases ?? []) }"
    }
}
