//
//  LogItem.swift
//  NasaApp
//
//  Created by Franco Fantillo on 2024-04-20.
//

import Foundation

enum ResultStatus: String {
    case SUCCESS
    case FAIL
}

struct LogItem: Encodable {
    
    enum CodingKeys: CodingKey {
        case initialURL
        case finalURL
        case time
        case result
    }
    
    let initialURL: String
    let finalURL: String
    let time: Int
    let result: String
    
    init(initialURL: String, finalURL: String, time: Int, result: ResultStatus) {
        self.initialURL = initialURL
        self.finalURL = finalURL
        self.time = time
        self.result = result.rawValue
    }
}
