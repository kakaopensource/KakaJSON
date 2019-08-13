//
//  ProtocolType.swift
//  KakaJSON
//
//  Created by MJ Lee on 2019/8/1.
//  Copyright © 2019 MJ Lee. All rights reserved.
//

public class ProtocolType: BaseType, LayoutType {
    private(set) var layout: UnsafeMutablePointer<ProtocolLayout>!
    
    override func build() {
        super.build()
        
        layout = builtLayout()
    }
}
