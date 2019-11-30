//
//  LoginViewController.swift
//  TheMovieDBApp
//
//  Created by Flavia Arsuffi on 21/11/19.
//  Copyright © 2019 Flavia Arsuffi. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpElements()
        emailTextField.text = "teste@teste.com"
        passwordTextField.text = "teste@11"
        
        
    }
    
    func setUpElements() {
        
        errorLabel.alpha = 0
        
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(loginButton)
        
        
        
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        
        let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            if error != nil {
                
                self.errorLabel.text = error?.localizedDescription
                self.errorLabel.alpha = 1
            } else {
                
                if let tabbarViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.tabbarViewController) {
                    tabbarViewController.modalPresentationStyle = .fullScreen
                    self.present(tabbarViewController, animated: true, completion: nil)
                }
            }
            
            
        }
        
    }
    
    
    
}
