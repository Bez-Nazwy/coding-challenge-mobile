//
//  MainViewController.swift
//  Hackathon
//
//  Created by Krzysztof Kapała on 22/11/2018.
//  Copyright © 2018 Krzysztof Kapała. All rights reserved.
//

import UIKit
import Alamofire

class MainViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.downloadData()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func downloadData() {
        SorApi.sharedInstance.downloadNumberData(completionHandler: { (response) in
            //load response/ refresh view
        }) { (error) in
            print(error)
        }

        
    }
    
    
}
