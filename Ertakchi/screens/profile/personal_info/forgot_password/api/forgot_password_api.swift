//
//  forgot_password_api.swift
//  Ertakchi
//
//  Created by Mekhriddin Jumaev on 14/01/24.
//

import Foundation
import Alamofire

extension API {
    
    func sendRecovery_email(username: String, email: String, completion: @escaping (LoginModel?, Error?) -> Void) {
        let url = API_URL_SEND_RECOV_EMAIL
        
        let parameters: [String: String] = [
            "username": username,
            "email": email
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
    
    func verify_code(token: String, code: String, completion: @escaping (LoginModel?, Error?) -> Void) {
        let url = API_URL_VERIFY_CODE

        let parameters: [String: String] = [
            "token": token,
            "code": code
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
    
    func reset_new_password(token: String, code: String, completion: @escaping (Error?) -> Void) {
        let url = API_URL_NEW_PASS
        
        let parameters: [String: String] = [
            "token": token,
            "code": code
        ]
                
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
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
    
    func deleteAccount(completion: @escaping (Error?) -> Void) {
        let url = API_URL_DELETE_ACCAUNT
        let token = Token.getToken()
                
        AF.request(url, method: .delete, parameters: nil, encoding: URLEncoding.default, headers: token)
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
