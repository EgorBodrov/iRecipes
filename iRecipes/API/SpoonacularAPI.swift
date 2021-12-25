//
//  SpoonacularAPI.swift
//  iRecipes
//
//  Created by Mihail on 12/13/21.
//

import Foundation
import RxSwift

final class SpoonacularAPI {
    static let shared = SpoonacularAPI()
    private let apiKey = "4d2429171e844fc68b93cb9395acaa6c"
    private let urlPrefix = "https://api.spoonacular.com/recipes/"
    
    func getJSON(with endPoint: String, completion: @escaping (Data) -> Void) {
        if let url = URL(string: urlPrefix + endPoint) {
            print(url)
            let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
                if let content = data {
                    completion(content)
                }
            }
            task.resume()
        }
    }
    
    func searchRecipes(query: String, completion: @escaping ([RecipePreview]) -> Void) {
        self.getJSON(with: "complexSearch?query=" + query + "&apiKey=" + apiKey) { (json) in
            let response = try! JSONDecoder().decode(RecipeResponse.self, from: json)
            completion(response.results!)
        }
    }
    
    func getRandomRecipes(completion: @escaping ([Recipe]) -> Void) {
        self.getJSON(with: "random?number10&apiKey=" + apiKey) { (json) in
            let response = try! JSONDecoder().decode([Recipe].self, from: json)
            completion(response)
        }
    }
    
    
    func getRecipeById(id: Int, completion: @escaping ([Recipe]) -> Void) {
        self.getJSON(with: "informationBulk?ids=" + String(id) + "&apiKey=" + apiKey) { (json) in
            let response = try! JSONDecoder().decode([Recipe].self, from: json)
            completion(response)
        }
    }
}
