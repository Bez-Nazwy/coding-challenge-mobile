//
//  ViewController.swift
//  Hackathon
//
//  Created by Krzysztof Kapała on 22/11/2018.
//  Copyright © 2018 Krzysztof Kapała. All rights reserved.
//

import UIKit
import Alamofire

class RegisterViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var messageLabel: UILabel!
    let URL_USER_REGISTER = "http://jakisadres"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func registerButtonDidClick(_ sender: Any) {
        
        let parameters: Parameters = [
            "username":usernameTextField.text!,
            "password":passwordTextField.text!
        ]
        Alamofire.request(URL_USER_REGISTER, method: HTTPMethod.post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            print(response)
            
            if let result = response.result.value {
                let jsonData = result as! NSDictionary
                self.messageLabel.text = jsonData.value(forKey: "message") as! String?
            }
        }
    }
    
}

