//
//  DevGuidline.h
//  KakaJSON
//
//  Created by MJ Lee on 2019/8/14.
//  Copyright © 2019 MJ Lee. All rights reserved.
//

1. Please make all test cases right in release\debug mode before pushing your code

2. NamingConvention
① public extension for system types、model types
- obj.kk.memberName
- e.g. "123".kk.numberCount, model.kk.JSON()

② internal extension for system types、model types
- obj.kk_memberName
- e.g. "123".kk_numberCount, model.kk_JSON()

③ private\fileprivate
- obj._memberName
- e.g. "123"._numberCount, model._JSON()

④ Name of method or tpye must be `JSON`
- not `json`, not `Json`
- name of variable can be `json`

/**********************************************************/

1. 提交代码之前，请务必先保证通过所有的测试用例（Debug+Release模式）

2. 命名规范
① 给模型类型、系统自带类型，扩展public的成员
- obj.kk.成员名称
- 比如 "123".kk.numberCount, model.kk.JSON()

② 给模型类型、系统自带类型，扩展internal的成员
- obj.kk_成员名称
- 比如 "123".kk_numberCount, model.kk_JSON()

③ private\fileprivate的成员
- obj._成员名称
- 比如 "123"._numberCount, model._JSON()

④ 类型名、方法名必须是大写的`JSON`
- 不要写`json`, 也不要写`Json`
- 如果是变量名、常量名、参数名，可以用小写`json`
