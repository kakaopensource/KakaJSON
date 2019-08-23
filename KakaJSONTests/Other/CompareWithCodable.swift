//
//  CompareWithCodable.swift
//  KakaJSONTests
//
//  Created by MJ Lee on 2019/8/18.
//  Copyright © 2019 MJ Lee. All rights reserved.
//

class CompareWithCodable: XCTestCase {
    struct Cat: Codable {
        var weight: Double = 0.0
        var name: String = ""
    }
    
    func testCodable() {
        let jsonData = """
        {
        "name": "Miaomiao",
        "weight": 1.66
        }
        """.data(using: .utf8)!
        
        let cat = try! JSONDecoder().decode(Cat.self, from: jsonData)
        XCTAssert(cat.name == "Miaomiao")
        XCTAssert(cat.weight == 1.66)
    }
}
