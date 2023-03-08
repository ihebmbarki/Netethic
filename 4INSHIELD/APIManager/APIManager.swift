//
//  APIManager.swift
//  4INSHIELD
//
//  Created by iheb mbarki on 28/2/2023.
//

import Foundation
import Alamofire


enum APIErrors: Error {
    case custom(message: String)
}
typealias handler = (Swift.Result<Any?, APIErrors>) -> Void



class APIManager {
    static let shareInstance = APIManager()
    
    func registerAPI(register: RegisterModel, completionHandler: @escaping (Bool, String) -> ()){
        
        let headers: HTTPHeaders = [
            .contentType("application/json")
        ]
        
        AF.request(register_url, method: .post, parameters: register, encoder: JSONParameterEncoder.default, headers: headers).response { response in
            debugPrint(response)
            switch response.result {
            case.success(let data):
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: [])
                    if (200..<300).contains(response.response!.statusCode)  {
                        completionHandler(true, "user registered successfully")
                    }else {
                        completionHandler(false, "try again!")
                    }
                }catch{
                    print(error.localizedDescription)
                    completionHandler(false, "try again!")
                }
            case.failure(let err):
                print(err.localizedDescription)
                completionHandler(false, "try again!")
            }
            
        }
    }
    
    func loginAPI(login: LoginModel, completionHandler: @escaping handler){
        
        let headers: HTTPHeaders = [ 
            .contentType("application/json")
        ]
        
        AF.request(login_url, method: .post, parameters: login, encoder: JSONParameterEncoder.default, headers: headers).response { response in
            debugPrint(response)
            switch response.result {
            case.success(let data):
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: [])
                    if response.response?.statusCode == 200 {
                        completionHandler(.success(json))
                    }else {
                        completionHandler(.failure(.custom(message: "Check your network connectivity")))
                    }
                }catch{
                    print(error.localizedDescription)
                    completionHandler(.failure(.custom(message: "Try again")))
                }
            case.failure(let err):
                print(err.localizedDescription)
                completionHandler(.failure(.custom(message: "Try again")))
            }
            
        }
    }
    

    func verifyOTPActivationCode(email: String, codeOTP: String, completionHandler: @escaping handler){
        
        let headers: HTTPHeaders = [
            .contentType("application/json")
        ]
        let data = [
            "email": email,
            "token": codeOTP
        ]
        AF.request(otp_url, method: .post, parameters: data , encoder: JSONParameterEncoder.default, headers: headers).response { response in
            debugPrint(response)
            
            switch response.result {
            case.success(let data):
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: [])
                    if response.response?.statusCode == 200 {
                        completionHandler(.success(json))
                    }else {
                        completionHandler(.failure(.custom(message: "Check your network connectivity")))
                    }
                }catch{
                    print(error.localizedDescription)
                    completionHandler(.failure(.custom(message: "Try again")))
                }
            case.failure(let err):
                print(err.localizedDescription)
                completionHandler(.failure(.custom(message: "Try again")))
            }
            
        }
    }
    
    func activateAccount(withEmail: String, completion: @escaping(Bool) -> Void) {
     
        let data = [
            "email": withEmail
        ]
        AF.request(email_verif_url, method: .post, parameters: data,
                   encoder: JSONParameterEncoder.default).response { response in
            debugPrint(response)

            switch response.result {
//            case .success(let data):
            case .success( _):
//                print("DEBUG:", data)
                
                guard let statusCode = (response.response?.statusCode) else {return}
                if statusCode == 200 {
                    completion(true)
                } else {
                    completion(false)
                }
                
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
}
