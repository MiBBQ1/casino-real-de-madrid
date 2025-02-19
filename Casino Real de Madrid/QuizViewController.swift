import UIKit

class QuizViewController: UIViewController {    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var stepLabel: UILabel!
    @IBOutlet weak var questionView: UIView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet var answerBtns: [UIButton]!
    @IBOutlet weak var frwBtn: UIButton!
    
    @IBOutlet weak var resultView: UIView!
    @IBOutlet weak var subscrView: UIView!
    @IBOutlet weak var resLabel: UILabel!
    
    
    var mainTitle = ""
    var quiz = [Quiz]()
    var step = 0 {
        didSet {
            if step == 4 {
                resultView.isHidden = false
            }
            else {
                setQuiz()
            }
        }
    }
    var correct = 0
    var correctCount = 0 {
        didSet {
            stepLabel.text = String(correctCount) + "/4"
            resLabel.text = "The quiz is complete!\nYou have answered correctly to " + String(correctCount) + "/4"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionView.layer.borderColor = UIColor.white.cgColor
        questionView.layer.borderWidth = 2
        
        subscrView.layer.borderColor = UIColor.white.cgColor
        subscrView.layer.borderWidth = 2
        
        titleLabel.text = mainTitle
        
        setQuiz()
    }
    
    private func setQuiz() {
        let qu = quiz[step]
        questionLabel.text = qu.question
        answerBtns[0].setTitle(qu.answer0, for: .normal)
        answerBtns[1].setTitle(qu.answer1, for: .normal)
        answerBtns[2].setTitle(qu.answer2, for: .normal)
        correct = qu.correct ?? 0
        
        for btn in answerBtns {
            btn.layer.borderColor = UIColor.white.cgColor
            btn.layer.borderWidth = 2
            btn.isEnabled = true
        }
        
        frwBtn.isHidden = true
    }
    
    @IBAction func tapBack(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tapAnswer(_ sender: UIButton) {
        let ansTrue = sender.tag == correct
        let color = ansTrue ? UIColor(named: "mainGreen") : UIColor(named: "qRed")
        correctCount += ansTrue ? 1 : 0
        sender.layer.borderColor = color?.cgColor
//        sender.layer.borderWidth = 2
        
        for btn in answerBtns {
            btn.isEnabled = false
        }
        
        frwBtn.isHidden = false
    }
    
    @IBAction func tapFrw(_ sender: UIButton) {
        step += 1
    }
}

class Quiz: Codable {
    var question: String?
    var answer0: String?
    var answer1: String?
    var answer2: String?
    var correct: Int?
    
    static func loadFirstQuizData() -> [Quiz] {
        let f1 = Quiz()
        f1.question = "Which dish consists of chickpeas, meat, and vegetables, served in three stages?"
        f1.answer0 = "Callos a la Madrileña"
        f1.answer1 = "Cocido Madrileño"
        f1.answer2 = "Huevos Rotos"
        f1.correct = 1
        
        let f2 = Quiz()
        f2.question = "What is the name of the famous sandwich with fried squid rings?"
        f2.answer0 = "Bocadillo de Calamares"
        f2.answer1 = "Ensalada Madrileña"
        f2.answer2 = "Tostada de Mariscos"
        f2.correct = 0
        
        let f3 = Quiz()
        f3.question = "Which Madrid dessert is similar to French toast and is especially popular during Holy Week?"
        f3.answer0 = "Bartolillos Madrileños"
        f3.answer1 = "Leche Frita"
        f3.answer2 = "Torrijas"
        f3.correct = 2
        
        let f4 = Quiz()
        f4.question = "Which drink is made from tiger nuts and served cold?"
        f4.answer0 = "Horchata de Chufa"
        f4.answer1 = "Clara con Limón"
        f4.answer2 = "Tinto de Verano Sin Alcohol"
        f4.correct = 0
        
        return [f1, f2, f3, f4]
    }
    
    static func loadSecondQuizData() -> [Quiz] {
        let f1 = Quiz()
        f1.question = "Which Madrid dish features fried eggs over crispy potatoes, often topped with jamón ibérico?"
        f1.answer0 = "Callos a la Madrileña"
        f1.answer1 = "Huevos Rotos"
        f1.answer2 = "Ensalada de Garbanzos y Atún"
        f1.correct = 1
        
        let f2 = Quiz()
        f2.question = "What is the traditional Madrid-style tripe stew called?"
        f2.answer0 = "Callos a la Madrileña"
        f2.answer1 = "Bocadillo de Calamares"
        f2.answer2 = "Ensalada de Bacalao y Naranjas"
        f2.correct = 0
        
        let f3 = Quiz()
        f3.question = "What is the non-alcoholic version of Tinto de Verano made with?"
        f3.answer0 = "Grape juice and lemon soda"
        f3.answer1 = "Apple juice and tonic water"
        f3.answer2 = "Watermelon juice and ginger ale"
        f3.correct = 0
        
        let f4 = Quiz()
        f4.question = "Which Madrid dessert consists of fried custard squares dusted with cinnamon sugar?"
        f4.answer0 = "Leche Frita"
        f4.answer1 = "Rosquillas de San Isidro"
        f4.answer2 = "Bartolillos Madrileños"
        f4.correct = 0
        
        return [f1, f2, f3, f4]
    }
    
    static func loadThirdQuizData() -> [Quiz] {
        let f1 = Quiz()
        f1.question = "Which traditional dish is commonly eaten in Madrid during winter?"
        f1.answer0 = "Cocido Madrileño"
        f1.answer1 = "Ensalada Madrileña"
        f1.answer2 = "Clara con Limón"
        f1.correct = 0
        
        let f2 = Quiz()
        f2.question = "Which pastry is associated with the San Isidro festival in Madrid?"
        f2.answer0 = "Torrijas"
        f2.answer1 = "Rosquillas de San Isidro"
        f2.answer2 = "Bartolillos de Crema"
        f2.correct = 1
        
        let f3 = Quiz()
        f3.question = "What is the thick hot chocolate in Madrid often paired with?"
        f3.answer0 = "Churros"
        f3.answer1 = "Flan"
        f3.answer2 = "Torrijas"
        f3.correct = 0
        
        let f4 = Quiz()
        f4.question = "Which Madrid salad features chickpeas and tuna as its main ingredients?"
        f4.answer0 = "Ensalada de Garbanzos y Atún"
        f4.answer1 = "Ensalada de Bacalao y Naranjas"
        f4.answer2 = "Ensalada de San Isidro"
        f4.correct = 0
        
        return [f1, f2, f3, f4]
    }
}

