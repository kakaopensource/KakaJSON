//
//  JTM_03_NestedModel.swift
//  KakaJSONTests
//
//  Created by MJ Lee on 2019/8/10.
//  Copyright © 2019 MJ Lee. All rights reserved.
//

import XCTest
@testable import KakaJSON

class JTM_03_NestedModel: XCTestCase {
    func testNormal() {
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
        
        let person = json.kj.model(Person.self)
        XCTAssert(person.name == name)
        
        XCTAssert(person.car?.name == car.name)
        XCTAssert(person.car?.price == car.price)
        
        XCTAssert(person.books?.count == books.count)
        XCTAssert(person.books?[0].name == books[0].name)
        XCTAssert(person.books?[0].price == Double(books[0].price))
        XCTAssert(person.books?[1].name == books[1].name)
        XCTAssert(person.books?[1].price == Double(books[1].price))
        
        XCTAssert(person.dogs?.count == dogs.count)
        XCTAssert(person.dogs?["dog0"]?.name == dogs[0].name)
        XCTAssert(person.dogs?["dog0"]?.age == dogs[0].age)
        XCTAssert(person.dogs?["dog1"]?.name == dogs[1].name)
        XCTAssert(person.dogs?["dog1"]?.age == dogs[1].age)
    }
    
    func testDefaultValue() {
        struct Car: Convertible {
            var name: String = ""
            var price: Double = 0.0
        }
        
        class Dog: Convertible {
            var name: String = ""
            var age: Int = 0
            required init() {}
            init(name: String, age: Int) {
                self.name = name
                self.age = age
            }
        }
        
        struct Person: Convertible {
            var name: String = ""
            // KakaJSON will use your defaultValue instead of creating a new model
            // KakaJSON will not creat a new model again if you already have a default model value
            var car: Car = Car(name: "Bently", price: 106.5)
            var dog: Dog = Dog(name: "Larry", age: 5)
        }
        
        let json: [String: Any] = [
            "name": "Jake",
            "car": ["price": 305.6],
            "dog": ["name": "Wangwang"]
        ]
        
        let person = json.kj.model(Person.self)
        XCTAssert(person.name == "Jake")
        // keep defaultValue
        XCTAssert(person.car.name == "Bently")
        // use value from json
        XCTAssert(person.car.price == 305.6)
        // use value from json
        XCTAssert(person.dog.name == "Wangwang")
        // keep defaultValue
        XCTAssert(person.dog.age == 5)
    }

    func testRecursive() {
        class Person: Convertible {
            var name: String = ""
            var parent: Person?
            required init() {}
        }
        
        let json: [String: Any] = [
            "name": "Jack",
            "parent": ["name": "Jim"]
        ]
        
        let person = json.kj.model(Person.self)
        XCTAssert(person.name == "Jack")
        XCTAssert(person.parent?.name == "Jim")
    }
    
    func testGeneric() {
        struct User: Convertible {
            let id: String = ""
            let nickName: String = ""
        }
        
        struct Goods: Convertible {
            private(set) var price: CGFloat = 0.0
            let name: String = ""
        }
        
        struct NetResponse<Element>: Convertible {
            let data: Element? = nil
            let msg: String = ""
            private(set) var code: Int = 0
        }
        
        let json1 = """
        {
            "data": {"nickName": "KaKa", "id": 213234234},
            "msg": "Success",
            "code" : 200
        }
        """
        let response1 = json1.kj.model(NetResponse<User>.self)
        XCTAssert(response1?.msg == "Success")
        XCTAssert(response1?.code == 200)
        XCTAssert(response1?.data?.nickName == "KaKa")
        XCTAssert(response1?.data?.id == "213234234")
        
        let json2 = """
        {
            "data": [
                {"price": "6199", "name": "iPhone XR"},
                {"price": "8199", "name": "iPhone XS"},
                {"price": "9099", "name": "iPhone Max"}
            ],
            "msg": "Success",
            "code" : 200
        }
        """
        let response2 = json2.kj.model(NetResponse<[Goods]>.self)
        XCTAssert(response2?.msg == "Success")
        XCTAssert(response2?.code == 200)
        XCTAssert(response2?.data?.count == 3)
        XCTAssert(response2?.data?[0].price == 6199)
        XCTAssert(response2?.data?[0].name == "iPhone XR")
        XCTAssert(response2?.data?[1].price == 8199)
        XCTAssert(response2?.data?[1].name == "iPhone XS")
        XCTAssert(response2?.data?[2].price == 9099)
        XCTAssert(response2?.data?[2].name == "iPhone Max")
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
        
        let person = json.kj.model(Person.self)
        XCTAssert(person.name == name)
        
        XCTAssert(person.books?.count == books.count)
        XCTAssert(person.books?[0]??.name == books[0].name)
        XCTAssert(person.books?[0]??.price == Double(books[0].price))
        XCTAssert(person.books?[1]??.name == books[1].name)
        XCTAssert(person.books?[1]??.price == Double(books[1].price))
        
        XCTAssert(person.dogs?.count == dogs.count)
        XCTAssert(person.dogs?["dog0"]????.name == dogs[0].name)
        XCTAssert(person.dogs?["dog0"]????.age == dogs[0].age)
        XCTAssert(person.dogs?["dog1"]????.name == dogs[1].name)
        XCTAssert(person.dogs?["dog1"]????.age == dogs[1].age)
    }
    
    func testSet() {
        struct Book: Convertible, Hashable {
            var name: String = ""
            var price: Double = 0.0
        }
        
        struct Person: Convertible {
            var name: String = ""
            var books: Set<Book>?
        }
        
        let name = "Jack"
        let bookName = "Fast C++"
        let bookPrice = 666.6
        
        let json: [String: Any] = [
            "name": name,
            "books": [
                ["name": bookName, "price": bookPrice]
            ]
        ]
        
        let person = json.kj.model(Person.self)
        XCTAssert(person.name == name)
        
        XCTAssert(person.books?.count == 1)
        let book = person.books?.randomElement()
        XCTAssert(book?.name == bookName)
        XCTAssert(book?.price == bookPrice)
    }
    
    static var allTests = [
        "testNormal": testNormal,
        "testDefaultValue": testDefaultValue,
        "testRecursive": testRecursive,
        "testGeneric": testGeneric,
        "testOptional": testOptional,
        "testSet": testSet
    ]
}
