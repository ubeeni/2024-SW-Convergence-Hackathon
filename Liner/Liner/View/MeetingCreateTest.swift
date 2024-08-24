import SwiftUI
import Firebase

struct UserInfo {
    let name: String
    let email: String
    let department: String
    let jobDescription: String
}

struct MeetingCreateTest: View {
    @State private var userInfos: [UserInfo] = []
    @State private var selectedUserNames: [String] = []
    @State private var meetingStartTime = Date()
    @State private var meetingEndTime = Date()
    @State private var requestReason = ""
    @State private var showUserSelectionModal = false
    @ObservedObject var userViewModel = FirebaseUserViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            Button(action: {
                loadUserInfos()
                showUserSelectionModal = true
            }) {
                Text("Select Recipients")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .sheet(isPresented: $showUserSelectionModal) {
                UserSelectionModal(userNames: .constant(userInfos.map { $0.name }), selectedUsers: $selectedUserNames)
            }

            DatePicker("회의 시작 시간", selection: $meetingStartTime, displayedComponents: [.date, .hourAndMinute])
            
            DatePicker("회의 종료 시간", selection: $meetingEndTime, displayedComponents: [.date, .hourAndMinute])
            
            TextField("요청사유", text: $requestReason)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button(action: {
                saveMeeting()
            }) {
                Text("Create Meeting")
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
    }
    
    private func loadUserInfos() {
        let firestore = Firestore.firestore()
        firestore.collection("user").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching user infos: \(error.localizedDescription)")
            } else {
                if let documents = snapshot?.documents {
                    userInfos = documents.compactMap { document -> UserInfo? in
                        guard let name = document["userName"] as? String,
                              let email = document["email"] as? String,
                              let department = document["department"] as? String,
                              let jobDescription = document["jobDescription"] as? String else {
                            return nil
                        }
                        return UserInfo(name: name, email: email, department: department, jobDescription: jobDescription)
                    }
                }
            }
        }
    }

    private func saveMeeting() {
        let firestore = Firestore.firestore()
        
        // 선택된 사용자 이름을 이메일로 변환
        let selectedUserEmails = selectedUserNames.compactMap { name -> String? in
            return userInfos.first(where: { $0.name == name })?.email
        }
        
        // `replyPerson` 배열을 생성
        var replyPerson: [String] = []
        if selectedUserNames.contains(userViewModel.savedUserName) {
            replyPerson.append(userViewModel.email)
        }
        
        let meetingData: [String: Any] = [
            "requestPerson": userViewModel.email,
            "susinja": selectedUserEmails,
            "replyPerson": replyPerson,
            "meetingStartTime": meetingStartTime,
            "meetingEndTime": meetingEndTime,
            "requestReason": requestReason,
            "requestTime": Date()
        ]

        let timestamp = DateFormatterManager.shared.stringWithCurrentDate(format: .fullDateTime)
        firestore.collection("meeting").document(timestamp).setData(meetingData) { error in
            if let error = error {
                print("Error creating meeting: \(error.localizedDescription)")
            } else {
                print("Meeting successfully created!")
            }
        }
    }
}

import SwiftUI

struct UserSelectionModal: View {
    @Binding var userNames: [String]
    @Binding var selectedUsers: [String]
    @Environment(\.presentationMode) var presentationMode // 모달창 닫기 위한 환경 변수
    
    var body: some View {
        NavigationView {
            List(userNames, id: \.self) { userName in
                MultipleSelectionRow(title: userName, isSelected: selectedUsers.contains(userName)) {
                    if selectedUsers.contains(userName) {
                        selectedUsers.removeAll(where: { $0 == userName })
                    } else {
                        selectedUsers.append(userName)
                    }
                }
            }
            .navigationTitle("회의에 참석할 인원을 선택하세요.")
            .navigationBarItems(trailing: Button("확인") {
                presentationMode.wrappedValue.dismiss() // 모달 창 닫기
            })
        }
    }
}


struct MultipleSelectionRow: View {
    var title: String
    var isSelected: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                if isSelected {
                    Spacer()
                    Image(systemName: "checkmark")
                }
            }
        }
    }
}
