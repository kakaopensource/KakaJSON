# KakaJSON
![pod](https://img.shields.io/cocoapods/v/KakaJSON.svg) ![platforms](https://img.shields.io/badge/platforms-iOS%208.0%20%7C%20macOS%2010.9%20%7C%20tvOS%209.0%20%7C%20watchOS%202.0-F28D00.svg)

Fast conversion between JSON and model in Swift.

## 中文教程
- [KakaJSON手册](https://www.cnblogs.com/mjios/p/11352776.html)

## Integration
### CocoaPods
```ruby
pod 'KakaJSON', '~> 1.1.0' 
```

## Usages
### JSON To Model
```swift
struct Cat: Convertible {
    var name: String = ""
    var weight: Double = 0.0
}

let json: [String: Any] = [
    "name": "Miaomiao",
    "weight": 6.66
]

let cat = json.kk.model(Cat.self)
// let cat = model(from: json, Cat.self)
```

### Model To JSON
```swift
struct Car: Convertible {
    var name: String = "Bently"
    var new: Bool = true
    var age: Int = 10
    var weight: Double = 0.1234567890123456
    var height: Decimal = 0.123456789012345678901234567890123456789
    var price: NSDecimalNumber = 0.123456789012345678901234567890123456789
    var minSpeed: Double = 66.66
    var maxSpeed: NSNumber = 77.77
}

let car = Car()
let json = car.kk.JSON()
let jsonString = car.kk.JSONString()
// let json = JSON(from: car)
// let jsonString = JSONString(from: car)
```
## More documentation will be coming out soon....
