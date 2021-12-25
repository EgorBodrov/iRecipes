//
//  RecipePreview.swift
//  iRecipes
//
//  Created by Mihail on 12/19/21.
//

import Foundation

struct RecipePreview : Codable,Identifiable {
    let id: Int?
    let title: String?
    let image: String?
    let imageType: String?
}
