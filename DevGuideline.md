//
//  DevGuideline.md
//  KakaJSON
//
//  Created by MJ Lee on 2019/8/14.
//  Copyright © 2019 MJ Lee. All rights reserved.
//

/*
 Metadata Reference:
 0. https://github.com/apple/swift/blob/master/docs/ABI/TypeMetadata.rst
 1. https://github.com/apple/swift/blob/master/include/swift/ABI/MetadataKind.def
 2. https://github.com/apple/swift/blob/master/include/swift/ABI/Metadata.h
 3. https://github.com/apple/swift/blob/master/include/swift/ABI/MetadataValues.h
 4. https://github.com/apple/swift/blob/master/utils/dtrace/runtime.d
 5. https://github.com/apple/swift/blob/master/include/swift/Reflection/Records.h
 */

1. 提交代码之前，请务必先保证在真机、模拟器上通过所有的测试用例（Debug+Release模式）

2. 命名规范
① 给模型类型、系统自带类型，扩展public的成员
- obj.kj.成员名称
- 比如 "123".kj.numberCount, model.kj.JSON()

② 给模型类型、系统自带类型，扩展internal的成员
- obj.kj_成员名称
- 比如 "123".kj_numberCount, model.kj_JSON()

③ private\fileprivate的成员
- obj._成员名称
- 比如 "123"._numberCount, model._JSON()

④ 类型名、方法名必须是大写的`JSON`
- 不要写`json`, 也不要写`Json`
- 如果是变量名、常量名、参数名，可以用小写`json`

/**********************************************************/

1. Please make all test cases right before pushing your code
- include iOS Device\Simulator
- include release\debug mode

2. NamingConvention
① public extension for system types、model types
- obj.kj.memberName
- e.g. "123".kj.numberCount, model.kj.JSON()

② internal extension for system types、model types
- obj.kj_memberName
- e.g. "123".kj_numberCount, model.kj_JSON()

③ private\fileprivate
- obj._memberName
- e.g. "123"._numberCount, model._JSON()

④ Name of method or type must be `JSON`
- not `json`, not `Json`
- name of variable can be `json`
