import UIKit

class MyRecipeViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var descrLabel: UILabel!
    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var typeVeiw: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet var views: [UIView]!
    @IBOutlet weak var ingridView: UIView!
    @IBOutlet weak var ingridLabel: UILabel!
    @IBOutlet weak var firstStep: UIView!
    @IBOutlet weak var firstStepLabel: UILabel!
    @IBOutlet weak var secondStep: UIView!
    @IBOutlet weak var seecondStepLabel: UILabel!
    @IBOutlet weak var thirdStep: UIView!
    @IBOutlet weak var thirdStepLabel: UILabel!
    
    var item = Item()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBorder(views: views)
        
        titleLabel.text = item.title
        imgView.image = item.saveImage
        descrLabel.text = item.mainDescr
        if item.time != "" && item.time != nil {
            timeView.isHidden = false
            timeLabel.text = item.time
        }
        if item.type != "" && item.type != nil {
            typeVeiw.isHidden = false
            typeLabel.text = item.type
        }
        if item.ingredients != "" && item.ingredients != nil {
            ingridView.isHidden = false
            ingridLabel.text = item.ingredients
        }
        if item.descr0 != "" && item.descr0 != nil {
            firstStep.isHidden = false
            firstStepLabel.text = item.descr0
        }
        if item.descr1 != "" && item.descr1 != nil {
            secondStep.isHidden = false
            seecondStepLabel.text = item.descr1
        }
        if item.descr2 != "" && item.descr2 != nil {
            thirdStep.isHidden = false
            thirdStepLabel.text = item.descr2
        }
    }
    
    private func setBorder(views: [UIView]) {
        for view in views {
            view.layer.borderColor = UIColor.white.cgColor
            view.layer.borderWidth = 2
        }
    }
    
    @IBAction func tapBack(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}
