//
//  FunctionType.swift
//  KakaJSON
//
//  Created by MJ Lee on 2019/8/1.
//  Copyright © 2019 MJ Lee. All rights reserved.
//

public class FunctionType: BaseType, LayoutType {
    private(set) var layout: UnsafeMutablePointer<FunctionLayout>!
    public private(set) var `throws`: Bool = false
    public private(set) var returnType: Any.Type = Any.self
    public private(set) var argumentTypes: [Any.Type]?
    
    override func build() {
        super.build()
        
        layout = builtLayout()
        
        `throws` = (layout.pointee.flags & 0x01000000) != 0
        returnType = layout.pointee.parameters.item(0)
        
        let argumentsCount = layout.pointee.flags & 0x00FFFFFF
        guard argumentsCount > 0 else { return }
        var arr = [Any.Type]()
        for i in 1...argumentsCount {
            arr.append(layout.pointee.parameters.item(i))
        }
        argumentTypes = arr
    }
    
    override public var description: String {
        return "\(name) { kind = \(kind), argumentTypes = \(argumentTypes ?? []), returnType = \(returnType), throws = \(`throws`) }"
    }
}
