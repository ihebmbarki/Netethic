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
    
    var baseURL: String {
        switch environment {
        case .debugStaging, .releaseStaging:
            //                public static final String MLENGINE_BASE_URL = "https://mlengine.staging.4indata.fr";
            //                public static final String WEBERVSER_BASE_URL  = "https://webserver.staging.4indata.fr";
            //                public static final String CRAWLSERVER_BASE_URL  = "https://crawlserver.staging.4indata.fr";
            //                public static final String DEVICESERVER_BASE_URL = "https://deviceserver.staging.4indata.fr";
            //                public static final String RECOMMENDATION_URL = "http://54.36.177.119:8000";
            //                public static final String PROFIL_SEARCH = "http://54.36.177.119:8200";
            //                public static final String CLIENT_ID = "270449";
            //                public static final String CLIENT_SECRET ="4fc5b6906261b1fc6fa228d8606a287567add4cb231458a89e7c23f0";
        case .debugDevelopment, .releaseDevelopment:
            //                public static final String MLENGINE_BASE_URL = "http://141.94.246.237:8800";
            //                public static final String WEBERVSER_BASE_URL = "https://api.shield.kaisens.fr";
            //                public static final String CRAWLSERVER_BASE_URL  = "http://141.94.246.237:8004";
            //                public static final String DEVICESERVER_BASE_URL  = "https://deviceserver.shield.kaisens.fr/";
            //                public static final String RECOMMENDATION_URL = "http://54.36.177.119:8000";
            //                public static final String PROFIL_SEARCH = "http://54.36.177.119:8200";
            //                public static final String CLIENT_ID = "175211";
            //                public static final String CLIENT_SECRET ="fb606ceb76d93b2656b7a734f2ff8538c003e6f01f200a6650fd1a63";
        case .debugProduction, .releaseProduction:
            //                public static final String MLENGINE_BASE_URL = "http://141.94.246.237:8800";
            //                public static final String WEBERVSER_BASE_URL = "https://api.shield.kaisens.fr";
            //                public static final String CRAWLSERVER_BASE_URL  = "http://141.94.246.237:8004";
            //                public static final String DEVICESERVER_BASE_URL  = "https://deviceserver.shield.kaisens.fr/";
            //                public static final String RECOMMENDATION_URL = "http://54.36.177.119:8000";
            //                public static final String PROFIL_SEARCH = "http://54.36.177.119:8200";
            //                public static final String CLIENT_ID = "175211";
            //                public static final String CLIENT_SECRET ="fb606ceb76d93b2656b7a734f2ff8538c003e6f01f200a6650fd1a63";
            
        }
    }
    
    init() {
        let currentConfiguration = Bundle.main.object(forInfoDictionaryKey: "Configuration") as! String
        
        environment = Environment(rawValue: currentConfiguration)!
    }
}
