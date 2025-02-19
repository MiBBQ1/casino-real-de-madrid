import UIKit

class AddFirstViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var photoBtn: UIButton!
    @IBOutlet var views: [UIView]!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var typeTF: UITextField!
    @IBOutlet weak var timeTF: UITextField!
    @IBOutlet weak var categorieBtn: UIButton!
    @IBOutlet weak var arrowImgView: UIImageView!
    @IBOutlet var dishBtn: [UIButton]!
    @IBOutlet weak var textView: UITextView!
    
    var saveItem = Item()
    
    var hidenCategory = true {
        didSet {
            for btn in dishBtn {
                btn.isHidden = hidenCategory
            }
            
            let img = hidenCategory ? UIImage(named: "downBtn") : UIImage(named: "upBtn")
            arrowImgView.image = img
        }
    }
    
    var changePhoto = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBorder(views: views)
        setBorder(views: dishBtn)
        categorieBtn.layer.borderColor = UIColor.white.cgColor
        categorieBtn.layer.borderWidth = 2
        
        setTextView(text: "Description")
        
        NotificationCenter.default.addObserver(
          self,
          selector: #selector(keyboardWillShow(_:)),
          name: UIResponder.keyboardWillShowNotification,
          object: nil)
        NotificationCenter.default.addObserver(
          self,
          selector: #selector(keyboardWillHide(_:)),
          name: UIResponder.keyboardWillHideNotification,
          object: nil)
        
        let gr = UITapGestureRecognizer(target: self, action: #selector(tapView))
        view.addGestureRecognizer(gr)
    }
    
    @objc
    private func keyboardWillShow(_ notification: Notification) {
      guard let inset = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height,
            let duration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue else {
        return
      }
      setScrollViewContentInset(inset, duration: duration)
    }
    
    @objc
    private func keyboardWillHide(_ notification: Notification) {
      guard let duration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue else {
        return
      }
      setScrollViewContentInset(.zero, duration: duration)
    }
    
    private func setScrollViewContentInset(_ inset: CGFloat, duration: Double) {
      UIView.animate(withDuration: duration) { [weak self] in
        self?.scrollView?.contentInset.bottom = inset
      }
    }
    
    @objc func tapView() {
        view.endEditing(true)
    }
    
    private func setBorder(views: [UIView]) {
        for view in views {
            view.layer.borderColor = UIColor.white.cgColor
            view.layer.borderWidth = 2
        }
    }
    
    private func setTextView(text: String) {
        let color = text == "Description" ? UIColor.placeholderText : .white
        textView?.attributedText = NSAttributedString(
            string: text,
            attributes: [.foregroundColor: color,
                         .font: UIFont.boldSystemFont(ofSize: 14)]
        )
    }
    
    private func save() {
        if changePhoto {
            saveItem.saveImage = photoBtn.imageView?.image
        }
        saveItem.title = nameTF.text
        saveItem.time = timeTF.text

        if categorieBtn.titleLabel?.text != "Category of the dish" {
            saveItem.type = categorieBtn.titleLabel?.text
        }
        saveItem.mainDescr = textView.text
    }
    
    @IBAction func tapPhoto(_ sender: UIButton) {
        let vc = UIImagePickerController()
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func tapCategory(_ sender: UIButton) {
        hidenCategory = !hidenCategory
    }
    
    @IBAction func selectedCategory(_ sender: UIButton) {
        categorieBtn.setTitle(sender.titleLabel?.text, for: .normal)
        hidenCategory = true
    }
    
    @IBAction func tapNext(_ sender: UIButton) {
        save()
        if let screen = AddSecondViewController.loadFromStoryboard(name: "Main") {
            screen.saveItem = saveItem
            self.navigationController?.pushViewController(screen, animated: true)
        }
    }
    
    @IBAction func tapBack(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

extension AddFirstViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        photoBtn.setImage(image, for: .normal)
        changePhoto = true
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension AddFirstViewController: UITextViewDelegate {
    func scrollToView(_ view: UIView) {
        guard let scrollView = scrollView else { return }
        let frame = scrollView.convert(view.frame, from: view.superview)
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(400)) {
            scrollView.scrollRectToVisible(frame, animated: true)
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        scrollToView(textView)
        
        if textView.text == "Description" {
            textView.text = ""
        }
        
        setTextView(text: textView.text)
    }

    func textViewDidChange(_ textView: UITextView) {
        setTextView(text: textView.text)
    }
}
