//
//  WebsterModel.swift
//  Lookup
//
//  Created by Adrian Bolinger on 11/27/22.
//

import Combine
import Foundation

//typealias WebstersDict = [String: String]

class WebstersDictionary {
    private(set) lazy var dict: [String: String] = {
        guard let bundle = Bundle.main.url(forResource: "websters_dictionary", withExtension: "json"),
              let data = try? Data(contentsOf: bundle),
              let decodedJSON = try? JSONDecoder().decode(Dictionary<String, String>.self, from: data) else {
            return [:]
        }

        return decodedJSON
    }()

    public var keys: Dictionary<String, String>.Keys {
        dict.keys
    }

    public func lookup(_ word: String) -> String {
        dict[word.lowercased()] ?? "Definition not found"
    }
}
