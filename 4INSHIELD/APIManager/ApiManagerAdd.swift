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
    

    func getIndicatorActivityData(personID: Int, fromDateTimestamp: TimeInterval, toDateTimestamp: TimeInterval, completion: @escaping ([IndicatorActiviteElement]?) -> Void) {
        let indicatorActivityURL = "\(BuildConfiguration.shared.MLENGINE_BASE_URL)/api/score/per-type/"
        
        let parameters: [String: Any] = [
            "person_id": personID,
            "from_date_timestamp": fromDateTimestamp,
            "to_date_timestamp": toDateTimestamp
        ]
        
        AF.request(indicatorActivityURL, method: .get, parameters: parameters).response { response in
            print(response)
            switch response.result {
            case .success(let data):
                do {
                    let indicatorActivity = try JSONDecoder().decode([IndicatorActiviteElement].self, from: data!)
                    completion(indicatorActivity)
                } catch let error as NSError {
                    print("Error decoding JSON: \(error.localizedDescription)")
                    completion(nil)
                }
            case .failure(let error):
                print("API Error getting indicator activity data: \(error)")
                completion(nil)
            }
        }
    }

    func getPhoneUsageForChart(childID: Int, statisticsData: Bool, completion: @escaping (Phoneuse?) -> Void) {
        let usageURL = "\(BuildConfiguration.shared.DEVICESERVER_BASE_URL)/api/usage_duration_daily/"
        
        var urlComponents = URLComponents(string: usageURL)
        urlComponents?.queryItems = [
            URLQueryItem(name: "child_id", value: "\(childID)"),
            URLQueryItem(name: "statistics_data", value: "\(statisticsData)")
        ]
        
        guard let finalURL = urlComponents?.url else {
            completion(nil)
            return
        }
        
        AF.request(finalURL, method: .get).response { response in
            switch response.result {
            case .success(let data):
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let phoneUsage = try decoder.decode(Phoneuse.self, from: data)
                        completion(phoneUsage)
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



    
    
    
    
}
