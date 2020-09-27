//
//  MemoService.swift
//  Somday
//
//  Created by 김예은 on 2020/08/27.
//  Copyright © 2020 kyeahen. All rights reserved.
//


struct MemoService: GettableService, APIServie {
    
    typealias NetworkData = MemoData
    static let shareInstance = MemoService()

    //MARK: GET - /apis/memo (메모 조회)
    func getMemoList(completion: @escaping (NetworkResult<Any>) -> Void) {
        
        let editURL = self.url("/apis/memo")
        
        get(editURL) { (result) in
            switch result {
                
            case .success(let networkResult):
                switch networkResult.resResult.status{
                    
                case HTTPResponseCode.getSuccess.rawValue : //200
                    
                    completion(.networkSuccess(networkResult.resResult.data))
                    
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

struct DefaultMemoService: PostableService, DeletableService, PuttableService, APIServie {
    
    typealias NetworkData = Data
    static let shareInstance = DefaultMemoService()
    
        //MARK: POST - /apis/memo (메모 작성)
       func postMemo(params: [String : Any], completion: @escaping (NetworkResult<Any>) -> Void) {
           
           let url = self.url("/apis/memo")
           
           post(url, params: params) { (result) in
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
    
     //MARK: Put - /apis/memo/{memoId} (메모 수정)
    func putMemo(idx: Int, params: [String : Any], completion: @escaping (NetworkResult<Any>) -> Void) {
        
        let url = self.url("/apis/memo/\(idx)")
        
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

    //MARK: Delete - /apis/memo/{memoId} (메모 삭제)
    func deleteMemo(idx: Int, completion: @escaping (NetworkResult<Any>) -> Void) {
        
        let url = self.url("/apis/memo/\(idx)")
        
        delete(url, params: [:]) { (result) in
            switch result {
                
            case .success(let networkResult):
                switch networkResult.resCode {
                    
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
                
            case .failure(_):
                completion(.networkFail)
                print("Fail: Network Fail")
            }
        }
        
    }
    
    //MARK: Put - /apis/memo/{memoId}/checked?checked={checked} (메모 체크 상태 변경)
    func putCheck(idx: Int, checked: Bool, params: [String : Any], completion: @escaping (NetworkResult<Any>) -> Void) {
       
       let url = self.url("/apis/memo/\(idx)/checked?checked=\(checked)")
       
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


