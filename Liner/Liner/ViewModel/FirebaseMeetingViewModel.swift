//
//  FirebaseMeetingViewModel.swift
//  Liner
//
//  Created by ram on 8/24/24.
//
//import SwiftUI
//import Firebase
//
//class FirebaseMeetingViewModel: ObservableObject {
//    @Published var userInfos: [UserInfo] = []
//    @Published var selectedUserNames: [String] = []
//    @Published var meetingStartTime = Date()
//    @Published var meetingEndTime = Date()
//    @Published var requestReason = ""
//    @Published var showUserSelectionModal = false
//    
//    func loadUserInfos() {
//        let firestore = Firestore.firestore()
//        firestore.collection("user").getDocuments { snapshot, error in
//            if let error = error {
//                print("Error fetching user infos: \(error.localizedDescription)")
//            } else {
//                if let documents = snapshot?.documents {
//                    self.userInfos = documents.compactMap { document -> UserInfo? in
//                        guard let name = document["userName"] as? String,
//                              let email = document["email"] as? String,
//                              let department = document["department"] as? String,
//                              let jobDescription = document["jobDescription"] as? String else {
//                            return nil
//                        }
//                        return UserInfo(name: name, email: email, department: department, jobDescription: jobDescription)
//                    }
//                }
//            }
//        }
//    }
//    
//    func saveMeeting(requestPersonEmail: String, savedUserName: String, userEmail: String) {
//        let firestore = Firestore.firestore()
//        
//        // Convert selected user names to emails
//        let selectedUserEmails = selectedUserNames.compactMap { name -> String? in
//            return userInfos.first(where: { $0.name == name })?.email
//        }
//        
//        // Create `replyPerson` array
//        var replyPerson: [String] = []
//        if selectedUserNames.contains(savedUserName) {
//            replyPerson.append(userEmail)
//        }
//        
//        let meetingData: [String: Any] = [
//            "requestPerson": requestPersonEmail,
//            "susinja": selectedUserEmails,
//            "replyPerson": replyPerson,
//            "meetingStartTime": meetingStartTime,
//            "meetingEndTime": meetingEndTime,
//            "requestReason": requestReason,
//            "requestTime": Date()
//        ]
//        
//        let timestamp = DateFormatterManager.shared.stringWithCurrentDate(format: .fullDateTime)
//        firestore.collection("meeting").document(timestamp).setData(meetingData) { error in
//            if let error = error {
//                print("Error creating meeting: \(error.localizedDescription)")
//            } else {
//                print("Meeting successfully created!")
//            }
//        }
//    }
//}
