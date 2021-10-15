//
//  File.swift
//  
//
//  Created by SathyaKrishna on 20/09/21.
//

import Foundation

let appEnvironment: AppEnvironment = .staging
let locale = Locale.current
let region = locale.regionCode ?? ""



public struct AppUrls {
    let base = ""
    static let version = "api/v%d/"
}

/// Fayvit Environment properties
public enum AppEnvironment: CaseIterable {
    case development
    case staging
    case production
    
    var baseUrl: String {
        let regionCode = Region(rawValue: region)
        switch regionCode {
        case .IN:
            switch self {
            case .development: return "https://dev.myfayvit.com/"
            case .staging: return "https://stgin.myfayvit.com/"
            case .production: return "https://stgin.myfayvit.com/"
            }
        default:
            switch self {
            case .development: return "https://dev.myfayvit.com/"
            case .staging: return "https://stg.myfayvit.com/"
            case .production: return "https://stg.myfayvit.com/"
            }
        }
    }
    
    var subdomain: String {
        let regionCode = Region(rawValue: region)
        switch regionCode {
        case .IN:
            switch self {
            case .development: return "dev"
            case .staging: return "stgin"
            case .production: return "stgin"
            }
        default:
            switch self {
            case .development: return "dev"
            case .staging: return "stg"
            case .production: return "stg"
            }
        }
    }
    
    var fetchLimit: Int { return 10 }
}

enum Region: String {
    case IN
}

extension AppEnvironment {
    static func runOnDebug(run: () -> Void) {
        #if DEBUG
        run()
        #endif
    }
}
