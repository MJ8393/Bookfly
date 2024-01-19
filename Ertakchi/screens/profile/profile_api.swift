//
//  profile_api.swift
//  Ertakchi
//
//  Created by Mekhriddin Jumaev on 09/01/24.
//

import Foundation
import Alamofire

extension API {
    
    func getProfileInfo(completion: @escaping (ProfileInfo?, Error?) -> Void) {
        let url = API_URL_GET_INFO
        
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
                            let model = try decoder.decode(ProfileInfo.self, from: jsonData)
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
    
    
    func resetPassword(oldPassword: String, newPassword: String, completion: @escaping (Error?) -> Void) {
        let url = API_URL_RESET
        let headers = Token.getToken()
        
        let parameters: [String: String] = [
            "oldPassword": oldPassword,
            "newPassword": newPassword
        ]
                
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
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
    
    func updateProfile(fullname: String, username: String, password: String, completion: @escaping (LoginModel?, Error?) -> Void) {
        let url = API_URL_UPDATE_PROFILE
        
        let parameters: [String: String] = [
            "fullName": fullname,
            "username": username,
            "email": password
        ]
        
        AF.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default)
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
    
}

struct ProfileInfo: Codable {
    let name: String?
    let email: String?
    let username: String?
    let photoUrl: String?
}
