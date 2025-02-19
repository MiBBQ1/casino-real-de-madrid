import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var mainView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.layer.borderColor = UIColor.white.cgColor
        mainView.layer.borderWidth = 2
    }
    
    @IBAction func tapDev(_ sender: UIButton) {
        let urlSting = "https://www.google.com/"
        if let url = URL(string: urlSting), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func tapPriv(_ sender: UIButton) {
        let urlSting = "https://www.google.com/"
        if let url = URL(string: urlSting), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func tapTerm(_ sender: UIButton) {
        let urlSting = "https://www.google.com/"
        if let url = URL(string: urlSting), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}
