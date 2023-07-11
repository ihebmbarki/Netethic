//
//  UsersNetworking.swift
//  4INSHIELD
//
//  Created by Mohamed Abbes on 6/7/2023.
//

import Foundation
import Alamofire
import UIKit

enum usersNetworking{
    case getToxicPersons(childID: Int)
    case getProfileImageURL(username: String)
    case getConcernedRelationship(childID: Int)
    case fetchScore(platform: String, childID: Int, startDateTimestamp: Int, endDateTimestamp: Int)
    case getPlatforms(childID: Int)
    case getMaxScorePerDate(childID: Int, startDateTimestamp: TimeInterval, endDateTimestamp: TimeInterval)
    case getMentalState(childID: Int, startDateTimestamp: TimeInterval, endDateTimestamp: TimeInterval)
    case getScore
    case updateUserInfo(userName: String, updateData: [String:Any])
    case getCurrentUserData(username: String)
    case deleteSocialProfile(profileID: Int)
    case updateChild(childID: Int, childData: [String:Any])
    case uploadChildPic(childID: Int, photo: UIImage)
    case deleteChildProfilePic(childID: Int)
    case getCurrentChildProfiles(childID: Int)
    case getChild(childID: Int)
    case deleteDevice(deviceID: Int)
    case deleteChild(childID: Int)
    case resetPassword(withEmail: String, newPassword: String)
    case postVerifyOTPCode(email: String, codeOTP: String)
    case getUsers
    case postGenerateOTPActivationCode(email: String)
    case getCurrentUserChildren(username: String)
    case putSetOnboardingSimpleTrue(username: String)
    case getUserOnboardingStatus(withUserName: String)
    case getLastregistredChildID(withUsername: String)
    case addSocialMediaProfile(socialData: Profil)
    case getUserWizardStep(withUserName: String)
    case saveUserJourney(journeyData: UserJourney)
    case addChildInfos(regData: ChildModel)
    case postRegisterAPI(register: RegisterModel)
    case postLoginAPI(login: LoginModel)
    case postVerifyOTPActivationCode(codeOTP: String)
    case postActivateAccount
}

func currentEmail() -> String? {
    guard let email = UserDefaults.standard.string(forKey: "userEmail") else {
        print("User email not found")
        return nil
    }
    
    return email
}


extension usersNetworking: TargetType {


    var baseURL: String{
        switch self {
            case .updateUserInfo, .getCurrentUserData, .deleteSocialProfile, .updateChild, .uploadChildPic,
                 .deleteChildProfilePic, .getCurrentChildProfiles, .getChild, .deleteDevice, .deleteChild, .resetPassword,
                 .postVerifyOTPCode,  .getUsers, .postGenerateOTPActivationCode, .getCurrentUserChildren, .putSetOnboardingSimpleTrue,
                 .getUserOnboardingStatus, .getLastregistredChildID, .addSocialMediaProfile, .getUserWizardStep, .saveUserJourney, .postLoginAPI, .postVerifyOTPActivationCode, .postActivateAccount:
            return BuildConfiguration.shared.WEBERVSER_BASE_URL
            case .getToxicPersons, .getConcernedRelationship, .fetchScore, .getPlatforms, .getMaxScorePerDate:
                return BuildConfiguration.shared.MLENGINE_BASE_URL
            case .getMentalState, .getScore:
                return BuildConfiguration.shared.DEVICESERVER_BASE_URL
            case .getProfileImageURL:
                return BuildConfiguration.shared.CRAWLSERVER_BASE_URL
        case .addChildInfos:
            return BuildConfiguration.shared.WEBERVSER_BASE_URL
        case .postRegisterAPI:
            return BuildConfiguration.shared.WEBERVSER_BASE_URL
        }
    }
    var path: String{
        switch self {
        case .getToxicPersons(childID: let childID):
                    return "/api/data/count/concerned-relationship/?person_id=\(childID)&rule_name=toxicity_rule"
        case .getProfileImageURL(username: let username):
                    return "/api/user-profile/?username=\(username)"
        case .getConcernedRelationship(childID: let childID):
                    return "/api/count/concerned-relationship/?person_id=\(childID)&rule_name=toxicity_rule"
        case .fetchScore:
                    return "/api/score/plateform/per_date/"
        case .getPlatforms(childID: let childID):
                    return "/api/person/platforms/?person_id=\(childID)"
        case .getMaxScorePerDate(childID: let childID, startDateTimestamp: let startDateTimestamp, endDateTimestamp: let endDateTimestamp):
                    return "/api/score/max-score-platform/per-date/\(startDateTimestamp)/\(endDateTimestamp)/\(childID)/toxicity_rule"
        case .getMentalState(childID: let childID, startDateTimestamp: let startDateTimestamp, endDateTimestamp: let endDateTimestamp):
                    return "/api/mentalstateView/?child_id=\(childID)&start_date=\(startDateTimestamp)&end_date=\(endDateTimestamp)"
        case .getScore:
                    return "/score/general/"
        case .updateUserInfo(userName: let userName):
                    return "/api/users/\(userName)/"
        case .getCurrentUserData(username: let username):
                    return "/api/users/\(username)"
        case .deleteSocialProfile(profileID: let profileID):
                    return "/api/profiles/\(profileID)/"
        case .updateChild(childID: let childID):
                    return "/api/childs/\(childID)/"
        case .uploadChildPic(childID: let childID):
                    return "/api/childs/\(childID)/upload_photo/"
        case .deleteChildProfilePic(childID: let childID):
                    return "/api/childs/\(childID)/"
        case .getCurrentChildProfiles(childID: let childID):
                    return "/api/childs/\(childID)/profiles/"
        case .getChild(childID: let childID):
                    return "/api/childs/\(childID)/"
        case .deleteDevice(deviceID: let deviceID):
                    return "/api/devices/\(deviceID)/"
        case .deleteChild(childID: let childID):
                    return "/api/childs/\(childID)/"
        case .resetPassword:
                    return "/auth/change-password/"
        case .postVerifyOTPCode:
                    return "/auth/verify-totp-token/"
        case .getUsers:
                    return "/api/users/"
        case .postGenerateOTPActivationCode:
                    return "/auth/generate-new-totp-token/"
        case .getCurrentUserChildren(username: let username):
                    return "/api/users/\(username)/childs/"
        case .putSetOnboardingSimpleTrue:
                    return "/api/users/onboarding_simple/"
        case .getUserOnboardingStatus(let withUserName):
                    return "/api/users/\(withUserName)/"
        case .getLastregistredChildID(let withUsername):
                    return "/api/users/\(withUsername)/childs/"
        case .addSocialMediaProfile:
                    return "/api/profiles/"
        case .getUserWizardStep(let withUserName):
                    return "/api/users/\(withUserName)/journey/"
        case .saveUserJourney:
                    return "/api/userjourney/"
        case .addChildInfos:
                    return "/api/childs/"
        case .postRegisterAPI:
                    return "/auth/register/"
        case .postLoginAPI:
                    return "/auth/login/"
        case .postVerifyOTPActivationCode:
                    return "/auth/verify-totp-token/"
        case .postActivateAccount:
                    return "/auth/email-verify-app-mobile/"
        }
    }
    var methods: HTTPMethod{
        switch self {
        case .getToxicPersons, .getProfileImageURL, .getConcernedRelationship, .fetchScore, .getPlatforms, .getMaxScorePerDate,
                .getMentalState, .getScore, .getCurrentUserData, .getCurrentChildProfiles, .getChild, .getUsers, .getCurrentUserChildren,
                .getUserOnboardingStatus, .getLastregistredChildID, .getUserWizardStep:
            return .get
        case .updateUserInfo, .deleteChildProfilePic, .resetPassword:
            return .patch
        case .deleteSocialProfile, .deleteDevice, .deleteChild:
            return .delete
        case .updateChild, .putSetOnboardingSimpleTrue, .uploadChildPic:
            return .put
        case .postVerifyOTPCode, .postGenerateOTPActivationCode, .addSocialMediaProfile, .saveUserJourney, .addChildInfos, .postRegisterAPI,
                .postLoginAPI, .postVerifyOTPActivationCode, .postActivateAccount:
            return .post
        }
    }
    var task: Task{
        switch self{
            case .getToxicPersons, .getProfileImageURL, .getConcernedRelationship, .getPlatforms, .getMaxScorePerDate, .getMentalState,
                 .getScore, .getCurrentUserData, .deleteSocialProfile, .getCurrentChildProfiles, .getChild, .deleteDevice, .deleteChild,
                 .getUsers, .getCurrentUserChildren, .getUserOnboardingStatus, .getLastregistredChildID, .addSocialMediaProfile,
                 .getUserWizardStep, .addChildInfos:
                return .requestPlain
        
            case .fetchScore(let platform, let childID, let startDateTimestamp, let endDateTimestamp):
                return .requestParameters(parameters: [ "person_id": childID,
                                                        "from_date_timestamp": startDateTimestamp,
                                                        "to_date_timestamp": endDateTimestamp,
                                                        "rule_name": "toxicity_rule",
                                                        "plateform_name": platform],
                                                                encoding: JSONEncoding.default)
        case .updateUserInfo(_, let updateData):
                return .requestParameters(parameters: updateData,encoding: JSONEncoding.default)
        case .updateChild(_, let childData):
                return .requestParameters(parameters: childData,encoding: JSONEncoding.default)
            case .deleteChildProfilePic(let childID):
                return .requestParameters(parameters: ["id": childID,
                                                        "photo": ""
                                                        ] as [String : Any],
                                                                        encoding: JSONEncoding.default)
            case .resetPassword(let withEmail, let newPassword):
                return .requestParameters(parameters: [ "email": withEmail,
                                                        "password": newPassword
                                                        ] as [String : Any],
                                                                        encoding: JSONEncoding.default)
            case .postVerifyOTPCode(let email, let codeOTP):
                return .requestParameters(parameters: [ "email": email,
                                                        "token": codeOTP],
                                                                        encoding: JSONEncoding.default)
            case .postGenerateOTPActivationCode(let email):
                return .requestParameters(parameters: ["email": email],encoding: JSONEncoding.default)
            case .putSetOnboardingSimpleTrue(let username):
                return .requestParameters(parameters: ["username": username,
                                                        "onboarding_simple": true
                                                        ] as [String : Any],
                                                                        encoding: JSONEncoding.default)
        case .saveUserJourney(let journeyData):
            if let dictionary = try? JSONEncoder().encode(journeyData),
                let parameters = try? JSONSerialization.jsonObject(with: dictionary, options: []) as? [String: Any] {
                return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
            } else {
                return .requestPlain
            }
        case .addChildInfos(let regData):
            if let dictionary = try? JSONEncoder().encode(regData),
                let parameters = try? JSONSerialization.jsonObject(with: dictionary, options: []) as? [String: Any] {
                return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
            } else {
                return .requestPlain
            }

        case .postRegisterAPI(let register):
            if let dictionary = try? JSONEncoder().encode(register),
                let parameters = try? JSONSerialization.jsonObject(with: dictionary, options: []) as? [String: Any] {
                return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
            } else {
                return .requestPlain
            }

        case .postLoginAPI(let login):
            do {
                let jsonData = try JSONEncoder().encode(login)
                let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: [])
                
                if let parameters = jsonObject as? [String: Any] {
                    return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
                }
            } catch {
                print("Error encoding login object: \(error)")
            }
            
            return .requestPlain

               
        case .postVerifyOTPActivationCode(let codeOTP):
            return .requestParameters(parameters: ["email": currentEmail() ?? "",
                                                        "token": codeOTP],
                                                                encoding: JSONEncoding.default)
        case .postActivateAccount:
            return .requestParameters(parameters: ["email": currentEmail() ?? ""],encoding: JSONEncoding.default)
        case .uploadChildPic(childID: _, photo: let photo):
            return .requestParameters(parameters: ["photo":photo], encoding: JSONEncoding.default)
        }
    }
    var headers: [String : String]? {
        switch self{
                case .getToxicPersons, .getProfileImageURL, .getConcernedRelationship, .fetchScore, .getPlatforms, .getMaxScorePerDate,
                     .getMentalState, .getScore, .updateUserInfo, .getCurrentUserData, .deleteSocialProfile, .updateChild,
                     .uploadChildPic, .deleteChildProfilePic, .getCurrentChildProfiles, .getChild, .deleteDevice, .deleteChild,
                     .resetPassword, .postVerifyOTPCode, .getUsers, .postGenerateOTPActivationCode, .getCurrentUserChildren,
                     .putSetOnboardingSimpleTrue, .getUserOnboardingStatus, .getLastregistredChildID, .getUserWizardStep,
                     .saveUserJourney, .postVerifyOTPActivationCode, .postActivateAccount:
            return [:]
                case .addSocialMediaProfile, .addChildInfos, .postRegisterAPI, .postLoginAPI:
                        return ["Content-Type": "application/json"]
        }

    }

   
}
