//
//  NamingConvention.h
//  KakaJSON
//
//  Created by MJ Lee on 2019/8/14.
//  Copyright © 2019 MJ Lee. All rights reserved.
//

① public extension for system types
- obj.kk.member
- e.g. "123".kk.numberCount

② internal extension for system types
- obj.kk_member
- e.g. "123".kk_numberCount

③ private\fileprivate
- obj._member
- e.g. "123"._numberCount

④ is JSON, not json, not Json, not jSON
