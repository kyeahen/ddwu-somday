//
//  WorkService.swift
//  Somday
//
//  Created by 김예은 on 2020/08/27.
//  Copyright © 2020 kyeahen. All rights reserved.
//

import SwiftyJSON

struct WorkService: GettableService, APIServie {
    
    typealias NetworkData = WorkData
    static let shareInstance = WorkService()

    //MARK: GET - /apis/reservation/work (야작 신청 조회)
    func getWorkData(completion: @escaping (NetworkResult<Any>) -> Void) {
        
        let url = self.url("/apis/reservation/work")
        
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

struct WorkRoomService: GettableService, APIServie {
    
    typealias NetworkData = WorkRoomData
    static let shareInstance = WorkRoomService()

    //MARK: GET - /apis/reservation/work/room (야작 강의실 조회)
    func getRoomData(completion: @escaping (NetworkResult<Any>) -> Void) {
        
        let url = self.url("/apis/reservation/work/room")
        
        get(url) { (result) in
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

struct DefaultWorkService: PostableService, DeletableService, PuttableService, APIServie {
    
    typealias NetworkData = Data
    static let shareInstance = DefaultWorkService()
    
        //MARK: POST - /apis/reservation/work/room/{roomId} (야작 신청)
    func postWork(roomId: Int, params: [String : Any], completion: @escaping (NetworkResult<Any>) -> Void) {
           
           let url = self.url("/apis/reservation/work/room/\(roomId)")
           
           post(url, params: params) { (result) in
               switch result {
                   
               case .success(let networkResult):
                   switch networkResult.resResult.status {
                       
                   case HTTPResponseCode.postSuccess.rawValue : //201
                       
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

    //MARK: Delete - /apis/reservation/work/{workId} (야작 신청 취소)
    func deleteWork(workId: Int, completion: @escaping (NetworkResult<Any>) -> Void) {
        
        let url = self.url("/apis/reservation/work/\(workId)")
        
        delete(url, params: [:]) { (result) in
            switch result {
                
            case .success(let networkResult):
                switch networkResult.resCode {
                    
                case HTTPResponseCode.postSuccess.rawValue : //201
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



