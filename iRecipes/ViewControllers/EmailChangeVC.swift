//
//  EmailChangeVC.swift
//  iRecipes
//
//  Created by Mihail on 12/20/21.
//

import UIKit
import Firebase
import FirebaseAuth

class EmailChangeVC: UIViewController {

    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        errorLabel.alpha = 0
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        if emailText.text != nil {
            let user = Auth.auth().currentUser!
            if emailText.text != user.email! {
                user.updateEmail(to: emailText.text!) {error in
                    if let error = error {
                        self.showError(error: error.localizedDescription)
                    } else {
                        FirebaseManager.shared.updateUserField(collection: "users", documentPath: user.uid, fieldname: "email", value: self.emailText.text!)
                        self.emailText.text = ""
                        self.errorLabel.alpha = 0
                    }
                    
                }
                
            } else {
                showError(error: "Your passed your current email")
            }
        } else {
            showError(error: "Please, enter your new email")
        }
    }
    
    
    func showError(error e: String) {
        errorLabel.text = e
        errorLabel.alpha = 1
    }

}
