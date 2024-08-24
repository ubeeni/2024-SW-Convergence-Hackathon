//
//  MeetingView.swift
//  Liner
//
//  Created by KimYuBin on 8/23/24.
//

import SwiftUI

struct MeetingView: View {
    @State private var showDetails: Bool = false
    @State private var attendees: [String] = ["파이리", "니니", "제이미", "레오", "라일리"]
    @State private var isMicOn: Bool = true
    @State private var isSpeakerOn: Bool = true
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                Button(action: {
                    withAnimation {
                        showDetails.toggle()
                    }
                }) {
                    HStack(alignment: .center, spacing: 0) {
                        Text("App 신규 TF 주간롤링(월)")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .frame(width: 385, height: 48, alignment: .leading)
                            .background(Color(red: 0.6, green: 0.63, blue: 0.5))
                            .cornerRadius(20)
                        
                        Image(systemName: "clock.fill")
                            .font(.system(size: 20))
                            .foregroundStyle(.white)
                            .padding(.leading, 20)
                        
                        Text("10:00 - 12:00")
                            .font(.system(size: 20))
                            .foregroundStyle(.white)
                            .padding(.leading, 10)
                            .padding(.trailing, 20)
                        
                        Spacer()
                        
                        HStack {
                            Image(systemName: "person.fill")
                            
                            Text("5")
                        }
                        .font(.system(size: 18))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 15)
                        .padding(.vertical, 12)
                        .background(Color(red: 0.6, green: 0.63, blue: 0.5))
                        .cornerRadius(20)
                    }
                    .padding(.horizontal, 18)
                    .padding(.vertical, 16)
                }
                
                if showDetails {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 3), spacing: 8) {
                        ForEach(attendees, id: \.self) { attendee in
                            Rectangle()
                                .fill(Color(red: 0.85, green: 0.85, blue: 0.85))
                                .frame(width: 212, height: 160)
                                .overlay(
                                    Text(attendee)
                                        .foregroundStyle(.black)
                                        .font(.system(size: 16))
                                )
                                .cornerRadius(16)
                        }
                    }
                    .padding(.vertical, 30)
                    .padding(.horizontal, 40)
                }
            }
            .background(
                Group {
                    if showDetails {
                        LinearGradient(
                            stops: [
                                Gradient.Stop(color: Color(red: 0.28, green: 0.28, blue: 0.28), location: 0.00),
                                Gradient.Stop(color: Color(red: 0.9, green: 0.94, blue: 0.78), location: 1.00),
                            ],
                            startPoint: UnitPoint(x: 0.5, y: 0.15),
                            endPoint: UnitPoint(x: 0.5, y: 1.27)
                        )
                    } else {
                        Color(red: 0.28, green: 0.28, blue: 0.28)
                    }
                }
            )
            .cornerRadius(20)
            .padding(.top, 42)
            .frame(height: showDetails ? 450 : 80)
            .animation(.easeInOut(duration: 0.3), value: showDetails)
            
            Rectangle()
                .foregroundStyle(Color(red: 0.94, green: 0.94, blue: 0.94))
                .cornerRadius(16)
                .padding(.top, 38)
                .padding(.bottom, 36)
            
            HStack(spacing: 0) {
                Button(action: {
                    isMicOn.toggle()
                }) {
                    Image(systemName: isMicOn ? "mic.fill" : "mic.slash.fill")
                        .font(.system(size: 60))
                        .foregroundStyle(Color(red: 0.62, green: 0.62, blue: 0.62))
                        .frame(width: 110, height: 110)
                        .background(isMicOn ? Color(red: 0.85, green: 0.97, blue: 0.51) : Color(red: 0.85, green: 0.85, blue: 0.85))
                        .cornerRadius(22.93)
                }
                
                Button(action: {
                    isSpeakerOn.toggle()
                }) {
                    Image(systemName: isSpeakerOn ? "speaker.fill" : "speaker.slash.fill")
                        .font(.system(size: 60))
                        .foregroundStyle(Color(red: 0.62, green: 0.62, blue: 0.62))
                        .frame(width: 110, height: 110)
                        .background(isSpeakerOn ? Color(red: 0.85, green: 0.97, blue: 0.51) : Color(red: 0.85, green: 0.85, blue: 0.85))
                        .cornerRadius(16)
                }
                .padding(.leading, 16)
                
                Spacer()
                
                Button(action: {
                }) {
                    HStack {
                        Image(systemName: "stop.fill")
                        
                        Text("회의 종료")
                    }
                    .font(.system(size: 28))
                    .foregroundStyle(.white)
                    .frame(width: 300, height: 110)
                    .background(Color(red: 0.35, green: 0.35, blue: 0.36))
                    .cornerRadius(22.93)
                }
            }
            .padding(.bottom, 40)
        }
    }
}

#Preview {
    MeetingView()
}
