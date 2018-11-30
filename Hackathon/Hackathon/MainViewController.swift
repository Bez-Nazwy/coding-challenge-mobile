//
//  MainViewController.swift
//  Hackathon
//
//  Created by Krzysztof Kapała on 22/11/2018.
//  Copyright © 2018 Krzysztof Kapała. All rights reserved.
//

import UIKit
import Alamofire

class MainViewController: UITableViewController {

    let URL_DATA = "https://jsonplaceholder.typicode.com/todos"
    var tableData:NSArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.downloadData()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func downloadData() {
        
//        Alamofire.request(URL_DATA, method: HTTPMethod.get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON {
//            (response) in
//            print(response)
//
//            if let result = response.result.value {
//                let jsonData = result as! NSArray
//                self.tableData = jsonData
//                self.tableView.reloadData()
//            }
//        }
        
        SorApi.sharedInstance.downloadTestData(completionHandler: { (data) in
            self.tableData = data as NSArray?
            self.tableView.reloadData()
        }) { (error) in
            print(error)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if let data = self.tableData {
            let dic = data[indexPath.row] as! NSDictionary
            
            cell.textLabel?.text = dic.value(forKey: "title") as! String
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let data = self.tableData {
            return data.count
        } else {
            return 0
        }
    }
    
}
