//
//  MTJ_02_NestedModel.swift
//  KakaJSONTests
//
//  Created by MJ Lee on 2019/8/12.
//  Copyright © 2019 MJ Lee. All rights reserved.
//

import XCTest
@testable import KakaJSON

class MTJ_02_NestedModel: XCTestCase {
    func test() {
        // Equatable is only for test cases, is not necessary for Model-To-JSON.
        struct Book: Convertible, Equatable {
            var name: String = ""
            var price: Double = 0.0
        }
        
        // Equatable is only for test cases, is not necessary for Model-To-JSON.
        struct Car: Convertible, Equatable {
            var name: String = ""
            var price: Double = 0.0
        }
        
        // Equatable is only for test cases, is not necessary for Model-To-JSON.
        struct Dog: Convertible, Equatable {
            var name: String = ""
            var age: Int = 0
        }
        
        // Equatable is only for test cases, is not necessary for Model-To-JSON.
        struct Person: Convertible, Equatable {
            var name: String = "Jack"
            var car: Car? = Car(name: "Bently", price: 106.666)
            var books: [Book]? = [
                Book(name: "Fast C++", price: 666.6),
                Book(name: "Data Structure And Algorithm", price: 666.6),
            ]
            var dogs: [String: Dog]? = [
                "dog0": Dog(name: "Wang", age: 5),
                "dog1": Dog(name: "ErHa", age: 3),
            ]
        }
        
        let jsonString = Person().kj.JSONString()
        /*
         {
             "dogs" : {
                 "dog0" : {
                     "name" : "Wang",
                     "age" : 5
                 },
                 "dog1" : {
                     "name" : "ErHa",
                     "age" : 3
                 }
             },
             "books" : [
                 {
                     "price" : 666.6,
                     "name" : "Fast C++"
                 },
                 {
                     "name" : "Data Structure And Algorithm",
                     "price" : 666.6
                 }
             ],
             "name" : "Jack",
             "car" : {
                 "price" : 106.666,
                 "name" : "Bently"
             }
         }
         */
        
        XCTAssert(jsonString.contains("106.666") == true)
        XCTAssert(jsonString.contains("666.6") == true)
        XCTAssert(jsonString.contains("Data Structure And Algorithm") == true)
        
        checkModelToJSon(Person.self)
    }
    
    func testAny() {
        struct Book: Convertible {
            var name: String = ""
            var price: Double = 0.0
        }
        
        struct Dog: Convertible {
            var name: String = ""
            var age: Int = 0
        }
        
        struct Person: Convertible {
            // NSArray\NSMutableArray
            var books: [Any]? = [
                Book(name: "Fast C++", price: 666.6),
                Book(name: "Data Structure And Algorithm", price: 1666.6),
            ]
            
            // NSDictionary\NSMutableDictionary
            var dogs: [String: Any]? = [
                "dog0": Dog(name: "Wang", age: 5),
                "dog1": Dog(name: "ErHa", age: 3),
            ]
        }
        
        let jsonString = Person().kj.JSONString()
        /*
         {
             "dogs" : {
                 "dog1" : {
                     "age" : 3,
                     "name" : "ErHa"
                 },
                 "dog0" : {
                     "age" : 5,
                     "name" : "Wang"
                 }
             },
             "books" : [
                 {
                     "name" : "Fast C++",
                     "price" : 666.6
                 },
                 {
                     "price" : 1666.6,
                     "name" : "Data Structure And Algorithm"
                 }
             ]
         }
         */
        XCTAssert(jsonString.contains("1666.6") == true)
        XCTAssert(jsonString.contains("666.6") == true)
        XCTAssert(jsonString.contains("Fast C++") == true)
    }
    
    static var allTests = [
        "test": test,
        "testAny": testAny
    ]
}
