import SwiftUI
import Firebase
import UserNotifications

struct ContentView: View {
    @State private var selectedMeeting: Meeting?
    @State private var meetingTime: String = ""
    
    var body: some View {
        HStack(spacing: 0) {
            SidebarView(selectedMeeting: $selectedMeeting)
                .frame(width: 385)
            
            if let meeting = selectedMeeting {
                MeetingView(meetingTitle: meeting.title,
                            meetingTime: meeting.time,
                            attendees: meeting.attendees)
                .padding(.trailing, 37)
            } else {
                VStack {
                    Image(.imgTalk)
                        .resizable()
                    
                    Spacer()
                }
                .padding(.trailing, 37)
                .frame(width: .infinity)
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .handleDeepLink)) { notification in
            print("Notification received")
            if let url = notification.object as? URL {
                print("URL received: \(url)")
                handleDeepLink(url: url)
            } else {
                print("No URL found in notification")
            }
        }
        .onAppear {
            // 앱 실행 시 혹시 알림 데이터가 있는지 확인 (cold start 대응)
            if let url = getDeepLinkFromLaunchOptions() {
                handleDeepLink(url: url)
            }
        }
    }
    
    private func handleDeepLink(url: URL) {
        // 딥링크의 URL Scheme 및 호스트를 확인합니다.
        print("Handling deep link with URL: \(url)")
        if url.scheme == "liner" && url.host == "meetingDetail" {
            // URL에서 쿼리 파라미터를 추출합니다.
            if let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems {
                if let meetingTimeParam = queryItems.first(where: { $0.name == "meetingTime" })?.value {
                    // meetingTime 값을 상태 변수에 저장
                    meetingTime = meetingTimeParam
                    print("미팅타임은 이것 !! \(meetingTime)")
                    
                    // Firestore에서 해당 meetingTime에 맞는 데이터를 가져오는 함수 호출
                    fetchMeeting(meetingTime: meetingTime)
                } else {
                    print("No meetingTime parameter found")
                }
            } else {
                print("Failed to extract query items from URL")
            }
        } else {
            print("URL scheme or host does not match")
        }
    }

    private func fetchMeeting(meetingTime: String) {
        print("Firestore query for meetingTime: \(meetingTime)")
        
        let db = Firestore.firestore()
        let meetingsRef = db.collection("meeting")
        
        // 트리밍하여 공백 제거
        let trimmedMeetingTime = meetingTime.trimmingCharacters(in: .whitespacesAndNewlines)
        print("Trimmed meetingTime: \(trimmedMeetingTime)")
        
        // Firestore 쿼리
        meetingsRef.getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching meeting: \(error.localizedDescription)")
                return
            }
            
            print("Documents found: \(snapshot?.documents.count ?? 0)")
            
            guard let documents = snapshot?.documents, !documents.isEmpty else {
                print("No meeting found with the specified time")
                return
            }
            
            // 각 문서에 대해 비교
            for document in documents {
                let documentID = document.documentID
                
                // meetingTime과 문서 ID를 비교
                if documentID == trimmedMeetingTime {
                    let meetingData = document.data()
                    print("Matching meeting found: \(meetingData)")
                    
                    // 선택된 미팅으로 설정
                    DispatchQueue.main.async {
//                        self.selectedMeeting = Meeting(
//                            title: meetingData["title"] as? String ?? "",
//                            time: meetingData["time"] as? String ?? "",
//                            attendees: meetingData["attendees"] as? [String] ?? []
//                        )
                    }
                    break
                }
            }
        }
    }






    private func getDeepLinkFromLaunchOptions() -> URL? {
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            return sceneDelegate.launchURL
        }
        return nil
    }
}
