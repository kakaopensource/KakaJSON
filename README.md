# KakaJSON
[![pod](https://img.shields.io/cocoapods/v/KakaJSON.svg)](https://github.com/CocoaPods/CocoaPods) [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage) [![SwiftPM compatible](https://img.shields.io/badge/SwiftPM-Compatible-brightgreen.svg)](https://swift.org/package-manager/)

>  Fast conversion between JSON and model in Swift.

- Convert model to JSON with one line of code.（一行代码Model转JSON）
- Convert JSON to Model with one line of code.（一行代码JSON转Model）
- Archive\Unarchive object with one line of code.（一行代码实现常见数据的归档\解档）



## 中文教程
- [KakaJSON手册](https://www.cnblogs.com/mjios/p/11352776.html)



## Integration

### CocoaPods
```ruby
pod 'KakaJSON', '~> 1.1.2' 
```

### Carthage
```ruby
github "kakaopensource/KakaJSON" ~> 1.1.2
```

### Swift Package Manager

To use Swift Package Manager, you should update to Xcode 11.
* Open your project.
* Click File tab
* Select Swift Packages 
* Add Package Dependency, enter [KakaJSON repo's URL](https://github.com/kakaopensource/KakaJSON.git)

Or you can login Xcode with your GitHub account. just search **KakaJSON**.



## Usages
- [Coding](#coding)
- [JSON To Model_01_Basic Usage](#json-to-model_01_basic-usage)
  - [Simple Model](#simple-model)
  - [Class Type](#class-type)
  - [Inheritance](#inheritance)
  - [let](#let)
  - [NSNull](#nsnull)
  - [JSONString](#jsonstring)
  - [JSONData](#jsondata)
  - [Nested Model 1](#nested-model-1)
  - [Nested Model 2](#nested-model-2)
  - [Nested Model 3](#nested-model-3)
  - [Recursive](#recursive)
  - [Generic](#generic)
  - [Model Array](#model-array)
  - [Model Array In Dictionary](#model-array-in-dictionary)
  - [Convert](#convert)
  - [Listen](#listen)
- [JSON To Model_02_Data Type](#json-to-model_02_data-type)
  - [Int](#int)
  - [Float](#float)
  - [Double](#double)
  - [CGFloat](#cgfloat)
  - [Bool](#bool)
  - [String](#string)
  - [Decimal](#decimal)
  - [NSDecimalNumber](#nsdecimalnumber)
  - [NSNumber](#nsnumber)
  - [Optional](#optional)
  - [URL](#url)
  - [Data](#data)
  - [Date](#date)
  - [Enum](#enum)
  - [Enum In Array](#enum-in-array)
  - [Enum In Dictionary](#enum-in-dictionary)
  - [Enum Array In Dictionary](#enum-array-in-dictionary)
  - [Array](#array)
  - [Set](#set)
  - [Dictionary](#dictionary)
- [JSON To Model_03_Key Mapping](#json-to-model_03_key-mapping)
  - [Basic Usage](#basic-usage)
  - [Camel -> Underline](#camel---underline)
  - [Underline -> Camel](#underline---camel)
  - [Inheritance](#inheritance-1)
  - [Override 1](#override-1)
  - [Override 2](#override-2)
  - [Global Config](#global-config)
  - [Local Config](#local-config)
  - [Config Example 1](#config-example-1)
  - [Config Example 2](#config-example-2)
  - [Complex](#complex)
- [JSON To Model_04_Custom Value](#json-to-model_04_custom-value)
  - [Date](#date-1)
  - [Unspecific Type](#unspecific-type)
  - [Example](#example)
  - [Other Ways](#other-ways)
- [JSON To Model_05_Dynamic Model](#json-to-model_05_dynamic-model)
- [Model To JSON](#model-to-json)
	- [JSON and JSONString](#json-and-jsonstring)
	- [Optional](#optional-1)
	- [Enum](#enum-1)
	- [Nested Model](#nested-model)
	- [Any](#any)
	- [Model Array](#model-array-1)
	- [Model Set](#model-set)
	- [Key Mapping](#key-mapping-1)
	- [Custom Value](#custom-value-1)
	- [Listen](#listen)



## Coding

```swift
// file path (can be String or URL)
let file = "/Users/mj/Desktop/test.data"

/****************** String ******************/
let string1 = "123"
// wrtite String to file
write(string1, to: file)
// read String from file
let string2 = read(String.self, from: file)
XCTAssert(string2 == string1)
// read Int from file
XCTAssert(read(Int.self, from: file) == 123)

/****************** Date ******************/
let date1 = Date(timeIntervalSince1970: 1565922866)
// wrtite Date to file
write(date1, to: file)
 
// read Date from file
let date2 = read(Date.self, from: file)
XCTAssert(date2 == date1)
 
// read Int from file
XCTAssert(read(Int.self, from: file) == 1565922866)

/****************** Array ******************/
let array1 = ["Jack", "Rose"]
// wrtite [String] to file
write(array1, to: file)
 
// read [String] from file
let array2 = read([String].self, from: file)
XCTAssert(array2 == array1)
// Also support Set\Dictionary

/****************** Model ******************/
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
 
// wrtite Person to file
write(Person(), to: file)
 
// read Person from file
let person = read(Person.self, from: file)
 
XCTAssert(person?.name == "Jack")
XCTAssert(person?.car?.name == "Bently")
XCTAssert(person?.car?.price == 106.666)
XCTAssert(person?.books?.count == 2)
XCTAssert(person?.dogs?.count == 2)

/****************** Model Array ******************/
struct Car: Convertible {
    var name: String = ""
    var price: Double = 0.0
}
 
let models1 = [
    Car(name: "BMW", price: 100.0),
    Car(name: "Audi", price: 70.0)
]
// wrtite [Car] to file
write(models1, to: file)
 
// read [Car] from file
let models2 = read([Car].self, from: file)
XCTAssert(models2?.count == models1.count)
XCTAssert(models2?[0].name == "BMW")
XCTAssert(models2?[0].price == 100.0)
XCTAssert(models2?[1].name == "Audi")
XCTAssert(models2?[1].price == 70.0)

/****************** Model Set ******************/
struct Car: Convertible, Hashable {
    var name: String = ""
    var price: Double = 0.0
}
 
let models1: Set<Car> = [
    Car(name: "BMW", price: 100.0),
    Car(name: "Audi", price: 70.0)
]
 
// wrtite Set<Car> to file
write(models1, to: file)
 
// read Set<Car> from file
let models2 = read(Set<Car>.self, from: file)!
XCTAssert(models2.count == models1.count)
for car in models2 {
    XCTAssert(["BMW", "Audi"].contains(car.name))
    XCTAssert([100.0, 70.0].contains(car.price))
}

/****************** Model Dictionary ******************/
struct Car: Convertible {
    var name: String = ""
    var price: Double = 0.0
}
 
let models1 = [
    "car0": Car(name: "BMW", price: 100.0),
    "car1": Car(name: "Audi", price: 70.0)
]
 
// wrtite [String: Car] to file
write(models1, to: file)
 
// read [String: Car] from file
let models2 = read([String: Car].self, from: file)
XCTAssert(models2?.count == models1.count)
 
let car0 = models2?["car0"]
XCTAssert(car0?.name == "BMW")
XCTAssert(car0?.price == 100.0)
 
let car1 = models2?["car1"]
XCTAssert(car1?.name == "Audi")
XCTAssert(car1?.price == 70.0)
```



## JSON To Model_01_Basic Usage

### Simple Model
```swift
struct Cat: Convertible {
    var name: String = ""
    var weight: Double = 0.0
}

// json can also be NSDictionary, NSMutableDictionary
let json: [String: Any] = [
    "name": "Miaomiao",
    "weight": 6.66
]

let cat1 = json.kj.model(Cat.self)
XCTAssert(cat1.name == "Miaomiao")
XCTAssert(cat1.weight == 6.66)

// you can call global function `model`
let cat2 = model(from: json, Cat.self)

// support type variable
var type: Convertible.Type = Cat.self
let cat3 = json.kj.model(type: type) as? Cat
let cat4 = model(from: json, type: type) as? Cat
```

### Class Type
```swift
class Cat: Convertible {
    var weight: Double = 0.0
    var name: String = ""
    // The protocol `Convertible` required an init constructor
    // for initializing an instance completely.
    required init() {}
}
let json = ...
let cat = json.kj.model(Cat.self)

// a class inherit from NSObject
class Person: NSObject, Convertible {
    var name: String = ""
    var age: Int = 0
    // must add `override` because NSObject has `init`
    required override init() {}
}
let person = json.kj.model(Person.self)

struct Dog: Convertible {
    var weight: Double = 0.0
    var name: String = ""
    // This struct don't need to implement init because compiler generates init for it
}

struct Pig: Convertible {
    var weight: Double
    var name: String
    // This struct need to implement init to initialize all the stored properties.
    init() {
        name = ""
        weight = 0.0
    }
}
```

### Inheritance
```swift
class Person: Convertible {
    var name: String = ""
    var age: Int = 0
    required init() {}
}
 
class Student: Person {
    var score: Int = 0
    var no: String = ""
}
 
let json: [String: Any] = [
    "name": "jack",
    "age": 18,
    "score": 98,
    "no": "9527"
]
 
let student = json.kj.model(Student.self)
```

### let
```swift
struct Cat: Convertible {
    // let of integer type is very restricted in release mode
    // please user `private(set) var` instead of `let`
    private(set) var weight: Double = 0.0
    let name: String = ""
}
let json = ...
let cat = json.kj.model(Cat.self)
```

### NSNull
```swift
struct Cat: Convertible {
    var weight: Double = 0.0
    var name: String = "xx"
    var data: NSNull?
}

let json: [String: Any] = [
    "name": NSNull(),
    "weight": 6.6,
    "data": NSNull()
]

let cat = json.kj.model(Cat.self)
// convert failed, keep default value
XCTAssert(cat.name == "xx")
XCTAssert(cat.weight == 6.6)
XCTAssert(cat.data == NSNull())
```

### JSONString
```swift
// jsonString can alse be NSString, NSMutableString
let jsonString = """
{
    "name": "Miaomiao",
    "weight": 6.66
}
"""
 
let cat1 = jsonString.kj.model(Cat.self)
let cat2 = model(from: jsonString, Cat.self)

var type: Convertible.Type = Cat.self
let cat3 = jsonString.kj.model(type: type) as? Cat
let cat4 = model(from: jsonString, type: type) as? Cat
```

### JSONData
```swift
// jsonData can alse be NSData, NSMutableData
let jsonData = """
{
    "name": "Miaomiao",
    "weight": 6.66
}
""".data(using: .utf8)!
 
let cat1 = jsonData.kj.model(Cat.self)
let cat2 = model(from: jsonData, Cat.self)

var type: Convertible.Type = Cat.self
let cat3 = jsonData.kj.model(type: type) as? Cat
let cat4 = model(from: jsonData, type: type) as? Cat
```

### Nested Model 1
```swift
// let all the models comform to Convertible

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
 
let json: [String: Any] = [
    "name": "Jack",
    "car": ["name": "BMW7", "price": 105.5],
    "books": [
        ["name": "Fast C++", "price": 666.6],
        ["name": "Data Structure And Algorithm", "price": 1666.6]
    ],
    "dogs": [
        "dog0": ["name": "Larry", "age": 5],
        "dog1": ["name": "ErHa", "age": 2]
    ]
]
 
let person = json.kj.model(Person.self)
XCTAssert(person.car?.name == "BMW7")
XCTAssert(person.books?[1].name == "Data Structure And Algorithm")
XCTAssert(person.dogs?["dog0"]?.name == "Larry")
```

### Nested Model 2
```swift
struct Book: Convertible, Hashable {
    var name: String = ""
    var price: Double = 0.0
}
 
struct Person: Convertible {
    var name: String = ""
    var books: Set<Book>?
}
 
let json: [String: Any] = [
    "name": "Jack",
    "books": [
        ["name": "Fast C++", "price": 666.6]
    ]
]
 
let person = json.kj.model(Person.self)
XCTAssert(person.name == "Jack")
 
XCTAssert(person.books?.count == 1)
let book = person.books?.randomElement()
XCTAssert(book?.name == "Fast C++")
XCTAssert(book?.price == 666.6)
```

### Nested Model 3
```swift
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
```

### Recursive
```swift
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
```

### Generic
```swift
struct NetResponse<Element>: Convertible {
    let data: Element? = nil
    let msg: String = ""
    private(set) var code: Int = 0
}
 
struct User: Convertible {
    let id: String = ""
    let nickName: String = ""
}
 
struct Goods: Convertible {
    private(set) var price: CGFloat = 0.0
    let name: String = ""
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
```

### Model Array
```swift
struct Car: Convertible {
    var name: String = ""
    var price: Double = 0.0
}
 
// json can also be NSArray, NSMutableArray
let json: [[String: Any]] = [
    ["name": "Benz", "price": 98.6],
    ["name": "Bently", "price": 305.7],
    ["name": "Audi", "price": 64.7]
]
 
 
let cars1 = json.kj.modelArray(Car.self)
XCTAssert(cars1[1].name == "Bently")
 
let cars2 = modelArray(from: json, Car.self)

var type: Convertible.Type = Car.self
let cars3 = json.kj.modelArray(type: type) as? [Car]
let cars4 = modelArray(from: json, type: type) as? [Car]
 
// jsonString -> Model Array
let jsonString = "...."
let cars5 = jsonString.kj.modelArray(Car.self)
let cars6 = modelArray(from: jsonString, Car.self)
let cars7 = jsonString.kj.modelArray(type: type) as? [Car]
let cars8 = modelArray(from: jsonString, type: type) as? [Car]
```

### Model Array In Dictionary
```swift
struct Book: Convertible {
    var name: String = ""
    var price: Double = 0.0
}

struct Person: Convertible {
    var name: String = ""
    var books: [String: [Book?]?]?
}

let name = "Jack"
let mobileBooks = [
    (name: "iOS", price: 10.5),
    (name: "Android", price: 8.5)
]
let serverBooks = [
    (name: "Java", price: 20.5),
    (name: "Go", price: 18.5)
]

let json: [String: Any] = [
    "name": name,
    "books": [
        "mobile": [
            ["name": mobileBooks[0].name, "price": mobileBooks[0].price],
            ["name": mobileBooks[1].name, "price": mobileBooks[1].price]
        ],
        "server": [
            ["name": serverBooks[0].name, "price": serverBooks[0].price],
            ["name": serverBooks[1].name, "price": serverBooks[1].price]
        ]
    ]
]

let person = json.kj.model(Person.self)
XCTAssert(person.name == name)
let books0 = person.books?["mobile"]
XCTAssert(books0??.count == mobileBooks.count)
for i in 0..<mobileBooks.count {
    XCTAssert(books0??[i]?.name == mobileBooks[i].name);
    XCTAssert(books0??[i]?.price == mobileBooks[i].price);
}
let books1 = person.books?["server"]
XCTAssert(books1??.count == serverBooks.count)
for i in 0..<serverBooks.count {
    XCTAssert(books1??[i]?.name == serverBooks[i].name);
    XCTAssert(books1??[i]?.price == serverBooks[i].price);
}
```

### Convert
```swift
struct Cat: Convertible {
    var name: String = ""
    var weight: Double = 0.0
}
 
let json: [String: Any] = [
    "name": "Miaomiao",
    "weight": 6.66
]
 
var cat = Cat()
// fill a cat instance with json
// .kj_m is a mutable version of .kj
cat.kj_m.convert(json)
XCTAssert(cat.name == "Miaomiao")
XCTAssert(cat.weight == 6.66)

```

### Listen
```swift
struct Car: Convertible {
    var name: String = ""
    var age: Int = 0
    
    // call when will begin to convert from json to model
    mutating func kj_willConvertToModel(from json: JSONObject) {
        print("Car - kj_willConvertToModel")
    }
    
    // call when did finish converting from json to model
    mutating func kj_didConvertToModel(from json: JSONObject) {
        print("Car - kj_didConvertToModel")
    }
}
 
let name = "Benz"
let age = 100
let car = ["name": name, "age": age].kj.model(Car.self)
// Car - kj_willConvertToModel
// Car - kj_didConvertToModel
XCTAssert(car.name == name)
XCTAssert(car.age == age)
 
/*************************************************************/
 
class Person: Convertible {
    var name: String = ""
    var age: Int = 0
    required init() {}
    
    func kj_willConvertToModel(from json: JSONObject) {
        print("Person - kj_willConvertToModel")
    }
    
    func kj_didConvertToModel(from json: JSONObject) {
        print("Person - kj_didConvertToModel")
    }
}
 
class Student: Person {
    var score: Int = 0
    
    override func kj_willConvertToModel(from json: JSONObject) {
        // call super's implementation if necessary
        super.kj_willConvertToModel(from: json)
        
        print("Student - kj_willConvertToModel")
    }
    
    override func kj_didConvertToModel(from json: JSONObject) {
        // call super's implementation if necessary
        super.kj_didConvertToModel(from: json)
        
        print("Student - kj_didConvertToModel")
    }
}
 
let name = "jack"
let age = 10
let score = 100
let student = ["name": name, "age": age, "score": score].kj.model(Student.self)
// Person - kj_willConvertToModel
// Student - kj_willConvertToModel
// Person - kj_didConvertToModel
// Student - kj_didConvertToModel
XCTAssert(student.name == name)
XCTAssert(student.age == age)
XCTAssert(student.score == score)

```



## JSON To Model_02_Data Type

### Int
```swift
struct Student: Convertible {
    var age1: Int8 = 6
    var age2: Int16 = 0
    var age3: Int32 = 0
    var age4: Int64 = 0
    var age5: UInt8 = 0
    var age6: UInt16 = 0
    var age7: UInt32 = 0
    var age8: UInt64 = 0
    var age9: UInt = 0
    var age10: Int = 0
    var age11: Int = 0
}
 
let json: [String: Any] = [
    "age1": "suan8fa8",
    "age2": "6suan8fa8",
    "age3": "6",
    "age4": 6.66,
    "age5": NSNumber(value: 6.66),
    "age6": Int32(6),
    "age7": true,
    "age8": "FALSE", 
    "age9": Decimal(6.66),
    "age10": NSDecimalNumber(value: 6.66)，
    "age11": Date(timeIntervalSince1970: 1565922866)
]
 
let student = json.kj.model(Student.self)
// convert failed，keep defualt value
XCTAssert(student.age1 == 6) 
XCTAssert(student.age2 == 6) 
XCTAssert(student.age3 == 6)
XCTAssert(student.age4 == 6)
XCTAssert(student.age5 == 6)
XCTAssert(student.age6 == 6)
// true is 1，false is 0
XCTAssert(student.age7 == 1) 
// "true"\"TRUE"\"YES"\"yes" is 1，"false"\"FALSE"\"NO"\"no" is 0
XCTAssert(student.age8 == 0) 
XCTAssert(student.age9 == 6)
XCTAssert(student.age10 == 6)
XCTAssert(student.age11 == 1565922866)
```

### Float
```swift
struct Student: Convertible {
    var height1: Float = 0.0
    var height2: Float = 0.0
    var height3: Float = 0.0
    var height4: Float = 0.0
    var height5: Float = 0.0
    var height6: Float = 0.0
    var height7: Float = 0.0
    var height8: Float = 0.0
    var height9: Float = 0.0
}
 
let json: [String: Any] = [
    "height1": "6.66suan8fa8",
    "height2": "0.12345678",
    "height3": NSDecimalNumber(string: "0.12345678"),
    "height4": Decimal(string: "0.12345678") as Any,
    "height5": 666,
    "height6": true,
    "height7": "NO",
    "height8": CGFloat(0.12345678),
    "height9": Date(timeIntervalSince1970: 1565922866)
]
 
let student = json.kj.model(Student.self)
XCTAssert(student.height1 == 6.66)
XCTAssert(student.height2 == 0.12345678)
XCTAssert(student.height3 == 0.12345678)
XCTAssert(student.height4 == 0.12345678)
XCTAssert(student.height5 == 666.0)
// true is 1.0，false is 0.0
XCTAssert(student.height6 == 1.0)
// "true"\"TRUE"\"YES"\"yes" is 1.0，"false"\"FALSE"\"NO"\"no" is 0.0
XCTAssert(student.height7 == 0.0)
XCTAssert(student.height8 == 0.12345678)
XCTAssert(student.height9 == 1565922866)
```

### Double
```swift
struct Student: Convertible {
    var height1: Double = 0.0
    var height2: Double = 0.0
    var height3: Double = 0.0
    var height4: Double = 0.0
    var height5: Double = 0.0
    var height6: Double = 0.0
    var height7: Double = 0.0
    var height8: Double = 0.0
    var height9: Double = 0.0
}
 
let json: [String: Any] = [
    "height1": "6.66suan8fa8",
    "height2": "0.1234567890123456",
    "height3": NSDecimalNumber(string: "0.1234567890123456"),
    "height4": Decimal(string: "0.1234567890123456") as Any,
    "height5": 666,
    "height6": true,
    "height7": "NO",
    "height8": CGFloat(0.1234567890123456),
    "height9": Date(timeIntervalSince1970: 1565922866)
]
 
let student = json.kj.model(Student.self)
XCTAssert(student.height1 == 6.66)
XCTAssert(student.height2 == 0.1234567890123456)
XCTAssert(student.height3 == 0.1234567890123456)
XCTAssert(student.height4 == 0.1234567890123456)
XCTAssert(student.height5 == 666.0)
// true is 1.0，false is 0.0
XCTAssert(student.height6 == 1.0)
// "true"\"TRUE"\"YES"\"yes" is 1.0，"false"\"FALSE"\"NO"\"no" is 0.0
XCTAssert(student.height7 == 0.0)
XCTAssert(student.height8 == 0.1234567890123456)
XCTAssert(student.height9 == 1565922866)
```

### CGFloat
```swift
struct Student: Convertible {
    var height1: CGFloat = 0.0
    var height2: CGFloat = 0.0
    var height3: CGFloat = 0.0
    var height4: CGFloat = 0.0
    var height5: CGFloat = 0.0
    var height6: CGFloat = 0.0
    var height7: CGFloat = 0.0
    var height8: CGFloat = 0.0
    var height9: CGFloat = 0.0
}
 
let json: [String: Any] = [
    "height1": "6.66suan8fa8",
    "height2": "0.1234567890123456",
    "height3": NSDecimalNumber(string: "0.1234567890123456"),
    "height4": Decimal(string: "0.1234567890123456") as Any,
    "height5": 666,
    "height6": true,
    "height7": "NO", 
    "height8": 0.1234567890123456, 
    "height9": Date(timeIntervalSince1970: 1565922866)
]
 
let student = json.kj.model(Student.self)
XCTAssert(student.height1 == 6.66)
XCTAssert(student.height2 == CGFloat(0.1234567890123456))
XCTAssert(student.height3 == CGFloat(0.1234567890123456))
XCTAssert(student.height4 == CGFloat(0.1234567890123456))
XCTAssert(student.height5 == 666.0)
XCTAssert(student.height6 == 1.0)
XCTAssert(student.height7 == 0.0)
XCTAssert(student.height8 == CGFloat(0.1234567890123456))
XCTAssert(student.height9 == CGFloat(1565922866))
```

### Bool
```swift
struct Student: Convertible {
    var rich1: Bool = false
    var rich2: Bool = false
    var rich3: Bool = false
    var rich4: Bool = false
    var rich5: Bool = false
    var rich6: Bool = false
}
 
let json: [String: Any] = [
    "rich1": 100,
    "rich2": 0.0,
    "rich3": "1",
    "rich4": NSNumber(value: 0.666),
    "rich5": "true",
    "rich6": "NO" 
]
 
let student = json.kj.model(Student.self)
// number 0 is false，not number 0 is true
XCTAssert(student.rich1 == true)
XCTAssert(student.rich2 == false)
XCTAssert(student.rich3 == true)
// 0.666 isn't 0，so true
XCTAssert(student.rich4 == true)
// "true"\"TRUE"\"YES"\"yes" is true
XCTAssert(student.rich5 == true)
// "false"\"FALSE"\"NO"\"no" is false
XCTAssert(student.rich6 == false)
```

### String
```swift
// Support String, NSString, NSMutableString
 
struct Student: Convertible {
    var name1: String = ""
    var name2: String = ""
    var name3: NSString = ""
    var name4: NSString = ""
    var name5: NSMutableString = ""
    var name6: NSMutableString = ""
    var name7: String = ""
    var name8: String = ""
    var name9: String = ""
}
 
let json: [String: Any] = [
    "name1": 666,
    "name2": NSMutableString(string: "777"),
    "name3": [1,[2,3],"4"],
    "name4": NSDecimalNumber(string: "0.123456789012345678901234567890123456789"),
    "name5": 6.66,
    "name6": false,
    "name7": NSURL(fileURLWithPath: "/users/mj/desktop"),
    "name8": URL(string: "http://www.520suanfa.com") as Any,
    "name9": Date(timeIntervalSince1970: 1565922866)
]
 
let student = json.kj.model(Student.self)
XCTAssert(student.name1 == "666")
XCTAssert(student.name2 == "777")
// call array's description
XCTAssert(student.name3 == "[1, [2, 3], \"4\"]")
XCTAssert(student.name4 == "0.123456789012345678901234567890123456789")
XCTAssert(student.name5 == "6.66")
XCTAssert(student.name6 == "false")
XCTAssert(student.name7 == "file:///users/mj/desktop")
XCTAssert(student.name8 == "http://www.520suanfa.com")
XCTAssert(student.name9 == "1565922866")
```

### Decimal
```swift
struct Student: Convertible {
    var money1: Decimal = 0
    var money2: Decimal = 0
    var money3: Decimal = 0
    var money4: Decimal = 0
    var money5: Decimal = 0
    var money6: Decimal = 0
    var money7: Decimal = 0
    var money8: Decimal = 0
}
 
let json: [String: Any] = [
    "money1": 0.1234567890123456,
    "money2": true,
    "money3": NSDecimalNumber(string: "0.123456789012345678901234567890123456789"),
    "money4": "0.123456789012345678901234567890123456789",
    "money5": 666,
    "money6": "NO",
    "money7": CGFloat(0.1234567890123456),
    "money8": Date(timeIntervalSince1970: 1565922866)
]
 
let student = json.kj.model(Student.self)
XCTAssert(student.money1 == Decimal(string: "0.1234567890123456"))
XCTAssert(student.money2 == 1)
XCTAssert(student.money3 == Decimal(string: "0.123456789012345678901234567890123456789"))
XCTAssert(student.money4 == Decimal(string: "0.123456789012345678901234567890123456789"))
XCTAssert(student.money5 == 666)
XCTAssert(student.money6 == 0)
XCTAssert(student.money7 == Decimal(string: "0.1234567890123456"))
XCTAssert(student.money8 == Decimal(string: "1565922866"))
```

### NSDecimalNumber
```swift
struct Student: Convertible {
    var money1: NSDecimalNumber = 0
    var money2: NSDecimalNumber = 0
    var money3: NSDecimalNumber = 0
    var money4: NSDecimalNumber = 0
    var money5: NSDecimalNumber = 0
    var money6: NSDecimalNumber = 0
    var money7: NSDecimalNumber = 0
    var money8: NSDecimalNumber = 0
}
 
let json: [String: Any] = [
    "money1": 0.1234567890123456,
    "money2": true,
    "money3": Decimal(string: "0.123456789012345678901234567890123456789") as Any,
    "money4": "0.123456789012345678901234567890123456789",
    "money5": 666.0,
    "money6": "NO",
    "money7": CGFloat(0.1234567890123456),
    "money8": Date(timeIntervalSince1970: 1565922866)
]
 
let student = json.kj.model(Student.self)
XCTAssert(student.money1 == NSDecimalNumber(string: "0.1234567890123456"))
XCTAssert(student.money2 == true)
XCTAssert(student.money2 == 1)
XCTAssert(student.money3 == NSDecimalNumber(string: "0.123456789012345678901234567890123456789"))
XCTAssert(student.money4 == NSDecimalNumber(string: "0.123456789012345678901234567890123456789"))
XCTAssert(student.money5 == 666)
XCTAssert(student.money6 == false)
XCTAssert(student.money6 == 0)
XCTAssert(student.money7 == NSDecimalNumber(string: "0.1234567890123456"))
XCTAssert(student.money8 == NSDecimalNumber(string: "1565922866"))
```

### NSNumber
```swift
struct Student: Convertible {
    var money1: NSNumber = 0
    var money2: NSNumber = 0
    var money3: NSNumber = 0
    var money4: NSNumber = 0
    var money5: NSNumber = 0
    var money6: NSNumber = 0
    var money7: NSNumber = 0
    var money8: NSNumber = 0
}
 
let json: [String: Any] = [
    "money1": 0.1234567890123456,
    "money2": true,
    "money3": Decimal(string: "0.1234567890123456") as Any,
    "money4": "0.1234567890123456",
    "money5": 666.0,
    "money6": "NO",
    "money7": CGFloat(0.1234567890123456),
    "money8": Date(timeIntervalSince1970: 1565922866)
]
 
let student = json.kj.model(Student.self)
XCTAssert(student.money1 == NSNumber(value: 0.1234567890123456))
XCTAssert(student.money2 == true)
XCTAssert(student.money2 == 1)
XCTAssert(student.money2 == 1.0)
XCTAssert(student.money3 == NSNumber(value: 0.1234567890123456))
XCTAssert(student.money4 == NSNumber(value: 0.1234567890123456))
XCTAssert(student.money5 == 666)
XCTAssert(student.money5 == 666.0)
XCTAssert(student.money6 == false)
XCTAssert(student.money6 == 0)
XCTAssert(student.money6 == 0.0)
XCTAssert(student.money7 == NSNumber(value: longDouble))
XCTAssert(student.money8 == NSNumber(value: 1565922866))
```

### Optional
```swift
// Support any number of ?
 
struct Student: Convertible {
    var rich1: Bool = false
    var rich2: Bool? = false
    var rich3: Bool?? = false
    var rich4: Bool??? = false
    var rich5: Bool???? = false
    var rich6: Bool????? = false
}
 
let rich1: Int????? = 100
let rich2: Double???? = 0.0
let rich3: String??? = "0"
let rich4: NSNumber?? = NSNumber(value: 0.666)
let rich5: String? = "true"
let rich6: String = "NO" 
 
let json: [String: Any] = [
    "rich1": rich1 as Any,
    "rich2": rich2 as Any,
    "rich3": rich3 as Any,
    "rich4": rich4 as Any,
    "rich5": rich5 as Any,
    "rich6": rich6
]
 
let student = json.kj.model(Student.self)
XCTAssert(student.rich1 == true)
XCTAssert(student.rich2 == false)
XCTAssert(student.rich3 == false)
XCTAssert(student.rich4 == true)
XCTAssert(student.rich5 == true)
XCTAssert(student.rich6 == false)
```

### URL
```swift
// Support URL, NSURL
 
struct Student: Convertible {
    var url1: NSURL?
    var url2: NSURL?
    var url3: URL?
    var url4: URL?
}
 
let url = "http://520suanfa.com/红黑树"
let encodedUrl = "http://520suanfa.com/%E7%BA%A2%E9%BB%91%E6%A0%91"
 
let json: [String: Any] = [
    "url1": url,
    "url2": URL(string: encodedUrl) as Any,
    "url3": url,
    "url4": NSURL(string: encodedUrl) as Any
]
 
let student = json.kj.model(Student.self)
XCTAssert(student.url1?.absoluteString == encodedUrl)
XCTAssert(student.url2?.absoluteString == encodedUrl)
XCTAssert(student.url3?.absoluteString == encodedUrl)
XCTAssert(student.url4?.absoluteString == encodedUrl)
```

### Data
```swift
// Support NSData, Data
 
struct Student: Convertible {
    var data1: NSData?
    var data2: NSData?
    var data3: Data?
    var data4: Data?
    var data5: NSMutableData?
    var data6: NSMutableData?
}
 
let utf8 = String.Encoding.utf8
let str = "RedBlackTree"
let data = str.data(using: utf8)!
 
let json: [String: Any] = [
    "data1": str,
    "data2": data,
    "data3": str,
    "data4": NSMutableData(data: data),
    "data5": str,
    "data6": data
]
 
let student = json.kj.model(Student.self)
XCTAssert(String(data: (student.data1)! as Data, encoding: utf8) == str)
XCTAssert(String(data: (student.data2)! as Data, encoding: utf8) == str)
XCTAssert(String(data: (student.data3)!, encoding: utf8) == str)
XCTAssert(String(data: (student.data4)!, encoding: utf8) == str)
XCTAssert(String(data: (student.data5)! as Data, encoding: utf8) == str)
XCTAssert(String(data: (student.data6)! as Data, encoding: utf8) == str)
```

### Date
```swift
// Support Date, NSDate
 
struct Student: Convertible {
    var date1: NSDate?
    var date2: NSDate?
    var date3: Date?
    var date4: Date?
    var date5: Date?
    var date6: Date?
    var date7: Date?
}
 
let milliseconds: TimeInterval = 1565922866
 
let json: [String: Any] = [
    "date1": milliseconds,
    "date2": Date(timeIntervalSince1970: milliseconds),
    "date3": milliseconds,
    "date4": NSDate(timeIntervalSince1970: milliseconds),
    "date5": "\(milliseconds)",
    "date6": NSDecimalNumber(string: "\(milliseconds)"),
    "date7": Decimal(string: "\(milliseconds)") as Any
]
 
let student = json.kj.model(Student.self)
XCTAssert(student.date1?.timeIntervalSince1970 == milliseconds)
XCTAssert(student.date2?.timeIntervalSince1970 == milliseconds)
XCTAssert(student.date3?.timeIntervalSince1970 == milliseconds)
XCTAssert(student.date4?.timeIntervalSince1970 == milliseconds)
XCTAssert(student.date5?.timeIntervalSince1970 == milliseconds)
XCTAssert(student.date6?.timeIntervalSince1970 == milliseconds)
XCTAssert(student.date7?.timeIntervalSince1970 == milliseconds)
```

### Enum
```swift
// let enum with rawValue conform to ConvertibleEnum
 
// String RawValue
enum Grade: String, ConvertibleEnum {
    case perfect = "A"
    case great = "B"
    case good = "C"
    case bad = "D"
}
 
struct Student: Convertible {
    var grade1: Grade = .perfect
    var grade2: Grade = .perfect
}
 
let json: [String: Any] = [
    "grade1": "C",
    "grade2": "D"
]
 
let student = json.kj.model(Student.self)
XCTAssert(student.grade1 == .good)
XCTAssert(student.grade2 == .bad)
 
// Double RawValue
enum Grade2: Double, ConvertibleEnum {
    case perfect = 8.88
    case great = 7.77
    case good = 6.66
    case bad = 5.55
}
 
struct Student2: Convertible {
    var grade1: Grade2 = .perfect
    var grade2: Grade2 = .perfect
    var grade3: Grade2 = .perfect
    var grade4: Grade2 = .perfect
}
 
let json2: [String: Any] = [
    "grade1": "5.55kaka",
    "grade2": 6.66,
    "grade3": NSNumber(value: 7.77),
    "grade4": NSDecimalNumber(string: "8.88")
]
 
let student2 = json2.kj.model(Student2.self)
XCTAssert(student2?.grade1 == .bad)
XCTAssert(student2?.grade2 == .good)
XCTAssert(student2?.grade3 == .great)
XCTAssert(student2?.grade4 == .perfect)
```

### Enum In Array
```swift
enum Grade: String, ConvertibleEnum {
    case perfect = "A"
    case great = "B"
    case good = "C"
    case bad = "D"
}

struct Student: Convertible {
    var name: String?
    var grades: [Grade]?
}

let json: [String: Any] = [
    "name": "Jack",
    "grades": ["D", "B"]
]

let stu = json.kj.model(Student.self)
XCTAssert(stu.name == "Jack")
XCTAssert(stu.grades?[0] == .bad)
XCTAssert(stu.grades?[1] == .great)
```

### Enum In Dictionary
```swift
enum Grade: String, ConvertibleEnum {
    case perfect = "A"
    case great = "B"
    case good = "C"
    case bad = "D"
}

struct Student: Convertible {
    var name: String?
    var grades: [String: Grade]?
}

let json: [String: Any] = [
    "name": "Jack",
    "grades": ["2019": "D", "2020": "B"]
]

let stu = json.kj.model(Student.self)
XCTAssert(stu.name == "Jack")
XCTAssert(stu.grades?["2019"] == .bad)
XCTAssert(stu.grades?["2020"] == .great)
```

### Enum Array In Dictionary
```swift
enum Grade: String, ConvertibleEnum {
    case perfect = "A"
    case great = "B"
    case good = "C"
    case bad = "D"
}

struct Student: Convertible {
    var name: String?
    var grades: [String: [Grade?]]?
}

let json: [String: Any] = [
    "name": "Jack",
    "grades": ["2019": ["A", "B"], "2020": ["C", "D"]]
]

let stu = json.kj.model(Student.self)
XCTAssert(stu.name == "Jack")
XCTAssert(stu.grades?["2019"]?[0] == .perfect)
XCTAssert(stu.grades?["2019"]?[1] == .great)
XCTAssert(stu.grades?["2020"]?[0] == .good)
XCTAssert(stu.grades?["2020"]?[1] == .bad)
```

### Array
```swift
// Support conversion between Array\NSArray\NSMutableArray and Set\NSSet\NSMutableSet
 
struct Person: Convertible {
    var array1: [Int]?
    var array2: NSArray?
    var array3: NSMutableArray?
    var array4: [Int]?
    var array5: NSArray?
    var array6: NSMutableArray?
}
 
let array = [1, 2, 3]
 
let json: [String: Any] = [
    "array1": NSMutableArray(array: array),
    "array2": array,
    "array3": array,
    "array4": NSMutableSet(array: array),
    "array5": NSSet(array: array),
    "array6": Set(array),
]
 
let person = json.kj.model(Person.self)
XCTAssert(person.array1 == array)
XCTAssert(person.array2 == array as NSArray)
XCTAssert(person.array3 == NSMutableArray(array: array))
 
for i in array {
    XCTAssert(person.array4?.contains(i) == true)
    XCTAssert(person.array5?.contains(i) == true)
    XCTAssert(person.array6?.contains(i) == true)
}
```

### Set
```swift
// Support conversion between Set\NSSet\NSMutableSet and Array\NSArray\NSMutableArray
 
struct Person: Convertible {
    var set1: Set<Int>?
    var set2: NSSet?
    var set3: NSMutableSet?
    var set4: Set<Int>?
    var set5: NSSet?
    var set6: NSMutableSet?
}
 
let array = [1, 2, 3]
 
let json: [String: Any] = [
    "set1": NSMutableSet(array: array),
    "set2": Set(array),
    "set3": Set(array),
    "set4": NSMutableArray(array: array),
    "set5": array,
    "set6": array
]
 
let person = json.kj.model(Person.self)
for i in array {
    XCTAssert(person.set1?.contains(i) == true)
    XCTAssert(person.set2?.contains(i) == true)
    XCTAssert(person.set3?.contains(i) == true)
    XCTAssert(person.set4?.contains(i) == true)
    XCTAssert(person.set5?.contains(i) == true)
    XCTAssert(person.set6?.contains(i) == true)
}
```

### Dictionary
```swift
// Support conversion between Dictionary, NSDictionary and NSMutableDictionary
 
struct Person: Convertible {
    var dict1: [String: Any]?
    var dict2: NSDictionary?
    var dict3: NSMutableDictionary?
}
 
let dict = ["no1": 100, "no2": 200]
 
let json: [String: Any] = [
    "dict1": NSMutableDictionary(dictionary: dict),
    "dict2": dict,
    "dict3": dict
]
 
let person = json.kj.model(Person.self)
for (k, v) in dict {
    XCTAssert(person.dict1?[k] as? Int == v)
    XCTAssert(person.dict2?[k] as? Int == v)
    XCTAssert(person.dict3?[k] as? Int == v)
}
```



## JSON To Model_03_Key Mapping

### Basic Usage
```swift
struct Person: Convertible {
    var nickName: String = ""
    var mostFavoriteNumber: Int = 0
    var birthday: String = ""
 
    func kj_modelKey(from property: Property) -> ModelPropertyKey {
        switch property.name {
        // `nickName` -> `nick_name`
        case "nickName": return "nick_name"
        // `mostFavoriteNumber` -> `most_favorite_number`
        case "mostFavoriteNumber": return "most_favorite_number"
        default: return property.name
        }
    }
}
 
let nick_name = "ErHa"
let most_favorite_number = 666
let birthday = "2011-10-12"
 
let json: [String: Any] = [
    "nick_name": nick_name,
    "most_favorite_number": most_favorite_number,
    "birthday": birthday
]
 
let student = json.kj.model(Person.self)
XCTAssert(student.nickName == nick_name)
XCTAssert(student.mostFavoriteNumber == most_favorite_number)
XCTAssert(student.birthday == birthday)
```

### Camel -> Underline
```swift
struct Person: Convertible {
    var nickName: String = ""
    var mostFavoriteNumber: Int = 0
    var birthday: String = ""
 
    func kj_modelKey(from property: Property) -> ModelPropertyKey {
        // `nickName` -> `nick_name`
        return property.name.kj.underlineCased()
    }
}
 
let nick_name = "ErHa"
let most_favorite_number = 666
let birthday = "2011-10-12"
 
let json: [String: Any] = [
    "nick_name": nick_name,
    "most_favorite_number": most_favorite_number,
    "birthday": birthday
]
 
let student = json.kj.model(Person.self)
XCTAssert(student.nickName == nick_name)
XCTAssert(student.mostFavoriteNumber == most_favorite_number)
XCTAssert(student.birthday == birthday)
```

### Underline -> Camel
```swift
struct Person: Convertible {
    var nick_name: String = ""
    var most_favorite_number: Int = 0
    var birthday: String = ""
    
    func kj_modelKey(from property: Property) -> ModelPropertyKey {
        // `nick_name` -> `nickName`
        return property.name.kj.camelCased()
    }
}
 
let nickName = "ErHa"
let mostFavoriteNumber = 666
let birthday = "2011-10-12"
 
let json: [String: Any] = [
    "nickName": nickName,
    "mostFavoriteNumber": mostFavoriteNumber,
    "birthday": birthday
]
 
let student = json.kj.model(Person.self)
XCTAssert(student.nick_name == nickName)
XCTAssert(student.most_favorite_number == mostFavoriteNumber)
XCTAssert(student.birthday == birthday)
```

### Inheritance
```swift
class Person: Convertible {
    var nickName: String = ""
    required init() {}
    
    func kj_modelKey(from property: Property) -> ModelPropertyKey {
        // `nickName` -> `nick_ame`
        return property.name.kj.underlineCased()
    }
}
 
class Student: Person {
    var mathScore: Int = 0
    // `mathScore` -> `math_score`
}
 
let nick_ame = "Jack"
let math_score = 96
let json: [String: Any] = ["nick_name": nick_ame, "math_score": math_score]
 
let person = json.kj.model(Person.self)
XCTAssert(person.nickName == nick_ame)
 
let student = json.kj.model(Student.self)
XCTAssert(student.nickName == nick_ame)
XCTAssert(student.mathScore == math_score)
```

### Override 1
```swift
class Person: Convertible {
    var name: String = ""
    required init() {}
    
    func kj_modelKey(from property: Property) -> ModelPropertyKey {
        // `name` -> `_name_`
        return property.name == "name" ? "_name_" : property.name
    }
}
 
class Student: Person {
    var score: Int = 0
    
    override func kj_modelKey(from property: Property) -> ModelPropertyKey {
        // `score` -> `_score_`，`name` -> `_name_`
        return property.name == "score" ? "_score_" : super.kj_modelKey(from: property)
    }
}
 
let name = "Jack"
let score = 96
let json: [String: Any] = ["_name_": name, "_score_": score]
 
let person = json.kj.model(Person.self)
XCTAssert(person.name == name)
 
let student = json.kj.model(Student.self)
XCTAssert(student.name == name)
XCTAssert(student.score == score)
```

### Override 2
```swift
class Person: Convertible {
    var name: String = ""
    required init() {}
    
    func kj_modelKey(from property: Property) -> ModelPropertyKey {
        // `name` -> `_name_`
        return property.name == "name" ? "_name_" : property.name
    }
}
 
class Student: Person {
    var score: Int = 0
    
    override func kj_modelKey(from property: Property) -> ModelPropertyKey {
        // `score` -> `_score_`，`name` -> `name`
        return property.name == "score" ? "_score_" : property.name
    }
}
 
let personName = "Jack"
let person = ["_name_": personName].kj.model(Person.self)
XCTAssert(person.name == personName)
 
let studentName = "Rose"
let studentScore = 96
let student = ["name": studentName,
               "_score_": studentScore].kj.model(Student.self)
XCTAssert(student.name == studentName)
XCTAssert(student.score == studentScore)
```

### Global Config
```swift
// Set global config once, effect on any type
ConvertibleConfig.setModelKey { property in
    property.name.kj.underlineCased()
}
// ConvertibleConfig.setModelKey { $0.name.kj.underlineCased() }
 
class Person: Convertible {
    var nickName: String = ""
    required init() {}
}
 
class Student: Person {
    var mathScore: Int = 0
}
 
struct Car: Convertible {
    var maxSpeed: Double = 0.0
     var name: String = ""
}
 
let nick_ame = "Jack"
let math_score = 96
let json: [String: Any] = ["nick_name": nick_ame, "math_score": math_score]
 
let person = json.kj.model(Person.self)
XCTAssert(person.nickName == nick_ame)
 
let student = json.kj.model(Student.self)
XCTAssert(student.nickName == nick_ame)
XCTAssert(student.mathScore == math_score)
 
let max_speed = 250.0
let name = "Bently"
let car = ["max_speed": max_speed, "name": name].kj.model(Car.self)
XCTAssert(car.maxSpeed == max_speed)
XCTAssert(car.name == name)
```

### Local Config
```swift
// Set config for Person, Car
// It effects on Student because Person is Student's superclass
ConvertibleConfig.setModelKey(for: [Person.self, Car.self]) {
    property in
    property.name.kj.underlineCased()
}
 
class Person: Convertible {
    var nickName: String = ""
    required init() {}
}
 
class Student: Person {
    var mathScore: Int = 0
}
 
struct Car: Convertible {
    var maxSpeed: Double = 0.0
    var name: String = ""
}
 
let nick_ame = "Jack"
let math_score = 96
let json: [String: Any] = ["nick_name": nick_ame, "math_score": math_score]
 
let person = json.kj.model(Person.self)
XCTAssert(person.nickName == nick_ame)
 
let student = json.kj.model(Student.self)
XCTAssert(student.nickName == nick_ame)
XCTAssert(student.mathScore == math_score)
 
let max_speed = 250.0
let name = "Bently"
let car = ["max_speed": max_speed, "name": name].kj.model(Car.self)
XCTAssert(car.maxSpeed == max_speed)
XCTAssert(car.name == name)
```

### Config Example 1
```swift
// Global config
ConvertibleConfig.setModelKey { property in
    property.name.kj.underlineCased()
}
 
// Config of Person
ConvertibleConfig.setModelKey(for: Person.self) { property in
    // `name` -> `_name_`
    property.name == "name" ? "_name_" : property.name
}
 
// Config of Student
ConvertibleConfig.setModelKey(for: Student.self) { property in
    // `score` -> `_score_`，`name` -> `name`
    property.name == "score" ? "_score_" : property.name
}
 
class Person: Convertible {
    var name: String = ""
    required init() {}
}
 
class Student: Person {
    var score: Int = 0
}
 
struct Car: Convertible {
    var maxSpeed: Double = 0.0
    var name: String = ""
}
 
let personName = "Jack"
let person = ["_name_": personName].kj.model(Person.self)
XCTAssert(person.name == personName)
 
let studentName = "Rose"
let studentScore = 96
let student = ["name": studentName,
               "_score_": studentScore].kj.model(Student.self)
XCTAssert(student.name == studentName)
XCTAssert(student.score == studentScore)
 
let max_speed = 250.0
let name = "Bently"
let car = ["max_speed": max_speed, "name": name].kj.model(Car.self)
XCTAssert(car.maxSpeed == max_speed)
XCTAssert(car.name == name)
```

### Config Example 2
```swift
// Global config
ConvertibleConfig.setModelKey { property in
    property.name.kj.underlineCased()
}
 
// Config of Person
ConvertibleConfig.setModelKey(for: Person.self) { property in
    // `name` -> `_name_`
    property.name == "name" ? "_name_" : property.name
}
 
// Config of Student
ConvertibleConfig.setModelKey(for: Student.self) { property in
    // `score` -> `_score_`，`name` -> `name`
    property.name == "score" ? "_score_" : property.name
}
 
class Person: Convertible {
    var name: String = ""
    required init() {}
    
    func kj_modelKey(from property: Property) -> ModelPropertyKey {
        // use ConvertibleConfig to get the config of Person
        // `name` -> `_name_`
        return ConvertibleConfig.modelKey(from: property, Person.self)
    }
}
 
class Student: Person {
    var score: Int = 0
    
    override func kj_modelKey(from property: Property) -> ModelPropertyKey {
        // `score` -> `score`，`name` -> `name`
        return property.name
    }
}
 
struct Car: Convertible {
    var maxSpeed: Double = 0.0
    var name: String = ""
    
    func kj_modelKey(from property: Property) -> ModelPropertyKey {
        // use ConvertibleConfig to get the global config
        // `maxSpeed` -> `max_speed`
        // `name` -> `name`
        return ConvertibleConfig.modelKey(from: property)
    }
}
 
/*
 If there are many settings of modelKey, the rule is （e.g. Student）
 1. use Student's kj_modelKey firstly
 2. if 1 dosen't exist, use ConvertibleConfig of Student
 3. if 1\2 dosen't exist, use ConvertibleConfig of Student's superclass
 4. if 1\2\3 dosen't exist, use ConvertibleConfig of Student's superclass's superclass...
 5. if 1\2\3\4 dosen't exist, use gloabal ConvertibleConfig
 */
 
// Person, Student, Car all have kj_modelKey, so use kj_modelKey firstly
 
let personName = "Jack"
let person = ["_name_": personName].kj.model(Person.self)
XCTAssert(person.name == personName)
 
let studentName = "Rose"
let studentScore = 96
let student = ["name": studentName,
               "score": studentScore].kj.model(Student.self)
XCTAssert(student.name == studentName)
XCTAssert(student.score == studentScore)
 
let max_speed = 250.0
let name = "Bently"
let car = ["max_speed": max_speed, "name": name].kj.model(Car.self)
XCTAssert(car.maxSpeed == max_speed)
XCTAssert(car.name == name)
```

### Complex
```swift
struct Toy: Convertible {
    var price: Double = 0.0
    var name: String = ""
}
 
struct Dog: Convertible {
    var name: String = ""
    var age: Int = 0
    var nickName: String?
    var toy: Toy?
    
    func kj_modelKey(from property: Property) -> ModelPropertyKey {
        switch property.name {
        // toy -> dog["toy"]
        case "toy": return "dog.toy"
        // name -> data[1]["dog"]["name"]
        case "name": return "data.1.dog.name"
        // try every mapping of array orderly until success
        // 1. nickName -> nickName
        // 2. nickName -> nick_name
        // 3. nickName -> dog["nickName"]
        // 4. nickName -> dog["nick_name"]
        case "nickName": return ["nickName", "nick_name", "dog.nickName", "dog.nick_name"]
        default: return property.name
        }
    }
}
 
let name = "Larry"
let age = 5
let nickName1 = "Jake1"
let nickName2 = "Jake2"
let nickName3 = "Jake3"
let nickName4 = "Jake4"
let toy = (name: "Bobbi", price: 20.5)
 
let json: [String: Any] = [
    "data": [10, ["dog" : ["name": name]]],
    "age": age,
    "nickName": nickName1,
    "nick_name": nickName2,
    "dog": [
        "nickName": nickName3,
        "nick_name": nickName4,
        "toy": ["name": toy.name, "price": toy.price]
    ]
]
 
let dog = json.kj.model(Dog.self)
XCTAssert(dog.name == name)
XCTAssert(dog.age == age)
XCTAssert(dog.nickName == nickName1)
XCTAssert(dog.toy?.name == toy.name)
XCTAssert(dog.toy?.price == toy.price)


/*-------------------------------------------------*/

struct Team: Convertible {
    var name: String?
    var captainName: String?
    
    func kj_modelKey(from property: Property) -> ModelPropertyKey {
        switch property.name {
        case "captainName":     return "captain.name"
        default:                return property.name
        }
    }
}

let teamName = "V"
let captainName = "Quentin"

let json: [String: Any] = [
    "name": teamName,
    "captain.name": captainName,
]
let team = json.kj.model(Team.self)
XCTAssert(team.name == teamName)
XCTAssert(team.captainName == captainName)

/*-------------------------------------------------*/

struct Model: Convertible {
    var valueA: String?
    var valueB: String?
    
    func kj_modelKey(from property: Property) -> ModelPropertyKey {
        switch property.name {
        case "valueA":          return "a.0.a"
        case "valueB":          return "b.0.b.0.b"
        default:                return property.name
        }
    }
}

let json: [String: Any] = [
    "a": [ "l", "u", "o" ],
    "b": [
        [ "b": [ "x", "i", "u" ] ]
    ]
]
let model = json.kj.model(Model.self)
XCTAssert(model.valueA == "l")
XCTAssert(model.valueB == "x")
```



## JSON To Model_04_Custom Value

### Date
```swift
private let date1Fmt: DateFormatter = {
    let fmt = DateFormatter()
    fmt.dateFormat = "yyyy-MM-dd"
    return fmt
}()
 
private let date2Fmt: DateFormatter = {
    let fmt = DateFormatter()
    fmt.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
    return fmt
}()
 
struct Student: Convertible {
    var date1: Date?
    var date2: NSDate?
 
    func kj_modelValue(from jsonValue: Any?, _ property: Property) -> Any? {
        switch property.name {
        case "date1": return (jsonValue as? String).flatMap(date1Fmt.date)
        
        case "date2": return (jsonValue as? String).flatMap(date2Fmt.date)
 
        default: return jsonValue
        }
    }
}
 
let date1 = "2008-09-09"
let date2 = "2011-11-12 14:20:30.888"
 
let json: [String: Any] = [
    "date1": date1,
    "date2": date2
]
 
let student = json.kj.model(Student.self)
XCTAssert(student.date1.flatMap(date1Fmt.string) == date1)
XCTAssert(student.date2.flatMap(date2Fmt.string) == date2)
```

### Unspecific Type
```swift
struct Person: Convertible {
    var name: String = ""
    var pet: Any?
 
    func kj_modelValue(from jsonValue: Any?, _ property: Property) -> Any? {
        if property.name != "pet" { return jsonValue }
        return (jsonValue as? [String: Any])?.kj.model(Dog.self)
    }
}
 
struct Dog: Convertible {
    var name: String = ""
    var weight: Double = 0.0
}
 
let json: [String: Any] = [
    "name": "Jack",
    "pet": ["name": "Wang", "weight": 109.5]
]
 
let person = json.kj.model(Person.self)
XCTAssert(person.name == "Jack")
 
let pet = person.pet as? Dog
XCTAssert(pet?.name == "Wang")
XCTAssert(pet?.weight == 109.5)

/*-------------------------------------------------*/

class Book: Convertible {
    var name: String = ""
    var price: Double = 0.0
    required init() {}
}

struct Person: Convertible {
    var name: String = ""
    // [AnyObject]、[Convertible]、NSArray、NSMutableArray
    var books: [Any]?
    
    func kj_modelValue(from jsonValue: Any?,
                       _ property: Property) -> Any? {
        if property.name != "books" { return jsonValue }
        // if books is `NSMutableArray`, neet convert `Array` to `NSMutableArray`
        // because `Array` to `NSMutableArray` is not a bridging conversion
        return (jsonValue as? [Any])?.kj.modelArray(Book.self)
    }
}

let name = "Jack"
let books = [
    (name: "Fast C++", price: 666),
    (name: "Data Structure And Algorithm", price: 1666)
]

let json: [String: Any] = [
    "name": name,
    "books": [
        ["name": books[0].name, "price": books[0].price],
        ["name": books[1].name, "price": books[1].price]
    ]
]

let person = json.kj.model(Person.self)
XCTAssert(person.name == name)

XCTAssert(person.books?.count == books.count)

let book0 = person.books?[0] as? Book
XCTAssert(book0?.name == books[0].name)
XCTAssert(book0?.price == Double(books[0].price))

let book1 = person.books?[1] as? Book
XCTAssert(book1?.name == books[1].name)
XCTAssert(book1?.price == Double(books[1].price))
```

### Example
```swift
struct Student: Convertible {
    var age: Int = 0
    var name: String = ""
    
    func kj_modelValue(from jsonValue: Any?, _ property: Property) -> Any? {
        switch property.name {
        case "age": return (jsonValue as? Int).flatMap { $0 + 5 }
 
        case "name": return (jsonValue as? String).flatMap { "kj_" + $0 }
 
        default: return jsonValue
        }
    }
}
 
let json: [String: Any] = [
    "age": 10,
    "name": "Jack"
]
 
let student = json.kj.model(Student.self)
XCTAssert(student.age == 15)
XCTAssert(student.name == "kj_Jack")
```

### Other Ways
```swift
struct Student: Convertible {
    var age: Int = 0
    var name: String = ""
 
    mutating func kj_didConvertToModel(from json: JSONObject) {
        age += 5
        name = "kj_" + name
    }
}
 
let json: [String: Any] = [
    "age": 10,
    "name": "Jack"
]
 
let student = json.kj.model(Student.self)
XCTAssert(student.age == 15)
XCTAssert(student.name == "kj_Jack")
```



## JSON To Model_05_Dynamic Model

```swift
struct Book: Convertible {
    var name: String = ""
    var price: Double = 0.0
}
 
struct Car: Convertible {
    var name: String = ""
    var price: Double = 0.0
}
 
struct Pig: Convertible {
    var name: String = ""
    var height: Double = 0.0
}
 
struct Dog: Convertible {
    var name: String = ""
    var weight: Double = 0.0
}
 
struct Person: Convertible {
    var name: String = ""
    var pet: Any?
 
    // toys can also be NSArray, NSMutableArray
    var toys: [Any]?
 
    // foods can also be NSDictionary, NSMutableDictionary
    var foods: [String: Any]?
    
    func kj_modelType(from jsonValue: Any?, _ property: Property) -> Convertible.Type? {
        switch property.name {
        case "toys": return Car.self
        case "foods": return Book.self 
        case "pet":
            if let pet = jsonValue as? [String: Any],
                let _ = pet["height"] {
                return Pig.self
            }
            return Dog.self
        default: return nil
        }
    }
}
 
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
    // "pet": ["name": pig.name, "height": pig.height],
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
```



## Model To JSON

### JSON and JSONString
```swift
struct Car: Convertible {
    var name: String = "Bently"
    var new: Bool = true
    var age: Int = 10
    var area: Float = 0.12345678
    var weight: Double = 0.1234567890123456
    var height: Decimal = 0.123456789012345678901234567890123456789
    var price: NSDecimalNumber = NSDecimalNumber(string: "0.123456789012345678901234567890123456789")
    var minSpeed: Double = 66.66
    var maxSpeed: NSNumber = 77.77
    var capacity: CGFloat = 88.88
    var birthday: Date = Date(timeIntervalSince1970: 1565922866)
    var url: URL? = URL(string: "http://520suanfa.com")
}
 
let car = Car()
// car -> JSON
let json1 = car.kj.JSONObject()
// global function `JSONObject(from:)`
let json2 = JSONObject(from: car)
 
// car -> JSONString
let jsonString1 = car.kj.JSONString()
// global function  `JSONString(from:)`
let jsonString2 = JSONString(from: car)
/* {"birthday":1565922866,"new":true,"height":0.123456789012345678901234567890123456789,
"weight":0.1234567890123456,"minSpeed":66.66,
"price":0.123456789012345678901234567890123456789,"age":10,
"name":"Bently","area":0.12345678,"maxSpeed":77.77,
"capacity":88.88,"url":"http:\/\/520suanfa.com"} */
 
// get prettyPrinted JSONString
let jsonString3 = car.kj.JSONString(prettyPrinted: true)
let jsonString4 = JSONString(from: car, prettyPrinted: true)
/*
 {
     "height" : 0.123456789012345678901234567890123456789,
     "weight" : 0.1234567890123456,
     "minSpeed" : 66.66,
     "new" : true,
     "maxSpeed" : 77.77,
     "age" : 10,
     "capacity" : 88.88,
     "birthday" : 1565922866,
     "name" : "Bently",
     "price" : 0.123456789012345678901234567890123456789,
     "area" : 0.12345678,
     "url" : "http:\/\/520suanfa.com"
 }
 */
```

### Optional
```swift
struct Student: Convertible, Equatable {
    var op1: Int? = 10
    var op2: Double?? = 66.66
    var op3: Float??? = 77.77
    var op4: String???? = "Jack"
    var op5: Bool????? = true
    // op6 can alse be NSArray\Set<CGFloat>\NSSet\NSMutableArray\NSMutableSet
    var op6: [CGFloat]?????? = [44.44, 55.55]
}
 
let jsonString = Student().kj.JSONString()
/*
{
  "op1" : 10,
  "op4" : "Jack",
  "op2" : 66.66,
  "op5" : true,
  "op6" : [
    44.44,
    55.55
  ],
  "op3" : 77.77
}
*/
```

### Enum
```swift
// A enum with rawValue who conforms to ConvertibleEnum 
enum Grade: String, ConvertibleEnum {
    case perfect = "A"
    case great = "B"
    case good = "C"
    case bad = "D"
}
 
struct Student: Convertible {
    var grade1: Grade = .great
    var grade2: Grade = .bad
}
 
// put rawValue into the jsonString
let jsonString = Student().kj.JSONString()
/* {"grade2":"D","grade1":"B"} */
```

### Nested Model
```swift
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
```

### Any
```swift
struct Book: Convertible {
    var name: String = ""
    var price: Double = 0.0
}
 
struct Dog: Convertible {
    var name: String = ""
    var age: Int = 0
}
 
struct Person: Convertible {
    // books can alse be NSArray\NSMutableArray
    var books: [Any]? = [
        Book(name: "Fast C++", price: 666.6),
        Book(name: "Data Structure And Algorithm", price: 666.6),
    ]
    
    // dogs can alse be NSDictionary\NSMutableDictionary
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
```

### Model Array
```swift
struct Car: Convertible {
    var name: String = ""
    var price: Double = 0.0
}
 
// models can alse be NSArray\NSMutableArray
let models = [
    Car(name: "BMW", price: 100.0),
    Car(name: "Audi", price: 70.0),
    Car(name: "Bently", price: 300.0)
]
 
let jsonString1 = models.kj.JSONString()
// gloabal function `JSONString(from:)`
let jsonString2 = JSONString(from: models)
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
```

### Model Set
```swift
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
```

### Key Mapping
```swift
struct Dog: Convertible {
    var nickName: String = "Wang"
    var price: Double = 100.6
    
    func kj_JSONKey(from property: Property) -> JSONPropertyKey {
        switch property.name {
        case "nickName": return "_nick_name_"
        default: return property.name
        }
    }
}
 
let jsonString = Dog().kj.JSONString()
/* {"price":100.6,"_nick_name_":"Wang"} */

// kj_JSONKey support ConvertibleConfig.
// It is similar to kj_modelKey.
```

### Custom Value
```swift
private let dateFmt: DateFormatter = {
    let fmt = DateFormatter()
    fmt.dateFormat = "yyyy-MM-dd HH:mm:ss"
    return fmt
}()
 
struct Student: Convertible {
    var birthday: Date?
    
    func kj_JSONValue(from modelValue: Any?, _ property: Property) -> Any? {
        if property.name != "birthday" { return modelValue }
        return birthday.flatMap(dateFmt.string)
    }
}
 
let time = "2019-08-13 12:52:51"
let date = dateFmt.date(from: time)
let student = Student(birthday: date)
let jsonString = student.kj.JSONString()
/* {"birthday":"2019-08-13 12:52:51"} */

// kj_JSONValue support ConvertibleConfig.
// It is similar to kj_modelKey.
```

### Listen
```swift
struct Car: Convertible {
    var name: String = "Bently"
    var age: Int = 10
    
    // call when will begin to convert from model to json
    func kj_willConvertToJSON() {
        print("Car - kj_willConvertToJSON")
    }
 
    // call when did finish converting from model to json
    func kj_didConvertToJSON(json: [String: Any]) {
        print("Car - kj_didConvertToJSON", json)
    }
}
```
