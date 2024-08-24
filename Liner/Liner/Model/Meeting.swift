//
//  Meeting.swift
//  Liner
//
//  Created by KimYuBin on 8/23/24.
//

import SwiftUI
import Firebase

struct UserInfo {
    let name: String
    let email: String
    let department: String
    let jobDescription: String
}

struct Meeting {
    var title: String
    var time: String
    var attendees: [Participant]
}

struct Participant: Hashable {
    let name: String
    let team: String
    let image: String
}
