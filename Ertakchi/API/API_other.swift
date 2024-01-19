//
//  API_other.swift
//  Ertakchi
//
//  Created by Mekhriddin Jumaev on 06/01/24.
//

import Foundation
import Alamofire


extension API {
    
    func likeBook(id: Int64, isLiked: Bool, completion: @escaping (Error?) -> Void) {
        let url = API_URL_LIKE + "/\(id)?isLiked=\(isLiked)"
        let headers = Token.getToken()
                
        AF.request(url, method: .post, parameters: nil, encoding: URLEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .response { response in
                switch response.result {
                case .success(_):
                    completion(nil)
                case .failure(let error):
                    completion(error)
                }
            }
    }
    
    func reviewBook(id: Int64, message: String, rankingType: Int, completion: @escaping (Book?, Error?) -> Void) {
        let url = API_URL_REVIEW + "\(id)"
        let headers = Token.getToken()
        
        let parameters: [String: Any] = [
            "message": message,
            "rankingType": rankingType
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                        let decoder = JSONDecoder()
                        let model = try decoder.decode(Book.self, from: jsonData)
                        completion(model, nil)
                    } catch {
                        completion(nil, error)
                    }
                case .failure(let error):
                    completion(nil, nil)
                }
            }
    }
    
    func updateReview(id: Int64, message: String, rankingType: Int, completion: @escaping (Book?, Error?) -> Void) {
        let url = API_URL_REVIEW + "\(id)"
        let headers = Token.getToken()
        
        let parameters: [String: Any] = [
            "message": message,
            "rankingType": rankingType
        ]
        
        AF.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                        let decoder = JSONDecoder()
                        let model = try decoder.decode(Book.self, from: jsonData)
                        completion(model, nil)
                    } catch {
                        completion(nil, error)
                    }
                case .failure(let error):
                    completion(nil, nil)
                }
            }
    }
    
    func removeFromFavorites(id: Int64, completion: @escaping (Book?, Error?) -> Void) {
        let url = API_URL_REVIEW + "\(id)"
        let headers = Token.getToken()

        AF.request(url, method: .delete, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                        let decoder = JSONDecoder()
                        let model = try decoder.decode(Book.self, from: jsonData)
                        completion(model, nil)
                    } catch {
                        completion(nil, error)
                    }
                case .failure(let error):
                    completion(nil, nil)
                }
            }
    }
    
    func addToSearch(id: Int64, completion: @escaping (Error?) -> Void) {
        let url = API_URL_ADD_TO_SEARCH + "\(id)"
        let headers = Token.getToken()
                
        AF.request(url, method: .post, parameters: nil, encoding: URLEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .response { response in
                switch response.result {
                case .success(_):
                    completion(nil)
                case .failure(let error):
                    completion(error)
                }
            }
    }
    

    func changeLang(lang: String, completion: @escaping (Error?) -> Void) {
        let url = API_URL_LANGUAGE + "?lang=\(lang)"
        let headers = Token.getToken()
                
        AF.request(url, method: .post, parameters: nil, encoding: URLEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .response { response in
                switch response.result {
                case .success(_):
                    completion(nil)
                case .failure(let error):
                    completion(error)
                }
            }
    }
    
    func buyBook(id: Int64, completion: @escaping (Error?) -> Void) {
        let url = API_URL_BUY_BOOK + "/\(id)"
        
        let headers = Token.getToken()
                
        AF.request(url, method: .post, parameters: nil, encoding: URLEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .response { response in
                switch response.result {
                case .success(_):
                    completion(nil)
                case .failure(let error):
                    completion(error)
                }
            }
    }
    
    
    
}
