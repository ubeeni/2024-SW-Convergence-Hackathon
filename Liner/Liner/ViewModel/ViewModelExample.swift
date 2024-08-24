import SwiftUI
import Firebase

// MARK: - ViewModel
class FirebaseUserViewModel: ObservableObject {
    @Published var savedUserName: String = ""
    @Published var email: String = ""
    @Published var jobDescription: String = ""
    @Published var department: String = ""  // 부서 정보 추가
    @Published var isEmailVerified = false
    @Published var statusMessage = ""
    @Published var alertMessage = ""
    @Published var showAlert = false
    @Published var isUserInfoSaved = false
    
    private let userDefaults = UserDefaults.standard
    private let firestore = Firestore.firestore()
    
    init() {
        loadUserInfo()
    }
    
    func loadUserInfo() {
        loadUserInfoFromUserDefaults()
        loadUserInfoFromFirestore()
    }
    
    private func loadUserInfoFromUserDefaults() {
        savedUserName = userDefaults.string(forKey: "userName") ?? ""
        email = userDefaults.string(forKey: "userEmail") ?? ""
        jobDescription = userDefaults.string(forKey: "userJobDescription") ?? ""
        department = userDefaults.string(forKey: "userDepartment") ?? ""  // 부서 정보 로드
        isEmailVerified = !email.isEmpty
        isUserInfoSaved = !savedUserName.isEmpty || !email.isEmpty || !jobDescription.isEmpty || !department.isEmpty
    }
    
    private func loadUserInfoFromFirestore() {
        guard let currentDeviceToken = Messaging.messaging().fcmToken else {
            statusMessage = "디바이스 토큰을 가져오지 못했습니다."
            return
        }
        
        firestore.collection("user")
            .whereField("deviceToken", isEqualTo: currentDeviceToken)
            .getDocuments { [weak self] snapshot, error in
                guard let self = self else { return }
                
                if let error = error {
                    self.statusMessage = "Firestore에서 문서 검색 중 오류 발생: \(error.localizedDescription)"
                    return
                }
                
                if let document = snapshot?.documents.first {
                    let data = document.data()
                    DispatchQueue.main.async {
                        self.savedUserName = data["userName"] as? String ?? ""
                        self.email = data["email"] as? String ?? ""
                        self.jobDescription = data["jobDescription"] as? String ?? ""
                        self.department = data["department"] as? String ?? ""  // 부서 정보 로드
                        self.isEmailVerified = !self.email.isEmpty
                        self.isUserInfoSaved = true
                        
                        // Firestore에서 로드한 데이터를 UserDefaults에도 저장
                        self.userDefaults.set(self.savedUserName, forKey: "userName")
                        self.userDefaults.set(self.email, forKey: "userEmail")
                        self.userDefaults.set(self.jobDescription, forKey: "userJobDescription")
                        self.userDefaults.set(self.department, forKey: "userDepartment")  // 부서 정보 저장
                    }
                }
            }
    }
    
    func checkEmailDuplication() {
        firestore.collection("user").whereField("email", isEqualTo: email).getDocuments { [weak self] (snapshot, error) in
            guard let self = self else { return }
            
            if let error = error {
                self.statusMessage = "이메일 확인 중 오류 발생: \(error.localizedDescription)"
                self.alertMessage = "이메일 확인 중 오류가 발생했습니다."
                self.showAlert = true
                return
            }
            
            if let documents = snapshot?.documents, !documents.isEmpty {
                self.alertMessage = "이미 등록된 이메일입니다. 다른 이메일을 선택해주세요."
                self.isEmailVerified = false
            } else {
                self.alertMessage = "사용 가능한 이메일입니다."
                self.isEmailVerified = true
            }
            self.showAlert = true
        }
    }
    
    func saveUserInfo() {
        guard isEmailVerified else {
            alertMessage = "중복확인을 해주세요"
            showAlert = true
            return
        }
        
        userDefaults.set(savedUserName, forKey: "userName")
        userDefaults.set(email, forKey: "userEmail")
        userDefaults.set(jobDescription, forKey: "userJobDescription")
        userDefaults.set(department, forKey: "userDepartment")  // 부서 정보 저장
        
        isUserInfoSaved = true
        statusMessage = "정보가 저장되었습니다!"
        
        saveUserInfoToFirestore()
    }
    
    private func saveUserInfoToFirestore() {
        guard let currentDeviceToken = Messaging.messaging().fcmToken else {
            statusMessage = "디바이스 토큰을 가져오지 못했습니다."
            return
        }
        
        let userData: [String: Any] = [
            "userName": savedUserName,
            "email": email,
            "jobDescription": jobDescription,
            "department": department,  // 부서 정보 추가
            "deviceToken": currentDeviceToken,
            "isPresent": 0
        ]
        
        firestore.collection("user")
            .whereField("deviceToken", isEqualTo: currentDeviceToken)
            .getDocuments { [weak self] snapshot, error in
                guard let self = self else { return }
                
                if let error = error {
                    self.statusMessage = "Firestore에서 문서 검색 중 오류 발생: \(error.localizedDescription)"
                    return
                }
                
                if let document = snapshot?.documents.first {
                    document.reference.updateData(userData) { error in
                        if let error = error {
                            self.statusMessage = "Firestore에서 문서 업데이트 중 오류 발생: \(error.localizedDescription)"
                        } else {
                            self.statusMessage = "문서가 성공적으로 업데이트되었습니다!"
                        }
                    }
                } else {
                    let timestamp = DateFormatterManager.shared.stringWithCurrentDate(format: .fullDateTime)
                    self.firestore.collection("user").document(timestamp).setData(userData) { error in
                        if let error = error {
                            self.statusMessage = "Firestore에 새 문서 생성 중 오류 발생: \(error.localizedDescription)"
                        } else {
                            self.statusMessage = "새 문서가 타임스탬프로 성공적으로 생성되었습니다!"
                        }
                    }
                }
            }
    }
}
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

import Foundation

class DateFormatterManager {
    static let shared = DateFormatterManager()
    
    private init() {}
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        return formatter
    }()
    
    // 여러 날짜 형식 정의
    enum DateFormat: String {
        case fullDateTime = "yyyy-MM-dd HH:mm:ss"
        case shortDate = "yyyy-MM-dd"
        case timeOnly = "HH:mm:ss"
        case customDateTime = "dd/MM/yyyy HH:mm" // 원하는 다른 형식을 추가할 수 있음
    }
    
    // 현재 시간을 포함하는 경우
    func stringWithCurrentDate(format: DateFormat) -> String {
        let currentDate = Date()
        dateFormatter.dateFormat = format.rawValue
        return dateFormatter.string(from: currentDate)
    }
    
    // 특정 날짜를 문자열로 변환 (현재 시간 포함 안함)
    func string(from date: Date, format: DateFormat) -> String {
        dateFormatter.dateFormat = format.rawValue
        return dateFormatter.string(from: date)
    }
    
    // 문자열을 날짜로 변환
    func date(from string: String, format: DateFormat) -> Date? {
        dateFormatter.dateFormat = format.rawValue
        return dateFormatter.date(from: string)
    }
}
