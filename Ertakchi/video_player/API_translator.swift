//
//  API_translator.swift
//  Ertakchi
//
//  Created by Mekhriddin Jumaev on 19/01/24.
//

import Foundation
import Alamofire

var app_id = "511ce480"
var key_id = "f3798739e13ddd1f2b13ebd8a391e1c0"

extension API {
    func translate(word: String, complition: @escaping (Result<Translation, Error>) -> Void) {
        let url = "https://od-api.oxforddictionaries.com:443/api/v2/entries/en-gb/" + word
        
        let headers: HTTPHeaders = [
            "app_id": app_id,
            "app_key": key_id
        ]
        
        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers, interceptor: nil)
            .response{ resp in
                switch resp.result {
                case .success(let data):
                    do {
                        let decoder = JSONDecoder()
                        let data = try decoder.decode(Translation.self, from: data!)
                        complition(.success(data))
                    } catch {
                        complition(.failure(error))
                    }
                case .failure(let error):
                    complition(.failure(error))
                }
            }
    }
}

struct Translation: Codable {
    let id: String?
    let results: [TransResult]?
}

struct TransResult: Codable {
    let id: String?
    let language: String?
    let lexicalEntries: [LexicalEntry]?
}

struct LexicalEntry: Codable {
    let entries: [Entry]?
}

struct Entry: Codable {
    let senses: [Sense]?
}

struct Sense: Codable {
    let definitions: [String]?
    let examples: [TransExample]?
}

struct TransExample: Codable {
    let text: String?
}
