//
//  ColorTarget.swift
//  ShapeChallenge
//
//  Created by Vũ Tiến on 11/13/20.
//

import Foundation
import Moya

enum ColorTarget {
    case fetchRandomColor
    case fetchRandomPattern
}

extension ColorTarget: TargetType {
    var baseURL: URL { return URL(string: "https://www.colourlovers.com/api")! }
    
    var path: String {
        switch self {
        case .fetchRandomColor:
            return "/colors/random"
        case .fetchRandomPattern:
            return "/patterns/random"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchRandomColor, .fetchRandomPattern:
            return .get
        }
    }
    
    var task: Task {
        return .requestParameters(parameters: ["format":"json"], encoding: URLEncoding.queryString)
    }
    
    var sampleData: Data {
        switch self {
        case .fetchRandomColor:
            guard let url = Bundle.main.url(forResource: "StubDataColor", withExtension: "json"),
                let data = try? Data(contentsOf: url) else {
                    return Data()
            }
            return data
        case .fetchRandomPattern:
            guard let url = Bundle.main.url(forResource: "StubDataPattern", withExtension: "json"),
                let data = try? Data(contentsOf: url) else {
                    return Data()
            }
            return data
        }
    }
    
    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
}
