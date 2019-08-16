//
//  JTM_03_NestedModel.swift
//  KakaJSONTests
//
//  Created by MJ Lee on 2019/8/10.
//  Copyright © 2019 MJ Lee. All rights reserved.
//

class JTM_03_NestedModel: XCTestCase {
    func test() {
        struct Book: Convertible {
            var name: String = ""
            var price: Double = 0.0
        }
        
        struct Car: Convertible {
            var name: String = ""
            var price: Double = 0.0
        }
        
        struct Dog: Convertible {
            var name: String = ""
            var age: Int = 0
        }
        
        struct Person: Convertible {
            var name: String = ""
            var car: Car?
            var books: [Book]?
            var dogs: [String: Dog]?
        }
        
        let name = "Jack"
        let car = (name: "BMW7", price: 109.5)
        let books = [
            (name: "Fast C++", price: 666),
            (name: "Data Structure And Algorithm", price: 1666)
        ]
        let dogs = [
            (name: "Larry", age: 5),
            (name: "Wangwang", age: 2)
        ]
        
        let json: [String: Any] = [
            "name": name,
            "car": ["name": car.name, "price": car.price],
            "books": [
                ["name": books[0].name, "price": books[0].price],
                ["name": books[1].name, "price": books[1].price]
            ],
            "dogs": [
                "dog0": ["name": dogs[0].name, "age": dogs[0].age],
                "dog1": ["name": dogs[1].name, "age": dogs[1].age]
            ]
        ]
        
        let person = json.kk.model(Person.self)
        XCTAssert(person?.name == name)
        
        XCTAssert(person?.car?.name == car.name)
        XCTAssert(person?.car?.price == car.price)
        
        XCTAssert(person?.books?.count == books.count)
        XCTAssert(person?.books?[0].name == books[0].name)
        XCTAssert(person?.books?[0].price == Double(books[0].price))
        XCTAssert(person?.books?[1].name == books[1].name)
        XCTAssert(person?.books?[1].price == Double(books[1].price))
        
        XCTAssert(person?.dogs?.count == dogs.count)
        XCTAssert(person?.dogs?["dog0"]?.name == dogs[0].name)
        XCTAssert(person?.dogs?["dog0"]?.age == dogs[0].age)
        XCTAssert(person?.dogs?["dog1"]?.name == dogs[1].name)
        XCTAssert(person?.dogs?["dog1"]?.age == dogs[1].age)
    }

    
    func testOptional() {
        struct Book: Convertible {
            var name: String = ""
            var price: Double = 0.0
        }
        
        struct Dog: Convertible {
            var name: String = ""
            var age: Int = 0
        }
        
        struct Person: Convertible {
            var name: String = ""
            var books: [Book??]?
            var dogs: [String: Dog???]?
        }
        
        let name = "Jack"
        let books = [
            (name: "Fast C++", price: 666),
            (name: "Data Structure And Algorithm", price: 1666)
        ]
        let dogs = [
            (name: "Larry", age: 5),
            (name: "Wangwang", age: 2)
        ]
        
        let json: [String: Any] = [
            "name": name,
            "books": [
                ["name": books[0].name, "price": books[0].price],
                ["name": books[1].name, "price": books[1].price]
            ],
            "dogs": [
                "dog0": ["name": dogs[0].name, "age": dogs[0].age],
                "dog1": ["name": dogs[1].name, "age": dogs[1].age]
            ]
        ]
        
        let person = json.kk.model(Person.self)
        XCTAssert(person?.name == name)
        
        XCTAssert(person?.books?.count == books.count)
        XCTAssert(person?.books?[0]??.name == books[0].name)
        XCTAssert(person?.books?[0]??.price == Double(books[0].price))
        XCTAssert(person?.books?[1]??.name == books[1].name)
        XCTAssert(person?.books?[1]??.price == Double(books[1].price))
        
        XCTAssert(person?.dogs?.count == dogs.count)
        XCTAssert(person?.dogs?["dog0"]????.name == dogs[0].name)
        XCTAssert(person?.dogs?["dog0"]????.age == dogs[0].age)
        XCTAssert(person?.dogs?["dog1"]????.name == dogs[1].name)
        XCTAssert(person?.dogs?["dog1"]????.age == dogs[1].age)
    }
}
