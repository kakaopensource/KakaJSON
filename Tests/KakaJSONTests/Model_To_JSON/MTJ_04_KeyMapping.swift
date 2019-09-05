//
//  MTJ_04_KeyMapping.swift
//  KakaJSONTests
//
//  Created by MJ Lee on 2019/8/13.
//  Copyright © 2019 MJ Lee. All rights reserved.
//

import XCTest
@testable import KakaJSON

class MTJ_04_KeyMapping: XCTestCase {
    struct Dog: Convertible {
        var nickName: String = "Wang"
        var price: Double = 100.6
        
        func kj_JSONKey(from property: Property) -> JSONPropertyKey {
            switch property.name {
            case "nickName": return "_nick_name_"
            default: return property.name
            }
        }
    }
    
    func test() {
        let jsonString = Dog().kj.JSONString()
        /* {"price":100.6,"_nick_name_":"Wang"} */
        XCTAssert(jsonString.contains("_nick_name_") == true)
    }
    
    static var allTests = [
        "test": test
    ]
}
