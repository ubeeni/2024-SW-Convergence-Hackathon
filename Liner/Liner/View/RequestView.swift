//
//  RequestView.swift
//  Liner
//
//  Created by KimYuBin on 8/24/24.
//

import SwiftUI

struct RequestView: View {
    @Binding var currentDate: Date
    @Binding var items: [Date: [(time: String, title: String, attendees: [Participant])]]
    @Binding var selectedParticipants: Set<Participant>
    
    @State private var newTimeStart = Date()
    @State private var newTimeEnd = Date()
    @State private var newTitle: String = ""
    @State private var searchQuery: String = ""
    @State private var availableParticipants: [Participant] = [
        Participant(name: "김파이리", team: "개발 1팀", image: "imgProfile1"),
        Participant(name: "이파이리", team: "개발 1팀", image: "imgProfile2"),
        Participant(name: "박파이리", team: "개발 1팀", image: "imgProfile3"),
        Participant(name: "김니니", team: "개발 2팀", image: "imgProfile4"),
        Participant(name: "이니니", team: "개발 2팀", image: "imgProfile5")
    ]
    @State private var filteredParticipants: [Participant] = []
    @State private var selectedTags: [String] = []
    @State private var newTag: String = ""
    
    @Environment(\.presentationMode) var presentationMode
    
    let defaultTags: [String] = ["#신규", "#기존", "#긴급", "#정기", "#검토요청", "#코드리뷰", "#계획수립", "#경과보고"]
    
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                Spacer()
                
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark")
                        .font(Font.system(size: 40))
                        .fontWeight(.medium)
                        .foregroundStyle(Color(red: 0.85, green: 0.85, blue: 0.85))
                }
                .padding([.top, .trailing], 30)
            }
            
            VStack(alignment: .leading) {
                HStack {
                    Text("참여자")
                        .font(Font.system(size: 20))
                        .fontWeight(.medium)
                        .foregroundStyle(.black)
                    
                    VStack {
                        TextField("클릭하여 검색", text: $searchQuery, onCommit: {
                            searchParticipants()
                        })
                        .foregroundStyle(Color.black)
                        .padding()
                        .frame(width: 473, height: 50)
                        .background(Color(red: 0.94, green: 0.94, blue: 0.94))
                        .cornerRadius(20)
                        .padding(.leading, 53)
                    }
                }
                
                HStack(spacing: 16) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(displayedParticipants, id: \.self) { participant in
                                Button(action: {
                                    toggleParticipant(participant)
                                }) {
                                    VStack {
                                        Image(participant.image)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 81, height: 81)
                                        
                                        VStack {
                                            Text(participant.name)
                                                .foregroundStyle(.black)
                                                .fontWeight(.bold)
                                                .padding(.bottom, 2)
                                            Text(participant.team)
                                                .foregroundStyle(.black)
                                                .font(.subheadline)
                                        }
                                        .padding(8)
                                    }
                                    .opacity(selectedParticipants.contains(participant) ? 1.0 : 0.2)
                                    .cornerRadius(8)
                                    .padding(2)
                                }
                            }
                        }
                    }
                }
                .padding(.bottom, 16)
                
                Text("회의 제목")
                    .font(Font.system(size: 20))
                    .fontWeight(.medium)
                    .foregroundStyle(.black)
                
                TextField("회의 제목 입력", text: $newTitle)
                    .foregroundStyle(Color.black)
                    .padding()
                    .frame(width: 590, height: 48)
                    .background(Color(red: 0.94, green: 0.94, blue: 0.94))
                    .cornerRadius(20)
                    .padding(.bottom, 20)
                
                Text("회의 시간")
                    .font(Font.system(size: 20))
                    .fontWeight(.medium)
                    .foregroundStyle(.black)
                
                HStack {
                    HStack(spacing: 8) {
                        DatePicker("", selection: $currentDate, displayedComponents: [.date])
                            .environment(\.locale, Locale(identifier: "ko_KR"))
                            .datePickerStyle(CompactDatePickerStyle())
                            .onChange(of: currentDate) {
                                formatDate()
                            }
                            .labelsHidden()
                            .clipped()
                            .padding(.leading, 10)
                        
                        DatePicker("", selection: $newTimeStart, displayedComponents: [.hourAndMinute])
                            .labelsHidden()
                            .datePickerStyle(WheelDatePickerStyle())
                            .onChange(of: newTimeStart) {
                                validateTimeSelection()
                            }
                            .font(Font.system(size: 20))
                            .clipped()
                        
                        Text("~")
                            .foregroundStyle(.black)
                            .font(Font.system(size: 16))
                        
                        DatePicker("", selection: $newTimeEnd, displayedComponents: [.hourAndMinute])
                            .labelsHidden()
                            .datePickerStyle(WheelDatePickerStyle())
                            .onChange(of: newTimeEnd) {
                                validateTimeSelection()
                            }
                            .font(Font.system(size: 20))
                            .clipped()
                    }
                }
                
                HStack {
                    Text("회의 태그")
                        .font(Font.system(size: 20))
                        .fontWeight(.medium)
                        .foregroundStyle(.black)
                        .padding(.trailing, 25)
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(splitTagsIntoRows(), id: \.self) { rowTags in
                        HStack(spacing: 10) {
                            ForEach(rowTags, id: \.self) { tag in
                                Button(action: {
                                    toggleTag(tag)
                                }) {
                                    Text(tag)
                                        .padding(.vertical, 12)
                                        .padding(.horizontal, 24)
                                        .foregroundStyle(Color.black)
                                        .background(selectedTags.contains(tag) ? Color(red: 0.94, green: 0.94, blue: 0.94) : Color.white)
                                        .cornerRadius(20)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 20)
                                                .inset(by: 1)
                                                .stroke(Color(red: 0.94, green: 0.94, blue: 0.94), lineWidth: 2)
                                        )
                                }
                            }
                            
                            if rowTags == splitTagsIntoRows().last {
                                TextField("태그 추가", text: $newTag, onCommit: {
                                    addNewTag()
                                })
                                .foregroundStyle(Color.black)
                                .padding()
                                .frame(width: 98, height: 48)
                                .background(Color(red: 0.94, green: 0.94, blue: 0.94))
                                .cornerRadius(20)
                            }
                        }
                    }
                }
                
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Button("회의 요청하기") {
                        let timeFormatter = DateFormatter()
                        timeFormatter.dateFormat = "HH:mm"
                        let timeStringStart = timeFormatter.string(from: newTimeStart)
                        let timeStringEnd = timeFormatter.string(from: newTimeEnd)
                        
                        let title = newTitle
                        
                        if !items.keys.contains(currentDate) {
                            items[currentDate] = []
                        }
                        
                        
                        items[currentDate]?.append((
                            time: "\(timeStringStart) ~ \(timeStringEnd)",
                            title: title,
                            attendees: Array(selectedParticipants)
                        ))
                        
                        resetSelection()
                        presentationMode.wrappedValue.dismiss()
                    }
                    .font(Font.system(size: 20))
                    .fontWeight(.semibold)
                    .padding(.horizontal, 134)
                    .padding(.vertical, 18)
                    .background(Color(red: 0.85, green: 0.97, blue: 0.51))
                    .foregroundColor(.black)
                    .cornerRadius(12)
                    .disabled(newTimeEnd <= newTimeStart)
                    
                    Spacer()
                }
                .padding(.vertical, 20)
            }
            .padding(.horizontal, 40)
        }
        .background(Color.white)
        .padding()
        .clipped()
        .onAppear {
            formatDate()
            filteredParticipants = availableParticipants
        }
        .frame(width: 950, height: 750)
    }
    
    func resetSelection() {
        selectedParticipants.removeAll()
        newTimeStart = Date()
        newTimeEnd = Date()
        newTitle = ""
        searchQuery = ""
        newTag = ""
        selectedTags.removeAll()
    }
    
    var displayedParticipants: [Participant] {
        if searchQuery.isEmpty {
            return availableParticipants.filter { selectedParticipants.contains($0) || !availableParticipants.contains($0) }
        } else {
            return availableParticipants.filter { participant in
                participant.name.contains(searchQuery) || participant.team.contains(searchQuery) || selectedParticipants.contains(participant)
            }
        }
    }
    
    func splitTagsIntoRows() -> [[String]] {
        var rows: [[String]] = []
        var currentRow: [String] = []
        var currentWidth: CGFloat = 0
        let maxWidth: CGFloat = 900
        
        let allTags = defaultTags + selectedTags.filter { !defaultTags.contains($0) }
        
        for tag in allTags {
            let tagWidth = tag.widthOfString(usingFont: .systemFont(ofSize: 20)) + 48
            if currentWidth + tagWidth > maxWidth {
                rows.append(currentRow)
                currentRow = [tag]
                currentWidth = tagWidth
            } else {
                currentRow.append(tag)
                currentWidth += tagWidth + 10
            }
        }
        
        if !currentRow.isEmpty {
            rows.append(currentRow)
        }
        
        return rows
    }
    
    func formatDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy. MM. dd(E)"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        
        let formattedDate = dateFormatter.string(from: currentDate)
    }
    
    func searchParticipants() {
        filteredParticipants = displayedParticipants
    }
    
    func toggleParticipant(_ participant: Participant) {
        if selectedParticipants.contains(participant) {
            selectedParticipants.remove(participant)
        } else {
            selectedParticipants.insert(participant)
        }
    }
    
    func toggleTag(_ tag: String) {
        if let index = selectedTags.firstIndex(of: tag) {
            selectedTags.remove(at: index)
        } else {
            selectedTags.append(tag)
        }
    }
    
    func addNewTag() {
        let tagToAdd = newTag.trimmingCharacters(in: .whitespacesAndNewlines)
        if !tagToAdd.isEmpty {
            let formattedTag = tagToAdd.hasPrefix("#") ? tagToAdd : "#\(tagToAdd)"
            selectedTags.append(formattedTag)
            newTag = ""
        }
    }
    
    func validateTimeSelection() {
        if newTimeEnd <= newTimeStart {
            newTimeEnd = Calendar.current.date(byAdding: .minute, value: 30, to: newTimeStart) ?? newTimeStart
        }
    }
}

extension String {
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = (self as NSString).size(withAttributes: fontAttributes)
        return size.width
    }
}
