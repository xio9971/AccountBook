//
//  Storage.swift
//  AccountBook
//
//  Created by James Kim on 8/5/20.
//  Copyright © 2020 FastCampus. All rights reserved.
//

import Foundation

struct Storage {
    static var shared = Storage()
    
    init() {
        loadFromData()
    }
    
    private func loadFromData() {
        // Json 파일에서 읽어오도록 해주세요. 아니면 코어데이터를 이용해주세요.
    }
}
