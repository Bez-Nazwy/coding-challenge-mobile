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
    
    @IBOutlet weak var queueNumberLbl: UILabel!
    @IBOutlet weak var timerLbl: UILabel!
    var timer = Timer()
    var seconds = 9000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.downloadData()
        self.runTimer()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func downloadData() {
        SorApi.sharedInstance.downloadNumberData(completionHandler: { (response) in
            //load response/ refresh view
        }) { (error) in
            print(error)
        }
    }
    
    @objc func updateTimer() {
        if seconds < 1 {
            timer.invalidate()
            //Send alert to indicate time's up.
        } else {
            seconds -= 1
            timerLbl.text = timeString(time: TimeInterval(seconds))
        }
    }
    
    func timeString(time:TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
    }
}
