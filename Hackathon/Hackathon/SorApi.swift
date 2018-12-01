//
//  SorApi.swift
//  Hackathon
//
//  Created by Krzysztof Kapała on 30/11/2018.
//  Copyright © 2018 Krzysztof Kapała. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class SorApi {
    public static let sharedInstance = SorApi()
    
    private let baseURL = "http://156.17.140.39"
    
    private enum Endpoint:String {
        case getTestData = "/api/patients"
        case login = "/api/auth/mobile"
    }
    
    private func createRequestPath(endpoint:Endpoint, param:String = "") -> String {
        
        let formedPath = baseURL + "\(endpoint.rawValue)" + "/\(param)"
        
        return formedPath
    }
    
    private func performRequest(method:HTTPMethod, url:String, parameters:Parameters?, encoding:ParameterEncoding, headers:[String:String]?, handler:((_:(DataResponse<Any>)) -> Void)?)
    {
        do
        {
            
           try Alamofire.request(url.asURL(), method: method, parameters: parameters, encoding: encoding, headers: headers)
                .responseJSON { response in
                    handler?(response)
            }
        }
        catch
        {
            print(error)
        }
    }
    
    public func downloadNumberData(number:String ,completionHandler:@escaping ((_:[String : Any]?) -> Void), errorHandler:@escaping ((_ error:Error) -> Void)) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let header: HTTPHeaders = [
            "Authorization" : "Bearer \(appDelegate.token)"
        ]
        
        self.performRequest(method: .get, url: self.createRequestPath(endpoint: .getTestData, param: number), parameters: nil, encoding: JSONEncoding.default, headers: header) { (response) in
            
            switch response.result
            {
            case .success(let responseObject):
                let json = JSON(responseObject)
                completionHandler(json.dictionaryObject)
            case .failure(_):
                errorHandler(response.error!)
            }
        }
    }
    
    public func login(userNumber:String, userPassword: String, completionHandler:@escaping ((_:[String : Any]?) -> Void), errorHandler:@escaping ((_ error:Error) -> Void)) {
        
        let parameters: Parameters = [
            "patientNumber" : userNumber,
            "password" : userPassword
        ]
        
        self.performRequest(method: .post, url: self.createRequestPath(endpoint: .login), parameters: parameters, encoding: JSONEncoding.default, headers: nil) { (response) in
            
            switch response.result
            {
            case .success(let responseObject):
                let json = JSON(responseObject)
                print("halo \(json)")
                completionHandler(json.dictionaryObject)
            case .failure(_):
                errorHandler(response.error!)
            }
        }
    }
    
    public func leaveQueue(number:String ,completionHandler:@escaping ((_:[String : Any]?) -> Void), errorHandler:@escaping ((_ error:Error) -> Void)) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let header: HTTPHeaders = [
            "Authorization" : "Bearer \(appDelegate.token)"
        ]
        
        self.performRequest(method: .get, url: self.createRequestPath(endpoint: .getTestData, param: number), parameters: nil, encoding: JSONEncoding.default, headers: header) { (response) in
            
            switch response.result
            {
            case .success(let responseObject):
                let json = JSON(responseObject)
                completionHandler(json.dictionaryObject)
            case .failure(_):
                errorHandler(response.error!)
            }
        }
    }

    
}
