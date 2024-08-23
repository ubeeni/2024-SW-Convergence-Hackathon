//
//  SidebarView.swift
//  Liner
//
//  Created by KimYuBin on 8/23/24.
//

import SwiftUI

struct SidebarView: View {
    @State private var search: String = ""
    @State private var showModal: Bool = false
    @State private var newTime = Date()
    @State private var newTitle: String = ""
    @State private var currentDate = Date()
    
    @State private var items: [Date: [(time: String, title: String)]] = [
        Date(): [("10:00", "데일리스크럼"), ("14:00", "회의"), ("09:00", "아침 미팅")]
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                ZStack(alignment: .bottomTrailing) {
                    Image(.imgProfile)
                        .resizable()
                        .frame(width: 81, height: 81)
                    
                    Circle()
                        .frame(width: 23, height: 23)
                        .foregroundStyle(Color.green)
                }
                
                VStack(alignment: .leading, spacing: 0) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("김파이리")
                            .font(Font.system(size: 22))
                            .fontWeight(.bold)
                        
                        Text("개발 1팀")
                            .font(Font.system(size: 14))
                            .fontWeight(.medium)
                    }
                    
                    Text("서비스의 유지보수 직무를 맡고 있습니다.")
                        .font(Font.system(size: 12))
                        .fontWeight(.regular)
                        .padding(.top, 8)
                }
                .padding(.leading, 12)
                
                Spacer()
            }
            .padding(.leading, 31)
            .padding(.top, 43)
            
            Button {
                
            } label: {
                HStack(spacing: 0) {
                    Image(.imgComputer)
                    
                    Spacer()
                    
                    Text("개발 1팀")
                        .font(Font.system(size: 24))
                        .fontWeight(.semibold)
                        .foregroundStyle(.black)
                    
                }
                .padding(.horizontal)
                .frame(height: 80)
                .background(Color(red: 0.96, green: 0.96, blue: 0.96))
                .cornerRadius(20)
                .padding(.horizontal)
                .padding(.top, 50)
            }
            
            Spacer()
                .frame(height: .infinity)
            
            HStack {
                Button(action: {
                    currentDate = Calendar.current.date(byAdding: .day, value: -1, to: currentDate) ?? currentDate
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(Color.black)
                    
                }
                
                Spacer()
                
                Text(formattedDate(currentDate))
                    .font(Font.system(size: 20))
                    .fontWeight(.medium)
                    .foregroundStyle(Color(red: 0.17, green: 0.17, blue: 0.17))
                
                Spacer()
                
                Button(action: {
                    currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
                }) {
                    Image(systemName: "chevron.right")
                        .foregroundColor(.black)
                }
            }
            .padding(.horizontal, 40)
            
            Button(action: {
                showModal.toggle()
            }) {
                HStack {
                    Text("Meeting")
                        .font(Font.system(size: 24))
                        .fontWeight(.medium)
                        .foregroundColor(Color(red: 0.17, green: 0.17, blue: 0.17))
                    
                    Spacer()
                    
                    Image(systemName: "plus")
                        .foregroundColor(.black)
                }
                .padding(.horizontal)
                .frame(height: 60)
                .background(Color(red: 0.84, green: 1, blue: 0.39))
                .cornerRadius(12)
                .padding(.horizontal)
            }
            .padding(.top, 16)
            
            ScrollView {
                VStack(spacing: 16) {
                    if let dailyItems = items[currentDate] {
                        ForEach(dailyItems.sorted(by: { $0.time < $1.time }), id: \.time) { item in
                            NavigationLink(destination: MeetingView()) {
                                HStack {
                                    Text(item.time)
                                        .font(Font.system(size: 20))
                                        .fontWeight(.medium)
                                        .foregroundStyle(Color(red: 0.17, green: 0.17, blue: 0.17))
                                    
                                    Spacer()
                                    
                                    Text(item.title)
                                        .font(Font.system(size: 16))
                                        .fontWeight(.medium)
                                        .foregroundStyle(Color(red: 0.17, green: 0.17, blue: 0.17))
                                }
                                .padding(.horizontal)
                                .frame(height: 60)
                                .background(Color(red: 0.96, green: 0.96, blue: 0.96))
                                .cornerRadius(12)
                            }
                        }
                    } else {
                        Text("회의 기록이 없습니다.")
                            .font(Font.system(size: 16))
                            .foregroundColor(.gray)
                    }
                }
                .padding(.top, 16)
                .padding(.horizontal)
            }
        }
        .sheet(isPresented: $showModal) {
            VStack {
                DatePicker(
                    "시간 선택",
                    selection: $newTime,
                    displayedComponents: [.hourAndMinute]
                )
                .datePickerStyle(WheelDatePickerStyle())
                .padding()
                
                TextField("제목 입력", text: $newTitle)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button("추가") {
                    let timeFormatter = DateFormatter()
                    timeFormatter.dateFormat = "HH:mm"
                    let timeString = timeFormatter.string(from: newTime)
                    
                    if !items.keys.contains(currentDate) {
                        items[currentDate] = []
                    }
                    items[currentDate]?.append((time: timeString, title: newTitle))
                    showModal.toggle()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(12)
                
                Spacer()
            }
            .padding()
        }
    }
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M월 d일 (E)"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
}

#Preview {
    SidebarView()
}
