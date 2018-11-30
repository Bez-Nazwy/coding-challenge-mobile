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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.errorLbl.textColor = .red
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func loginButtonDidClick(_ sender: UIButton) {
        
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
            if let data = response {
                let dic = data.first as! NSDictionary
                appDelegate.token =  dic.value(forKey: "token") as! String
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
}

