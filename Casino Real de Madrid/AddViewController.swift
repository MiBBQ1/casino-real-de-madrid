import UIKit

class AddViewController: UIViewController {
    
    @IBOutlet weak var notItemsImgView: UIImageView!
    @IBOutlet weak var tableView: UITableView!

    var items = [Item]()
    
    let indentifire = "ListCell"
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        items = Item.loadItems()
        tableView.reloadData()
    }
    
    @IBAction func tapAdd(_ sender: UIButton) {
        if let screen = AddFirstViewController.loadFromStoryboard(name: "Main") {
            self.navigationController?.pushViewController(screen, animated: true)
        }
    }    
}

extension AddViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notItemsImgView.isHidden = !items.isEmpty
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: indentifire, for: indexPath)
        let mainCell = cell as? ListCell
        
        let item = items[indexPath.row]
        mainCell?.item = item
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let screen = MyRecipeViewController.loadFromStoryboard(name: "Main") {
            screen.item = items[indexPath.row]
            self.navigationController?.pushViewController(screen, animated: true)
        }
    }
}

class ListCell: UITableViewCell {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    
    var item: Item? {
        didSet {
            mainView.layer.borderColor = UIColor.white.cgColor
            mainView.layer.borderWidth = 2
            
            imgView.image = item?.saveImage
            titleLabel.text = item?.title
            timeLabel.text = item?.time
            typeLabel.text = item?.type
        }
    }
}
