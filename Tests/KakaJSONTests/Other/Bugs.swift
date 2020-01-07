//
//  Bugs.swift
//  KakaJSON
//
//  Created by MJ Lee on 2020/1/7.
//

import XCTest
@testable import KakaJSON

class TestBugs: XCTestCase {
    // https://github.com/kakaopensource/KakaJSON/issues/39
    func testIssue39() {
        struct ChatRoomModel: Convertible {
            var lastMessage: String = ""
            var lastMessageTime: NSNumber = 0
            var pkid: NSNumber = 0
            var unreadNoticeCount: NSNumber = 0
        }
        struct WorkShopsModel: Convertible {
            var chatRoom:   ChatRoomModel?
            var imgUrl:     String = ""
            var isMine:     NSNumber = false
            var pkid:       NSNumber = 0
            var unsignined: NSNumber?
            var status:     NSNumber = 0
            var title:      String = ""
            var regCount:   Int?
            var tbString:   String?
            var teString:   String?
        }
        
        let json: [String: Any]  = [
            "chatRoom": [
                "last_message": "666",
                "last_message_time": 1567578912000,
                "pkid": 2,
                "unread_notice_count": 10
            ],
            "img_url": "xx.jpg",
            "is_mine": true,
            "pkid": 3,
            "reg_count": 1,
            "status": 1,
            "tbString": "2019-01-30",
            "teString": "2019-09-28",
            "title": "777",
            "unsignined": true
        ]
        
        ConvertibleConfig.setModelKey { (property) in
            return property.name.kj.underlineCased()
            // return [property.name.kj.underlineCased()]
        }
        
        let workShops = json.kj.model(WorkShopsModel.self)
        XCTAssert(workShops.chatRoom?.lastMessage == "666")
        XCTAssert(workShops.chatRoom?.pkid == 2)
        XCTAssert(workShops.chatRoom?.unreadNoticeCount == 10)
        XCTAssert(workShops.chatRoom?.lastMessageTime == 1567578912000)
        XCTAssert(workShops.imgUrl == "xx.jpg")
        XCTAssert(workShops.isMine == true)
        XCTAssert(workShops.pkid == 3)
        XCTAssert(workShops.regCount == 1)
        XCTAssert(workShops.status == 1)
        XCTAssert(workShops.tbString == "2019-01-30")
        XCTAssert(workShops.teString == "2019-09-28")
        XCTAssert(workShops.title == "777")
        XCTAssert(workShops.unsignined == true)
    }
    
    static var allTests = [
        "testIssue39": testIssue39
    ]
}

