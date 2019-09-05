//
//  MTJ_03_ModelArray.swift
//  KakaJSONTests
//
//  Created by MJ Lee on 2019/8/12.
//  Copyright © 2019 MJ Lee. All rights reserved.
//

import XCTest
@testable import KakaJSON

class MTJ_03_ModelArray: XCTestCase {

    func testArray() {
        struct Car: Convertible {
            var name: String = ""
            var price: Double = 0.0
        }
        
        // NSArray\NSMutableArray
        let models = [
            Car(name: "BMW", price: 100.0),
            Car(name: "Audi", price: 70.0),
            Car(name: "Bently", price: 300.0)
        ]
        
        let jsonString = models.kj.JSONString()
        /*
         [
             {
                 "name" : "BMW",
                 "price" : 100
             },
             {
                 "price" : 70,
                 "name" : "Audi"
             },
             {
                 "price" : 300,
                 "name" : "Bently"
             }
         ]
         */
        XCTAssert(jsonString.contains("BMW") == true)
        XCTAssert(jsonString.contains("100") == true)
        XCTAssert(jsonString.contains("Audi") == true)
        XCTAssert(jsonString.contains("70") == true)
        XCTAssert(jsonString.contains("Bently") == true)
        XCTAssert(jsonString.contains("300") == true)
    }
    
    func testSet() {
        struct Car: Convertible, Hashable {
            var name: String = ""
            var price: Double = 0.0
        }
        
        let models: Set<Car> = [
            Car(name: "BMW", price: 100.0),
            Car(name: "Audi", price: 70.0),
            Car(name: "Bently", price: 300.0)
        ]
        
        let jsonString = models.kj.JSONString()
        /*
         [
             {
                 "price" : 70,
                 "name" : "Audi"
             },
             {
                 "price" : 300,
                 "name" : "Bently"
             },
             {
                 "name" : "BMW",
                 "price" : 100
             }
         ]
         */
        XCTAssert(jsonString.contains("BMW") == true)
        XCTAssert(jsonString.contains("100") == true)
        XCTAssert(jsonString.contains("Audi") == true)
        XCTAssert(jsonString.contains("70") == true)
        XCTAssert(jsonString.contains("Bently") == true)
        XCTAssert(jsonString.contains("300") == true)
    }
    
    static var allTests = [
        "testArray": testArray,
        "testSet": testSet
    ]
}
