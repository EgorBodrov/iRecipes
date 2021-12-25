//
//  ResetPasswordVC.swift
//  iRecipes
//
//  Created by Mihail on 12/20/21.
//

import UIKit
import Firebase
import FirebaseAuth

class ResetPasswordVC: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        errorLabel.alpha = 0
        // Do any additional setup after loading the view.
    }
    
    @IBAction func resetButtonTapped(_ sender: Any) {
        if emailText.text != "" {
            let auth = Auth.auth()
            auth.sendPasswordReset(withEmail: emailText.text!) { error in
                if let error = error {
                    self.showError(error: error.localizedDescription)
                } else {
                    self.showSuccess(info: "Follow the link sent in your address")
                }
            }
        } else {
            showError(error: "Enter email")
        }
    }
    
    func showSuccess(info i: String) {
        errorLabel.textColor = .systemGreen
        errorLabel.text = i
        errorLabel.alpha = 1
    }
    
    func showError(error e: String) {
        errorLabel.textColor = .systemRed
        errorLabel.text = e
        errorLabel.alpha = 1
    }

}
