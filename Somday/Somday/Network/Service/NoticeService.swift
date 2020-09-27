//
//  NoticeService.swift
//  Somday
//
//  Created by 김예은 on 2020/08/29.
//  Copyright © 2020 kyeahen. All rights reserved.
//

import Foundation

struct NoticeService: GettableService, APIServie {
    
    typealias NetworkData = NoticeData
    static let shareInstance = NoticeService()

    //MARK: GET - /apis/notice (공지사항 전체)
    func getAllNoticeData(page: Int, completion: @escaping (NetworkResult<Any>) -> Void) {
        
        let url = self.url("/apis/notice?page=\(page)")
        
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
    
    //MARK: GET - /apis/notice/category/{categoryId} (공지사항 카테고리별)
    func getCategoryData(categoryId: String, page: Int, completion: @escaping (NetworkResult<Any>) -> Void) {
        
        let url = self.url("/apis/notice/category/\(categoryId)?page=\(page)")
        
        get(url) { (result) in
            switch result {
                
            case .success(let networkResult):
                switch networkResult.resResult.status{
                    
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
                
            case .failure(_) :
                completion(.networkFail)
                print("Fail: Network Fail")
            }
        }
    }
    
    //MARK: GET - /apis/notice/category/{categoryId}?searchword={searchWord} (검색 공지사항 카테고리별)
    func getCategorySearchData(categoryId: String, word: String, completion: @escaping (NetworkResult<Any>) -> Void) {
           
           let url = self.url("/apis/notice/search/category/\(categoryId)?searchWord=\(word)")
           
           get(url) { (result) in
               switch result {
                   
               case .success(let networkResult):
                   switch networkResult.resResult.status{
                       
                   case HTTPResponseCode.getSuccess.rawValue : //200
                   
                        completion(.networkSuccess(networkResult.resResult.data))
                    
                   case HTTPResponseCode.badRequest.rawValue : //400
                        completion(.badRequest)
                    
                   case HTTPResponseCode.searchNull.rawValue : //410
                        completion(.searchNull)

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
                    
                   case HTTPResponseCode.searchNull.rawValue : //410
                        completion(.searchNull)
                    
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

struct TopNoticeService: GettableService, APIServie {
    
    typealias NetworkData = TopData
    static let shareInstance = TopNoticeService()
    
    //MARK: GET - /apis/notice/top (상단 고정 게시물 조회)
       func getTopData(completion: @escaping (NetworkResult<Any>) -> Void) {
           
           let url = self.url("/apis/notice/top")
           
           get(url) { (result) in
               switch result {
                   
               case .success(let networkResult):
                   switch networkResult.resResult.status{
                       
                   case HTTPResponseCode.getSuccess.rawValue : //200
                   
                       completion(.networkSuccess(networkResult.resResult.data))
                       
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
                   
               case .failure(_) :
                   completion(.networkFail)
                   print("Fail: Network Fail")
               }
           }
       }
}

struct DetailNoticeService: GettableService, APIServie {
    
    typealias NetworkData = DetialData
    static let shareInstance = DetailNoticeService()
    
    //MARK: GET - /apis/notice/{noticeId} (공지사항 상세보기)
    func getDetailNoticeData(idx: Int, completion: @escaping (NetworkResult<Any>) -> Void) {
           
           let url = self.url("/apis/notice/\(idx)")
           
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

struct SearchNoticeService: GettableService, APIServie {
    
    typealias NetworkData = SearchData
    static let shareInstance = SearchNoticeService()
    
    //MARK: GET - /apis/notice/search?searchWord={searchWord} (검색 공지사항 전체)
    func getAllSearchData(word: String, completion: @escaping (NetworkResult<Any>) -> Void) {
           
           let url = self.url("/apis/notice/search?searchWord=\(word)")
           
           get(url) { (result) in
               switch result {
                   
               case .success(let networkResult):
                   switch networkResult.resResult.status{
                       
                   case HTTPResponseCode.getSuccess.rawValue : //200
                   
                        completion(.networkSuccess(networkResult.resResult.data))
                    
                   case HTTPResponseCode.badRequest.rawValue : //400
                        completion(.badRequest)
                    
                   case HTTPResponseCode.searchNull.rawValue : //410
                        completion(.searchNull)

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
                    
                   case HTTPResponseCode.searchNull.rawValue : //410
                        completion(.searchNull)
                    
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



