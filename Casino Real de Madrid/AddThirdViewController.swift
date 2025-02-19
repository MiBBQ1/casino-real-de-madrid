import UIKit

class AddThirdViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView?
    @IBOutlet var views: [UIView]!
    @IBOutlet weak var tf0: UITextView!
    @IBOutlet weak var tf1: UITextView!
    @IBOutlet weak var tf2: UITextView!
    @IBOutlet weak var addBtn: UIButton!
    
    var saveItem = Item()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for view in views {
            view.layer.borderColor = UIColor.white.cgColor
            view.layer.borderWidth = 2
        }
        
        setTextView(textView: tf0, text: "Description")
        setTextView(textView: tf1, text: "Description")
        setTextView(textView: tf2, text: "Description")
        
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
    
    private func setTextView(textView: UITextView, text: String) {
        let color = text == "Description" ? UIColor.placeholderText : .white
        textView.attributedText = NSAttributedString(
            string: text,
            attributes: [.foregroundColor: color,
                         .font: UIFont.boldSystemFont(ofSize: 14)]
        )
    }
    
    @IBAction func tapBack(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tapNext(_ sender: UIButton) {
        Item.addItem(saveItem)
        
        if let navigationController = self.navigationController {
            for controller in navigationController.viewControllers {
                if controller is TabBarViewController {
                    navigationController.popToViewController(controller, animated: true)
                    break
                }
            }
        }
    }
    
    @IBAction func tapAdd(_ sender: UIButton) {
        if !tf0.text.isEmpty && tf0.text != "Description" {
            saveItem.descr0 = tf0.text
        }        
        if !tf1.text.isEmpty && tf1.text != "Description" {
            saveItem.descr1 = tf1.text
        }
        if !tf2.text.isEmpty && tf2.text != "Description" {
            saveItem.descr2 = tf2.text
        }
    }
}

extension AddThirdViewController: UITextViewDelegate {
    
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
        
        setTextView(textView: textView, text: textView.text)
    }

    func textViewDidChange(_ textView: UITextView) {
        addBtn.isEnabled = !(textView.text?.isEmpty ?? true)
        setTextView(textView: textView, text: textView.text)
    }
}
