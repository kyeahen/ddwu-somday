//
//  HTTPResponseCode.swift
//  Somday
//
//  Created by 김예은 on 2020/08/27.
//  Copyright © 2020 kyeahen. All rights reserved.
//

import Foundation

enum HTTPResponseCode: Int{
    case getSuccess = 200
    case postSuccess = 201
    case noContent = 204 //put
    
    case selectErr = 300
    
    case badRequest = 400
    case accessDenied = 401
    case forbidden = 403
    case nullValue = 404
    case conflict = 409
    case noResponse = 444
    case searchNull = 410
    
    case serverErr = 500
    case notImplemented = 501
    
    //인증번호 400 에러
    case noRequest = 701
    case wrongRequest = 702
    case expireCode = 703
}

enum Result<T> {
    case success(T)
    case error(Int)
    case failure(Error)
}

enum NetworkResult<T> {
    case networkSuccess(T) //200
    
    case badRequest //400
    case accessDenied //401
    case nullValue //404
    case duplicated //409
    case large //413
    case noResponse // 444
    case searchNull
    
    case serverErr //500
    case requestFail //501
    case networkFail
    
    case noRequlst //701
    case wrongInput //702
    case expireCode //703

}
