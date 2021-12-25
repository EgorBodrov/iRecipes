//
//  ViewController.swift
//  iRecipes
//
//  Created by Mihail on 12/8/21.
//

import FirebaseAuth
import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        errorLabel.alpha = 0
    }
    
    func validateFields() -> String? {
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
                return "Make sure you fill all the fields"
        }
        
        return nil
    }
    
    func goToHome() {
        let home = storyboard?.instantiateViewController(identifier: "HomePage")
        view.window?.rootViewController = home
        view.window?.makeKeyAndVisible()
    }
    
    func showError(_ msg: String) {
        errorLabel.text = msg
        errorLabel.alpha = 1
    }
    
    @IBAction func signInButtonTapped(_ sender: Any) {
        let validated = validateFields()
        
        if validated != nil {
            showError(validated!)
        } else {
            Auth.auth().signIn(withEmail: emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines), password: passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)) { (result, error) in
                if error != nil {
                    self.showError(error!.localizedDescription)
                } else {
                    self.errorLabel.alpha = 0
                    FirebaseManager.shared.updateUserField(collection: "users", documentPath: Auth.auth().currentUser!.uid, fieldname: "password", value: self.passwordTextField.text!)
                    self.goToHome()
                }
            }
        }
    }
    
}

