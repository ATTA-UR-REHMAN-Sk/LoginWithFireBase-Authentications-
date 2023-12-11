//
//  ViewController.swift
//  LoginWithFireBase
//
//  Created by apple on 18/07/2023.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    var gmailId: String?
    var passId: String?
    
    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Log In"
        label.font = .systemFont(ofSize: 24,weight: .semibold)
        return label
    }()
    private let emailField: UITextField = {
        let emailField = UITextField()
        emailField.placeholder = "Email Address"
        emailField.layer.borderWidth = 1
        emailField.autocorrectionType = .no
        emailField.layer.borderColor = UIColor.black.cgColor
        emailField.backgroundColor = .white
        emailField.leftViewMode = .always
        emailField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        return emailField
    }()
   private let passwordField: UITextField = {
        let passField = UITextField()
        passField.placeholder = "Password"
        passField.layer.borderWidth = 1
        passField.isSecureTextEntry = true
        passField.layer.borderColor = UIColor.black.cgColor
        passField.leftViewMode = .always
        passField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        passField.backgroundColor = .white
        return passField
    }()
    private let button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Login", for: .normal)
        return button
    }()
    private let signOutButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Log Out", for: .normal)
        return button
    }()
    private let label1: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Gmail:aaa@123.com Pswd:aaa112"
        label.font = .systemFont(ofSize: 20,weight: .regular)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.addSubview(label)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(button)
        view.addSubview(label1)
        
        view.backgroundColor = .systemPurple
        
        gmailId = emailField.text
        passId = passwordField.text
        
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        
        if FirebaseAuth.Auth.auth().currentUser != nil {
            
            
//            label.isHidden = true
//            button.isHidden = true
//            emailField.isHidden = true
//            passwordField.isHidden = true

//            view.addSubview(signOutButton)
//            signOutButton.frame = CGRect(x: 20, y: 150, width: view.bounds.width-40, height: 52)
//            signOutButton.addTarget(self, action: #selector(logOutTapped), for: .touchUpInside)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        do{
            try FirebaseAuth.Auth.auth().signOut()
            label.isHidden = false
            button.isHidden = false
            emailField.isHidden = false
            passwordField.isHidden = false
            signOutButton.isHidden = true
            
            signOutButton.resignFirstResponder()
        }
        catch {
            print("An error occured")
        }
    }
    
    @objc private func logOutTapped(){
        do{
            try FirebaseAuth.Auth.auth().signOut()
            label.isHidden = false
            button.isHidden = false
            emailField.isHidden = false
            passwordField.isHidden = false
            signOutButton.isHidden = true

            signOutButton.resignFirstResponder()
        }
        catch {
            print("An error occured")
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        label.frame = CGRect(x: 0, y: 100, width: view.frame.size.width, height: 80)
        
        emailField.frame = CGRect(x: 20, y:label.frame.origin.y+label.frame.size.height+10, width: view.frame.size.width-40, height: 50)
        
        passwordField.frame = CGRect(x: 20, y: emailField.frame.origin.y+emailField.frame.size.height+10, width: view.frame.size.width-40, height: 50)
        button.frame = CGRect(x: 20, y: passwordField.frame.origin.y+passwordField.frame.size.height+30, width: view.frame.size.width-40, height: 52)
        //label.frame = CGRect(x: 0, y: 100, width: view.frame.size.width, height: 80)
        label1.frame = CGRect(x: 0, y: button.frame.origin.y+button.frame.size.height+30, width: view.frame.size.width, height: 80)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if FirebaseAuth.Auth.auth().currentUser == nil {
            emailField.becomeFirstResponder()
        }
    }
    
    @objc private func didTapButton() {
        
        print("Continue button tapped")
        guard let email = emailField.text, !email.isEmpty,
              let password = passwordField.text, !password.isEmpty else {
            print("Missing field data")
            return
        }
        // Get auth instance
        // attemp sign in
        
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: {[weak self] result, error in
            guard let strongSelf = self else {
                return
            }
            guard error == nil else {
                // show account creation
                strongSelf.showCreateAccount(email: email, password: password)
                //  print("Account creation failed")
                
                return
            }
            let vc = self?.storyboard?.instantiateViewController(withIdentifier: "FirebaseDataBase") as! FirebaseDataBase
//            vc.GmailId.text = self?.gmailId
//            vc.Password.text = self?.passId
            self?.navigationController?.pushViewController(vc, animated: true)
            print("You have signed In")
            strongSelf.label.isEnabled = true
            strongSelf.emailField.isHidden = true
            strongSelf.passwordField.isHidden = true
            strongSelf.button.isHidden = true
            strongSelf.signOutButton.isHidden = false
            strongSelf.emailField.resignFirstResponder()
            strongSelf.emailField.resignFirstResponder()
        })
    }
    
    func showCreateAccount(email: String, password: String) {
        let alert = UIAlertController(title: "Create Account", message: "Would you like to create", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: {_ in
            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password, completion: {[weak self] result, error in
                guard let strongSelf = self else {
                    return
                }
                guard error == nil else {
                    // show account creation
                    strongSelf.showCreateAccount(email: email, password: password)
                    //  print("Account creation failed")
                    return
                }
                print("You have signed In")
                strongSelf.label.isEnabled = true
                strongSelf.emailField.isHidden = true
                strongSelf.passwordField.isHidden = true
                strongSelf.button.isHidden = true
                
                strongSelf.signOutButton.isHidden = false
                
                strongSelf.emailField.resignFirstResponder()
                strongSelf.passwordField.resignFirstResponder()
            })
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {_ in
            
        }))
        
        present(alert, animated: true)
    }
    
}
