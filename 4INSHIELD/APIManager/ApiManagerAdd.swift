//
//  ApiManagerAdd.swift
//  4INSHIELD
//
//  Created by kaisensData on 18/7/2023.
//

import Foundation
import Alamofire
import UIKit



class ApiManagerAdd {
    
    static let shareInstance1 = ApiManagerAdd()
    
    func addChildInfos(regData: ChildModel, completionHandler: @escaping (Bool, String) -> Void) {
        let headers: HTTPHeaders = [
            .contentType("application/json")
        ]
        //.responseDecodable(of: UserRole.self)
        AF.request(add_Child_url, method: .post, parameters: regData, encoder: JSONParameterEncoder.default, headers: headers)
            .validate(statusCode: 200..<300).response { response in
                switch response.result {
                case .success(let responseObject):
                    // La réponse a été décodée avec succès
                   // print(responseObject.id)
                   //print(responseObject.username)
                    
                    // Utilisez responseObject et vérifiez si la réponse correspond à vos attentes
                    if (200..<300).contains(response.response?.statusCode ?? 0) {
                        completionHandler(true, "User child registered successfully")
                    } else {
                        completionHandler(false, "Failed to register user child")
                    }
                    
                case .failure(let error):
                    // Une erreur s'est produite lors de la requête ou du décodage
                    if let underlyingError = error.underlyingError as? DecodingError {
                        // Traitez les erreurs de décodage spécifiques ici
                        switch underlyingError {
                        case .typeMismatch(let expectedType, let context):
                            print("Type mismatch: expected \(expectedType), context: \(context)")
                        case .valueNotFound(let valueType, let context):
                            print("Value not found: value type \(valueType), context: \(context)")
                        default:
                            print("Decoding error: \(underlyingError)")
                        }
                        
                        completionHandler(false, "Failed to register user child")
                    } else {
                        // Gérez les autres erreurs ici
                        print("Error: \(error)")
                        completionHandler(false, "Failed to register user child")
                    }
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
        
    func getLastregistredChildID(withUsername: String, completion: @escaping (Int) -> Void) {
        let get_ChildID_url = "\(BuildConfiguration.shared.WEBERVSER_BASE_URL)/api/users/\(withUsername)/childs/"
        
        AF.request(get_ChildID_url, method: .get)
            .responseDecodable(of: [ChildResponseModelElement].self) { response in
                switch response.result {
                case .success(let childs):
                    let sortedChilds = childs.sorted { $0.user.created_at < $1.user.created_at }
                    if let lastChild = sortedChilds.last {
                        completion(lastChild.id)
                    } else {
                        completion(0) // Ajustez cette valeur par défaut si nécessaire
                    }
                case .failure(let error):
                    print("API Error getting child data: \(error)")
                    completion(0) // Ajustez cette valeur par défaut si nécessaire
                }
            }
    }
    
//      func addSocialMediaProfile(socialData: Profil, completionHandler: @escaping (Result<String, APIError>) -> Void) {
//          let headers: HTTPHeaders = [
//              .contentType("application/json")
//          ]
//          let socialData: HTTPHeaders = [
//              "child": 2,
//              "social_media_name": 1,
//              "pseudo": "rrommmmm2",
//              "url": "kmmmmmmmmlp3"
//          ]
//
//          AF.request(add_Child_Profile,method: .post, parameters: socialData, encoder: JSONParameterEncoder.default, headers: headers).response { response in
//              print(response.result)
//              switch response.result {
//              case .success(let data):
//                  do {
//                      
//                      let profile = try JSONDecoder().decode(Profil.self, from: data!)
//                      print(profile)
//                      completionHandler(.success("Child social media registered successfully"))
//                      print( "Child social media registered successfully")
//                      
//                  } catch {
//                      print("Failed to register child's social media")
//                      completionHandler(.failure(.custom(message: "Failed to register child's social media")))
//                  }
//                            //        }
////                  guard let statusCode = (response.response?.statusCode) else {return}
////                  if statusCode == 201 {
////                      do {
////                          let profile = try JSONDecoder().decode(Profil.self, from: response.data!)
////                          completionHandler(.success("Child social media registered successfully"))
////
////                      } catch {
////                          completionHandler(.failure(.custom(message: "Failed to register child's social media")))
////                      }
//          //        }
//              case .failure(let err):
//                  print("Error sending data to the API: \(err.localizedDescription)")
//              }
//          }
//      }
//    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
