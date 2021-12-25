//
//  HomeTableVC.swift
//  iRecipes
//
//  Created by Mihail on 12/19/21.
//

import Foundation
import UIKit

class FeedVC : UITableViewController {
    @IBOutlet weak var searchTextField: UITextField!
    var recipes = [RecipePreview]()
    var recipelist: Recipe!
    var title1: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let recipeCell = UINib.init(nibName: "RecipeCell", bundle: nil)
        self.tableView.register(recipeCell, forCellReuseIdentifier: "RecipeCell")
        
        let anonymousFunction = { (recipeList: [RecipePreview]) in
            DispatchQueue.main.async {
                self.recipes = recipeList
                self.tableView.reloadData()
            }
        }
       
        SpoonacularAPI.shared.searchRecipes(query: "", completion: anonymousFunction)
    }
    
    @IBAction func buttonPushed(_ sender: Any) {
        super.viewDidLoad()
        let anonymousFunction = { (recipeList: [RecipePreview]) in
            DispatchQueue.main.async {
                self.recipes = recipeList
                self.tableView.reloadData()
            }
        }
       
        SpoonacularAPI.shared.searchRecipes(query: searchTextField.text!, completion: anonymousFunction)
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 333
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath) as! RecipeCell
        let recipe = recipes[indexPath.row]
        cell.titleLable.text = recipe.title
        if let url = URL(string: recipe.image!) {
            cell.loadImage(from: url)
        }
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("TEST")
        
        let newAnonymousFunction = { (recipeList: [Recipe]) in
            DispatchQueue.main.async {
                self.recipelist = recipeList[0]
                self.performSegue(withIdentifier: "goToCard", sender: self.recipelist)
            }
        }
        SpoonacularAPI.shared.getRecipeById(id: self.recipes[indexPath.row].id!, completion: newAnonymousFunction)
        
        //let recipeCardVC = RecipeCardViewController()
        //recipeCardVC.recipe = recipe
        
        //self.present(recipeCardVC, animated: true)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToCard" {
            let vc = segue.destination as! RecipeCardViewController
            let rec = sender as! Recipe
            vc.recipe = rec
        }
    }
}
