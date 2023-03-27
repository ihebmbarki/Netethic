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
    
    func verifyOTPActivationCode(codeOTP: String, completionHandler: @escaping (Result<String, APIError>) -> Void) {
            
            guard let email = UserDefaults.standard.string(forKey: "userEmail") else {
                completionHandler(.failure(.custom(message: "User email not found")))
                return
            }
            
            let data = ["email": email,
                        "token": codeOTP]

            AF.request(otp_url, method: .post, parameters: data, encoder: JSONParameterEncoder.default).response { response in
                switch response.result {
                case .success( _):
                    guard let statusCode = (response.response?.statusCode) else {return}
                    if statusCode == 200 {
                        completionHandler(.success(email))
                    } else {
                        completionHandler(.failure(.custom(message: "Invalid OTP code")))
                    }
                case .failure(let err):
                    print(err.localizedDescription)
                    completionHandler(.failure(.custom(message: "Try again")))
                }
            }
        }
    
    func activateAccount(completionHandler: @escaping (Result<Bool, APIError>) -> Void) {
        guard let email = UserDefaults.standard.string(forKey: "userEmail") else {
            completionHandler(.failure(.custom(message: "User email not found")))
            return
        }
        
        AF.request(email_verif_url, method: .post, parameters: ["email": email], encoder: JSONParameterEncoder.default).response { response in
            switch response.result {
            case .success( _):
                guard let statusCode = (response.response?.statusCode) else {return}
                if statusCode == 200 {
                    completionHandler(.success(true))
                } else {
                    completionHandler(.failure(.custom(message: "Account activation failed")))
                }
            case .failure(let err):
                print(err.localizedDescription)
                completionHandler(.failure(.custom(message: "Try again")))
            }
        }
    }
    
    struct ErrorResponse: Decodable {
        let message: String
    }
    enum APIError: Error {
        case custom(message: String)
        case decodingError
        case serverError
    }
}

func addChildInfos(registerData: Childd, completionHandler: @escaping(ChildModel) -> Void) {
    
    let headers: HTTPHeaders = [
        .contentType("application/json")
    ]
    
    AF.request(add_Child_url, method: .post, parameters: registerData, encoder: JSONParameterEncoder.default, headers: headers).response { response in
        debugPrint(response)
        switch response.result {
        case.success(let data):
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: [])
                if (200..<300).contains(response.response!.statusCode)  {
//                    completionHandler(true, "Child registered successfully")
                }else {
//                    completionHandler(false, "try again!")
                }
            }catch{
                print(error.localizedDescription)
//                completionHandler(false, "try again!")
            }
        case.failure(let err):
            print(err.localizedDescription)
//            completionHandler(false, "try again!")
        }
        
    }
}
