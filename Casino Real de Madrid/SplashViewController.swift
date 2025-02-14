import UIKit

class SplashViewController: UIViewController {
    
    @IBOutlet weak var backgrImgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var descrLabel: UILabel!
    @IBOutlet weak var pageContr: UIPageControl!
    
    var stap = 0 {
        didSet {
            if stap == 3 {
                ShowOnboarding.show = false
                if let screen = TabBarViewController.loadFromStoryboard(name: "Main") {
                    self.navigationController?.pushViewController(screen, animated: false)
                }
            }
            else {
                let backgrName = "splBackgr" + String(stap)
                backgrImgView.image = UIImage(named: backgrName)
                titleLabel.text = arrTitle[stap]
                descrLabel.text = arrDescr[stap]
                let imgName = "spl" + String(stap)
                imgView.image = UIImage(named: imgName)
                pageContr.currentPage = stap
            }
        }
    }
    
    var arrTitle = ["Discover the Authentic Flavors of Madrid", "Taste Madrid: Your Culinary Adventure Begins!", "Real Cuisine de Madrid – The Taste of Tradition"]
    var arrDescr = ["Explore traditional dishes, delightful desserts, refreshing drinks, and vibrant salads from the heart of Madrid.", "From iconic tapas to rich stews and sweet treats, dive into Madrid’s culinary heritage.", "Browse authentic Madrid dishes, mark your favorites, write reviews, and add your own recipes." ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !(ShowOnboarding.show ?? true){
            if let screen = TabBarViewController.loadFromStoryboard(name: "Main") {
                self.navigationController?.pushViewController(screen, animated: false)
            }
        }
    }

    @IBAction func tapFrw(_ sender: UIButton) {
        stap += 1
    }
}

class ShowOnboarding: Codable {
    static let showKey = "show"
    static var show: Bool? {
        get {
            return UserDefaults.standard.value(forKey: ShowOnboarding.showKey) as? Bool
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: ShowOnboarding.showKey)
            UserDefaults.standard.synchronize()
        }
    }
}
