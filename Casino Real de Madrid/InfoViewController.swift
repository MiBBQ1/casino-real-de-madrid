import UIKit

class InfoViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet var tagViews: [UIView]!
    @IBOutlet var tagLabels: [UILabel]!
    @IBOutlet weak var firstDescrView: UIView!
    @IBOutlet weak var secondDescrView: UIView!
    @IBOutlet weak var threeDescrView: UIView!
    @IBOutlet weak var firstDescrLabel: UILabel!
    @IBOutlet weak var secondDescrLabel: UILabel!
    @IBOutlet weak var threeDescrLabel: UILabel!
    
    var item = Item()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = item.title
        imgView.image = item.image
        
        guard let tags = item.tags else { return }
        for (index, tag) in tags.enumerated() {
            tagViews[index].isHidden = false
            tagLabels[index].text = tag
        }
        
        firstDescrView.isHidden = ((item.descr0?.isEmpty) == nil)
        secondDescrView.isHidden = ((item.descr1?.isEmpty) == nil)
        threeDescrView.isHidden = ((item.descr2?.isEmpty) == nil)
        firstDescrLabel.text = item.descr0
        secondDescrLabel.text = item.descr1
        threeDescrLabel.text = item.descr2
    }
    
    @IBAction func tapBack(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}
