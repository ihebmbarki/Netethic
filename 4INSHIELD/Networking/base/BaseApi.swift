//
//  BaseApi.swift
//  4INSHIELD
//
//  Created by Mohamed Abbes on 6/7/2023.
//

import Foundation
import Alamofire

class BaseAPI<T: TargetType>{


    func fetchData<M: Decodable>(target: T, responseClass: M.Type, completion: @escaping (Result<M?, NSError>) -> Void) {
        let method = Alamofire.HTTPMethod(rawValue: target.methods.rawValue)
        let headers = Alamofire.HTTPHeaders(target.headers ?? [:])
        let params = bulidParams(task: target.task)
        
        AF.request(target.baseURL + target.path, method: method, parameters: params.0, encoding: params.1, headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: M.self) { response in
                switch response.result {
                case .success(let value):
                    completion(.success(value))
                    print("c'est bon dans le nv de fetchData! \(value)")
                case .failure(let error):
                    completion(.failure(error as NSError))
                    print("pas bon dans fetchData ! : \(error)")

                }
            }
    }

    private func bulidParams(task: Task) -> ([String:Any], ParameterEncoding){
        switch task {
            case .requestPlain:
                return ([:], URLEncoding.default)
        case .requestParameters(parameters: let parameters, encoding: let encoding):
                return (parameters, encoding)
        }
    }
}
