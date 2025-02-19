import UIKit

extension UIViewController {
    var customTabBarController: TabBarViewController? {
        return parent as? TabBarViewController
    }
}

class TabBarViewController: UIViewController {
    
    var currentVC: UIViewController? {
        didSet {
            guard currentVC != oldValue else { return }
            if let oldVC = oldValue {
                oldVC.willMove(toParent: nil)
                oldVC.view.removeFromSuperview()
                oldVC.removeFromParent()
            }
            presentControllerInContainer(currentVC)
            updateButtons()
        }
    }
    
    func presentControllerInContainer(_ vc: UIViewController?) {
        guard let vc = vc, let contentView = vc.view else { return }
        containerView?.addSubview(contentView)
        containerView?.pinSubview(contentView, insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
                        
        addChild(vc)
        vc.willMove(toParent: self)
    }
    
    static let sbName = "Main"
    let mainVC = MainViewController.loadFromStoryboard(name: TabBarViewController.sbName)
    let addVC = AddViewController.loadFromStoryboard(name: TabBarViewController.sbName)
    let listVC = ListViewController.loadFromStoryboard(name: TabBarViewController.sbName)
    let settingsVC = SettingsViewController.loadFromStoryboard(name: TabBarViewController.sbName)
    
    
    @IBOutlet weak var containerView: UIView?
    @IBOutlet weak var mainBtn: UIButton?
    @IBOutlet weak var addBtn: UIButton?
    @IBOutlet weak var listBtn: UIButton?
    @IBOutlet weak var settBtn: UIButton?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tapHome()
    }
  
    func updateButtons() {
        let mainImgName = (currentVC == mainVC) ?  "foodOn" : "foodOff"
        mainBtn?.setImage(UIImage(named: mainImgName), for: .normal)
        
        let addImgName = (currentVC == addVC) ?  "addOn" : "addOff"
        addBtn?.setImage(UIImage(named: addImgName), for: .normal)
        
        let listImgName = (currentVC == listVC) ? "listOn" : "listOff"
        listBtn?.setImage(UIImage(named: listImgName), for: .normal)
        
        let settingsImgName = (currentVC == settingsVC) ? "settOn" : "settOff"
        settBtn?.setImage(UIImage(named: settingsImgName), for: .normal)
    }

    @IBAction func tapHome () {
        currentVC = mainVC
    }

    @IBAction func tapAdd() {
        currentVC = addVC
    }

    @IBAction func tapList() {
        currentVC = listVC
    }

    @IBAction func tapSett() {
        currentVC = settingsVC
    }
}
