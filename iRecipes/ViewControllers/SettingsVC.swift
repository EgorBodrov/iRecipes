//
//  SettingsVC.swift
//  iRecipes
//
//  Created by Mihail on 12/18/21.
//

import UIKit
import FirebaseAuth
import Firebase

class SettingsVC: UIViewController {

    @IBOutlet weak var verifyButton: UIButton!
    @IBOutlet weak var successLabel: UILabel!
    
    let user = Auth.auth().currentUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        successLabel.alpha = 0
        if user.isEmailVerified == true {
            verifyButton.isUserInteractionEnabled = false
            verifyButton.alpha = 0
        }
    }
    
    func showSuccess(info i: String) {
        successLabel.textColor = .systemGreen
        successLabel.text = i
        successLabel.alpha = 1
    }
    
    func showError(error e: String) {
        successLabel.textColor = .systemRed
        successLabel.text = e
        successLabel.alpha = 1
    }
    
    @IBAction func verifyButtonTapped(_ sender: Any) {
        if user.isEmailVerified == false {
            user.sendEmailVerification(completion: {error in
                if error != nil {
                    self.showError(error: error!.localizedDescription)
                } else {
                    self.showSuccess(info: "Follow the link in your mail to approve the address")
                    self.verifyButton.alpha = 0
                    self.verifyButton.isUserInteractionEnabled = false
                }
            })
        } else {
            self.showError(error: "Your email has been already verified")
        }
    }
    
}
