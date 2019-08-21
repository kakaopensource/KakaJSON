//
//  CompareWithCodable.swift
//  KakaJSONTests
//
//  Created by MJ Lee on 2019/8/18.
//  Copyright © 2019 MJ Lee. All rights reserved.
//

class CompareWithCodable: XCTestCase {
    struct Cat: Convertible, Codable {
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
        print(cat)
    }
    
    func testKJ() {
        let jsonData: [String: Any] =
        [
            "name": "Miaomiao",
            "weight": 1.66
        ]
        
        measure {
            for _ in 0...1000 {
                let _ = jsonData.kj.model(Cat.self)
            }
        }
    }
}
