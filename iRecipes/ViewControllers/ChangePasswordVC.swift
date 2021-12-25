//
//  ChangePasswordVC.swift
//  iRecipes
//
//  Created by Mihail on 12/20/21.
//

import UIKit
import Firebase
import FirebaseAuth

class ChangePasswordVC: UIViewController {

    @IBOutlet weak var currentText: UITextField!
    @IBOutlet weak var newText: UITextField!
    @IBOutlet weak var repeatText: UITextField!
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        errorLabel.alpha = 0
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        if currentText.text != "" && newText.text != "" && repeatText.text != "" {
            if newText.text == repeatText.text {
                let user = Auth.auth().currentUser!
                if self.isPasswordValid(self.newText.text!) == true {
                    user.updatePassword(to: newText.text!) {error in
                        if let error = error {
                            self.showError(error: error.localizedDescription)
                        } else {
                            
                            FirebaseManager.shared.updateUserField(collection: "users", documentPath: user.uid, fieldname: "password", value: self.newText.text!)
                            self.errorLabel.text = ""
                            self.currentText.text = ""
                            self.newText.text = ""
                            self.repeatText.text = ""
                        }
                    }
                } else {
                    self.showError(error: "Password must be at least 8 symbols length, contains an alphabet letter, special character and a number")
                }
                
            } else {
                showError(error: "Passwords do not match")
            }
        } else {
            showError(error: "Fill all fields")
        }
    }
    
    func showError(error e: String) {
        errorLabel.text = e
        errorLabel.alpha = 1
    }
    
    func isPasswordValid(_ password : String) -> Bool{
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
}
