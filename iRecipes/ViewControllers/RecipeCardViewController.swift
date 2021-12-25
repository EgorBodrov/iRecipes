//
//  RecipeCardViewController.swift
//  iRecipes
//
//  Created by Mihail on 12/24/21.
//

import UIKit
import Firebase
import FirebaseAuth

class Section {
    let title: String
    let options: [String]
    var isOpened: Bool = false
    
    init(title: String, options: [String]) {
        self.title = title
        self.options = options
    }
    
}

class RecipeCardViewController: UIViewController {
    
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var likeButton: UIBarButtonItem!
    
    var recipe: Recipe!
    var isLiked: Bool = false
    private var sections: [Section]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = URL(string: recipe.image!) {
            loadImage(from: url)
        }
        
        timeLabel.text = String(recipe.readyInMinutes) + " minutes"
        titleLabel.text = recipe.title
        
        FirebaseManager.shared.setUserRecipesField(collection: "recipes", documentPath: Auth.auth().currentUser!.uid)
        
        FirebaseManager.shared.getUserRecipes(collection: "recipes", documentPath: Auth.auth().currentUser!.uid, completion: {doc in
            guard doc != nil else { return }
            if doc?.favourites.contains(self.recipe.id!) == true {
                self.isLiked = true
                self.likeButton.image = UIImage(systemName: "heart.fill")
            } else {
                self.likeButton.image = UIImage(systemName: "heart")
            }
        })
        
        var ingredients = [String]()
        for ig in recipe.extendedIngredients! {
            ingredients.append("    " + ig.originalString!)
        }
        
        var instructions = [String]()
        if recipe.analyzedInstructions != nil {
            for ins in (recipe.analyzedInstructions?[0].steps!)! {
                instructions.append("    " + String(ins.number!) + ". " + ins.step!)
            }
        }
        
        sections = [
            Section(title: "Ingredients", options: ingredients),
            Section(title: "Instructions", options: instructions)
        ]
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    @IBAction func likeButtonTapped(_ sender: Any) {
        
        if isLiked == true {
            FirebaseManager.shared.deleteUserRecipe(collection: "recipes", documentPath: Auth.auth().currentUser!.uid, value: self.recipe.id!)
            likeButton.image = UIImage(systemName: "heart")
        } else {
            FirebaseManager.shared.updateUserRecipes(collection: "recipes", documentPath: Auth.auth().currentUser!.uid, newValue: self.recipe.id!)
            likeButton.image = UIImage(systemName: "heart.fill")
        }
        
        isLiked = !isLiked
    }
    
    func loadImage(from url: URL) {
        self.mainImage.image = nil
        var task: URLSessionTask!

        if let task = task {
            task.cancel()
        }

        if let imageFromCache = imageCache.object(forKey: url.absoluteURL as AnyObject) as? UIImage {
            self.mainImage.image = imageFromCache
            return
        }
        task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let data = data,
                let newImage = UIImage(data: data)
            else {
                print("couldn't load image from url: \(url)")
                return
            }

            imageCache.setObject(newImage, forKey: url.absoluteURL as AnyObject)
            DispatchQueue.main.async {
                self.mainImage.image = newImage
            }
        }
        task.resume()
    }

}

extension RecipeCardViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        sections[indexPath.section].isOpened = !sections[indexPath.section].isOpened
        tableView.reloadSections([indexPath.section], with: .none)
    }
}

extension RecipeCardViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if indexPath.row == 0 {
            cell.textLabel?.text = sections[indexPath.section].title
        } else {
            cell.textLabel?.text = sections[indexPath.section].options[indexPath.row - 1]
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = sections[section]
        
        if section.isOpened {
            return section.options.count + 1
        } else {
            return 1
        }
    }
    
    
    
}


//class RecipeCardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
//
//    @IBOutlet weak var timeLabel: UILabel!
//    @IBOutlet weak var mainImage: UIImageView!
//    @IBOutlet weak var titleLabel: UILabel!
//    @IBOutlet weak var ingredientsTableView: UITableView!
//
//    private let tableView: UITableView = {
//        let tableView = UITableView()
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
//        return tableView
//    }()
//
//    var recipe: Recipe!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        if let url = URL(string: recipe.image!) {
//            loadImage(from: url)
//        }
//        timeLabel.text = String(recipe.readyInMinutes) + " minutes"
//        titleLabel.text = recipe.title
//        view.addSubview(tableView)
//        tableView.dataSource = self
//        tableView.delegate = self
//    }
//
//    override func didReceiveMemoryWarning() {
//            super.didReceiveMemoryWarning()
//            // Dispose of any resources that can be recreated.
//        }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 5
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        cell.textLabel?.text = "123"
//        return cell
//    }
//
//    func loadImage(from url: URL) {
//        self.mainImage.image = nil
//        var task: URLSessionTask!
//
//        if let task = task {
//            task.cancel()
//        }
//
//        if let imageFromCache = imageCache.object(forKey: url.absoluteURL as AnyObject) as? UIImage {
//            self.mainImage.image = imageFromCache
//            return
//        }
//        task = URLSession.shared.dataTask(with: url) { (data, response, error) in
//            guard
//                let data = data,
//                let newImage = UIImage(data: data)
//            else {
//                print("couldn't load image from url: \(url)")
//                return
//            }
//
//            imageCache.setObject(newImage, forKey: url.absoluteURL as AnyObject)
//            DispatchQueue.main.async {
//                self.mainImage.image = newImage
//            }
//        }
//        task.resume()
//    }
//
//}
