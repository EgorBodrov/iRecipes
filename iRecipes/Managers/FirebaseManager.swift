//
//  FirebaseManager.swift
//  iRecipes
//
//  Created by Mihail on 12/17/21.
//

import Foundation
import UIKit
import Firebase

class FirebaseManager {
    
    static let shared = FirebaseManager()
    
    private func configureFB() -> Firestore {
        var db: Firestore!
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
    
        return db
    }
    
    func getData(collection c: String, documentPath d: String, completion: @escaping (UserDocument?) -> Void) {
        let db = configureFB()
        db.collection(c).document(d).getDocument(completion: { (document, error) in
            guard error == nil else { completion(nil); return }
            let doc = UserDocument(age: document?.get("age") as! String, email: document?.get("email") as! String, password: document?.get("password") as! String, name: document?.get("name") as! String, username: document?.get("username") as! String, country: document?.get("country") as! String, city: document?.get("city") as! String)
            completion(doc)
        })
    }
    
    func updateUserField(collection c: String, documentPath d: String, fieldname f: String, value v:String)  {
        let db = configureFB()
        db.collection(c).document(d).updateData([f: v]) {error in
            if error == nil {
                print(error?.localizedDescription)
            }
            
        }
    }
    
    func updateDataUser(collection c: String, documentPath d: String, fullname n: String, country co: String, city ci: String, age a: String) {
        let db = configureFB()
        db.collection(c).document(d).updateData(["name": n, "country": co, "city": ci, "age": a]) {error in
            if error == nil {
                print(error?.localizedDescription)
            }
            
        }
        
    }
    
    func setUserRecipesField(collection c: String, documentPath d: String) {
        let db = configureFB()
        db.collection(c).document(d).getDocument(completion: {(doc, error) in
            if doc?.exists == false {
                db.collection(c).document(d).setData(["favourites": [0]])
            }
        })
    }
    
    func getUserRecipes(collection c: String, documentPath d: String, completion: @escaping (RecipeDocument?) -> Void) {
        let db = configureFB()
        
        db.collection(c).document(d).getDocument(completion: { (document, error) in
            guard error == nil else { completion(nil); return }
            let doc = RecipeDocument(favourites: document?.get("favourites") as! [Int])
            completion(doc)
        })
    }
    
    func updateUserRecipes(collection c: String, documentPath d: String, newValue: Int) {
        let db = configureFB()
        
        db.collection(c).document(d).updateData(["favourites": FieldValue.arrayUnion([newValue])]) {error in
            if error == nil {
                print(error?.localizedDescription)
            }
            
        }
    }
    
    func deleteUserRecipe(collection c: String, documentPath d: String, value: Int) {
        let db = configureFB()
        
        db.collection(c).document(d).updateData(["favourites": FieldValue.arrayRemove([value])]) {error in
            if error == nil {
                print(error?.localizedDescription)
            }
            
        }
    }
    
}
