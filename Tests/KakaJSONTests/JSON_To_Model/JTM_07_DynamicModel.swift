//
//  JTM_07_DynamicModel.swift
//  KakaJSONTests
//
//  Created by MJ Lee on 2019/8/12.
//  Copyright © 2019 MJ Lee. All rights reserved.
//

import XCTest
@testable import KakaJSON

class JTM_07_DynamicModel: XCTestCase {
    class Book: Convertible {
        var name: String = ""
        var price: Double = 0.0
        required init() {}
    }
    
    class Car: Convertible {
        var name: String = ""
        var price: Double = 0.0
        required init() {}
    }
    
    class Pig: Convertible {
        var name: String = ""
        var height: Double = 0.0
        required init() {}
    }
    
    class Dog: Convertible {
        var name: String = ""
        var weight: Double = 0.0
        required init() {}
    }
    
    struct Person: Convertible {
        var name: String = ""
        // AnyObject、Convertible
        var pet: Any?
        // [AnyObject]、[Convertible]、NSArray、NSMutableArray
        var toys: [Any]?
        // [String: AnyObject]、[String: Convertible]
        // NSDictionary、NSMutableDictionary
        var foods: [String: Any]?
        
        func kj_modelType(from jsonValue: Any?,
                          _ property: Property) -> Convertible.Type? {
            switch property.name {
            case "pet":
                if let pet = jsonValue as? [String: Any],
                    let _ = pet["height"] {
                    return Pig.self
                }
                return Dog.self
            case "toys": return Car.self
            case "foods": return Book.self
            default: return nil
            }
        }
    }
    
    func test() {
        let name = "Jack"
        let dog = (name: "Wang", weight: 109.5)
        let pig = (name: "Keke", height: 1.55)
        let books = [
            (name: "Fast C++", price: 666.0),
            (name: "Data Structure And Algorithm", price: 1666.0)
        ]
        let cars = [
            (name: "Benz", price: 100.5),
            (name: "Bently", price: 300.6)
        ]
        
        let json: [String: Any] = [
            "name": name,
            "pet": ["name": dog.name, "weight": dog.weight],
//            "pet": ["name": pig.name, "height": pig.height],
            "toys": [
                ["name": cars[0].name, "price": cars[0].price],
                ["name": cars[1].name, "price": cars[1].price]
            ],
            "foods": [
                "food0": ["name": books[0].name, "price": books[0].price],
                "food1": ["name": books[1].name, "price": books[1].price]
            ]
        ]
        
        let person = json.kj.model(Person.self)
        XCTAssert(person.name == name)
        
        if let pet = person.pet as? Dog {
            XCTAssert(pet.name == dog.name)
            XCTAssert(pet.weight == dog.weight)
        } else if let pet = person.pet as? Pig {
            XCTAssert(pet.name == pig.name)
            XCTAssert(pet.height == pig.height)
        }
        
        let toy0 = person.toys?[0] as? Car
        XCTAssert(toy0?.name == cars[0].name)
        XCTAssert(toy0?.price == cars[0].price)
        
        let toy1 = person.toys?[1] as? Car
        XCTAssert(toy1?.name == cars[1].name)
        XCTAssert(toy1?.price == cars[1].price)
        
        let food0 = person.foods?["food0"] as? Book
        XCTAssert(food0?.name == books[0].name)
        XCTAssert(food0?.price == books[0].price)
        
        let food1 = person.foods?["food1"] as? Book
        XCTAssert(food1?.name == books[1].name)
        XCTAssert(food1?.price == books[1].price)
    }
    
    static var allTests = [
        "test": test
    ]
}
