//
//  UserInfoCreateTest.swift
//  Liner
//
//  Created by ram on 8/24/24.
//
import SwiftUI
import Firebase

// MARK: - View
struct UserInfoCreateTest: View {
    @StateObject private var viewModel = FirebaseUserViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("사용자 정보를 입력해주세요")
                    .font(.headline)
                    .padding()
                
                TextField("이름 입력", text: $viewModel.savedUserName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                
                HStack {
                    TextField("이메일 입력", text: $viewModel.email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .keyboardType(.emailAddress)
                        .onChange(of: viewModel.email) { _ in
                            viewModel.isEmailVerified = false
                        }
                    
                    Button("중복확인") {
                        viewModel.checkEmailDuplication()
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(viewModel.isEmailVerified ? Color.gray : Color.blue)
                    .cornerRadius(5)
                    .disabled(viewModel.isEmailVerified)
                }
                .padding()
                
                TextField("부서 입력", text: $viewModel.department)  // 부서 입력 필드 추가
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                
                TextField("직무 설명 입력", text: $viewModel.jobDescription)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                
                
                Button(viewModel.isUserInfoSaved ? "수정" : "저장") {
                    viewModel.saveUserInfo()
                }
                .foregroundColor(.white)
                .padding()
                .background(Color.blue)
                .cornerRadius(8)
                .padding()
                
                if !viewModel.statusMessage.isEmpty {
                    Text(viewModel.statusMessage)
                        .foregroundColor(.green)
                        .padding()
                }
                
                NavigationLink("미팅생성", destination: MeetingCreateTest())
            }
            .padding()
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text("알림"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("확인")))
            }
        }
    }
}


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

