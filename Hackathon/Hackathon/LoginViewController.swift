//
//  LoginViewController.swift
//  Hackathon
//
//  Created by Krzysztof Kapała on 30/11/2018.
//  Copyright © 2018 Krzysztof Kapała. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController {

    @IBOutlet weak var userNumberTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func registerButtonDidClick(_ sender: Any) {
        
        guard let number = userNumberTextField.text else {return}
        guard let password = passwordTextField.text else { return}
        
        SorApi.sharedInstance.login(userNumber: number, userPassword: password, completionHandler: { (response) in
            //tu ide dalej i zapisuje token
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//            appDelegate.token = response.token
            
        }) { (error) in
            print(error)
        }
    }
    
}

