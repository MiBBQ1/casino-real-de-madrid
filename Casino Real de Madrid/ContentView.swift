

import SwiftUI

struct ContentView: View {
    @Environment(\.window) private var window: UIWindow?
    
    var body: some View {
        ZStack {
          
            VStack {
                MyViewControllerRepresentable()
            }
            .edgesIgnoringSafeArea(.all)
                    
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
struct MyViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UINavigationController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = storyboard.instantiateViewController(withIdentifier: "SplashViewController") as! SplashViewController
        let navigationController = UINavigationController(rootViewController: loginViewController)
        navigationController.navigationBar.tintColor = .black
        return navigationController
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
       
    }
}
#Preview {
    ContentView()
}
