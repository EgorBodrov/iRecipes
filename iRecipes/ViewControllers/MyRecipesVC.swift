//
//  MyRecipeVCTableViewController.swift
//  iRecipes
//
//  Created by Mihail on 12/24/21.
//

import UIKit
import Firebase
import FirebaseAuth

class MyRecipesVC: UITableViewController {
    var recipes = [Recipe]()
    var recipelist: Recipe!
    var title1: String!
    var ids: [Int]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let recipeCell = UINib.init(nibName: "RecipeCell", bundle: nil)
        self.tableView.register(recipeCell, forCellReuseIdentifier: "RecipeCell")
        
        // get ids from db
        FirebaseManager.shared.getUserRecipes(collection: "recipes", documentPath: Auth.auth().currentUser!.uid, completion: {doc in
            DispatchQueue.main.async {
                guard doc != nil else { return }
                self.ids = doc?.favourites
            }
        })
        
//        print("data 2: ", self.ids)
//        let idsString = ids.map{String($0)}.joined(separator: ",")
//
//        let anonymousFunction = { (recipeList: [Recipe]) in
//            DispatchQueue.main.async {
//                self.recipes = recipeList
//                self.tableView.reloadData()
//            }
//        }
//
//        SpoonacularAPI.shared.getRecipeById(id: idsString, completion: anonymousFunction)
//    }
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

