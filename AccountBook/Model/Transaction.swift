//
//  Transaction.swift
//  AccountBook
//
//  Created by James Kim on 8/5/20.
//  Copyright © 2020 FastCampus. All rights reserved.
//

import Foundation

enum SpendType {
    case 대중교통
    case 식사
    case 보험
    case 술자리
    case 물건구입
    case 커피
    case 기타
    
    var warning: String {
        switch self {
            // TODO: 해당하는 타입에 돈을 많이 썼을떄 워닝을 넣어주세요.
        default: return "기타물건을 너무 많이사셨어요. 조심하세요."
        }
    }
}

struct Transaction {
    var amount: Float
    var date: Date
    var type: SpendType
}
