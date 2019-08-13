//
//  EnumLayout.swift
//  KakaJSON
//
//  Created by MJ Lee on 2019/7/31.
//  Copyright © 2019 MJ Lee. All rights reserved.
//

struct EnumLayout: NominalLayout {
    let kind: UnsafeRawPointer
    /// An out-of-line description of the type
    var description: UnsafeMutablePointer<EnumDescriptor>
}
