//
//  MailService.swift
//  Somday
//
//  Created by 김예은 on 2020/08/27.
//  Copyright © 2020 kyeahen. All rights reserved.
//

struct MailService: PostableService, GettableService, APIServie {
    
    typealias NetworkData = Data
    static let shareInstance = MailService()
    
    //MARK: Post - /apis/auth/mail (인증메일 전송)
    func postMail(params: [String : Any], completion: @escaping (NetworkResult<Any>) -> Void) {
       
       let url = self.url("/apis/auth/mail")
       
       post(url, params: params) { (result) in
           switch result {
               
           case .success(let networkResult):
               switch networkResult.resResult.status {
                   
               case HTTPResponseCode.postSuccess.rawValue : //201
                   
                   completion(.networkSuccess(networkResult.resResult))
                   
               case HTTPResponseCode.nullValue.rawValue : //400
                   completion(.nullValue)
                
                case HTTPResponseCode.serverErr.rawValue : //500
                    completion(.serverErr)
                   
               default :
                   print("Success: \(networkResult.resCode)")
                   break
               }
               
               break
               
           case .error(let resCode):
               switch resCode {
                   
                case HTTPResponseCode.nullValue.rawValue : //400
                    completion(.nullValue)
                
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
    
    //MARK: GET - /apis/auth/mail/학번/code?code=인증번호 (인증번호 확인)
    func getCode(id: String, code: Int, completion: @escaping (NetworkResult<Any>) -> Void) {
        
        let editURL = self.url("/apis/auth/mail/\(id)/code?code=\(code)")
        
        get(editURL) { (result) in
            switch result {
                
            case .success(let networkResult):
                switch networkResult.resResult.status{
                    
                case HTTPResponseCode.getSuccess.rawValue : //200
                    completion(.networkSuccess(networkResult.resResult))
                    
                case HTTPResponseCode.noRequest.rawValue : //701
                    completion(.noRequlst)
                    
                case HTTPResponseCode.wrongRequest.rawValue : //702
                    completion(.wrongInput)
                    
                case HTTPResponseCode.expireCode.rawValue : //703
                    completion(.expireCode)
                    
                case HTTPResponseCode.serverErr.rawValue : //500
                    completion(.serverErr)
                    
                default :
                    print("Success: \(networkResult.resCode)")
                    break
                }
                break
                
            case .error(let resCode):
                switch resCode {
                    
                case HTTPResponseCode.noRequest.rawValue : //701
                    completion(.noRequlst)
                    
                case HTTPResponseCode.wrongRequest.rawValue : //702
                    completion(.wrongInput)
                    
                case HTTPResponseCode.expireCode.rawValue : //703
                    completion(.expireCode)
                    
                case HTTPResponseCode.serverErr.rawValue : //500
                    completion(.serverErr)
                    
                default :
                    print("Error: \(resCode)")
                    break
                }
                break
                
            case .failure(_) :
                completion(.networkFail)
                print("Fail: Network Fail")
            }
        }
    }
    
}


