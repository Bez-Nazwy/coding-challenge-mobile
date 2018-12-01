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
    var seconds:Double = 0
    var myNumber = ""
    var ai:UIActivityIndicatorView = UIActivityIndicatorView()
    @IBOutlet weak var myDoctorLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = myNumber
        self.runTimer()
        self.downloadData()
        
    }
    
    func downloadData(isUpdateWaitTime: Bool = true) {
        SorApi.sharedInstance.downloadNumberData(number: myNumber, completionHandler: { (response) in
            
            if let dic = response {
                if let queueNumber = dic["queueNumber"] {
                    
                    if self.queueNumberLbl.text != "\(queueNumber)" && isUpdateWaitTime {
                        UIView.animate(withDuration: 0.6) {
                            self.timerLbl.frame.origin.x -= 400
                        }
                    }
                    
                    if (queueNumber as! Int) == 0 {
                        self.queueNumberLbl.text = "Teraz twoja kolej"
                    } else {
                        self.queueNumberLbl.text = "\(queueNumber)"
                    }
                    
                }
                
                if let serviceTime = dic["serviceTime"] {

                    let currentTime = NSDate().timeIntervalSince1970
                    
                    self.seconds = (serviceTime as! Double)/1000 - currentTime
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
        }) { (error) in
            print(error)
        }
    }
    
    @objc func updateTimer() {
        
        if seconds <= 0 && self.queueNumberLbl.text == "Teraz twoja kolej" {
            
            self.timerLbl.text = "-"
        }
        
        if seconds > 0 {
            seconds -= 1
            timerLbl.text = timeString(time: TimeInterval(seconds))
        }
        if Int(seconds) % 5 == 0 {
            downloadData(isUpdateWaitTime: seconds>0)
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
                SorApi.sharedInstance.resign(number: self.myNumber, completionHandler: { (response) in
                    self.logout()
                }, errorHandler: { (error) in
                    self.logout()
                    print(error)
                })
            } else {
//                let sv = UIViewController.displaySpinner(onView: self.view)
                
                let ai = UIActivityIndicatorView.init(style: UIActivityIndicatorView.Style.whiteLarge)
                ai.color = UIColor.gray
                ai.startAnimating()
                self.queueNumberLbl.text = ""
//                self.queueNumberLbl.backgroundColor = .white
                ai.center = self.queueNumberLbl.center
                self.view.addSubview(ai)
                
                SorApi.sharedInstance.postponeQueue(number: self.myNumber, completionHandler: { (response) in
                    self.downloadData()
                    ai.stopAnimating()
                }, errorHandler: { (error) in
                    self.downloadData()
                    ai.stopAnimating()
                })
            }
            
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
