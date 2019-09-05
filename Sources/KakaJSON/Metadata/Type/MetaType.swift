//
//  MetaType.swift
//  KakaJSON
//
//  Created by MJ Lee on 2019/8/2.
//  Copyright © 2019 MJ Lee. All rights reserved.
//

public class MetaType: BaseType, LayoutType {
    private(set) var layout: UnsafeMutablePointer<BaseLayout>!
    
    override func build() {
        super.build()
        
        layout = builtLayout()
    }
}
