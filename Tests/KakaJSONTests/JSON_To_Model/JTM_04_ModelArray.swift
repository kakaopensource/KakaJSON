//
//  JTM_04_ModelArray.swift
//  KakaJSONTests
//
//  Created by MJ Lee on 2019/8/10.
//  Copyright © 2019 MJ Lee. All rights reserved.
//

import XCTest
@testable import KakaJSON

class JTM_04_ModelArray: XCTestCase {
    let tuples = [
        (name: "BMW", price: 100.0),
        (name: "Audi", price: 70.0),
        (name: "Bently", price: 300.0)
    ]
    
    struct Car: Convertible {
        var name: String = ""
        var price: Double = 0.0
    }
    
    func testArray() {
        let json: [[String: Any]] = [
            ["name": tuples[0].name, "price": tuples[0].price],
            ["name": tuples[1].name, "price": tuples[1].price],
            ["name": tuples[2].name, "price": tuples[2].price]
        ]
        
        let cars = json.kj.modelArray(Car.self)
        check(cars)
    }
    
    func testNSArray() {
        let json = NSArray(objects:
            ["name": tuples[0].name, "price": tuples[0].price],
            ["name": tuples[1].name, "price": tuples[1].price],
            ["name": tuples[2].name, "price": tuples[2].price]
        )
        
        let cars = json.kj.modelArray(Car.self)
        check(cars)
    }
    
    func testNSMutableArray() {
        let json = NSMutableArray(objects:
            ["name": tuples[0].name, "price": tuples[0].price],
            ["name": tuples[1].name, "price": tuples[1].price],
            ["name": tuples[2].name, "price": tuples[2].price]
        )
        
        let cars = json.kj.modelArray(Car.self)
        check(cars)
    }
    
    func testSet() {
        // NSSet\NSMutableSet
        let json: Set<NSDictionary> = [
            ["name": tuples[0].name, "price": tuples[0].price]
        ]
        
        let cars = json.kj.modelArray(Car.self)
        XCTAssert(cars[0].name == tuples[0].name)
        XCTAssert(cars[0].price == tuples[0].price)
    }
    
    func testJSONString() {
        let JSONString = """
        [
            {"name":"\(tuples[0].name)","price":\(tuples[0].price)},
            {"name":"\(tuples[1].name)","price":\(tuples[1].price)},
            {"name":"\(tuples[2].name)","price":\(tuples[2].price)}
        ]
        """
        
        let cars = JSONString.kj.modelArray(Car.self)
        check(cars)
    }
    
    func check(_ cars: [Car]) {
        XCTAssert(cars.count == tuples.count)
        XCTAssert(cars[0].name == tuples[0].name)
        XCTAssert(cars[0].price == tuples[0].price)
        XCTAssert(cars[1].name == tuples[1].name)
        XCTAssert(cars[1].price == tuples[1].price)
        XCTAssert(cars[2].name == tuples[2].name)
        XCTAssert(cars[2].price == tuples[2].price)
    }
    
    static var allTests = [
        "testArray": testArray,
        "testNSArray": testNSArray,
        "testNSMutableArray": testNSMutableArray,
        "testSet": testSet,
        "testJSONString": testJSONString
    ]
}
