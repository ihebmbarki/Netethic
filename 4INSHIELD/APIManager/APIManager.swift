//
//  APIManager.swift
//  4INSHIELD
//
//  Created by iheb mbarki on 28/2/2023.
//

import Foundation
import Alamofire
import UIKit

enum APIErrors: Error {
    case custom(message: String)
}
enum CustomError: Error {
    case missingKey(String)
    case decodingError(Error)
    case unknownError
}
typealias handler = (Swift.Result<Any?, APIErrors>) -> Void

class APIManager {
    static let shareInstance = APIManager()

    func getScore(completion: @escaping (Score?) -> Void) {
        AF.request(user_score, method: .get).response { response in
            switch response.result {
            case .success(let data):
                if let score = try? JSONDecoder().decode(Score.self, from: data!) {
                    completion(score)
                } else {
                    completion(nil)
                }
            case .failure(let error):
                print("Error getting score: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }
    
    func updateUserInfo(withuserName userName: String, updateData: [String:Any], completion: @escaping(Result<User, Error>) -> Void) {
        let update_user_info = "\(BuildConfiguration.shared.WEBERVSER_BASE_URL)/api/users/\(userName)/"
        AF.request(update_user_info, method: .patch, parameters: updateData).response { response in
            switch response.result {
            case .success(let data):
                do {
                    let user = try JSONDecoder().decode(User.self, from: data!)
                    completion(.success(user))
                    print("User information has been successfully updated")
                } catch let error as DecodingError {
                    switch error {
                    case .keyNotFound(let key, _):
                        let errorMessage = "Missing key: \(key.stringValue)"
                        completion(.failure(CustomError.missingKey(errorMessage)))
                        print(errorMessage)
                    default:
                        completion(.failure(CustomError.decodingError(error)))
                        print("Failed to decode user data: \(error)")
                    }
                } catch let error {
                    completion(.failure(CustomError.decodingError(error)))
                    print("Failed to decode user data: \(error)")
                }
            case .failure(let error):
                completion(.failure(error))
                print("Error updating profile info: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchCurrentUserData(username: String ,completion: @escaping(User) -> Void) {
        var user: User?
        let user_info_url = "\(BuildConfiguration.shared.WEBERVSER_BASE_URL)/api/users/\(username)"
        AF.request(user_info_url, method: .get).response
        {
            response in switch response.result {
            case .success(let data):
                print("data:", data as Any)
                do {
                    user = try JSONDecoder().decode(User.self, from: response.data!)
                    //print(children)
                } catch let error as NSError {
                    print("Failed to load: \(error.localizedDescription)")
                }
                guard let ussr = user else {return}
                completion(ussr)
            case .failure(let error):
                print("Error geting user data: \(error.localizedDescription)")
            }
        }
    }
    
    func deleteSocialProfile(profileID: Int, onSuccess: @escaping() -> Void, onError: @escaping(Error?) -> Void) {
        let delete_profile_url = "\(BuildConfiguration.shared.WEBERVSER_BASE_URL)/api/profiles/\(profileID)/"
        
        AF.request(delete_profile_url, method: .delete).response
        {
            response in switch response.result {
            case .success( _):
                print("Social profile was successfully deleted")
                onSuccess()
            case .failure(let error):
                onError(error)
                print(error.localizedDescription)
            }
        }
    }
    
    func updateChild(withID childID: Int, childData: [String:Any], completion: @escaping(Child) -> Void) {
        var child: Child?
        
        let serverURL = "\(BuildConfiguration.shared.WEBERVSER_BASE_URL)/api/childs/\(childID)/"
        AF.request(serverURL, method: .put, parameters: childData).response
        {
            response in switch response.result {
            case .success( _):
                do {
                    child = try JSONDecoder().decode(Child.self, from: response.data!)
                    completion(child!)
                    print("Your child information has been successfully updated")
                } catch let error as NSError {
                    debugPrint("Failed to load: \(error.localizedDescription)")
                }
            case .failure(let error):
                print("Error updating child info: \(error.localizedDescription)")
            }
        }
    }
    
    func uploadChildPic(withID childID: Int, photo: UIImage) {
        let uploadPic_url = "\(BuildConfiguration.shared.WEBERVSER_BASE_URL)/api/childs/\(childID)/upload_photo/"
        guard let imageData = photo.jpegData(compressionQuality: 0.50) else {return}
        let headers: HTTPHeaders = [
            "Content-type": "multipart/form-data"
        ]
        AF.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(imageData,
                                         withName: "photo",
                                         fileName: "profilePic.jpeg", mimeType: "image/jpeg"
                )
            },
            to: uploadPic_url,
            method: .post ,
            headers: headers
        )
            .response { response in
                switch response.result {
                case .success(_):
                    debugPrint("Your child profile pic has been successfully updated")
                    break
                case .failure(let err):
                    debugPrint("Error while updating the child profile pic ", err.localizedDescription)
                    break
                }
            }
    }
    
    func deleteChildProfilePic(withID childID: Int) {
        let userData = [
            "id": childID,
            "photo": ""
        ] as [String : Any]
        
        let delete_childPic_url = "\(BuildConfiguration.shared.WEBERVSER_BASE_URL)/api/childs/\(childID)/"
        AF.request(delete_childPic_url, method: .patch, parameters: userData).response
        {
            response in switch response.result {
            case .success( _):
                print("Your child profile's pic has been successfully deleted")
            case .failure(let error):
                print("Error deleting child profile's pic: \(error.localizedDescription)")
            }
        }
    }
    
    func getCurrentChildProfiles(withID childID: Int, completion: @escaping([Profile]) -> Void) {
        var profiles = [Profile]()
        
        let child_profile_url = "\(BuildConfiguration.shared.WEBERVSER_BASE_URL)/api/childs/\(childID)/profiles/"
        print("URL: \(child_profile_url)")
        
        AF.request(child_profile_url, method: .get).responseJSON { response in
            switch response.result {
            case .success(let data):
                if let jsonData = try? JSONSerialization.data(withJSONObject: data) {
                    profiles = try! JSONDecoder().decode([Profile].self, from: jsonData)
                    completion(profiles)
                } else {
                    print("Error: failed to serialize data")
                }
            case .failure(let error):
                if let statusCode = response.response?.statusCode {
                    if statusCode == 404 {
                        print("Error: profile not found")
                    } else {
                        print("Error: \(error.localizedDescription)")
                    }
                } else {
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
    }

    
    func fetchChild(withID childID: Int ,completion: @escaping(Child) -> Void) {
        var child: Child?
        let fetch_child_url = "\(BuildConfiguration.shared.WEBERVSER_BASE_URL)/api/childs/\(childID)/"
        AF.request(fetch_child_url, method: .get).response
        {
            response in switch response.result {
            case .success( _):
                do {
                    child = try JSONDecoder().decode(Child.self, from: response.data!)
                    completion(child!)
                } catch let error as NSError {
                    print("Error: \(error.localizedDescription)")
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func deleteDevice(deviceID: Int) {
        let deleteDevice_url = "\(BuildConfiguration.shared.WEBERVSER_BASE_URL)/api/devices/\(deviceID)/"
        
        AF.request(deleteDevice_url, method: .delete).response
        {
            response in switch response.result {
            case .success( _):
                print("Child device was successfully deleted")
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
     
    func deleteChild(withID childID: Int) {
        
        let child_url = "\(BuildConfiguration.shared.WEBERVSER_BASE_URL)/api/childs/\(childID)/"
        
        AF.request(child_url, method: .delete).response
        {
            response in switch response.result {
            case .success( _):
                print("Child deleted successfully")
                
                guard let savedDeviceID = UserDefaults.standard.value(forKey: "savedDeviceID") as? Int else { return }
                self.deleteDevice(deviceID: savedDeviceID)

                // Remove savedDeviceID from UserDefaults after deleting the device
                UserDefaults.standard.removeObject(forKey: "savedDeviceID")
                
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func resetPassword(withEmail: String, newPassword: String, completion: @escaping(Bool) -> Void) {
        let userData = [
            "email": withEmail,
            "password": newPassword
        ] as [String : Any]
        AF.request(change_pwd_url, method: .patch, parameters: userData).response
        {
            response in switch response.result {
            case .success( _):
                
                guard let statusCode = (response.response?.statusCode) else {return}
                if statusCode == 200 {
                    completion(true)
                }
                else if statusCode == 400 {
                    completion(false)
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func verifyOTPCode(email: String, codeOTP: String, completion: @escaping(Bool) -> Void) {
        let data = [
            "email": email,
            "token": codeOTP
        ]
        AF.request(otp_url, method: .post, parameters: data, encoder: JSONParameterEncoder.default).response { response in
            switch response.result {
            case .success( _):
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
    
    func fetchUsers(completion: @escaping([User]) -> Void) {
        var users = [User]()
        AF.request(onboarding_url, method: .get).response
        {
            response in switch response.result {
            case .success( _):
                do {
                    users = try JSONDecoder().decode([User].self, from: response.data!)
                    completion(users)
                } catch let error as NSError {
                    print("Failed to load: \(error.localizedDescription)")
                }
            case .failure(let error):
                print("Error:\(error.localizedDescription)")
            }
        }
    }
    
    func generateOTPActivationCode(email: String, completion: @escaping(Bool) -> Void) {
        let data = [
            "email": email
        ]
        AF.request(generate_newOtp_url, method: .post, parameters: data).response { response in
            switch response.result {
            case .success( _):
                guard let statusCode = (response.response?.statusCode) else {return}
                if statusCode == 200 {
                    completion(true)
                } else {
                    completion(false)
                }
            case .failure(let err):
                print("Error: \(err.localizedDescription)")
            }
        }
    }
    
    func fetchCurrentUserChildren(username: String, completion: @escaping ([Child]) -> Void) {
        var children = [Child]()
        
        let serverURL = "\(BuildConfiguration.shared.WEBERVSER_BASE_URL)/api/users/\(username)/childs/"
        AF.request(serverURL, method: .get).responseJSON { response in
            switch response.result {
            case .success(let data):
                do {
                    children = try JSONDecoder().decode([Child].self, from: response.data!)
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
        
        AF.request(onboarding_url, method: .get).responseDecodable(of: [String: Bool].self) { response in
            switch response.result {
            case .success(let onboardingDict):
                let onboardingSimple = onboardingDict["onboarding_simple"]
                completion(onboardingSimple)
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
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


