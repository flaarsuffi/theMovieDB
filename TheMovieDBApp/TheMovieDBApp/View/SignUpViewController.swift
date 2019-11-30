//
//  SignUpViewController.swift
//  TheMovieDBApp
//
//  Created by Flavia Arsuffi on 21/11/19.
//  Copyright © 2019 Flavia Arsuffi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var lasNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        setUpElements()
        
        nameTextField.delegate = self
        lasNameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        
        
        
    }
    
    func setUpElements() {
        
        errorLabel.alpha = 0
        
        Utilities.styleTextField(nameTextField)
        Utilities.styleTextField(lasNameTextField)
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(signUpButton)
        
    }
    
    func validateFields() -> String? {
        
        if nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lasNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Por favor preencher todos os campos."
        }
        
        let cleanedPassaword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isPasswordValid(cleanedPassaword)  == false {
            return "Senha deve conter no mínimo 8 caracteres, um número e um caractere especial"
        }
        
        
        
        
        return nil
        
    }
    
    @IBAction func signUpTapped(_ sender: UIButton) {
        
        //Validate the fields
        let error = validateFields()
        
        if error != nil {
            
            
            showError(error ?? "")
            
        } else {
            
            let name = nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            let lastName = lasNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            
            Auth.auth().createUser(withEmail: email, password: password) { (results, err) in
                if err != nil {
                    self.showError("Erro ao criar usuário")
                }
                else {
                    let db = Firestore.firestore()
                    
                    db.collection("users").addDocument(data: ["name":name, "lastname":lastName, "uid":results?.user.uid ?? ""]) { (error) in
                        
                        if error != nil {
                            self.showError("Erro ao salvar user data")
                        }
                    }
                    
                    self.goToHomeViewController()
                }
            }
            
        }
    }
    
    func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.alpha = 1
        
    }
    
    func goToHomeViewController() {
        
      if let tabbarViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.tabbarViewController) {
            tabbarViewController.modalPresentationStyle = .fullScreen
            self.present(tabbarViewController, animated: true, completion: nil)
        }
    }
}

extension SignUpViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.isEqual(self.nameTextField) {
            self.lasNameTextField.becomeFirstResponder()
        } else {
            if textField.isEqual(self.lasNameTextField) {
                self.emailTextField.becomeFirstResponder()
            } else {
                if textField.isEqual(self.emailTextField) {
                    self.passwordTextField.becomeFirstResponder()
                } else {
                    self.passwordTextField.resignFirstResponder()
                }
            }
        }
         return true
    }
   
}

