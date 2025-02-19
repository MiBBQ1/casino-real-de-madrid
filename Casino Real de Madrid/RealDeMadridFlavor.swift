
import SwiftUI
import WebKit
import AppTrackingTransparency
import AdSupport
import OneSignalFramework
import AdServices

struct DotsLoaderView: View {
    @State private var isAnimating = false

    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<3) { index in
                Circle()
                    .frame(width: 12, height: 12)
                    .foregroundColor(.red)
                    .opacity(isAnimating ? 0.3 : 1.0)
                    .scaleEffect(isAnimating ? 0.8 : 1.2)
                    .animation(
                        Animation.easeInOut(duration: 0.6)
                            .repeatForever()
                            .delay(0.2 * Double(index)),
                        value: isAnimating
                    )
            }
        }
        .onAppear { isAnimating = true }
    }
}

@main
struct RealDeMadridFlavorApp: App {
    
    @State private var appState: AppState = .loading1
    @UIApplicationDelegateAdaptor(AppDelegateNapoLega.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                ContentView()
                    .onAppear { requestTrackingPermission() }
            }
            .onAppear { appState = .game }
        }
    }

    enum AppState {
        case loading1, loading2, webView, game
    }



    private func requestTrackingPermission() {
        guard #available(iOS 14, *) else { return }

        ATTrackingManager.requestTrackingAuthorization { status in
            DispatchQueue.main.async {
                switch status {
                case .authorized, .denied, .restricted:
                    NotificationCenter.default.post(name: .didReceiveTrackNapoLega, object: nil)

                case .notDetermined:
                    requestTrackingPermission()

                @unknown default:
                    print("Unknown tracking permission status")
                }
            }
        }
    }

 
}
