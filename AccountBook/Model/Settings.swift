//
//  Settings.swift
//  AccountBook
//
//  Created by James Kim on 8/5/20.
//  Copyright © 2020 FastCampus. All rights reserved.
//

import Foundation

enum Settings: CaseIterable {
    // allCases를 써서 numberOfRows를 잡아주세요.
    case limit
    case appVersion
    
    var rightText: String? {
        switch self {
            // TODO: settingViewController의 tableviewcell에서 보여줄 데이터를 넣어주세요.
        default: return nil
        }
    }
}
