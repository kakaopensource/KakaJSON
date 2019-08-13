//
//  ClassType.swift
//  KakaJSON
//
//  Created by MJ Lee on 2019/7/31.
//  Copyright © 2019 MJ Lee. All rights reserved.
//

public class ClassType: ModelType, PropertyType, LayoutType {
    private(set) var layout: UnsafeMutablePointer<ClassLayout>!
    public private(set) var `super`: ClassType?
    private(set) var propertyOffset: Int = 0
    private(set) var instanceSize: UInt32 = 0
    private(set) var instanceAlignMask: UInt16 = 0
    public private(set) var isPureSwiftClass: Bool = false
    
    override func build() {
        super.build()
        
        layout = builtLayout()
        genericTypes = builtGenericTypes()
        properties = builtProperties()
        
        `super` = Metadata.type(layout.pointee.superclass) as? ClassType
        if let superProperties = `super`?.properties {
            properties = properties ?? []
            properties!.insert(contentsOf: superProperties, at: 0)
        }

        propertyOffset = properties?[0].offset ?? 0
        instanceSize = layout.pointee.instanceSize
        instanceAlignMask = layout.pointee.instanceAlignMask
        /// Not sure
        isPureSwiftClass = (layout.pointee.rodata ~>> UnsafePointer<UInt8>.self).pointee > 0
    }
    
    override public var description: String {
        "\(name) { kind = \(kind), properties = \(properties ?? []), genericTypes = \(genericTypes ?? []), super = \(`super` != nil ? String(describing: `super`!) : "nil") }"
    }
}
