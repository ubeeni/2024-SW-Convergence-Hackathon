//
//  MeetingView.swift
//  Liner
//
//  Created by KimYuBin on 8/23/24.
//

import SwiftUI

struct MeetingView: View {
    @State private var showDetails: Bool = false
    @State private var isMicOn: Bool = true
    @State private var isSpeakerOn: Bool = true
    
    var meetingTitle: String
    var meetingTime: String
    var attendees: [Participant]
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                Button(action: {
                    withAnimation {
                        showDetails.toggle()
                    }
                }) {
                    HStack(alignment: .center, spacing: 0) {
                        Text(meetingTitle)
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
                        
                        Text(meetingTime)
                            .font(.system(size: 20))
                            .foregroundStyle(.white)
                            .padding(.leading, 10)
                            .padding(.trailing, 20)
                        
                        Spacer()
                        
                        HStack {
                            Image(systemName: "person.fill")
                            
                            Text("\(attendees.count)")
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
                    LazyVGrid(
                        columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 3),
                        alignment: .center,
                        spacing: 16
                    ) {
                        ForEach(attendees, id: \.self) { attendee in
                            ZStack(alignment: .bottomLeading) {
                                Image(attendee.image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 260, height: 140)
                                
                                HStack {
                                    Image(systemName: isMicOn ? "mic.fill" : "mic.slash.fill")
                                        .foregroundStyle(.white)
                                    
                                    Text(attendee.name)
                                        .font(.system(size: 14))
                                        .fontWeight(.medium)
                                        .foregroundColor(.white)
                                }
                                .padding(.horizontal, 8)
                                .padding(.vertical, 3)
                                .background(Color(red: 0.59, green: 0.59, blue: 0.59))
                                .cornerRadius(20)
                                .padding(.leading, 13.5)
                                .padding(.bottom, -5)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .frame(maxHeight: showDetails ? .infinity : 0)
                    .animation(.easeInOut(duration: 0.3), value: showDetails)
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
                            .frame(height: 80)
                    }
                }
            )
            .cornerRadius(20)
            .animation(.easeInOut(duration: 0.3), value: showDetails)
            
            Spacer()
            
            HStack {
                VStack {
                    LottieView(filename: "Sound")
                        .frame(width: 150, height: 150)
                    
                    Text("AI가 듣고 있어요!")
                        .font(.system(size: 12))
                        .foregroundStyle(Color(red: 0.97, green: 0.98, blue: 1))
                        .padding(.top, -40)
                }
                
                Spacer()
                
            }
            .background(
                Rectangle()
                    .foregroundStyle(Color(red: 0.84, green: 0.84, blue: 0.84))
                    .cornerRadius(16)
            )
            .padding(.bottom, 20)
            
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
                
                Button(action: {
                    //TODO: 파일 공유하기 버튼
                }) {
                    Image(systemName: "square.and.arrow.up.fill")
                        .font(.system(size: 60))
                        .foregroundStyle(.white)
                        .frame(width: 110, height: 110)
                        .background(Color(red: 0.62, green: 0.62, blue: 0.62))
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
    MeetingView(meetingTitle: "회의 제목", meetingTime: "10:00 - 12:00", attendees: [
        Participant(name: "파이리", team: "팀", image: "imgProfile1"),
        Participant(name: "니니", team: "팀", image: "imgProfile2"),
        Participant(name: "또가스", team: "팀", image: "imgProfile3"),
        Participant(name: "리아", team: "팀", image: "imgProfile4"),
        Participant(name: "홍길동", team: "팀", image: "imgProfile5")
    ])
}
