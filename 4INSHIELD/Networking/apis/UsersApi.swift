//
//  UsersApi.swift
//  4INSHIELD
//
//  Created by Mohamed Abbes on 6/7/2023.
//

import Foundation
import Alamofire


protocol UsersAPIProrotocol {
    func getToxicPersons(forPerson childID: Int, completion: @escaping (Result<(), NSError>) -> Void)
    func getConcernedRelationship(childID: Int, completion: @escaping (Result<Void, NSError>) -> Void)
    func fetchScore(platform: String, childID: Int, startDateTimestamp: Int, endDateTimestamp: Int, completion: @escaping (Result<Void, NSError>) -> Void)
    func getPlatforms(childID: Int, completion: @escaping (Result<Void, NSError>) -> Void)
    func getMaxScorePerDate(childID: Int, startDateTimestamp: TimeInterval, endDateTimestamp: TimeInterval, completion: @escaping ([String: Int]?) -> Void)
    func getMentalState(childID: Int, startDateTimestamp: TimeInterval, endDateTimestamp: TimeInterval, completion: @escaping ([State]?) -> Void)
    func getScore(completion: @escaping (Score?) -> Void)
    func updateUserInfo(withuserName userName: String, updateData: [String:Any], completion: @escaping(Result<User, Error>) -> Void)
    func getCurrentUserData(username: String ,completion: @escaping(User) -> Void)
    func deleteSocialProfile(profileID: Int, onSuccess: @escaping() -> Void, onError: @escaping(Error?) -> Void)
    func updateChild(withID childID: Int, childData: [String:Any], completion: @escaping(Child) -> Void)
    func getCurrentChildProfiles(withID childID: Int, completion: @escaping([Profile]) -> Void)
    func getChild(withID childID: Int ,completion: @escaping(Child) -> Void)
    func deleteDevice(deviceID: Int)
    func deleteChild(withID childID: Int)
    func resetPassword(withEmail: String, newPassword: String, completion: @escaping(Bool) -> Void)
    func postVerifyOTPCode(email: String, codeOTP: String, completion: @escaping(Bool) -> Void)
    func getUsers(completion: @escaping([User]) -> Void)
    func postGenerateOTPActivationCode(email: String, completion: @escaping(Bool) -> Void)
    func getCurrentUserChildren(username: String, completion: @escaping ([Child]) -> Void)
    func putSetOnboardingSimpleTrue(forUsername username: String, completion: @escaping (Result<Any?, Error>) -> Void)
    func getUserOnboardingStatus(withUserName: String, completion: @escaping (Bool?) -> Void)
    func getLastregistredChildID(withUsername: String, completion: @escaping(Int) -> Void)
    func addSocialMediaProfile(socialData: Profil, completionHandler: @escaping (Result<String, APIErrors>) -> Void)
    func getUserWizardStep(withUserName: String, completion: @escaping(Int) -> Void)
    func saveUserJourney(journeyData: UserJourney, completionHandler: @escaping (UserJourney) -> Void)
    func addChildInfos(regData: ChildModel, completionHandler: @escaping (Result<String, APIErrors>) -> Void)
    func postRegisterAPI(register: RegisterModel, completionHandler: @escaping (Bool, String) -> ())
    func postLoginAPI(login: LoginModel, completionHandler: @escaping (Result<LoginResponse?, NSError>, String) -> Void)
    func postVerifyOTPActivationCode(codeOTP: String, completionHandler: @escaping (Result<String, APIErrors>) -> Void)
    func postActivateAccount(completionHandler: @escaping (Result<Bool, APIErrors>) -> Void)


}

class UsersAPI: BaseAPI<usersNetworking>,UsersAPIProrotocol {
    func getMaxScorePerDate(childID: Int, startDateTimestamp: TimeInterval, endDateTimestamp: TimeInterval, completion: @escaping ([String : Int]?) -> Void) {
        
    }
    
    func getMentalState(childID: Int, startDateTimestamp: TimeInterval, endDateTimestamp: TimeInterval, completion: @escaping ([State]?) -> Void) {
        
    }
    
    func getScore(completion: @escaping (Score?) -> Void) {
        
    }
    
    func updateUserInfo(withuserName userName: String, updateData: [String : Any], completion: @escaping (Result<User, Error>) -> Void) {
        
    }
    
    func getCurrentUserData(username: String, completion: @escaping (User) -> Void) {
        
    }
    
    func updateChild(withID childID: Int, childData: [String : Any], completion: @escaping (Child) -> Void) {
        
    }
    
    func getCurrentChildProfiles(withID childID: Int, completion: @escaping ([Profile]) -> Void) {
        
    }
    
    func getChild(withID childID: Int, completion: @escaping (Child) -> Void) {
        
    }
    
    func deleteDevice(deviceID: Int) {
        
    }
    
    func deleteChild(withID childID: Int) {
        
    }
    
    func resetPassword(withEmail: String, newPassword: String, completion: @escaping (Bool) -> Void) {
        
    }
    
    func postVerifyOTPCode(email: String, codeOTP: String, completion: @escaping (Bool) -> Void) {
        
    }
    
    func getUsers(completion: @escaping ([User]) -> Void) {
        
    }
    
    func postGenerateOTPActivationCode(email: String, completion: @escaping (Bool) -> Void) {
        
    }
    
    func getCurrentUserChildren(username: String, completion: @escaping ([Child]) -> Void) {
        
    }
    
    func putSetOnboardingSimpleTrue(forUsername username: String, completion: @escaping (Result<Any?, Error>) -> Void) {
        
    }
    
    func getUserOnboardingStatus(withUserName: String, completion: @escaping (Bool?) -> Void) {
        completion(false)
    }
    
    func getLastregistredChildID(withUsername: String, completion: @escaping (Int) -> Void) {
        
    }
    
    func addSocialMediaProfile(socialData: Profil, completionHandler: @escaping (Result<String, APIErrors>) -> Void) {
        
    }
    
    func getUserWizardStep(withUserName: String, completion: @escaping (Int) -> Void) {
        
    }
    
    func saveUserJourney(journeyData: UserJourney, completionHandler: @escaping (UserJourney) -> Void) {
        
    }
    
    func addChildInfos(regData: ChildModel, completionHandler: @escaping (Result<String, APIErrors>) -> Void) {
        
    }
    
    func postVerifyOTPActivationCode(codeOTP: String, completionHandler: @escaping (Result<String, APIErrors>) -> Void) {
        
    }
    
    func postActivateAccount(completionHandler: @escaping (Result<Bool, APIErrors>) -> Void) {
        
    }
    
    func getToxicPersons(forPerson childID: Int, completion: @escaping (Result<(), NSError>) -> Void) {
        self.fetchData(target: .getToxicPersons(childID: childID), responseClass: ToxicProfileResponse.self) { (result: Result<ToxicProfileResponse?, NSError>) in
            completion(result.map { _ in () })
        }
    }

    func getConcernedRelationship(childID: Int, completion: @escaping (Result<(), NSError>) -> Void) {
        self.fetchData(target: .getConcernedRelationship(childID: childID), responseClass: ToxicPersons.self) { (result: Result<ToxicPersons?, NSError>) in
            completion(result.map { _ in () })
        }
    }

    func fetchScore(platform: String, childID: Int, startDateTimestamp: Int, endDateTimestamp: Int, completion: @escaping (Result<(), NSError>) -> Void) {
        self.fetchData(target: .fetchScore(platform: platform, childID: childID, startDateTimestamp: startDateTimestamp, endDateTimestamp: endDateTimestamp), responseClass: ScoreResponse.self) { (result: Result<ScoreResponse?, NSError>) in
            completion(result.map { _ in () })
        }
    }

    func getPlatforms(childID: Int, completion: @escaping (Result<(), NSError>) -> Void) {
        self.fetchData(target: .getPlatforms(childID: childID), responseClass: Platform.self) { (result: Result<Platform?, NSError>) in
            completion(result.map { _ in () })
        }
    }

//    func getMaxScorePerDate(childID: Int, startDateTimestamp: TimeInterval, endDateTimestamp: TimeInterval, completion: @escaping ([String: Int]?) -> Void) {
//        self.fetchData(target: .getMaxScorePerDate(childID: childID, startDateTimestamp: startDateTimestamp, endDateTimestamp: endDateTimestamp), responseClass: decode([String: Int].self, from: data)) { (result) in
//            completion(result)
//        }
//    }
//
//    func getMentalState(childID: Int, startDateTimestamp: TimeInterval, endDateTimestamp: TimeInterval, completion: @escaping ([State]?) -> Void) {
//        self.fetchData(target: .getMentalState(childID: childID, startDateTimestamp: startDateTimestamp, endDateTimestamp: endDateTimestamp), responseClass: decode([State].self, from: data)) { (result) in
//            completion(result)
//        }
//    }


    func getScore(completion: @escaping (Result<Score?, NSError>) -> Void){
        self.fetchData(target: .getScore, responseClass: Score.self){(result) in
            completion(result)
        }
    }
    func updateUserInfo(withuserName userName: String, updateData: [String:Any], completion: @escaping(Result<User?, NSError>) -> Void) {
        self.fetchData(target: .updateUserInfo(userName: userName, updateData: updateData), responseClass: User.self){(result) in
            completion(result)
        }
    }
    func getCurrentUserData(username: String ,completion: @escaping(Result<User?, NSError>) -> Void) {
        self.fetchData(target: .getCurrentUserData(username: username), responseClass: User.self){(result) in
            completion(result)
        }
    }
    func deleteSocialProfile(profileID: Int, onSuccess: @escaping() -> Void, onError: @escaping(Error?) -> Void) {
        self.fetchData(target: .deleteSocialProfile(profileID: profileID), responseClass: User.self ){(result) in
            onSuccess()
        }
    }
    func updateChild(withID childID: Int, childData: [String:Any], completion: @escaping(Result<Child?, NSError>) -> Void) {
        self.fetchData(target: .updateChild(childID: childID, childData: childData), responseClass: Child.self){(result) in
            completion(result)
        }
    }
//    func getCurrentChildProfiles(withID childID: Int, completion: @escaping([Profile]) -> Void) {
//        self.fetchData(target: .getCurrentChildProfiles(childID: childID), responseClass: JSONDecoder().decode([Profile].self, from: jsonData)){(result.toxicRelationships) in
//            completion(result.toxicRelationships)
//        }
//    }
    
    func getChild(withID childID: Int ,completion: @escaping(Result<Child?, NSError>) -> Void) {
        self.fetchData(target: .getChild(childID: childID), responseClass: Child.self){(result) in
            completion(result)
        }
    }
//    func deleteDevice(deviceID: Int) {
//        self.fetchData(target: .deleteDevice(deviceID: deviceID), responseClass: nil){(result) in
//
//        }
//    }
//    func deleteChild(withID childID: Int) {
//        self.fetchData(target: .deleteChild, responseClass: ""){(result) in
//            completion(result)
//
//        guard let savedDeviceID = UserDefaults.standard.value(forKey: "savedDeviceID") as? Int else { return }
//        self.deleteDevice(deviceID: savedDeviceID)
//
//        // Remove savedDeviceID from UserDefaults after deleting the device
//        UserDefaults.standard.removeObject(forKey: "savedDeviceID")
//        }
//    }
//    func resetPassword(withEmail: String, newPassword: String, completion: @escaping(Bool) -> Void) {
//        self.fetchData(target: .resetPassword, responseClass: ""){(result) in
//            completion(result)
//        }
//    }
//    func postVerifyOTPCode(email: String, codeOTP: String, completion: @escaping(Bool) -> Void){
//        self.fetchData(target: .postVerifyOTPCode, responseClass: JSONParameterEncoder.default){(result) in
//            completion(result)
//        }
//    }
//    func getUsers(completion: @escaping([User]) -> Void) {
//        self.fetchData(target: .getUsers, responseClass: JSONDecoder().decode([User].self, from: response.data!)){(result) in
//            completion(result)
//        }
//    }
//    func postGenerateOTPActivationCode(email: String, completion: @escaping(Bool) -> Void) {
//        self.fetchData(target: .postGenerateOTPActivationCode, responseClass: ""){(result) in
//            completion(result)
//        }
//    }
//    func getCurrentUserChildren(username: String, completion: @escaping ([Child]) -> Void) {
//        self.fetchData(target: .getCurrentUserChildren, responseClass: JSONDecoder().decode([Child].self, from: response.data!)){(result) in
//            completion(result)
//        }
//    }
//    func putSetOnboardingSimpleTrue(forUsername username: String, completion: @escaping (Result<Any?, Error>) -> Void) {
//     self.fetchData(target: .putSetOnboardingSimpleTrue, responseClass: ""){(result) in
//            completion(result)
//        }
//    }
//    func getUserOnboardingStatus(withUserName: String, completion: @escaping (Bool?) -> Void) {
//          self.fetchData(target: .getUserOnboardingStatus, responseClass: responseDecodable(of: [String: Bool].self)){(result) in
//            completion(result)
//        }
//    }
//    func getLastregistredChildID(withUsername: String, completion: @escaping(Int) -> Void) {
//        self.fetchData(target: .getLastregistredChildID, responseClass: JSONDecoder().decode([Child].self, from: data)){(result) in
//            completion(result)
//        }
//    }
//    func addSocialMediaProfile(socialData: Profil, completionHandler: @escaping (Result<String, APIError>) -> Void) {
//        self.fetchData(target: .addSocialMediaProfile, responseClass: JSONDecoder().decode(Profil.self), from: response.data!){(result) in
//            completion(result)
//        }
//    }
//    func getUserWizardStep(withUserName: String, completion: @escaping(Int) -> Void) {
//        self.fetchData(target: .getUserWizardStep, responseClass: JSONDecoder().decode([UserJourney].self)){(result) in
//            completion(result)
//        }
//    }
//    func saveUserJourney(journeyData: UserJourney, completionHandler: @escaping (UserJourney) -> Void) {
//            self.fetchData(target: .saveUserJourney, responseClass: JSONDecoder().decode([UserJourney].self)){(result) in
//            completion(result)
//        }
//    }
//    func addChildInfos(regData: ChildModel, completionHandler: @escaping (Result<String, APIError>) -> Void){
//        self.fetchData(target: .addChildInfos, responseClass: ""){(result) in
//            completion(result)
//        }
//    }
    func postRegisterAPI(register: RegisterModel, completionHandler: @escaping (Bool, String) -> ()){
        self.fetchData(target: .postRegisterAPI(register: register), responseClass: Bool.self){(result) in
            completionHandler(true, "")
        }
    }
    func postLoginAPI(login: LoginModel, completionHandler:  @escaping (Result<LoginResponse?, NSError>, String) -> ()) {
        self.fetchData(target: .postLoginAPI(login: login), responseClass: LoginResponse.self) { (result) in
            completionHandler(result, NSError.description())
            
        }
    }

    func postVerifyOTPActivationCode(codeOTP: String, completionHandler: @escaping (Result<EmptyResponse?, NSError>) -> Void) {
        self.fetchData(target: .postVerifyOTPActivationCode(codeOTP: codeOTP), responseClass: EmptyResponse.self){(result) in
            completionHandler(result)
        }
    }
    func postActivateAccount(completionHandler: @escaping (Result<Bool?, NSError>) -> Void) {
        self.fetchData(target: .postActivateAccount, responseClass: Bool.self){(result) in
            return completionHandler(result)
        }
    }


}
struct EmptyResponse: Decodable {}


