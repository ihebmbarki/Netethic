//
//  Environment.swift
//  4INSHIELD
//
//  Created by iheb mbarki on 20/3/2023.
//

import Foundation

enum Environment: String {
    case debugDevelopment = "Debug Development"
    case releaseDevelopment = "Release Development"
    
    case debugStaging = "Debug Staging"
    case releaseStaging = "Release Staging"
    
    case debugProduction = "Debug Production"
    case releaseProduction = "Release Production"
}

class BuildConfiguration {
    static let shared = BuildConfiguration()
    
    var environment: Environment
    
    var WEBERVSER_BASE_URL: String {
        switch environment {
        case .debugStaging, .releaseStaging:
            return "http://51.38.62.168:8017/"
        case .debugDevelopment, .releaseDevelopment:
            return "http://51.89.21.5:8017/"
        case .debugProduction, .releaseProduction:
            return "https://api.shield.kaisens.fr"
        }
    }
    
    var MLENGINE_BASE_URL: String {
        switch environment {
        case .debugStaging, .releaseStaging:
            return "https://mlengine.staging.4indata.fr/"
        case .debugDevelopment, .releaseDevelopment:
            return "https://mlengine.dev.netethic.fr/"
        case .debugProduction, .releaseProduction:
            return "https://mlengine.shield.kaisens.fr"
        }
    }
    
    var DEVICESERVER_BASE_URL: String {
        switch environment {
        case .debugStaging, .releaseStaging:
            return "http://deviceserver.staging.4indata.fr/"
        case .debugDevelopment, .releaseDevelopment:
            return "https://deviceserver.dev.netethic.fr/"
        case .debugProduction, .releaseProduction:
            return "https://deviceserver.shield.kaisens.fr"
        }
    }
    
    var CRAWLSERVER_BASE_URL: String {
        switch environment {
        case .debugStaging, .releaseStaging:
            return "https://crawlserver.staging.4indata.fr"
        case .debugDevelopment, .releaseDevelopment:
            return "http://51.89.21.5:8017/"
        case .debugProduction, .releaseProduction:
            return "https://crawlserver.shield.kaisens.fr"
        }
    }

    let RECOMMENDATION_URL = "http://54.36.177.119:8000"
    let PROFIL_SEARCH = "http://54.36.177.119:8200"
    //KaxavyStaging
   let CLIENT_ID = "270449"
    let CLIENT_SECRET = "4fc5b6906261b1fc6fa228d8606a287567add4cb231458a89e7c23f0"
    //Jhon
    //devlop
//  let CLIENT_ID = "568280"
//    let CLIENT_SECRET = "4bde50918d5b19eb6ca4a83ed4c7d9cd101aa3a10b6c1fe62df57fbc"
    
    init() {
        let currentConfiguration = Bundle.main.object(forInfoDictionaryKey: "Configuration") as! String
        
        environment = Environment(rawValue: currentConfiguration)!
    }
}

