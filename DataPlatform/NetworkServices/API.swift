//
//  API.swift
//  DataPlatform
//
//  Created by siva lingam on 13/5/21.
//

import Foundation

import UIKit
import RxSwift
import Moya

#if STAG
let baseUrl = "https://jsonplaceholder.typicode.com/"
#elseif UAT
let baseUrl = "https://jsonplaceholder.typicode.com/"
#else
let baseUrl = "https://jsonplaceholder.typicode.com/"
#endif

let loggerConfig = NetworkLoggerPlugin.Configuration(logOptions: .verbose)
let networkLogger = NetworkLoggerPlugin(configuration: loggerConfig)
let apiProvider = MoyaProvider<API>(plugins: [networkLogger])

public enum API {
    case getUsers
}

extension API: TargetType {
    
    public var baseURL: URL {
        switch self {
        case .getUsers:
            return URL(string: baseUrl)!
        }
    }
    
    public var path: String {
        switch self {
        case .getUsers:
            return "users"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .getUsers:
            return .get
        }
    }
    
    public var task: Task {
        switch self {
        default:
            return .requestPlain
        }
    }
    
    public var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
    
    public var validationType: ValidationType {
        return .customCodes([200])
    }

    public var sampleData: Data {
        switch self {
        case .getUsers:
            return mockStringFrom(file: "Users")
        }
    }
}


func mockStringFrom(file:String) -> Data {
    guard let path = Bundle.main.path(forResource: file, ofType: "json"),
        let data = NSData(contentsOfFile: path) else {
            return Data()
    }
    return Data(referencing: data)
}

// MARK: - Proquivider setup
func JSONResponseDataFormatter(_ data: Data) -> Data {
    do {
        let dataAsJSON = try JSONSerialization.jsonObject(with: data)
        let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
        return prettyData
    } catch {
        return data // fallback to original data if it can't be serialized.
    }
}
