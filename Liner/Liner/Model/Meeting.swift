//
//  Meeting.swift
//  Liner
//
//  Created by KimYuBin on 8/23/24.
//

import SwiftUI

struct Meeting {
    var title: String
    var time: String
    var attendees: [Participant]  // 참여자 목록 추가
}

struct Participant: Hashable {
    let name: String
    let team: String
    let image: String
}
