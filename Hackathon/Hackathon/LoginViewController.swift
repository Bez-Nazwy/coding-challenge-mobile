//
//  LoginViewController.swift
//  Hackathon
//
//  Created by Krzysztof Kapała on 30/11/2018.
//  Copyright © 2018 Krzysztof Kapała. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class LoginViewController: UIViewController {

    @IBOutlet weak var userNumberTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLbl: UILabel!
    
    var originalViewFrame: CGRect!
    var isKeyboardVisible: Bool! = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        super.viewDidLoad()
        originalViewFrame = self.view.frame;
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        self.errorLbl.textColor = .red
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.userNumberTextField.becomeFirstResponder()
    }
    
    @IBAction func loginButtonDidClick(_ sender: UIButton) {
        
        self.errorLbl.text = ""
        if (self.userNumberTextField.text?.isEmpty)! {
            self.badText(textField: self.userNumberTextField)
        } else {
            self.userNumberTextField.layer.borderWidth = 0
        }
        if (self.passwordTextField.text?.isEmpty)! {
            self.badText(textField: self.passwordTextField)
            return
        } else {
            self.passwordTextField.layer.borderWidth = 0
        }
        
        guard let number = userNumberTextField.text else {return}
        guard let password = passwordTextField.text else { return}
        
        SorApi.sharedInstance.login(userNumber: number, userPassword: password, completionHandler: { (response) in
            //tu ide dalej i zapisuje token
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            if let dic = response {
                
                if let token = dic["token"] {
                    appDelegate.token = token as! String
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "main") as! MainViewController
                    vc.myNumber = number
                    self.navigationController?.pushViewController(vc, animated: true)
                } else if let msg = dic["message"] {
                    self.badText(textField: self.userNumberTextField)
                    self.badText(textField: self.passwordTextField)
                    self.errorLbl.text = (msg as! String)
                }
            }
            
        }) { (error) in
            self.badText(textField: self.userNumberTextField)
            self.badText(textField: self.passwordTextField)
            self.errorLbl.text = "Zły numer lub hasło"
            print(error)
        }
    }
    
    func badText(textField: UITextField) {
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.red.cgColor
        textField.layer.cornerRadius = 4
        textField.shake()
    }
    
    @objc func keyboardShow(notification: NSNotification) {
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        self.view.frame.size.height = keyboardFrame.origin.y
        self.isKeyboardVisible = true
    }
    
    @objc func keyboardHide(notification: NSNotification) {
        self.view.frame = originalViewFrame
    }
    
    @objc func dismissKeyboard() {
        self.isKeyboardVisible = false
        view.endEditing(true)
    }
}

