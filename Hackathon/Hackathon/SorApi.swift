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
    
    private let baseURL = "https://jsonplaceholder.typicode.com"
    
    private enum Endpoint:String {
        case getTestData = "/todos"
    }
    
    private func performRequest(method:HTTPMethod, url:String, parameters:Parameters?, encoding:ParameterEncoding, headers:[String:String]?, handler:((_:(DataResponse<Any>)) -> Void)?)
    {
        do
        {
            try Alamofire.request(url.asURL(), method: method, parameters: parameters, encoding: encoding, headers: headers)
                /*.validate(statusCode: 200..<300)*/
                .responseJSON { response in
                    handler?(response)
            }
        }
        catch
        {
            print(error)
        }
    }
    
    private func createRequestPath(endpoint:Endpoint) -> String {
        
        let formedPath = baseURL + "\(endpoint.rawValue)"
        
        return formedPath
    }
    
    public func downloadTestData(completionHandler:@escaping ((_:[Any]?) -> Void), errorHandler:@escaping ((_ error:Error) -> Void)) {
        
        self.performRequest(method: .get, url: self.createRequestPath(endpoint: .getTestData), parameters: nil, encoding: JSONEncoding.default, headers: nil) { (response) in
            
            switch response.result
            {
            case .success(let responseObject):
                let json = JSON(responseObject)
                completionHandler(json.arrayObject)
            case .failure(_):
                errorHandler(response.error!)
            }
        }
    }
}