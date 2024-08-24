//
//  AcceptView.swift
//  Liner
//
//  Created by KimYuBin on 8/25/24.
//

import SwiftUI

struct AcceptView: View {
    var meetingTitle: String
    var meetingTime: String
    var attendees: [Participant]
    
    var body: some View {
        VStack(spacing: 0) {
            Image(.imgProfile1)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 120, height: 120)
                .clipShape(Circle())
            
            Text("8/26(월) 14:00")
                .font(.system(size: 24, weight: .semibold))
                .foregroundStyle(.black)
                .padding(.top, 16)
            
            Text("‘App 기존서비스 TF 긴급회의'")
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(.black)
                .padding(.top, 8)
            
            Text("‘김니니'님이 회의요청을 보냈습니다")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(.black)
                .padding(.top, 8)
            
            Text("#긴급")
                .padding(10)
                .frame(height: 30, alignment: .leading)
                .background(Color(red: 0.94, green: 0.94, blue: 0.94))
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .inset(by: 1)
                        .stroke(Color(red: 0.94, green: 0.94, blue: 0.94), lineWidth: 2)
                )
                .padding(.top, 16)
            
            Button(action: {
                
            }, label: {
                Text("수락하기")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(.black)
                    .frame(width: 320, height: 60)
                    .background(Color(red: 0.85, green: 0.97, blue: 0.51))
                    .cornerRadius(20)
            })
            .padding(.top, 22)
            
            Button(action: {
                
            }, label: {
                Text("거절하기")
                    .font(.system(size: 14, weight: .regular))
                  .underline()
                  .foregroundStyle(Color(red: 0.59, green: 0.59, blue: 0.59))
                  .padding(.top, 8)
            })
        }
        .padding(.horizontal, 98)
        .padding(.vertical, 49)
        .frame(width: 482, height: 490)
        .background(.white)
        .cornerRadius(20)
    }
}

#Preview {
    AcceptView(meetingTitle: "회의 제목", meetingTime: "10:00 - 12:00", attendees: [
        Participant(name: "파이리", team: "개발 1팀", image: "imgProfile1")
    ])
}
