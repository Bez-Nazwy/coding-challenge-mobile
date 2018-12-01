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
    
    private enum Doctor:String {
        case OCULIST = "Okulista"
        case INTERNIST = "Internista"
        case DERMATOLOGIST = "Dermatolog"
    }
    
    @IBOutlet weak var queueNumberLbl: UILabel!
    @IBOutlet weak var timerLbl: UILabel!
    var timer = Timer()
    var seconds:Double = 9000
    var myNumber = ""
    @IBOutlet weak var myDoctorLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = myNumber
        self.downloadData()
        self.runTimer()
    }
    
    func downloadData() {
        SorApi.sharedInstance.downloadNumberData(number: myNumber, completionHandler: { (response) in
            
            if let dic = response {
                if let queueNumber = dic["queueNumber"] {
                    self.queueNumberLbl.text = "\(queueNumber)"
                }
                
                if let serviceTime = dic["serviceTime"] {
                    let time = Date(timeIntervalSince1970: (serviceTime as! Double)/1000)
//
                    let currentTime = NSDate().timeIntervalSince1970
                    
                    self.seconds = (serviceTime as! Double) - currentTime
                    print(self.seconds)
                    UIView.animate(withDuration: 0.6) {
                        self.timerLbl.frame.origin.x -= 400
                    }
//                    self.seconds = time.timeIntervalSinceNow.int
//                        (serviceTime as! Int) * 60
                }
                
                if let doctor = dic["doctor"] {
                    let doctorString = "\(doctor)"
                    
                    if doctorString == "OCULIST" {
                        self.myDoctorLbl.text = Doctor.OCULIST.rawValue
                    }
                    
                    if doctorString == "INTERNIST" {
                        self.myDoctorLbl.text = Doctor.INTERNIST.rawValue
                    }
                    
                    if doctorString == "DERMATOLOGIST" {
                        self.myDoctorLbl.text = Doctor.DERMATOLOGIST.rawValue
                    }
                }
                
            }
            
            //load response/ refresh view
        }) { (error) in
            print(error)
        }
    }
    
    @objc func updateTimer() {
        
        if seconds < 1 {
            timer.invalidate()
        } else {
            seconds -= 1
            timerLbl.text = timeString(time: TimeInterval(seconds))
        }
        if Int(seconds) % 10 == 0 {
            downloadData()
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
    
    func logout() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.token = ""
        timer.invalidate()
        self.navigationController?.popViewController(animated: true)
    }
    
    func areYouSureAction(resign: Bool = false) {
        let ac = UIAlertController(title: "Czy jesteś pewny?", message: "", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Tak", style: .default, handler: { (action) in
            if resign {
                
            } else {
                
            }
            self.downloadData()
        }))
        ac.addAction(UIAlertAction(title: "Nie", style: .cancel, handler: nil))
        self.present(ac, animated: true, completion: nil)
    }
    
    @IBAction func leaveQueueDidClick(_ sender: UIButton) {
        self.areYouSureAction()
    }
    
    @IBAction func resignDidClick(_ sender: UIButton) {
        self.areYouSureAction(resign: true)
    }
    
    @IBAction func logoutDidClick(_ sender: UIButton) {
        self.logout()
    }
}

extension Date {
    init?(jsonDate: String) {
        
        let prefix = "/Date("
        let suffix = ")/"
        
        // Check for correct format:
        guard jsonDate.hasPrefix(prefix) && jsonDate.hasSuffix(suffix) else { return nil }
        
        // Extract the number as a string:
        let from = jsonDate.index(jsonDate.startIndex, offsetBy: prefix.characters.count)
        let to = jsonDate.index(jsonDate.endIndex, offsetBy: -suffix.characters.count)
        
        // Convert milliseconds to double
        guard let milliSeconds = Double(jsonDate[from ..< to]) else { return nil }
        
        // Create NSDate with this UNIX timestamp
        self.init(timeIntervalSince1970: milliSeconds/1000.0)
    }
}
