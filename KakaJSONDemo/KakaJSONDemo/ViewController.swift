//
//  ViewController.swift
//  KakaJSONDemo
//
//  Created by Quentin MED on 2019/9/5.
//  Copyright © 2019 KakaJSON. All rights reserved.
//

import UIKit
import KakaJSON

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        struct Repo: Convertible {
            var name: String?
            var url: URL?
        }
        
        let json = [
            "name": "KakaJSON",
            "url": "https://github.com/kakaopensource/KakaJSON"
        ]
        
        let repo = json.kj.model(Repo.self)
        print(repo)
    }
}

