//
//  ContentView.swift
//  Liner
//
//  Created by KimYuBin on 8/23/24.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedMeeting: Meeting?
    
    var body: some View {
        HStack(spacing: 0) {
            SidebarView(selectedMeeting: $selectedMeeting)
                .frame(width: 385)
            
            if let meeting = selectedMeeting {
                MeetingView(meetingTitle: meeting.title,
                            meetingTime: meeting.time,
                            attendees: meeting.attendees)
                .padding(.trailing, 37)
            } else {
                VStack {
                    Image(.imgTalk)
                        .resizable()
                    
                    Spacer()
                }
                .padding(.trailing, 37)
                .frame(width: .infinity)
            }
        }
    }
}

#Preview {
    ContentView()
}
