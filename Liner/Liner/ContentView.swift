//
//  ContentView.swift
//  Liner
//
//  Created by KimYuBin on 8/23/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        HStack(spacing: 0) {
            SidebarView()
                .frame(width: 385)
            
            MeetingView()
                .padding(.trailing, 37)
        }
    }
}

#Preview {
    ContentView()
}
