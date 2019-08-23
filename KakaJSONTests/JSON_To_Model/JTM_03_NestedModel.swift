//
//  JTM_03_NestedModel.swift
//  KakaJSONTests
//
//  Created by MJ Lee on 2019/8/10.
//  Copyright © 2019 MJ Lee. All rights reserved.
//

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
        XCTAssert(person?.name == "Jack")
        XCTAssert(person?.parent?.name == "Jim")
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
            let code: Int = 0
        }
        
        let json1 = """
        {
            "data": {"nickName": "KaKa", "id": 213234234},
            "msg": "Success",
            "code" : 200
        }
        """
        let response1 = json1.kj.model(NetResponse<User>.self)
        let user = response1?.data
        XCTAssert(user?.nickName == "KaKa")
        XCTAssert(user?.id == "213234234")
        
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
        let goods = response2?.data
        XCTAssert(goods?.count == 3)
        XCTAssert(goods?[0].price == 6199)
        XCTAssert(goods?[0].name == "iPhone XR")
        XCTAssert(goods?[1].price == 8199)
        XCTAssert(goods?[1].name == "iPhone XS")
        XCTAssert(goods?[2].price == 9099)
        XCTAssert(goods?[2].name == "iPhone Max")
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
        XCTAssert(person?.name == name)
        
        XCTAssert(person?.books?.count == 1)
        let book = person?.books?.randomElement()
        XCTAssert(book?.name == bookName)
        XCTAssert(book?.price == bookPrice)
    }
}
