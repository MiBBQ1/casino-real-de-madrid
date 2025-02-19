import Foundation
import SwiftUI
import UserNotifications
import AppTrackingTransparency
import AdSupport
import AdServices
import OneSignalFramework
import AppsFlyerLib
import Swifter

extension Notification.Name {
    static let didReceiveTrackNapoLega = Notification.Name("didReceiveTrackingAuthorization")
}

class AppDelegateNapoLega: NSObject, UIApplicationDelegate, AppsFlyerLibDelegate {
    
    static var orientationLock = UIInterfaceOrientationMask.all
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleTrackingAuthorizationNotification(_:)),
                                               name: .didReceiveTrackNapoLega,
                                               object: nil)
        
        //LclServNapoLega.shared.start()
        
        
        if let idfv = UIDevice.current.identifierForVendor?.uuidString {
           // UserDefaults.standard.setValue(idfv, forKey: ConstNapoLega.idfvID)
            AppsFlyerLib.shared().customerUserID = idfv
        }

        
        Task {
                    if let fetchedToken = await fetchAttributionToken() {
                        for i in 1...2 {
                            try? await Task.sleep(nanoseconds: UInt64(Double(i) * 5 * 1_000_000_000))
                          //  if let response = await sendTokenToASA(token: fetchedToken) {
                          //      handleResponse(response)
                          //  }
                        }
                    }
                }
        
        initializeOneSignal(launchOptions: launchOptions)
        initializeAppsFlyer()
        
        return true
    }
    
    @objc private func handleTrackingAuthorizationNotification(_ notification: Notification) {
        requestNotificationPermission()
        AppsFlyerLib.shared().start()
        
        
        let appsFlyerUID = AppsFlyerLib.shared().getAppsFlyerUID()
        if UserDefaults.standard.object(forKey: "appsEntryFirst") == nil {
            UserDefaults.standard.set(true, forKey: "appsEntryFirst")
           // UserDefaults.standard.setValue(appsFlyerUID, forKey: ConstNapoLega.appsUID)
        }
    }
 
    
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            if granted {
                UserDefaults.standard.set(true, forKey: "push_subscribe")
            }
        }
    }
    
    func application(_ application: UIApplication,
                     supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegateNapoLega.orientationLock
    }
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        if let customOSPayload = userInfo["custom"] as? NSDictionary,
           let launchUrl = customOSPayload["u"] as? String,
           let url = URL(string: launchUrl) {
           // UserDefaults.standard.set(true, forKey: ConstNapoLega.opFormPush)
            UIApplication.shared.open(url)
           // EvServNapoLega.shared.sendEvent(eventName: "push_open_browser")
        } else {
           // UserDefaults.standard.set(true, forKey: ConstNapoLega.opFormPush)
           // EvServNapoLega.shared.sendEvent(eventName: "push_open_webview")
        }
        
        completionHandler(.newData)
    }
    
    private func initializeOneSignal(launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        OneSignal.Debug.setLogLevel(.LL_VERBOSE)
        OneSignal.initialize("54b56ce2-70bf-4ef5-89ca-4857b05526f0", withLaunchOptions: launchOptions)
    }
    
    private func initializeAppsFlyer() {
        AppsFlyerLib.shared().appsFlyerDevKey = "BX5RmT4UeiWBs7XFeqzzDM"
        AppsFlyerLib.shared().appleAppID = "6741475841"
        AppsFlyerLib.shared().delegate = self
        AppsFlyerLib.shared().start()
    }
}
@MainActor
func handleResponse(_ response: String?) {
    guard let response = response, let data = response.data(using: .utf8) else { return }
    
    if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
       let dict = jsonObject as? [String: Any],
       let attribution = dict["attribution"] as? Bool {
       // UserDefaults.standard.set(attribution, forKey: ConstNapoLega.isASA)
    }
}


@MainActor
func fetchAttributionToken() async -> String? {
    do {
        return try AAAttribution.attributionToken()
    } catch {
        return nil
    }
}

extension AppDelegateNapoLega {
    func onConversionDataSuccess(_ installData: [AnyHashable: Any]) {
        if let status = installData["af_status"] as? String, status == "Non-organic",
           let campaign = installData["campaign"] as? String {
            
          
        }
        
    }
    
    func onConversionDataFail(_ error: Error) {
        print(error)
        
    }
     
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        AppsFlyerLib.shared().handleOpen(url, options: options)
        return true
    }
     
    func onAppOpenAttribution(_ attributionData: [AnyHashable : Any]) {
        print("\(attributionData)")
       
    }
    
    func onAppOpenAttributionFailure(_ error: Error) {
        print(error)
       
        
    }
}

