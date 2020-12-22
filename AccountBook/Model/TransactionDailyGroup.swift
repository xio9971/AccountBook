//
//  TransactionDailyGroup.swift
//  AccountBook
//
//  Created by James Kim on 8/5/20.
//  Copyright © 2020 FastCampus. All rights reserved.
//

import Foundation

struct TransactionDailyGroup {
    // Transaction들을 day기준으로 모아놓은 것입니다.
    var transactions: [Transaction]
    var date: Date
    
    
    var total: Float {
        // TODO: total이 그룹화된거에서 보여질거에요
        return 0
    }
}
