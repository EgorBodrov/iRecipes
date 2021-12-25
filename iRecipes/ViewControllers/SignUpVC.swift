//
//  SignUpVC.swift
//  iRecipes
//
//  Created by Mihail on 12/8/21.
//

import FirebaseAuth
import Firebase
import UIKit

class SignUpVC: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        errorLabel.alpha = 0
        // Do any additional setup after loading the view.
    }
    
    func isPasswordValid(_ password : String) -> Bool{
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
    func validateFields() -> String? {
        if nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            usernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            repeatPasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
                return "Make sure you fill all the fields"
        }
        
        let pass = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let passRepeated = repeatPasswordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard self.isPasswordValid(pass) == true else {
            return "Password must be at least 8 symbols length, contains an alphabet letter, special character and a number"
        }
        
        guard pass == passRepeated else {
            return "Passwords are not matching"
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
    
    @IBAction func signUpButtonClicked(_ sender: Any) {
        let validated = validateFields()
        
        if validated != nil {
            showError(validated!)
        } else {
            errorLabel.alpha = 0
            Auth.auth().createUser(withEmail: emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines), password: passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)) { (result, error) in
                if error != nil {
                    self.showError("Error in creating new user")
                } else {
                    let db = Firestore.firestore()
                    db.collection("users").document(result!.user.uid).setData(["email": self.emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines), "password": self.passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines), "name": self.nameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines), "username": self.usernameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines), "country": "", "city":"", "age": ""]) { error2 in
                        if error2 != nil {
                            self.showError("Error in adding data to database")
                        } else {
                            self.errorLabel.alpha = 0
                            self.goToHome()
                        }
                    }
                }
            }
        }
        
    }
}
