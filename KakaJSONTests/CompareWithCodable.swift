//
//  CompareWithCodable.swift
//  KakaJSONTests
//
//  Created by MJ Lee on 2019/8/18.
//  Copyright © 2019 MJ Lee. All rights reserved.
//

class CompareWithCodable: XCTestCase {
    
    struct Cat: Convertible, Codable {
        var name: String = ""
        var weight: Double = 0.0
    }
    
    /// average: 0.084 seconds in release mode
    func testKaka() {
        let json: [String: Any] = [
            "name": "Miaomiao",
            "weight": 6.66
        ]
        
        measure {
            for _ in 0...10000 {
                let cat = json.kk.model(Cat.self)
                XCTAssert(cat?.name == "Miaomiao")
                XCTAssert(cat?.weight == 6.66)
            }
        }
    }
    
    /// average: 0.117 seconds in release mode
    func testCodable() {
        let data = """
        {
            "name":"Miaomiao",
            "weight":6.66
        }
        """.data(using: .utf8)!
        measure {
            for _ in 0...10000 {
                let cat = try? JSONDecoder().decode(Cat.self,
                                                    from: data)
                XCTAssert(cat?.name == "Miaomiao")
                XCTAssert(cat?.weight == 6.66)
            }
        }
    }
}
