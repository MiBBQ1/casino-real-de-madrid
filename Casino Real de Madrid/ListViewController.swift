import UIKit

class ListViewController: UIViewController {
    
    @IBOutlet var views: [UIView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for view in views {
            view.layer.borderColor = UIColor.white.cgColor
            view.layer.borderWidth = 2
        }
    }
    
    @IBAction func tapPlay(_ sender: UIButton) {
        var quiz: [Quiz]
        if sender.tag == 0 {
            quiz = Quiz.loadFirstQuizData()
        }
        else if sender.tag == 1 {
            quiz = Quiz.loadSecondQuizData()
        }
        else {
            quiz = Quiz.loadThirdQuizData()
        }
        if let screen = QuizViewController.loadFromStoryboard(name: "Main") {
            screen.mainTitle = sender.titleLabel?.text ?? ""
            screen.quiz = quiz
            self.navigationController?.pushViewController(screen, animated: true)
        }
    }
}
