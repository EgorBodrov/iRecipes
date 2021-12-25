//
//  Recipe.swift
//  iRecipes
//
//  Created by Mihail on 12/19/21.
//

import Foundation

import Foundation

struct Recipe : Codable {
    
    struct ExtendedIngredients : Codable {
        var originalString : String?
    }
    
    var extendedIngredients : [ExtendedIngredients]?
    var id : Int?
    var title : String?
    var readyInMinutes : Int
    var image : String?
    var imageType : String?
    
    var instructions : String?
        struct AnalyzedInstructions : Codable {
            var name : String?
             struct Steps : Codable {
                    var number : Int?
                    var step : String?
                    
                        struct Ingredients : Codable {
                            var id : Int?
                            var name : String?
                            var image : String?
                        }
                    
                    var ingredients : [Ingredients]?
                    
                }
            var steps : [Steps]?
        }
    
    var analyzedInstructions : [AnalyzedInstructions]?
}
