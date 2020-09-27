//
//  DeletableService.swift
//  Somday
//
//  Created by 김예은 on 2020/08/27.
//  Copyright © 2020 kyeahen. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol DeletableService {
    
    associatedtype NetworkData : Codable
    typealias networkResult = (resCode: Int, resResult: NetworkData)
    func delete(_ URL: String, params: [String : Any], completion: @escaping (Result<networkResult>) -> Void)
}

extension DeletableService {
    
    func gino(_ value : Int?) -> Int {
        return value ?? 0
    }
    
    func delete(_ URL: String, params: [String : Any], completion: @escaping (Result<networkResult>) -> Void){
        
        guard let encodedUrl = URL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            print("Networking - invalid URL")
            return
        }
        
        print("URL은 \(encodedUrl)")
        
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        
        let headers : HTTPHeaders = [
            "authorization" : token,
            "Content-Type:" : "application/json",
            "charset" : "utf-8"
        ]
        
        AF.request(encodedUrl, method: .delete, parameters: params, encoding: JSONEncoding.default, headers: headers).responseData(){
            (res) in
            
            switch res.result {
            case .success (let value):
                
                print("Networking Delete Here")
                

                let resCode = self.gino(res.response?.statusCode)
                print(resCode)
                
                print(JSON(value))
                
                let decoder = JSONDecoder()
                
                //실패 모델
                do {
                    
                    let resData = try decoder.decode(NetworkData.self, from: value)
                    
                    let result : networkResult = (resCode, resData)
                    
                    completion(.success(result))
                    
                }catch{ //변수 문제 예외 예상
                    print("Catch Delete")
                    
                    completion(.error(resCode))
                }

                break
                
            case .failure(let err):
                print(err.localizedDescription)
                completion(.failure(err))
                break
            }
        }
        
        
    }
}


