//
//  GettableService.swift
//  Somday
//
//  Created by 김예은 on 2020/08/27.
//  Copyright © 2020 kyeahen. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol GettableService {
    
    associatedtype NetworkData : Codable
    typealias networkResult = (resCode: Int, resResult: NetworkData)
    func get(_ URL: String, method: HTTPMethod, completion: @escaping (Result<networkResult>) -> Void)
    
}

extension GettableService {
    
    func gino(_ value : Int?) -> Int {
        return value ?? 0
    }
    
    func get(_ URL: String, method: HTTPMethod = .get, completion: @escaping (Result<networkResult>) -> Void){
        
        guard let encodedUrl = URL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            print("Networking - invalid URL")
            return
        }
        
        print("URL은 \(encodedUrl)")
        //print("")
        
       let token = UserDefaults.standard.string(forKey: "token") ?? ""
        
        let headers : HTTPHeaders = [
            "authorization" : token,
            "Content-Type:" : "application/json",
            "charset" : "utf-8"
        ]
        
        AF.request(encodedUrl, method: method, parameters: nil, headers: headers).responseData {(res) in

            switch res.result {
                
            case .success (let value) :
                
                print("Networking Get Here!")
                print(JSON(value))
                
                let resCode = self.gino(res.response?.statusCode)
                print(resCode)
                
                let decoder = JSONDecoder()
                
                do {
                    print("들감")
                    let data = try decoder.decode(NetworkData.self, from: value)
                    
                    let result : networkResult = (resCode, data)
                    completion(.success(result))
                    
                }catch{
                    print("Catch GET")
                    completion(.error(resCode))
                }
                
                break
                
            case .failure(let err) :
                print(err.localizedDescription)
                completion(.failure(err))
                break
            }
            
        }
    }
    
}

