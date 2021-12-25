//
//  RecipeResponse.swift
//  iRecipes
//
//  Created by Mihail on 12/19/21.
//

import Foundation

struct RecipeResponse : Codable {
    let results: [RecipePreview]?
    let offset, number, totalResults: Int?
}
