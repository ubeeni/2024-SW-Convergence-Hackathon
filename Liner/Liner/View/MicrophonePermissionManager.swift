import SwiftUI
import AVFoundation

class MicrophonePermissionManager: ObservableObject {
    @Published var permissionGranted = false

    func requestPermission() {
        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            DispatchQueue.main.async {
                self.permissionGranted = granted
            }
        }
    }

    func checkPermission() {
        switch AVAudioSession.sharedInstance().recordPermission {
        case .granted:
            permissionGranted = true
        case .denied:
            permissionGranted = false
        case .undetermined:
            permissionGranted = false
        @unknown default:
            permissionGranted = false
        }
    }
}
