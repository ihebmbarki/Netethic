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
    
    func fetchCurrentUserChildren(withUserName: String, completion: @escaping ([Child]) -> Void) {
        var children = [Child]()
        
        let serverURL = "\(BuildConfiguration.shared.WEBERVSER_BASE_URL)/api/users/\(withUserName)/childs/"
        AF.request(serverURL, method: .get).response { response in
            switch response.result {
            case .success(let data):
                do {
                    children = try JSONDecoder().decode([Child].self, from: data!)
                    print("Decoded children: \(children)")
                } catch let error as NSError {
                    print("Failed to load: \(error.localizedDescription)")
                }
                completion(children)
            case .failure(let error):
                print("Error getting children list: \(error.localizedDescription)")
            }
        }
    }

    
    func setOnboardingSimpleTrue(forUsername username: String, completion: @escaping (Result<Any?, Error>) -> Void) {
        let parameters: [String: Any] = [
            "username": username,
            "onboarding_simple": true
        ]
        AF.request(set_Onboarding_url, method: .put, parameters: parameters, encoding: JSONEncoding.default).response { response in
            switch response.result {
            case .success(let value):
                print("Onboarding simple set to true: \(String(describing: value))")
                completion(.success(value))
            case .failure(let error):
                print("Failed to set onboarding simple to true: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
    
    func getUserOnboardingStatus(withUserName: String, completion: @escaping (Bool?) -> Void) {
        let onboarding_url = "\(BuildConfiguration.shared.WEBERVSER_BASE_URL)/api/users/\(withUserName)/"
        
        AF.request(onboarding_url, method: .get).responseJSON { response in
            switch response.result {
            case .success(let value):
                guard let json = value as? [String: Any],
                      let onboardingSimple = json["onboarding_simple"] as? Bool else {
                    completion(nil)
                    return
                }
                completion(onboardingSimple)
            case .failure(let error):
                print("API Error getting onboarding data: \(error)")
                completion(nil)
            }
        }
    }

    func getLastregistredChildID(withUsername: String, completion: @escaping(Int) -> Void) {
        var childs = [Child]()
        var lastChildID = 0
        
        let get_ChildID_url = "\(BuildConfiguration.shared.WEBERVSER_BASE_URL)/api/users/\(withUsername)/childs/"
        
        AF.request(get_ChildID_url, method: .get).response
        { response in
            switch response.result {
            case .success(let data):
                if let data = data {
                    do {
                        childs = try JSONDecoder().decode([Child].self, from: data)
                        let sortedChilds: [Child] = childs.sorted { $0.created_at.compare($1.created_at) == .orderedAscending }
//                        print("Sorted childs: \(sortedChilds)")
                        
                        if let lastChild = sortedChilds.last {
                            lastChildID = lastChild.id
                            completion(lastChildID)
                        }
                    } catch let error as NSError {
                        print("Failed to decode JSON: \(error.localizedDescription)")
                    }
                } else {
                    print("Response data is nil")
                }
            case .failure(let error):
                print("API Error getting journey data: \(error)")
            }
        }
    }
    
    func addSocialMediaProfile(socialData: Profil, completionHandler: @escaping (Result<String, APIError>) -> Void) {
        let headers: HTTPHeaders = [
            .contentType("application/json")
        ]
        AF.request(add_Child_Profile,method: .post, parameters: socialData, encoder: JSONParameterEncoder.default, headers: headers).response { response in
            switch response.result {
            case .success(let data):
                print(data as Any)
                guard let statusCode = (response.response?.statusCode) else {return}
                if statusCode == 201 {
                    do {
                        let profile = try JSONDecoder().decode(Profil.self, from: response.data!)
                        completionHandler(.success("Child social media registered successfully"))
                        
                    } catch {
                        completionHandler(.failure(.custom(message: "Failed to register child's social media")))
                    }
                }
            case .failure(let err):
                print("Error sending data to the API: \(err.localizedDescription)")
            }
        }
    }
    

    func getUserWizardStep(withUserName: String, completion: @escaping(Int) -> Void) {
            
            var userJourneys = [UserJourney]()
            var lastStep = 0
            
            let user_step_url = "\(BuildConfiguration.shared.WEBERVSER_BASE_URL)/api/users/\(withUserName)/journey/"

            AF.request(user_step_url, method: .get).response
            {
                response in
                print(response)
                switch response.result {
                case .success( _):
                    do {
                        userJourneys = try JSONDecoder().decode([UserJourney].self, from: response.data!)
                                                
                        if userJourneys.isEmpty {
                            lastStep = 0
                        } else {
                            guard let lastJourney = userJourneys.last else {return}
                            lastStep = lastJourney.wizard_step
                        }
                        
                        completion(lastStep)
                    } catch let error as NSError {
                        print("Error: \(error.localizedDescription)")
                    }
                case .failure(let error):
                    print("API Error getting journey data: \(error)")
                }
            }
        }

    func saveUserJourney(journeyData: UserJourney, completionHandler: @escaping (UserJourney) -> Void) {
            
        var journey: UserJourney?
        let _: HTTPHeaders = [
            .contentType("application/json")
        ]
            
            AF.request(user_journey_url, method: .post, parameters: journeyData, encoder: JSONParameterEncoder.default).response { response in
                switch response.result {
                case .success( _):
                    guard let statusCode = (response.response?.statusCode) else {return}
                    if statusCode == 200 {
                        do {
                            journey = try JSONDecoder().decode(UserJourney.self, from: response.data!)
                            completionHandler(journey!)
                        } catch let error as NSError {
                            print("Failed to load: \(error)")
                        }
                    }
                case .failure(let err):
                    debugPrint("API Error : \(err)")
                    break
                }
            }
        }
    
    func addChildInfos(regData: ChildModel, completionHandler: @escaping (Result<String, APIError>) -> Void){
        
        let headers: HTTPHeaders = [.contentType("application/json")]
        
        AF.request(add_Child_url, method: .post, parameters: regData, encoder: JSONParameterEncoder.default, headers: headers).response { response in
            debugPrint(response)
            switch response.result {
            case .success( _):
                guard let statusCode = (response.response?.statusCode) else {return}
                if statusCode == 200 {
                    completionHandler(.success("Child registered successfully"))
                } else {
                    completionHandler(.failure(.custom(message: "Failed to register child")))
                }
            case .failure(let err):
                print(err.localizedDescription)
                completionHandler(.failure(.custom(message: "Failed to register child")))
            }
        }
    }

    
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


