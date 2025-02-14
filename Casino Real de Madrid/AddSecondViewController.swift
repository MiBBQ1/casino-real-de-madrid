import UIKit

class AddSecondViewController: UIViewController {
    
    @IBOutlet var viewsTF: [UIView]!
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var quantiyTF: UITextField!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var addBtn: UIButton!
    
    var saveItem = Item()
    var resultStr = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for view in viewsTF {
            view.layer.borderColor = UIColor.white.cgColor
            view.layer.borderWidth = 2
        }
        
        let gr = UITapGestureRecognizer(target: self, action: #selector(tapView))
        view.addGestureRecognizer(gr)
    }
    
    @objc func tapView() {
        view.endEditing(true)
    }
    
    
    @IBAction func tapBack(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tapNext(_ sender: UIButton) {
        saveItem.ingredients = resultStr
        
        if let screen = AddThirdViewController.loadFromStoryboard(name: "Main") {
            screen.saveItem = saveItem
            self.navigationController?.pushViewController(screen, animated: true)
        }
    }
    
    @IBAction func tapAdd(_ sender: UIButton) {
        resultStr += (titleTF.text ?? "") + "\n" + (quantiyTF.text ?? "") + " g" + "\n\n"
        textView.text = resultStr
        
        titleTF.text = ""
        quantiyTF.text = ""
    }
}

extension AddSecondViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string

        let titleText = (textField == titleTF) ? newText : titleTF.text ?? ""
        let quantityText = (textField == quantiyTF) ? newText : quantiyTF.text ?? ""

        addBtn.isEnabled = !titleText.isEmpty && !quantityText.isEmpty
        
        return true
    }
}
