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
    case decodingError
    case serverError
    case networkError
    case parsingError
    case statusCodeError(message: String, statusCode: Int?)
}
enum CustomError: Error {
    case missingKey(String)
    case decodingError(Error)
    case unknownError
}
typealias handler = (Swift.Result<Any?, APIErrors>) -> Void

class APIManager {
    static let shareInstance = APIManager()
    
    func deleteUser(forUsername username: String, completion: @escaping (Result<Void, Error>) -> Void) {
         let childURL = "\(BuildConfiguration.shared.WEBERVSER_BASE_URL)/api/childs/\(username)/"
         
         AF.request(childURL, method: .delete).response { response in
             switch response.result {
             case .success:
                 print("User deleted successfully")
                 completion(.success(()))
             case .failure(let error):
                 print("Error: \(error.localizedDescription)")
                 completion(.failure(error))
             }
         }
     }
    
    func sendContactForm(contactForm: ContactForm, completionHandler: @escaping (Bool, String) -> ()) {
        let userID = UserDefaults.standard.object(forKey: "userID")

        let completeContactForm = ContactForm(id_user: userID as! Int, subject: contactForm.subject, message: contactForm.message, username: contactForm.username, email: contactForm.email)
        
        AF.request(contactFormURL, method: .post, parameters: completeContactForm, encoder: JSONParameterEncoder.default)
            .response { response in
                switch response.result {
                case .success(_):
                    if (200..<300).contains(response.response?.statusCode ?? 0) {
                        completionHandler(true, "Message sent successfully")
                    } else  {
                        completionHandler(false, "error: \(String(describing: response.error?.localizedDescription))")
                    }
                case .failure(let error):
                    print("Error: \(error)")
                    completionHandler(false, "error: \(error.localizedDescription)")
                }
            }
    }

    func fetchToxicPersons(forPerson childID: Int, completion: @escaping ([String]?) -> Void) {
        var toxicPseudos: [String]?
        let fetchToxicPersonsURL = "\(BuildConfiguration.shared.MLENGINE_BASE_URL)/api/data/count/concerned-relationship/?person_id=\(childID)&rule_name=toxicity_rule"
        
        AF.request(fetchToxicPersonsURL, method: .get).response { response in
            switch response.result {
            case .success:
                if let data = response.data {
                    do {
                        let result = try JSONDecoder().decode(ToxicProfileResponse.self, from: data)
                        toxicPseudos = result.profiles.flatMap { $0.toxicRelationships.map { $0.toxicProfilePseudo } }
                        completion(toxicPseudos)
                    } catch let error as NSError {
                        print("Error decoding JSON: \(error.localizedDescription)")
                        completion(nil)
                    }
                } else {
                    print("No data received")
                    completion(nil)
                }
            case .failure(let error):
                print("Error fetching toxic persons: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }
    
    func fetchProfileImageURL(forUsername username: String, completion: @escaping (URL?) -> Void) {
        let fetchProfileImageURL = "\(BuildConfiguration.shared.CRAWLSERVER_BASE_URL)/api/user-profile/?username=\(username)"
        
        AF.request(fetchProfileImageURL, method: .get).response { response in
            switch response.result {
            case .success:
                if let urlString = response.data.flatMap({ String(data: $0, encoding: .utf8) }) {
                    if let imageURL = URL(string: urlString) {
                        completion(imageURL)
                    } else {
                        print("Invalid image URL")
                        completion(nil)
                    }
                } else {
                    print("No data received")
                    completion(nil)
                }
            case .failure(let error):
                print("Error fetching images: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }
    
    
    func fetchConcernedRelationship(forPerson childID: Int, completion: @escaping (Int?) -> Void) {
        var concernedRelationship: Int?
        let fetchConcernedRelationshipURL = "\(BuildConfiguration.shared.MLENGINE_BASE_URL)/api/count/concerned-relationship/?person_id=\(childID)&rule_name=toxicity_rule"
        
        AF.request(fetchConcernedRelationshipURL, method: .get).response { response in
//            print(response.data!)
            switch response.result {
            case .success:
                if let data = response.data {
                    do {
                        let result = try JSONDecoder().decode(ToxicPersons.self, from: data)
                        concernedRelationship = result.toxicRelationships
                        completion(concernedRelationship)
                    } catch let error as NSError {
                        print("Error decoding JSON: \(error.localizedDescription)")
                        completion(nil)
                    }
                } else {
                    print("No data received")
                    completion(nil)
                }
            case .failure(let error):
                print("Error fetching concerned relationship: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }
    func fetchScore(forPlatform platform: String, childID: Int, startDateTimestamp: Int, endDateTimestamp: Int, completion: @escaping (Int?) -> Void) {
        let urlString = "\(BuildConfiguration.shared.MLENGINE_BASE_URL)/api/score/plateform/per_date/"
        let parameters: [String: Any] = [
            "person_id": childID,
            "from_date_timestamp": startDateTimestamp,
            "to_date_timestamp": endDateTimestamp,
            "rule_name": "toxicity_rule",
            "plateform_name": platform
        ]
        
        AF.request(urlString, method: .get, parameters: parameters).responseDecodable(of: ScoreResponse.self) { response in
            if let statusCode = response.response?.statusCode, statusCode == 500 {
                completion(nil) // Server error, return nil
            } else {
                switch response.result {
                case .success(let scoreResponse):
                    // Extract the global score from the response
                    let globalScore = scoreResponse.globalScore
                    completion(Int(globalScore))
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    completion(nil)
                }
            }
        }
    }
    
    func fetchScorePlatform(childID: Int, startDateTimestamp: Int, endDateTimestamp: Int, completion: @escaping (ScorePlateform?) -> Void) {
        let baseURL = BuildConfiguration.shared.MLENGINE_BASE_URL
        let endpoint = "/api/score/max-score-platform/per-date/"
        let urlString = baseURL + endpoint
        
        let parameters: [String: Any] = [
            "person_id": childID,
            "from_date_timestamp": startDateTimestamp,
            "to_date_timestamp": endDateTimestamp,
            "rule_name": "toxicity_rule"
        ]
        
        AF.request(urlString, method: .get, parameters: parameters, encoding: URLEncoding.queryString).response { response in
            debugPrint(response)
            switch response.result {
            case .success(let data):
                print("API response data:", data)
                
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let scorePlateform = try decoder.decode(ScorePlateform.self, from: data)
                        let score = scorePlateform // Assurez-vous que scorePlateform est bien de type scorePlateform
                        print("Decoded scoreResponse:", score)
                        completion(score)
                    } catch {
                        print("Error decoding data:", error)
                        completion(nil)
                    }
                } else {
                    completion(nil)
                }
            case .failure(let error):
                print("Error fetching data: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }
    
    func fetchPlatforms(forPerson childID: Int, completion: @escaping (Platform?) -> Void) {
        var platforms: Platform?
        let fetchPlatformsURL = "\(BuildConfiguration.shared.MLENGINE_BASE_URL)/api/person/platforms/?person_id=\(childID)"
        
        AF.request(fetchPlatformsURL, method: .get).response { response in
            print(response.data)
            switch response.result {
            case .success:
                do {
                    platforms = try JSONDecoder().decode(Platform.self, from: response.data!)
                    completion(platforms)
                } catch let error as NSError {
                    print("Error: \(error.localizedDescription)")
                    completion(nil)
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }
    
//    func getMaxScorePerDate(childID: Int, startDateTimestamp: TimeInterval, endDateTimestamp: TimeInterval, completion: @escaping ([String: Int]?) -> Void) {
//        let url = "\(BuildConfiguration.shared.MLENGINE_BASE_URL)/api/score/max-score-platform/per-date/\(startDateTimestamp)/\(endDateTimestamp)/\(childID)/toxicity_rule"
//        
//        AF.request(url, method: .get).response { response in
//            switch response.result {
//            case .success(let data):
//                if let data = data, let maxScoreData = try? JSONDecoder().decode([String: Int].self, from: data) {
//                    completion(maxScoreData)
//                } else {
//                    completion(nil)
//                }
//            case .failure(let error):
//                print("Error fetching maximum score data: \(error.localizedDescription)")
//                completion(nil)
//            }
//        }
//    }
    
    func getMentalStateForChart(childID: Int, startDateTimestamp: TimeInterval, endDateTimestamp: TimeInterval, completion: @escaping (State?) -> Void) {
        let mentalStateURL = "\(BuildConfiguration.shared.DEVICESERVER_BASE_URL)/api/mentalstateView/?child_id=\(childID)&start_date=\(startDateTimestamp)&end_date=\(endDateTimestamp)"
        
        AF.request(mentalStateURL, method: .get).response { response in
            switch response.result {
            case .success(let data):
                print("API response data:", data)
                
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let state = try decoder.decode(State.self, from: data)
                        print("Decoded state:", state)
                        completion(state)
                    } catch {
                        print("Error decoding data:", error)
                        completion(nil)
                    }
                } else {
                    completion(nil)
                }
            case .failure(let error):
                print("Error fetching data: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }
  
    func getMentalState(childID: Int, startDateTimestamp: TimeInterval, endDateTimestamp: TimeInterval, completion: @escaping (State?) -> Void) {
           let mentalStateURL = "\(BuildConfiguration.shared.DEVICESERVER_BASE_URL)api/mentalstateView/?child_id=\(childID)"
           
           AF.request(mentalStateURL, method: .get).response { response in
               debugPrint(response)
               switch response.result {
               case .success(let data):
                   print("API response data:", data)
                   
                   if let data = data {
                       do {
                           let decoder = JSONDecoder()
                           let state = try decoder.decode(State.self, from: data)
                           let states = state
                           print("Decoded states:", states)
                           completion(states)
                       } catch {
                           print("Error decoding data:", error)
                           completion(nil)
                       }
                   } else {
                       completion(nil)
                   }
               case .failure(let error):
                   print("Error fetching data: \(error.localizedDescription)")
                   completion(nil)
               }
           }
       }
    
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
    
    func fetchCurrentChildData(username: String, completion: @escaping (Userr?, Error?) -> Void) {
        let child_info_url = "\(BuildConfiguration.shared.WEBERVSER_BASE_URL)/api/users/\(username)"
        AF.request(child_info_url, method: .get).response { response in
            switch response.result {
            case .success(let data):
                do {
                    let user = try JSONDecoder().decode(Userr.self, from: data!)
                    completion(user, nil)
                } catch let error {
                    print("Failed to load: \(error.localizedDescription)")
                    completion(nil, error)
                }
            case .failure(let error):
                print("Error getting child data: \(error.localizedDescription)")
                completion(nil, error)
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
    
    func updateChild(withID childID: Int, childData: [String: Any], completion: @escaping (Childd) -> Void) {
        var child: Childd?

        let serverURL = "\(BuildConfiguration.shared.WEBERVSER_BASE_URL)/api/childs/\(childID)/"
        AF.request(serverURL, method: .put, parameters: childData).response { response in
            switch response.result {
            case .success:
                if let data = response.data {
                    do {
                        let jsonDecoder = JSONDecoder()
                        let topLevelResponse = try jsonDecoder.decode(TopLevelResponse.self, from: data)
                        if let updatedChild = topLevelResponse.child {
                            completion(updatedChild)
                            print("Your child information has been successfully updated")
                        } else {
                            print("Failed to decode child information from response")
                        }
                    } catch {
                        print("Failed to decode response: \(error)")
                    }
                } else {
                    print("Empty response data")
                }
            case .failure(let error):
                print("Error updating child info: \(error.localizedDescription)")
            }
        }
    }
    
    func uploadChildPic(withID roleId: Int, photo: UIImage) {
        let uploadPic_url = "\(BuildConfiguration.shared.WEBERVSER_BASE_URL)/api/childs/\(roleId)/upload_photo/"
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
    
    func uploadParentChildPic(withUser username: String, photo: UIImage) {
        let uploadPic_url = "\(BuildConfiguration.shared.WEBERVSER_BASE_URL)/api/users/\(username)/upload_photo/"
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
                debugPrint("Your user profile picture has been successfully updated")
                break
            case .failure(let err):
                debugPrint("Error while updating the user profile picte ", err.localizedDescription)
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
    
    
    func fetchChild(withID childID: Int ,completion: @escaping(Childd) -> Void) {
        var child: Childd?
        let fetch_child_url = "\(BuildConfiguration.shared.WEBERVSER_BASE_URL)/api/childs/\(childID)/"
        AF.request(fetch_child_url, method: .get).response
        {
            response in switch response.result {
            case .success( _):
                do {
                    child = try JSONDecoder().decode(Childd.self, from: response.data!)
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
        AF.request(generate_newOtp_url, method: .post, parameters: data, encoding: JSONEncoding.default).response { response in
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

    func fetchCurrentUserChildren(username: String, completion: @escaping ([Childd]) -> Void) {
        let serverURL = "\(BuildConfiguration.shared.WEBERVSER_BASE_URL)/api/users/\(username)/childs/"
        AF.request(serverURL, method: .get).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let childrenResponse = try JSONDecoder().decode([Childd].self, from: data)
                    print("Successfully decoded children")
                    completion(childrenResponse)
                } catch {
                    print("Failed to decode children: \(error)")
                    completion([])
                }
            case .failure(let error):
                print("Error getting children list: \(error.localizedDescription)")
                completion([])
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
        
        AF.request(onboarding_url, method: .get).responseDecodable(of: User.self) { response in
            switch response.result {
            case .success(let user):
                let onboardingSimple = user.onboarding_simple
                let roleDataID = user.role_data.id
                print(roleDataID)
                UserDefaults.standard.set(roleDataID, forKey: "RoleDataID")
                completion(onboardingSimple)
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                completion(nil)
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

    func registerAPI(register: RegisterModel, completionHandler: @escaping (Bool, String) -> ()) {
        let headers: HTTPHeaders = [
            .contentType("application/json")
        ]
        
        AF.request(register_url, method: .post, parameters: register, encoder: JSONParameterEncoder.default, headers: headers)
            .response { response in
                print(String(data: response.data ?? Data(), encoding: .utf8) ?? "")
                switch response.result {
                case .success:
                    if (200..<300).contains(response.response?.statusCode ?? 0) {
                        var successMessage = "success_signUp"
                        if LanguageManager.shared.currentLanguage == "fr" {
                            successMessage = "L'inscription a été effectuée avec succès !Veuillez vérifier votre e-mail d'inscription pour le lien d'activation."
                        } else {
                            successMessage = "Registration completed successfully! Please check your registered email for the activation link."
                        }
                        completionHandler(true, successMessage)
                    } else {
                        var errorMessage = "registration_failure_message"
                        if LanguageManager.shared.currentLanguage == "fr" {
                            errorMessage = "Les données sont introuvables."
                        } else {
                            errorMessage = "Data not found."
                        }
                        completionHandler(false, errorMessage)
                    }
                case .failure(let error):
                    if let statusCode = response.response?.statusCode {
                        if statusCode >= 500 {
                            if let data = response.data, let serverErrorString = String(data: data, encoding: .utf8) {
                                completionHandler(false, serverErrorString)
                            } else {
                                var errorMessage = "error_server"
                                if LanguageManager.shared.currentLanguage == "fr" {
                                    errorMessage = "Erreur serveur. Veuillez réessayer plus tard."
                                } else {
                                    errorMessage = "Server error. Please try again later."
                                }
                                completionHandler(false, errorMessage)
                            }
                        } else {
                            var errorMessage = "network_error_message"
                            if LanguageManager.shared.currentLanguage == "fr" {
                                errorMessage = "Une erreur de réseau est survenue."
                            } else {
                                errorMessage = "A network error occurred. Check your internet connection."
                            }
                            completionHandler(false, errorMessage)
                        }
                    } else {
                        var errorMessage = "unknown_error_message"
                        if LanguageManager.shared.currentLanguage == "fr" {
                            errorMessage = "Une erreur s'est produite. Veuillez réessayer."
                        } else {
                            errorMessage = "An error occurred. Please try again."
                        }
                        completionHandler(false, errorMessage)
                    }
                    print("error: \(error.localizedDescription)")
                }
            }
    }

    //AF.request(register_url, method: .post, parameters: register, encoder: JSONParameterEncoder.default, headers: headers).response {  response in
    //           // debugPrint(response)
    //            switch response.result {
    //                case.success(let data):
    //                   do {
    //                    let json = try JSONSerialization.jsonObject(with: data!, options: [])
    //                       if (200..<300).contains(response.response!.statusCode)  {
    //                         //  print(data)
    ////                     let parentId = String(data.parent.id)
    ////                      print(parentId)
    //                       completionHandler(true, "user registered successfully")
    //
    //                    }else {
    //                        completionHandler(false, "try again!")
    //                    }
    //                }catch{
    //                    print(error.localizedDescription)
    //                    completionHandler(false, "try again!")
    //                }
    //            case.failure(let err):
    //                print(err.localizedDescription)
    //                completionHandler(false, "try again!")
    //            }
    //
    //        }
    
    func registerChildAPI(parameters: [String: Any], completionHandler: @escaping (Bool, String) -> ()) {
        let headers: HTTPHeaders = [
            .contentType("application/json")
        ]
        
        AF.request(register_url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .response { response in
                print(String(data: response.data ?? Data(), encoding: .utf8) ?? "")
                switch response.result {
                case .success:
                    if (200..<300).contains(response.response?.statusCode ?? 0) {
                        var successMessage = ""
                        if LanguageManager.shared.currentLanguage == "fr" {
                            successMessage = "L'inscription a été effectuée avec succès ! Veuillez vérifier votre e-mail d'inscription pour le lien d'activation."
                        } else {
                            successMessage = "Registration completed successfully! Please check your registered email for the activation link."
                        }
                        completionHandler(true, successMessage)
                    } else {
                        var errorMessage = ""
                        if LanguageManager.shared.currentLanguage == "fr" {
                            errorMessage = "Les données sont introuvables."
                        } else {
                            errorMessage = "Data not found."
                        }
                        completionHandler(false, errorMessage)
                    }
                case .failure(let error):
                    var errorMessage = ""
                    if let statusCode = response.response?.statusCode {
                        if statusCode >= 500 {
                            if let data = response.data, let serverErrorString = String(data: data, encoding: .utf8) {
                                completionHandler(false, serverErrorString)
                            } else {
                                if LanguageManager.shared.currentLanguage == "fr" {
                                    errorMessage = "Erreur serveur. Veuillez réessayer plus tard."
                                } else {
                                    errorMessage = "Server error. Please try again later."
                                }
                                completionHandler(false, errorMessage)
                            }
                        } else {
                            if LanguageManager.shared.currentLanguage == "fr" {
                                errorMessage = "Une erreur de réseau est survenue."
                            } else {
                                errorMessage = "A network error occurred. Check your internet connection."
                            }
                            completionHandler(false, errorMessage)
                        }
                    } else {
                        if LanguageManager.shared.currentLanguage == "fr" {
                            errorMessage = "Une erreur s'est produite. Veuillez réessayer."
                        } else {
                            errorMessage = "An error occurred. Please try again."
                        }
                        completionHandler(false, errorMessage)
                    }
                    print("error: \(error.localizedDescription)")
                }
            }
    }
    
//    func registerChildAPI(register: ChildRegisterModel, completionHandler: @escaping (Bool, String) -> ()) {
//
//        AF.request(register_url, method: .post,  parameters: register).response { response in
//            switch response.result {
//            case .success(let data):
//                do {
//                    if (200..<300).contains(response.response!.statusCode) {
//                        completionHandler(true, "Child user registered successfully")
//                    } else {
//                        completionHandler(false, "Try again!")
//                    }
//                } catch {
//                    print(error.localizedDescription)
//                    completionHandler(false, "Try again!")
//                }
//            case .failure(let err):
//                print(err.localizedDescription)
//                completionHandler(false, "Try again!")
//            }
//        }
//    }
    
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
                    if response.response?.statusCode == 200 || response.response?.statusCode == 201 {
                        completionHandler(.success(json))
                    }else {
                        completionHandler(.failure(.custom(message: "Your email is not verified! Please verify your email address.")))
                    }
                }catch{
                    print(error.localizedDescription)
                    completionHandler(.failure(.custom(message: "Try kkkkkkkkk")))
                }
            case.failure(let error):
                if let statusCode = response.response?.statusCode {                           // Appel du completionHandler avec l'erreur d'Alamofire et le code de statut HTTP
                           completionHandler(.failure(.statusCodeError(message: error.localizedDescription, statusCode: statusCode)))
                       } else {
                           completionHandler(.failure(.networkError))
                       }
               
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
                    print("code valide")
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
}
    struct ErrorResponse: Decodable {
        let message: String
        let statuCode : Int?
    }
    enum APIError: Error {
        case custom(message: String)
        case decodingError
        case serverError
        case networkError
        case parsingError
        case statusCodeError(message: String, statusCode: Int?)
    }
    

