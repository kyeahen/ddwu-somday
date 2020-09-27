//
//  StudentService.swift
//  Somday
//
//  Created by 김예은 on 2020/08/27.
//  Copyright © 2020 kyeahen. All rights reserved.
//

struct StudentService: PostableService, PuttableService, APIServie {
    
    typealias NetworkData = Data
    static let shareInstance = StudentService()
    
    //MARK: POST - /apis/student (유저 회원가입)
    func postJoin(params: [String : Any], completion: @escaping (NetworkResult<Any>) -> Void) {
        
        let url = self.url("/apis/student")
        
        post(url, params: params) { (result) in
            switch result {
                
            case .success(let networkResult):
                switch networkResult.resResult.status {
                    
                case HTTPResponseCode.postSuccess.rawValue : //201
                    
                    completion(.networkSuccess(networkResult.resResult))
                    
                case HTTPResponseCode.badRequest.rawValue : //400
                    completion(.badRequest)
                
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
    
    //MARK: Put - /apis/student/update (회원가입 수정)
   func putStudentData(params: [String : Any], completion: @escaping (NetworkResult<Any>) -> Void) {
       
       let url = self.url("/apis/student/update")
       
       put(url, params: params) { (result) in
           switch result {
               
           case .success(let networkResult):
               switch networkResult.resResult.status {
                   
               case HTTPResponseCode.getSuccess.rawValue : //200
                   
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

struct MainStudentService : GettableService, APIServie {
    
    typealias NetworkData = StudentData
    static let shareInstance = MainStudentService()
    
    //MARK: GET - /apis/student/info (학생 기본 정보 조회)
    func getMainStudentData(completion: @escaping (NetworkResult<Any>) -> Void) {
        
        let url = self.url("/apis/student/info")
        
        get(url) { (result) in
            switch result {
                
            case .success(let networkResult):
                switch networkResult.resResult.status{
                    
                case HTTPResponseCode.getSuccess.rawValue : //200
                
                    completion(.networkSuccess(networkResult.resResult))
                    
                case HTTPResponseCode.serverErr.rawValue : //500
                    completion(.serverErr)
                    
                default :
                    print("Success: \(networkResult.resCode)")
                    break
                }
                break
                
            case .error(let resCode):
                switch resCode {
                    
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

