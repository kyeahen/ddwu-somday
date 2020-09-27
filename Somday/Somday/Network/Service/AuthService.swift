//
//  AuthService.swift
//  Somday
//
//  Created by 김예은 on 2020/08/27.
//  Copyright © 2020 kyeahen. All rights reserved.
//

import Foundation

struct AuthService: PostableService, PuttableService, APIServie {
    
    typealias NetworkData = Data
    static let shareInstance = AuthService()
    
    //MARK: POST - /apis/auth/student/token (유저 로그인)
    func postLogin(params: [String : Any], completion: @escaping (NetworkResult<Any>) -> Void) {
        
        let loginURL = self.url("/apis/auth/student/token")
        
        post(loginURL, params: params) { (result) in
            switch result {
                
            case .success(let networkResult):
                switch networkResult.resResult.status {
                    
                case HTTPResponseCode.getSuccess.rawValue : //200
                    
                    UserDefaults.standard.set(networkResult.resResult.data, forKey: "token")
                    completion(.networkSuccess(networkResult.resResult))
                    
                case HTTPResponseCode.badRequest.rawValue : //400
                    completion(.nullValue)
                    
                case HTTPResponseCode.nullValue.rawValue : //404
                    completion(.nullValue)
                
                case HTTPResponseCode.noResponse.rawValue : //444
                    completion(.noResponse)

                    
                default :
                    print("Success: \(networkResult.resCode)")
                    break
                }
                
                break
                
            case .error(let resCode):
                switch resCode {
                    
                case HTTPResponseCode.badRequest.rawValue : //400
                    completion(.nullValue)
                    
                case HTTPResponseCode.badRequest.rawValue : //404
                    completion(.badRequest)
                    
                case HTTPResponseCode.noResponse.rawValue : //444
                    completion(.noResponse)
                    
                case HTTPResponseCode.serverErr.rawValue : //500
                    completion(.serverErr)
                
                default :
                    print("Error: \(resCode)")
                    break
                }
                break
                
            case .failure(_):
                completion(.networkFail)
                print("Fail: Network Fail")
            }
        }
        
    }
    
    //MARK: Put - /apis/auth/student/token (비밀번호 변경)
   func putPassword(params: [String : Any], completion: @escaping (NetworkResult<Any>) -> Void) {
       
       
       //let token = UserDefaults.standard.string(forKey: "token")
       let url = self.url("/apis/auth/student/change/password")
       
       put(url, params: params) { (result) in
           switch result {
               
           case .success(let networkResult):
               switch networkResult.resResult.status {
                   
               case HTTPResponseCode.noContent.rawValue : //204
                   
                   completion(.networkSuccess(networkResult.resResult))
                   
               case HTTPResponseCode.badRequest.rawValue : //400
                   completion(.badRequest)
                
               case HTTPResponseCode.serverErr.rawValue : //500
                   completion(.serverErr)
                   
               default :
                   print("Success: \(networkResult.resCode)")
                   break
               }
               
               break
               
           case .error(let resCode):
               switch resCode {
                   
                case HTTPResponseCode.badRequest.rawValue : //400
                   completion(.badRequest)
                
                case HTTPResponseCode.serverErr.rawValue : //500
                    completion(.serverErr)
               
               default :
                   print("Error: \(resCode)")
                   break
               }
               break
               
           case .failure(_):
               completion(.networkFail)
               print("Fail: Network Fail")
           }
       }
       
   }
}

