//
//  TargetType.swift
//  4INSHIELD
//
//  Created by Mohamed Abbes on 6/7/2023.
//

import Foundation
import Alamofire

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

enum Task{
    case requestPlain

    case requestParameters(parameters:[String: Any], encoding: ParameterEncoding )
}

protocol TargetType {
    var baseURL: String { get}
    var path: String { get}
    var methods: HTTPMethod { get}
    var task: Task { get}
    var headers: [String: String]? { get}
}
