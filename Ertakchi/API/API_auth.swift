//
//  API.swift
//  Ertakchi
//
//  Created by Mekhriddin Jumaev on 31/12/23.
//

import Foundation
import Alamofire

let BASE_URL = "http://64.23.155.56:8080"

let testToken = UD.token ?? ""

class Token {
    static func getToken() -> HTTPHeaders {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(UD.token ?? "")",
            "Content-Type": "application/json"
        ]
        return headers
    }
}

class API {
    static let shared = API()
    
    // Login URLs
    let API_URL_LOGIN = BASE_URL + "/auth/login?lang=en"
    let API_URL_REGISTER = BASE_URL + "/auth/register?lang=en"
    let API_URL_DELETE_ACCAUNT = BASE_URL + "/auth"
    
    // Main URLs
    let API_URL_GET_BEST_SELLERS = BASE_URL + "/book/bestsellers"
    let API_URL_GET_POPULAR_BOOKS = BASE_URL + "/book/find-popular-books"
    let API_URL_GET_Favorites = BASE_URL + "/book/saved"
    let API_URL_GET_SEARCH = BASE_URL + "/book/search"
    let API_URL_POPULAR_SEARCH = BASE_URL + "/book/history/all"
    let API_URL_GET_AUTHERS = BASE_URL + "/author?lang"
    let API_URL_GET_GENRES = BASE_URL + "/genre?lang"
    let API_URL_PURCHASED_BOOKS = BASE_URL + "/book/all/purchased"
    let API_URL_GET_BOOK_BY_ID = BASE_URL + "/book"

    // Other URLS
    let API_URL_LIKE = BASE_URL + "/book/func/like"
    let API_URL_REVIEW = BASE_URL + "/book/func/reviews/"
    let API_URL_ADD_PHOTO = BASE_URL + "/file/upload-photo"
    let API_URL_ADD_TO_SEARCH = BASE_URL + "/book/func/add-search/"
    let API_URL_LANGUAGE = BASE_URL + "/auth/change-lang"
    let API_URL_BUY_BOOK = BASE_URL + "/book/func/buy"

    
    // Profile
    let API_URL_GET_INFO = BASE_URL + "/auth/info"
    let API_URL_RESET = BASE_URL + "/auth/reset-password"
    let API_URL_SEND_RECOV_EMAIL = BASE_URL + "/auth/send-mail"
    let API_URL_VERIFY_CODE = BASE_URL + "/auth/verify"
    let API_URL_NEW_PASS = BASE_URL + "/auth/new-password"
    let API_URL_UPDATE_PROFILE = BASE_URL + "/auth"
}

extension API {
    // MARK: LOGIN

    func login(username: String, password: String, completion: @escaping (LoginModel?, Error?) -> Void) {
        let url = API_URL_LOGIN
        
        let parameters: [String: String] = [
            "username": username,
            "password": password
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate() // This will validate the status code and Content-Type of the response
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    // Check the HTTP status code
                    if let httpResponse = response.response, (200..<300).contains(httpResponse.statusCode) {
                        do {
                            let jsonData = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                            let decoder = JSONDecoder()
                            let loginModel = try decoder.decode(LoginModel.self, from: jsonData)
                            completion(loginModel, nil)
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

    
    func register(fullName: String, username: String, email: String, password: String, completion: @escaping (LoginModel?, Error?) -> Void) {
        let url = API_URL_REGISTER
        
        let parameters: [String: String] = [
            "fullName": username,
            "username": username,
            "email": email,
            "password": password
         ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate() // This will validate the status code and Content-Type of the response
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    // Check the HTTP status code
                    if let httpResponse = response.response, (200..<300).contains(httpResponse.statusCode) {
                        do {
                            let jsonData = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                            let decoder = JSONDecoder()
                            let loginModel = try decoder.decode(LoginModel.self, from: jsonData)
                            completion(loginModel, nil)
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
    
    func getBookBy(id: Int64, completion: @escaping (Book?, Error?) -> Void) {
        let headers = Token.getToken()
        
        let lan = Helper.getLanguageCode()
        let url = API_URL_GET_BOOK_BY_ID + "/\(id)?lang=\(lan)"
                
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let httpResponse = response.response, (200..<300).contains(httpResponse.statusCode) {
                        do {
                            let jsonData = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                            let decoder = JSONDecoder()
                            let model = try decoder.decode(Book.self, from: jsonData)
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
