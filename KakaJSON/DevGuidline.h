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
- obj.kk.member
- e.g. "123".kk.numberCount, model.kk.JSON()

② internal extension for system types、model types
- obj.kk_member
- e.g. "123".kk_numberCount, model.kk_JSON()

③ private\fileprivate
- obj._member
- e.g. "123"._numberCount, model._JSON()

④ Name of method or tpye must be `JSON`
- not `json`, not `Json`, not `jSON`
- name of variable can be `json`
