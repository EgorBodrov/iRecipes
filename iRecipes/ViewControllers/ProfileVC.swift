//
//  ProfileVC.swift
//  iRecipes
//
//  Created by Mihail on 12/15/21.
//

import UIKit
import FirebaseAuth
import Firebase

class ProfileVC: UIViewController {
    
    
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var fullnameText: UITextField!
    @IBOutlet weak var ageText: UITextField!
    @IBOutlet weak var countryText: UITextField!
    @IBOutlet weak var cityText: UITextField!
    
    @IBOutlet weak var savechangesButton: UIButton!
    @IBOutlet weak var changeButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    
    let userID: String = Auth.auth().currentUser!.uid
    var oldName: String!
    var oldAge: String!
    var oldCountry: String!
    var oldCity: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FirebaseManager.shared.getData(collection: "users", documentPath: userID, completion: {doc in
            guard doc != nil else { return }
            self.nicknameLabel.text = doc?.username
            self.nicknameLabel.alpha = 1
            self.fullnameText.text = doc?.name
            self.ageText.text = doc?.age
            self.countryText.text = doc?.country
            self.cityText.text = doc?.city
        })
        
    }
    
    @IBAction func changeButtonTapped(_ sender: Any) {
        let title = changeButton.titleLabel?.text!
        
        if title == "Change" {
            self.oldName = fullnameText.text
            self.oldAge = ageText.text
            self.oldCountry = countryText.text
            self.oldCity = cityText.text
            
            // Set as changable
            fullnameText.isUserInteractionEnabled = true
            ageText.isUserInteractionEnabled = true
            countryText.isUserInteractionEnabled = true
            cityText.isUserInteractionEnabled = true
            
            // Set border style
            fullnameText.borderStyle = UITextField.BorderStyle.roundedRect
            ageText.borderStyle = UITextField.BorderStyle.roundedRect
            countryText.borderStyle = UITextField.BorderStyle.roundedRect
            cityText.borderStyle = UITextField.BorderStyle.roundedRect
            
            savechangesButton.alpha = 1
            savechangesButton.isUserInteractionEnabled = true
            
            changeButton.setTitle("Discard changes", for: .normal)
            
        } else if title == "Discard changes" {
            fullnameText.text = oldName
            ageText.text = oldAge
            countryText.text = oldCountry
            cityText.text = oldCity
            
            fullnameText.isUserInteractionEnabled = false
            ageText.isUserInteractionEnabled = false
            countryText.isUserInteractionEnabled = false
            cityText.isUserInteractionEnabled = false
            
            // Set border style
            fullnameText.borderStyle = UITextField.BorderStyle.none
            ageText.borderStyle = UITextField.BorderStyle.none
            countryText.borderStyle = UITextField.BorderStyle.none
            cityText.borderStyle = UITextField.BorderStyle.none
            
            savechangesButton.alpha = 0
            savechangesButton.isUserInteractionEnabled = false
            
            changeButton.setTitle("Change", for: .normal)
        
        }
    }
    
    @IBAction func savechangesButtonTapped(_ sender: Any) {
        FirebaseManager.shared.updateDataUser(collection: "users", documentPath: self.userID, fullname: self.fullnameText.text!, country: self.countryText.text!, city: self.cityText.text!, age: self.ageText.text!)
        
        fullnameText.isUserInteractionEnabled = false
        ageText.isUserInteractionEnabled = false
        countryText.isUserInteractionEnabled = false
        cityText.isUserInteractionEnabled = false
        
        // Set border style
        fullnameText.borderStyle = UITextField.BorderStyle.none
        ageText.borderStyle = UITextField.BorderStyle.none
        countryText.borderStyle = UITextField.BorderStyle.none
        cityText.borderStyle = UITextField.BorderStyle.none
        
        let title = changeButton.titleLabel?.text!
        if title == "Discard changes" {
            changeButton.setTitle("Change", for: .normal)
        }
        savechangesButton.alpha = 0
        savechangesButton.isUserInteractionEnabled = false
    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
        
        let home = storyboard?.instantiateViewController(identifier: "FormPage")
        view.window?.rootViewController = home
        view.window?.makeKeyAndVisible()
        
    }
    
    
}
