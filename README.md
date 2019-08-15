# KakaJSON
![podversion](https://img.shields.io/cocoapods/v/KakaJSON.svg)

Fast conversion between JSON and model in Swift.

## 中文教程
- [KakaJSON手册](https://www.cnblogs.com/mjios/p/11352776.html)

## Integration
### CocoaPods
```ruby
pod 'KakaJSON', '~> 1.0.2' 
```

## Usages
### JSON To Model
```swift
struct Cat: Convertible {
    var weight: Double = 0.0
    var name: String = ""
}

let json: [String: Any] = [
    "weight": "Miaomiao",
    "name": 6.66
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
