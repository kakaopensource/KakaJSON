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
        struct SBook: Convertible, Equatable {
            var name: String = ""
            var price: Double = 0.0
        }
        
        // Equatable is only for test cases, is not necessary for Model-To-JSON.
        struct SCar: Convertible, Equatable {
            var name: String = ""
            var price: Double = 0.0
        }
        
        // Equatable is only for test cases, is not necessary for Model-To-JSON.
        struct SDog: Convertible, Equatable {
            var name: String = ""
            var age: Int = 0
        }
        
        // Equatable is only for test cases, is not necessary for Model-To-JSON.
        struct SPerson: Convertible, Equatable {
            var name: String = "Jack"
            var car: SCar? = SCar(name: "Bently", price: 106.666)
            var books: [SBook]? = [
                SBook(name: "Fast C++", price: 666.6),
                SBook(name: "Data Structure And Algorithm", price: 666.6),
            ]
            var dogs: [String: SDog]? = [
                "dog0": SDog(name: "Wang", age: 5),
                "dog1": SDog(name: "ErHa", age: 3),
            ]
        }
        
        checkModelToJSon(SPerson.self)
    }
    
    func testAny() {
        // Equatable is only for test cases, is not necessary for Model-To-JSON.
        struct SBook: Convertible, Equatable {
            var name: String = ""
            var price: Double = 0.0
        }
        
        // Equatable is only for test cases, is not necessary for Model-To-JSON.
        struct SDog: Convertible, Equatable {
            var name: String = ""
            var age: Int = 0
        }
        
        struct SPerson: Convertible {
            // NSArray\NSMutableArray
            var books: [Any]? = [
                SBook(name: "Fast C++", price: 666.6),
                SBook(name: "Data Structure And Algorithm", price: 666.6),
            ]
            
            // NSDictionary\NSMutableDictionary
            var dogs: [String: Any]? = [
                "dog0": SDog(name: "Wang", age: 5),
                "dog1": SDog(name: "ErHa", age: 3),
            ]
        }
        
        let person = SPerson()
        guard let JSON = person.kk.JSON() else { fatalError() }
        
        let books0 = (JSON["books"] as? [Any])?.kk.modelArray(SBook.self)
        let books1 = person.books as? [SBook]
        XCTAssert(books0 == books1)
        
        let dogs = JSON["dogs"] as? [String: Any]
        let dog0 = (dogs?["dog0"] as? [String: Any])?.kk.model(SDog.self)
        XCTAssert(dog0 == person.dogs?["dog0"] as? SDog)
        
        let dog1 = (dogs?["dog1"] as? [String: Any])?.kk.model(SDog.self)
        XCTAssert(dog1 == person.dogs?["dog1"] as? SDog)
    }
}
