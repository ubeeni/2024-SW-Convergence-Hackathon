//
//  ContentView.swift
//  Liner
//
//  Created by KimYuBin on 8/23/24.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedMeeting: Meeting?
    @State private var showSplash = true
    
    var body: some View {
        ZStack {
            HStack(spacing: 0) {
                SidebarView(selectedMeeting: $selectedMeeting)
                    .frame(width: 385)
                
                if let meeting = selectedMeeting {
                    MeetingView(meetingTitle: meeting.title,
                                meetingTime: meeting.time,
                                attendees: meeting.attendees)
                    .padding(.trailing, 37)
                } else {
                    Spacer()
                    
                    OfficeView()
                    
                    Spacer()
                }
            }
            
            if showSplash {
                SplashView()
                    .transition(.opacity)
                    .zIndex(1)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation {
                    showSplash = false
                }
            }
        }
    }
}

struct SplashView: View {
    var body: some View {
        ZStack {
            VStack(alignment: .center) {
                Text("온라인을 오프라인처럼, 가까운 회의 공간")
                    .font(.system(size: 19))
                    .foregroundStyle(.white)

                LottieView(filename: "LogoAnimation")
                    .frame(width: 500, height: 500)
                    .padding(.top, -180)
                    .padding(.bottom, -180)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(
                stops: [
                    Gradient.Stop(color: Color(red: 0.59, green: 0.69, blue: 0.3).opacity(0.4), location: 0.01),
                    Gradient.Stop(color: Color(red: 0.14, green: 0.14, blue: 0.14).opacity(0.4), location: 0.55),
                    Gradient.Stop(color: Color(red: 0.14, green: 0.14, blue: 0.14).opacity(0.4), location: 1.00),
                ],
                startPoint: UnitPoint(x: 0.46, y: 1.26),
                endPoint: UnitPoint(x: 0.45, y: 0.19)
            )
        )
        .background(Color(red: 0.13, green: 0.13, blue: 0.13))
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    ContentView()
}
