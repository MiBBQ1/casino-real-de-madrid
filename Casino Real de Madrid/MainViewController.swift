import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var searchTexField: UITextField!
    @IBOutlet weak var stackViewFilter: UIStackView!
    @IBOutlet var filterBtns: [UIButton]!
    @IBOutlet weak var filterCountView: UIView!
    @IBOutlet weak var filterCountLabel: UILabel!
    @IBOutlet var typeBtns: [UIButton]!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var notResultImgView: UIImageView!
    
    var defaultItems = [Item]()
    var items = [Item]()
    
    let indentifier = "HomeCell"
    
    var isHiddenFilter = true {
        didSet {
            for subview in stackViewFilter.arrangedSubviews {
                subview.isHidden = isHiddenFilter
            }
        }
    }
    
    var filterTags: [String] = []
    var filteredItems = [Item]()
    var filterCount = 0 {
        didSet {
            filterCountView.isHidden = filterCount == 0
            filterCountLabel.text = String(filterCount)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultItems = Item.loadMainDishesData()
        items = Item.loadMainDishesData()
        
        searchTexField.attributedPlaceholder = NSAttributedString(
            string: "Search for a recipe...",
            attributes: [.foregroundColor: UIColor(named: "mainGray") ?? .gray]
        )
        
        for filterBtn in filterBtns {
            filterBtn.layer.borderColor = UIColor(named: "mainRad")?.cgColor
            filterBtn.layer.borderWidth = 1
        }
        
        setTypeBtns(selectedBtn: typeBtns[0])
    }
    
    private func setTypeBtns(selectedBtn: UIButton) {
        for typeBtn in typeBtns {
            typeBtn.layer.borderColor = UIColor(named: "mainRad")?.cgColor
            typeBtn.layer.borderWidth = 1
            typeBtn.backgroundColor = .white
            typeBtn.setTitleColor(UIColor(named: "mainRad"), for: .normal)
        }
        
        selectedBtn.layer.borderColor = UIColor.white.cgColor
        selectedBtn.layer.borderWidth = 1
        selectedBtn.backgroundColor = UIColor(named: "mainRad")
        selectedBtn.setTitleColor(.white, for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    @IBAction func tapFilterBtn(_ sender: UIButton) {
        isHiddenFilter = !isHiddenFilter
    }
    
    @IBAction func selectedFilter(_ sender: UIButton) {
        let tag = sender.tag == 0 ? 1 : 0
        sender.tag = tag
        let img = tag == 0 ? UIImage(named: "checkOff") : UIImage(named: "checkOn")
        sender.setImage(img, for: .normal)
        
        if tag == 1 {
            filterTags.append(sender.titleLabel?.text ?? "")
        }
        else {
            if let text = sender.titleLabel?.text, let index = filterTags.firstIndex(of: text) {
                filterTags.remove(at: index)
            }
        }
        
        setResultFilter()
    }
    
    private func setResultFilter() {
        items = defaultItems
        items = items.filter { item in
            guard let tags = item.tags else { return false }
            return filterTags.allSatisfy { tags.contains($0) }
        }
        
        filteredItems = items
        
        filterCount = filterTags.count
        
        tableView.reloadData()
    }
    
    @IBAction func tapMain(_ sender: UIButton) {
        setTypeBtns(selectedBtn: sender)
        defaultItems = Item.loadMainDishesData()
        items = Item.loadMainDishesData()
        
        setResultFilter()
    }
    
    @IBAction func tapSalad(_ sender: UIButton) {
        setTypeBtns(selectedBtn: sender)
        defaultItems = Item.loadSaladsData()
        items = Item.loadSaladsData()
        
        setResultFilter()
    }
    
    @IBAction func tapDrink(_ sender: UIButton) {
        setTypeBtns(selectedBtn: sender)
        defaultItems = Item.loadDrinksData()
        items = Item.loadDrinksData()
        
        setResultFilter()
    }
    
    @IBAction func tapDesert(_ sender: UIButton) {
        setTypeBtns(selectedBtn: sender)
        defaultItems = Item.loadDesertsData()
        items = Item.loadDesertsData()
        
        setResultFilter()
    }
    
    @IBAction func tapFav(_ sender: UIButton) {
        setTypeBtns(selectedBtn: sender)
        let arr = Item.loadAllData()
        let favManager = FavManager()
        var resultArr = [Item]()
        for pl in arr {
            if favManager.getArray().contains(pl.title ?? "") {
                resultArr.append(pl)
            }
        }
        items = resultArr
        
        setResultFilter()
    }
}

extension MainViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
        
        items = filterCount == 0 ? defaultItems : filteredItems

        items = items.filter { item in
            guard let title = item.title else { return false }
            return title.lowercased().contains(newText.lowercased())
        }
        
        if newText.isEmpty {
            items = filterCount == 0 ? defaultItems : filteredItems
        }

        tableView.reloadData()
        
        return true
    }
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notResultImgView.isHidden = !items.isEmpty
        
        return (items.count + 1) / 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let firstIndex = indexPath.row * 2
        let secondIndex = firstIndex + 1
          
        let item0 = items[firstIndex]
        let item1 = (secondIndex < items.count) ? items[secondIndex] : nil

        let result: UITableViewCell?
        let cell = tableView.dequeueReusableCell(withIdentifier: indentifier, for: indexPath) as? HomeCell
        cell?.viewController = self
        cell?.item0 = item0
        cell?.item1 = item1
        result = cell

        return result ?? UITableViewCell()
    }
}

class HomeCell: UITableViewCell {
    
    @IBOutlet weak var leftImgView: UIImageView!
    @IBOutlet weak var leftTitleLabel: UILabel!
    @IBOutlet weak var leftFavBtn: UIButton!
    @IBOutlet var leftTagsViews: [UIView]!
    @IBOutlet var leftTagsLabel: [UILabel]!
    
    
    @IBOutlet weak var rightMainView: UIView!
    @IBOutlet weak var rightImgView: UIImageView!
    @IBOutlet weak var rightTitleLabel: UILabel!
    @IBOutlet weak var rightFavBtn: UIButton!
    @IBOutlet var rightTagsViewvs: [UIView]!
    @IBOutlet var rightTagsLabels: [UILabel]!
    
    
    let favManager = FavManager()
    var favleft = false
    var favRight = false
    
    weak var viewController: UIViewController?
    
    var item0: Item? {
        didSet {
            favleft = favManager.getArray().contains(item0?.title ?? "")
            
            leftImgView.image = item0?.image
            leftTitleLabel.text = item0?.title
            
            let favImg = favleft ? UIImage(named: "favBtnOn") : UIImage(named: "favBtnOff")
            leftFavBtn.setImage(favImg, for: .normal)
            
            for lView in leftTagsViews {
                lView.isHidden = true
            }
            
            guard let tags = item0?.tags else { return }
            for (index, tag) in tags.enumerated() {
                leftTagsViews[index].isHidden = false
                leftTagsLabel[index].text = tag
            }
        }
    }
    
    var item1: Item? {
        didSet {
            rightMainView.isHidden = item1 == nil
            
            favRight = favManager.getArray().contains(item1?.title ?? "")
            
            rightImgView.image = item1?.image
            rightTitleLabel.text = item1?.title
            
            let favImg = favRight ? UIImage(named: "favBtnOn") : UIImage(named: "favBtnOff")
            rightFavBtn.setImage(favImg, for: .normal)
            
            for rView in rightTagsViewvs {
                rView.isHidden = true
            }
            
            guard let tags = item1?.tags else { return }
            for (index, tag) in tags.enumerated() {
                rightTagsViewvs[index].isHidden = false
                rightTagsLabels[index].text = tag
            }
        }
    }
    
    @IBAction func tapLeftFav(_ sender: UIButton) {
        favleft = !favleft
        if favleft {
            favManager.addFav(item0?.title ?? "")
        }
        else {
            favManager.removeStr(item0?.title ?? "")
        }
        let favImg = favleft ? UIImage(named: "favBtnOn") : UIImage(named: "favBtnOff")
        sender.setImage(favImg, for: .normal)
    }
    
    @IBAction func tapLeftItem(_ sender: UIButton) {
        if let screen = InfoViewController.loadFromStoryboard(name: "Main") {
            screen.item = item0 ?? Item()
            viewController?.navigationController?.pushViewController(screen, animated: true)
        }
    }
    
    @IBAction func tapRighrFav(_ sender: UIButton) {
        favRight = !favRight
        if favRight {
            favManager.addFav(item1?.title ?? "")
        }
        else {
            favManager.removeStr(item1?.title ?? "")
        }
        let favImg = favRight ? UIImage(named: "favBtnOn") : UIImage(named: "favBtnOff")
        sender.setImage(favImg, for: .normal)
    }
    
    @IBAction func tapRightItem(_ sender: UIButton) {
        if let screen = InfoViewController.loadFromStoryboard(name: "Main") {
            screen.item = item1 ?? Item()
            viewController?.navigationController?.pushViewController(screen, animated: true)
        }
    }
}

class Item: Codable {
    var title: String?
    var mainDescr: String?
    var ingredients: String?
    var descr0: String?
    var descr1: String?
    var descr2: String?
    var type: String?
    var tags: [String]?
    var time: String?
    var img: String?
    
    var image: UIImage? {
        if let name = img {
            return UIImage(named: name) ?? UIImage(contentsOfFile: name)
        }
        return nil
    }

    var saveImage: UIImage? {
        get {
            guard let imgName = img else { return nil }
            return loadImage(named: imgName)
        }
        set {
            if let newImage = newValue {
                img = saveImage(newImage)
            } else {
                img = nil
            }
        }
    }

    static var items: [Item] = loadItems()

    static func addItem(_ newItem: Item) {
        if let image = newItem.saveImage {
            newItem.img = newItem.saveImage(image)
        }
        items.append(newItem)
        saveItems()
    }

    static func saveItems() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(items) {
            UserDefaults.standard.set(encoded, forKey: "savedItems")
        }
    }

    static func loadItems() -> [Item] {
        if let savedData = UserDefaults.standard.data(forKey: "savedItems") {
            let decoder = JSONDecoder()
            if let loadedItems = try? decoder.decode([Item].self, from: savedData) {
                return loadedItems
            }
        }
        return []
    }

    private func saveImage(_ image: UIImage) -> String? {
        guard let data = image.jpegData(compressionQuality: 0.8) else { return nil }
          
        let fileName = UUID().uuidString + ".jpg"
        let fileURL = getDocumentsDirectory().appendingPathComponent(fileName)
          
        do {
            try data.write(to: fileURL)
            return fileName
        } catch {
            return nil
        }
    }

    private func loadImage(named fileName: String) -> UIImage? {
        let fileURL = getDocumentsDirectory().appendingPathComponent(fileName)
        return UIImage(contentsOfFile: fileURL.path)
    }

    private func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    static func loadAllData() -> [Item] {
        var items = loadMainDishesData()
        items += loadSaladsData()
        items += loadDrinksData()
        items += loadDesertsData()
        return items
    }
    
    static func loadMainDishesData() -> [Item] {
        let f1 = Item()
        f1.title = "Cocido Madrileño"
        f1.descr0 = "Cocido Madrileño is a hearty chickpea-based stew that embodies the rich culinary heritage of Madrid. Traditionally served in three courses, this dish is a testament to slow-cooked flavors and wholesome ingredients. The first course consists of the broth, obtained by simmering the ingredients for hours. This flavorful soup is often accompanied by thin noodles."
        f1.descr1 = "The second course features chickpeas, cabbage, and other vegetables such as carrots and potatoes, which have absorbed the essence of the meat during the cooking process. The final course includes various cuts of meat, such as beef shank, pork belly, morcilla (blood sausage), and chorizo. Sometimes, additional pieces like chicken or ham bones are included for extra depth of flavor."
        f1.descr2 = "Cocido Madrileño is more than just a dish—it is an experience. Traditionally eaten during colder months, it is a favorite in local taverns and home kitchens across Madrid. The meal is often enjoyed over long conversations, accompanied by red wine. Its origins date back to the Middle Ages, with influences from Sephardic Jewish cuisine. Over time, it evolved into a signature dish of Madrid, cherished for its comforting warmth and layered flavors."
        f1.type = "Main Dishes"
        f1.tags = ["Hot", "Meat"]
        f1.img = "m0"
        
        let f2 = Item()
        f2.title = "Bocadillo de Calamares"
        f2.descr0 = "Bocadillo de Calamares is one of Madrid’s most iconic street foods, loved by locals and tourists alike. This simple yet delicious sandwich consists of fresh squid rings, lightly battered and deep-fried to golden perfection, then placed inside a crusty baguette. The bread, slightly crunchy on the outside and soft on the inside, perfectly complements the crispy calamari."
        f2.descr1 = "While the classic version is served plain, many people enjoy adding a squeeze of lemon or a dollop of aioli for extra flavor. Some variations include a touch of spicy sauce or mayonnaise, enhancing the sandwich’s richness. Despite its coastal ingredients, Bocadillo de Calamares is uniquely associated with Madrid, thanks to the city’s love for seafood, which is transported fresh from Spain’s coastal regions."
        f2.descr2 = "This sandwich is a must-try when visiting Madrid, often found in the bustling Plaza Mayor and surrounding streets. It is a popular choice for a quick lunch or snack, best enjoyed with a cold beer or a refreshing glass of tinto de verano."
        f2.type = "Main Dishes"
        f2.tags = ["Cold", "Fish"]
        f2.img = "m1"
        
        let f3 = Item()
        f3.title = "Callos a la Madrileña"
        f3.descr0 = "Callos a la Madrileña is a traditional tripe stew that has been a staple in Madrid’s cuisine since the 16th century. This dish is prepared by slowly simmering beef tripe with chorizo, morcilla (blood sausage), and jamón (Spanish cured ham), creating a deeply flavorful and rich sauce. The stew is typically seasoned with paprika, garlic, bay leaves, and onions, giving it a smoky and slightly spicy taste."
        f3.descr1 = "Callos are known for their gelatinous texture, which comes from the natural collagen in the tripe. This quality makes the dish exceptionally rich and satisfying. It is usually served hot, often with a side of crusty bread to soak up the flavorful sauce."
        f3.descr2 = "Traditionally, Callos a la Madrileña is eaten during colder months, as it is incredibly warming and filling. It is a common feature on menus in old-fashioned Madrid taverns, where it is often paired with a glass of red wine or vermouth. While it may not be for the faint-hearted, Callos remains a beloved dish among Madrileños and adventurous food lovers."
        f3.type = "Main Dishes"
        f3.tags = ["Hot", "Meat"]
        f3.img = "m2"
        
        let f4 = Item()
        f4.title = "Rosquillas de San Isidro"
        f4.descr0 = "Rosquillas de San Isidro are traditional Madrid pastries associated with the city’s patron saint, San Isidro. These ring-shaped doughnuts come in several varieties, each with a unique twist. The most common types are “tontas” (plain and lightly sweetened), “listas” (glazed with sugar and lemon), “de Santa Clara” (coated with meringue), and “francesas” (covered in almonds)."
        f4.descr1 = "The preparation of Rosquillas involves a simple dough made from flour, eggs, sugar, and olive oil. Depending on the variety, the doughnuts can be deep-fried or baked. The “listas” version, which features a glossy lemon glaze, is particularly popular for its balance of sweetness and citrusy freshness."
        f4.descr2 = "These pastries are a central part of the annual San Isidro festival in May, where Madrid’s residents gather to celebrate with traditional food and drinks. Rosquillas are often paired with coffee or hot chocolate, making them a delightful treat at any time of the day. Their historical roots trace back centuries, with recipes passed down through generations, preserving their status as a cherished Madrid delicacy."
        f4.type = "Main Dishes"
        f4.tags = ["Sweet"]
        f4.img = "m3"
        
        let f5 = Item()
        f5.title = "Huevos Rotos"
        f5.descr0 = "Huevos Rotos, which translates to “broken eggs,” is a simple yet incredibly flavorful dish that showcases the best of Spanish comfort food. It consists of fried eggs served over a bed of crispy, golden potatoes, often topped with jamón ibérico or chorizo. The key to the dish lies in the eggs, which are left slightly runny so that the yolk mixes with the potatoes and cured meat, creating a rich and indulgent combination."
        f5.descr1 = "This dish is commonly found in Madrid’s taverns, where it is enjoyed as both a tapa and a main course. Some variations include adding green peppers or other meats, but the classic version remains the most popular."
        f5.descr2 = "Huevos Rotos is best eaten fresh, right after the eggs are cracked open and mixed into the potatoes. It pairs excellently with a cold beer or a glass of Spanish wine. Despite its simplicity, this dish perfectly encapsulates Madrid’s culinary philosophy—high-quality ingredients prepared with love and tradition."
        f5.type = "Main Dishes"
        f5.tags = ["Hot", "Meat"]
        f5.img = "m4"
        
        return [f1, f2, f3, f4, f5]
    }
    
    static func loadSaladsData() -> [Item] {
        let f1 = Item()
        f1.title = "Ensalada de San Isidro"
        f1.descr0 = "Ensalada de San Isidro is a fresh and vibrant salad inspired by Madrid’s patron saint, often enjoyed during the San Isidro festival. This colorful dish is made with crisp romaine lettuce, juicy cherry tomatoes, red onions, and green olives. What sets it apart is the addition of Spanish goat cheese, which brings a creamy contrast to the fresh ingredients."
        f1.descr1 = "The salad is typically dressed with a simple vinaigrette made from extra virgin olive oil, sherry vinegar, garlic, and a touch of honey. Some variations include roasted almonds for extra crunch or sun-dried tomatoes for a richer taste."
        f1.descr2 = "This salad is light yet satisfying, making it a perfect starter or side dish. It embodies the essence of Madrid’s cuisine—simple, high-quality ingredients that come together in a delicious and traditional way."
        f1.type = "Salads"
        f1.tags = ["Cold", "Vegetarian"]
        f1.img = "s0"
        
        let f2 = Item()
        f2.title = "Ensalada Madrileña"
        f2.descr0 = "Ensalada Madrileña is a bold and flavorful salad that combines fresh vegetables with traditional Spanish cured meats. The base consists of crisp mixed greens, roasted red peppers, and artichoke hearts, topped with slices of jamón ibérico and Manchego cheese."
        f2.descr1 = "A signature element of this salad is the addition of marinated chickpeas, which provide protein and a unique texture. The dressing is a blend of olive oil, balsamic vinegar, and smoked paprika, adding a distinct Spanish flavor."
        f2.descr2 = "This salad is often served as a tapa or light meal, accompanied by a glass of Spanish wine. It reflects Madrid’s love for high-quality meats and cheeses while remaining a refreshing and balanced dish."
        f2.type = "Salads"
        f2.tags = ["Cold", "Meat"]
        f2.img = "s1"
        
        let f3 = Item()
        f3.title = "Ensalada de Bacalao y Naranjas"
        f3.descr0 = "Ensalada de Bacalao y Naranjas is a refreshing cod and orange salad, a specialty that showcases Madrid’s historical connection to seafood. The dish features flaked salt cod (bacalao), which is gently poached or desalted and combined with juicy orange segments, black olives, and thinly sliced red onions."
        f3.descr1 = "The contrast of sweet citrus and savory fish creates a perfect balance of flavors. The salad is typically dressed with extra virgin olive oil, sherry vinegar, and a hint of cumin, giving it a Mediterranean flair. Some versions include hard-boiled eggs or fresh parsley for additional depth."
        f3.descr2 = "This salad is popular during warm months and is often enjoyed as a light lunch or tapa. The combination of protein-rich fish and refreshing citrus makes it both nutritious and flavorful."
        f3.type = "Salads"
        f3.tags = ["Cold", "Fish"]
        f3.img = "s2"
        
        let f4 = Item()
        f4.title = "Ensalada de Garbanzos y Atún"
        f4.descr0 = "Ensalada de Garbanzos y Atún is a nutritious and protein-packed salad commonly enjoyed in Madrid. This dish features chickpeas as the base, combined with high-quality canned tuna, diced tomatoes, red bell peppers, and cucumbers."
        f4.descr1 = "A key component of the salad is the dressing, made with olive oil, red wine vinegar, minced garlic, and a touch of paprika. Some variations include boiled eggs, capers, or fresh parsley for added complexity."
        f4.descr2 = "This salad is not only delicious but also incredibly filling, making it a great option for a quick lunch. It is often served with crusty bread and a glass of cold white wine, making it a staple in many Madrid households and tapas bars."
        f4.type = "Salads"
        f4.tags = ["Cold", "Fish", "Protein-Rich"]
        f4.img = "s3"
        
        let f5 = Item()
        f5.title = "Ensalada de Patatas a la Madrileña"
        f5.descr0 = "Ensalada de Patatas a la Madrileña is Madrid’s take on a classic potato salad, featuring bold flavors and simple ingredients. The dish consists of boiled potatoes cut into chunks, mixed with green beans, hard-boiled eggs, and roasted red peppers."
        f5.descr1 = "Instead of a heavy mayonnaise-based dressing, this salad is dressed with olive oil, vinegar, Dijon mustard, and fresh parsley. Some versions include smoked paprika or anchovies for an extra layer of flavor."
        f5.descr2 = "This salad is a popular side dish at summer gatherings and picnics in Madrid. It is light, refreshing, and full of Mediterranean flavors, making it a great complement to grilled meats or seafood."
        f5.type = "Salads"
        f5.tags = ["Cold", "Vegetarian"]
        f5.img = "s4"
        
        return [f1, f2, f3, f4, f5]
    }
    
    static func loadDrinksData() -> [Item] {
        let f1 = Item()
        f1.title = "Tinto de Verano Sin Alcohol"
        f1.descr0 = "Tinto de Verano Sin Alcohol is a refreshing, alcohol-free version of the classic Spanish summer drink. Instead of red wine, this version is made with red grape juice mixed with lemon soda or sparkling water, creating a light and fruity beverage. Served over ice with a slice of lemon, it retains the balance of sweetness and acidity that makes it so popular."
        f1.descr1 = "This drink is perfect for warm weather and is a great option for those who want to enjoy the flavors of Spain without alcohol. It is often served at outdoor gatherings and tapas bars, pairing well with salty snacks and fried foods."
        f1.type = "Drinks"
        f1.tags = ["Cold", "Fruity", "Refreshing"]
        f1.img = "d0"
        
        let f2 = Item()
        f2.title = "Horchata de Chufa"
        f2.descr0 = "Horchata de Chufa is a creamy and naturally sweet beverage made from tiger nuts, water, and sugar. This traditional drink is especially popular in Madrid during the summer months, offering a refreshing alternative to dairy-based drinks."
        f2.descr1 = "The unique nutty flavor of horchata pairs well with pastries, especially fartons, which are commonly dipped into the drink. Beyond its delicious taste, horchata is known for its nutritional benefits, being rich in antioxidants and naturally lactose-free."
        f2.type = "Drinks"
        f2.tags = ["Cold", "Sweet", "Nutty"]
        f2.img = "d1"
        
        let f3 = Item()
        f3.title = "Vermut de Grifo Sin Alcohol"
        f3.descr0 = "Vermut de Grifo Sin Alcohol is a non-alcoholic version of Madrid’s beloved draft vermouth. This drink maintains the complex flavors of traditional vermouth, infused with botanicals, herbs, and citrus zest, but without the alcohol content."
        f3.descr1 = "Served over ice with a slice of orange and a green olive, this beverage is perfect as an aperitif before a meal. It pairs beautifully with salty snacks like olives, pickled vegetables, and cured meats, making it a staple at Madrid’s tapas bars."
        f3.type = "Drinks"
        f3.tags = ["Cold", "Herbal", "Bitter-Sweet"]
        f3.img = "d2"
        
        let f4 = Item()
        f4.title = "Chocolate con Churros"
        f4.descr0 = "Chocolate con Churros is Madrid’s most famous wintertime indulgence. The drink consists of thick, rich hot chocolate, often made with cornstarch to achieve a pudding-like consistency, making it perfect for dipping crispy churros."
        f4.descr1 = "Chocolate con Churros is Madrid’s most famous wintertime indulgence. The drink consists of thick, rich hot chocolate, often made with cornstarch to achieve a pudding-like consistency, making it perfect for dipping crispy churros."
        f4.type = "Drinks"
        f4.tags = ["Hot", "Sweet"]
        f4.img = "d3"
        
        let f5 = Item()
        f5.title = "Clara con Limón Sin Alcohol"
        f5.descr0 = "Clara con Limón Sin Alcohol is a refreshing Spanish drink that replaces the beer with a non-alcoholic malt-based alternative, keeping the crisp and citrusy taste intact. Made with non-alcoholic beer and lemon soda, this drink is perfect for warm days and casual gatherings."
        f5.descr1 = "Often served at summer festivals and tapas bars, it pairs excellently with salty and fried foods. Whether enjoyed on a terrace or at a picnic, it remains a staple of Madrid’s casual drinking culture."
        f5.type = "Drinks"
        f5.tags = ["Cold", "Refreshing", "Citrus"]
        f5.img = "d4"
        
        return [f1, f2, f3, f4, f5]
    }
    
    static func loadDesertsData() -> [Item] {
        let f1 = Item()
        f1.title = "Bartolillos Madrileños"
        f1.descr0 = "Bartolillos Madrileños are a classic Madrid pastry, typically enjoyed during the festive season. These deep-fried, triangular pastries are filled with creamy vanilla custard and dusted with powdered sugar, giving them a delicate sweetness and crisp texture."
        f1.descr1 = "The dough is made from flour, butter, eggs, and a touch of aniseed for extra flavor. Once shaped and filled, they are fried until golden brown and slightly crispy on the outside while remaining soft and creamy inside."
        f1.descr2 = "Traditionally, Bartolillos are served warm and paired with a cup of thick hot chocolate or coffee. Their origins trace back to the 19th century, and they remain a beloved treat in Madrid’s bakeries, especially during Easter and Christmas."
        f1.type = "Deserts"
        f1.tags = ["Sweet"]
        f1.img = "de0"
        
        let f2 = Item()
        f2.title = "Torrijas"
        f2.descr0 = "Torrijas are a traditional Spanish dessert similar to French toast but richer in flavor and texture. This dish consists of thick slices of stale bread soaked in a mixture of milk, sugar, and cinnamon, then dipped in beaten eggs and fried until golden brown."
        f2.descr1 = "After frying, the torrijas are either drizzled with honey or sprinkled with sugar and cinnamon. Some versions are soaked in sweet wine before frying, giving them an extra depth of flavor."
        f2.descr2 = "Torrijas are especially popular during Semana Santa (Holy Week) in Madrid, where they are served in homes and pastry shops alike. Their warm, comforting taste and soft, custardy interior make them an irresistible treat."
        f2.type = "Deserts"
        f2.tags = ["Sweet"]
        f2.img = "de1"
        
        let f3 = Item()
        f3.title = "Rosquillas de San Isidro"
        f3.descr0 = "Rosquillas de San Isidro are traditional Madrid doughnuts associated with the city’s patron saint, San Isidro. They come in several varieties, including “tontas” (plain), “listas” (glazed with sugar and lemon), “de Santa Clara” (coated with meringue), and “francesas” (covered in almonds)."
        f3.descr1 = "These ring-shaped pastries are made with simple ingredients like flour, eggs, sugar, and olive oil. Depending on the variety, they may be deep-fried or baked and then topped with different coatings."
        f3.descr2 = "Rosquillas are a central part of Madrid’s San Isidro festival, held every May. They are best enjoyed with a cup of coffee or hot chocolate and have been a staple of Madrid’s confectionery for centuries."
        f3.type = "Deserts"
        f3.tags = ["Sweet"]
        f3.img = "de2"
        
        let f4 = Item()
        f4.title = "Bartolillos de Crema"
        f4.descr0 = "Bartolillos de Crema are a variation of the traditional Bartolillos Madrileños but with an extra creamy twist. These pastries feature a flaky, golden crust filled with rich, homemade custard flavored with vanilla and cinnamon."
        f4.descr1 = "The dough is prepared with butter, flour, and a touch of anise, then rolled out and filled with thick pastry cream before being fried to perfection. The result is a dessert that is both crispy and creamy, making it a favorite among locals."
        f4.descr2 = "Often enjoyed in Madrid’s historical pastry shops, Bartolillos de Crema are served dusted with powdered sugar and accompanied by hot chocolate or coffee. Their delightful contrast of textures and flavors makes them one of Madrid’s most cherished desserts."
        f4.type = "Deserts"
        f4.tags = ["Sweet"]
        f4.img = "de3"
        
        let f5 = Item()
        f5.title = "Leche Frita"
        f5.descr0 = "Leche Frita, which means “fried milk,” is a unique Spanish dessert that is especially popular in Madrid. This treat is made by cooking a thick custard from milk, sugar, cornstarch, and cinnamon, then letting it set until firm. Once cooled, it is cut into squares, coated in flour and egg, and fried until golden brown."
        f5.descr1 = "The final touch is a dusting of cinnamon sugar or a drizzle of honey, enhancing its sweetness and aroma. The contrast between the crispy, golden crust and the soft, creamy interior makes Leche Frita a delightful dessert experience."
        f5.descr2 = "Leche Frita is often enjoyed during Easter and festive celebrations. It is typically served warm, sometimes with a scoop of ice cream or a side of fruit compote for added indulgence."
        f5.type = "Deserts"
        f5.tags = ["Sweet"]
        f5.img = "de4"
        
        return [f1, f2, f3, f4, f5]
    }
}

class FavManager {
    private let key = "favsArray"
    private let defaults = UserDefaults.standard

    func addFav(_ str: String) {
        var array = getArray()
        if !array.contains(str) {
            array.append(str)
            saveArray(array)
        }
    }

    func getArray() -> [String] {
        return defaults.array(forKey: key) as? [String] ?? []
    }

    func removeStr(_ str: String) {
        var array = getArray()
        if let index = array.firstIndex(of: str) {
            array.remove(at: index)
            saveArray(array)
        }
    }

    private func saveArray(_ array: [String]) {
        defaults.set(array, forKey: key)
    }
}
