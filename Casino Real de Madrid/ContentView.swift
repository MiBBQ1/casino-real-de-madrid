

import SwiftUI

struct ContentView: View {
    @Environment(\.window) private var window: UIWindow?
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
            Text("Hello, world!")
           
        }
        .onAppear(){
            showLoginViewController()
        }
    }
    
    private func showLoginViewController() {
           let storyboard = UIStoryboard(name: "Main", bundle: nil)
           if let loginVC = storyboard.instantiateViewController(withIdentifier: "SplashViewController") as? SplashViewController {
               let rootVC = UINavigationController(rootViewController: loginVC)
               rootVC.navigationBar.isHidden = true
               window?.rootViewController = rootVC
           }
       }
}

#Preview {
    ContentView()
}
