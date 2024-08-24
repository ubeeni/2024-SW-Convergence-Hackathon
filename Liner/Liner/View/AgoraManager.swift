import Foundation
import AgoraRtcKit

class AgoraManager: NSObject, ObservableObject, AgoraRtcEngineDelegate {
    @Published var isInChannel = false
    @Published var participants: [UInt: ParticipantInfo] = [:]
    
    private var agoraEngine: AgoraRtcEngineKit?
    private let appId = "85346947a1ea4fb28109d090d3e1ec50"
    private let channelName = "good"
    
    override init() {
        super.init()
        setupAgoraEngine()
    }
    
    private func setupAgoraEngine() {
        agoraEngine = AgoraRtcEngineKit.sharedEngine(withAppId: appId, delegate: self)
        agoraEngine?.setChannelProfile(.communication)
        agoraEngine?.setClientRole(.broadcaster)
        agoraEngine?.enableAudio()
        
        agoraEngine?.enableAudioVolumeIndication(5, smooth: 10, reportVad: true)
    }
    
    func joinChannel(name: String) {
        agoraEngine?.joinChannel(byToken: "007eJxTYJA7WrL54qrbr3TWrfA8wLlDljklwi8098qVhLKfVrsW93srMFiYGpuYWZqYJxqmJpqkJRlZGBpYphhYGqQYpxqmJpsaZAecTGsIZGT4stSbhZEBAkF8Fob0/PwUBgYAhXsgLw==", channelId: channelName, info: nil, uid: 0) { _, uid, _ in
            DispatchQueue.main.async {
                self.isInChannel = true
                self.participants[uid] = ParticipantInfo(uid: uid, isSpeaking: false, userName: name)
            }
        }
    }
    
    func leaveChannel() {
        agoraEngine?.leaveChannel(nil)
        isInChannel = false
        participants.removeAll()
    }
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinChannel channel: String, withUid uid: UInt, elapsed: Int) {
        print("Joined channel: \(channel) with UID: \(uid)")
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int, name: String) {
          print("User joined: \(uid)")
          DispatchQueue.main.async {
              self.participants[uid] = ParticipantInfo(uid: uid, isSpeaking: false, userName: name)
          }
      }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid: UInt, reason: AgoraUserOfflineReason) {
        DispatchQueue.main.async {
            self.participants.removeValue(forKey: uid)
        }
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, reportAudioVolumeIndicationOfSpeakers speakers: [AgoraRtcAudioVolumeInfo], totalVolume: Int) {
//         print("Audio volume indication - Total volume: \(totalVolume)")
         DispatchQueue.main.async {
             // Reset all participants to not speaking
             for uid in self.participants.keys {
                 self.participants[uid]?.isSpeaking = false
             }
             
             // Update speaking status for active speakers
             for speaker in speakers {
//                 print("Speaker UID: \(speaker.uid), Volume: \(speaker.volume)")
                 if speaker.volume > 5 { // Adjust this threshold as needed
                     self.participants[speaker.uid]?.isSpeaking = true
                 }
             }
         }
     }
}

struct ParticipantInfo: Identifiable {
    let id = UUID()
    let uid: UInt
    var isSpeaking: Bool
    var userName: String
}
