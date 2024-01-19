//
//  API_main.swift
//  Ertakchi
//
//  Created by Mekhriddin Jumaev on 06/01/24.
//

import Foundation
import Alamofire

extension API {
    
    func getBestSellers(completion: @escaping ([Book]?, Error?) -> Void) {
        let lan = Helper.getLanguageCode()
        let url = API_URL_GET_BEST_SELLERS + "?lang=\(lan)"
                
        let headers = Token.getToken()

        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let httpResponse = response.response, (200..<300).contains(httpResponse.statusCode) {
                        do {
                            let jsonData = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                            let decoder = JSONDecoder()
                            let model = try decoder.decode([Book].self, from: jsonData)
                            completion(model, nil)
                        } catch {
                            completion(nil, error)
                        }
                    } else {
                        let error = NSError(domain: "", code: response.response?.statusCode ?? -1, userInfo: [NSLocalizedDescriptionKey: "Invalid status code"])
                        completion(nil, error)
                    }
                    
                case .failure(let error):
                    completion(nil, error)
                }
            }
    }
    
    func getPopular(completion: @escaping ([Book]?, Error?) -> Void) {
        let lan = Helper.getLanguageCode()

        let url = API_URL_GET_POPULAR_BOOKS + "?lang=\(lan)"
        
        let headers = Token.getToken()

        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let httpResponse = response.response, (200..<300).contains(httpResponse.statusCode) {
                        do {
                            let jsonData = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                            let decoder = JSONDecoder()
                            let model = try decoder.decode([Book].self, from: jsonData)
                            completion(model, nil)
                        } catch {
                            completion(nil, error)
                        }
                    } else {
                        let error = NSError(domain: "", code: response.response?.statusCode ?? -1, userInfo: [NSLocalizedDescriptionKey: "Invalid status code"])
                        completion(nil, error)
                    }
                    
                case .failure(let error):
                    completion(nil, error)
                }
            }
    }
    
    func getFavorites(completion: @escaping ([Book]?, Error?) -> Void) {
        let url = API_URL_GET_Favorites
        
        let headers = Token.getToken()

        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let httpResponse = response.response, (200..<300).contains(httpResponse.statusCode) {
                        do {
                            let jsonData = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                            let decoder = JSONDecoder()
                            let model = try decoder.decode([Book].self, from: jsonData)
                            completion(model, nil)
                        } catch {
                            completion(nil, error)
                        }
                    } else {
                        let error = NSError(domain: "", code: response.response?.statusCode ?? -1, userInfo: [NSLocalizedDescriptionKey: "Invalid status code"])
                        completion(nil, error)
                    }
                    
                case .failure(let error):
                    completion(nil, error)
                }
            }
    }
    
    func search(keyword: String, completion: @escaping ([Book]?, Error?) -> Void) {
        let url = API_URL_GET_SEARCH
        let lan = Helper.getLanguageCode()
        
        let parameters: Parameters = [
            "keyword": keyword,
            "lang": lan
         ]
        
        let headers = Token.getToken()

        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let httpResponse = response.response, (200..<300).contains(httpResponse.statusCode) {
                        do {
                            let jsonData = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                            let decoder = JSONDecoder()
                            let model = try decoder.decode([Book].self, from: jsonData)
                            completion(model, nil)
                        } catch {
                            completion(nil, error)
                        }
                    } else {
                        let error = NSError(domain: "", code: response.response?.statusCode ?? -1, userInfo: [NSLocalizedDescriptionKey: "Invalid status code"])
                        completion(nil, error)
                    }
                    
                case .failure(let error):
                    completion(nil, error)
                }
            }
    }
    
    func getPopularSearches(completion: @escaping ([Book]?, Error?) -> Void) {
        let lan = Helper.getLanguageCode()
        let url = API_URL_POPULAR_SEARCH + "?lang=\(lan)"
        
        let headers = Token.getToken()

        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let httpResponse = response.response, (200..<300).contains(httpResponse.statusCode) {
                        do {
                            let jsonData = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                            let decoder = JSONDecoder()
                            let model = try decoder.decode([Book].self, from: jsonData)
                            completion(model, nil)
                        } catch {
                            completion(nil, error)
                        }
                    } else {
                        let error = NSError(domain: "", code: response.response?.statusCode ?? -1, userInfo: [NSLocalizedDescriptionKey: "Invalid status code"])
                        completion(nil, error)
                    }
                    
                case .failure(let error):
                    completion(nil, error)
                }
            }
    }
    
    
    func getAuthers(completion: @escaping ([Auther]?, Error?) -> Void) {
        let lan = Helper.getLanguageCode()
        
        let url = API_URL_GET_AUTHERS + "=\(lan)"
        
        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let httpResponse = response.response, (200..<300).contains(httpResponse.statusCode) {
                        do {
                            let jsonData = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                            let decoder = JSONDecoder()
                            let model = try decoder.decode([Auther].self, from: jsonData)
                            completion(model, nil)
                        } catch {
                            completion(nil, error)
                        }
                    } else {
                        let error = NSError(domain: "", code: response.response?.statusCode ?? -1, userInfo: [NSLocalizedDescriptionKey: "Invalid status code"])
                        completion(nil, error)
                    }
                    
                case .failure(let error):
                    completion(nil, error)
                }
            }
    }
    
    func getGenres(completion: @escaping ([Genre]?, Error?) -> Void) {
        let lan = Helper.getLanguageCode()
        
        let url = API_URL_GET_GENRES + "=\(lan)"
        
        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let httpResponse = response.response, (200..<300).contains(httpResponse.statusCode) {
                        do {
                            let jsonData = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                            let decoder = JSONDecoder()
                            let model = try decoder.decode([Genre].self, from: jsonData)
                            completion(model, nil)
                        } catch {
                            completion(nil, error)
                        }
                    } else {
                        let error = NSError(domain: "", code: response.response?.statusCode ?? -1, userInfo: [NSLocalizedDescriptionKey: "Invalid status code"])
                        completion(nil, error)
                    }
                    
                case .failure(let error):
                    completion(nil, error)
                }
            }
    }
    
    func getPurchasedBooks(completion: @escaping ([Book]?, Error?) -> Void) {
        let lan = Helper.getLanguageCode()
        let url = API_URL_PURCHASED_BOOKS
        
        let headers = Token.getToken()

        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let httpResponse = response.response, (200..<300).contains(httpResponse.statusCode) {
                        do {
                            let jsonData = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                            let decoder = JSONDecoder()
                            let model = try decoder.decode([Book].self, from: jsonData)
                            completion(model, nil)
                        } catch {
                            completion(nil, error)
                        }
                    } else {
                        let error = NSError(domain: "", code: response.response?.statusCode ?? -1, userInfo: [NSLocalizedDescriptionKey: "Invalid status code"])
                        completion(nil, error)
                    }
                    
                case .failure(let error):
                    completion(nil, error)
                }
            }
    }
    
    
    
}


struct Auther: Codable {
    let id: Int64?
    let name: String?
    let bookList: [BookList]?
}

struct BookList: Codable {
    let imageUrl: String?
    let title: String?
    let id: Int64?
    let overallRanking: Double?
    let price: Double?
}

struct Genre: Codable {
    let id: Int64?
    let title: String?
    let books: [BookList]?
}
