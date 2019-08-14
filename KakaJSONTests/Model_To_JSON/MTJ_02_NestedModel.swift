//
//  MTJ_02_NestedModel.swift
//  KakaJSONTests
//
//  Created by MJ Lee on 2019/8/12.
//  Copyright © 2019 MJ Lee. All rights reserved.
//

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
        
        checkModelToJSon(Person.self)
    }
    
    func testAny() {
        // Equatable is only for test cases, is not necessary for Model-To-JSON.
        struct Book: Convertible, Equatable {
            var name: String = ""
            var price: Double = 0.0
        }
        
        // Equatable is only for test cases, is not necessary for Model-To-JSON.
        struct Dog: Convertible, Equatable {
            var name: String = ""
            var age: Int = 0
        }
        
        struct Person: Convertible {
            // NSArray\NSMutableArray
            var books: [Any]? = [
                Book(name: "Fast C++", price: 666.6),
                Book(name: "Data Structure And Algorithm", price: 666.6),
            ]
            
            // NSDictionary\NSMutableDictionary
            var dogs: [String: Any]? = [
                "dog0": Dog(name: "Wang", age: 5),
                "dog1": Dog(name: "ErHa", age: 3),
            ]
        }
        
        let person = Person()
        guard let JSON = person.kk.JSON() else { fatalError() }
        
        let books0 = (JSON["books"] as? [Any])?.kk.modelArray(Book.self)
        let books1 = person.books as? [Book]
        XCTAssert(books0 == books1)
        
        let dogs = JSON["dogs"] as? [String: Any]
        let dog0 = (dogs?["dog0"] as? [String: Any])?.kk.model(Dog.self)
        XCTAssert(dog0 == person.dogs?["dog0"] as? Dog)
        
        let dog1 = (dogs?["dog1"] as? [String: Any])?.kk.model(Dog.self)
        XCTAssert(dog1 == person.dogs?["dog1"] as? Dog)
    }
}
