//
//  DeviceManager.swift
//  Somday
//
//  Created by 김예은 on 2020/08/20.
//  Copyright © 2020 kyeahen. All rights reserved.
//

import Foundation
import DeviceKit

// iOS12 이상 지원하는 Device array
// iPads는 유니버셜 앱이 아닐 때 애플 리뷰어가 테스트하기 때문에 넣었다.
public enum DeviceGroup {
   case fourInches
   case fiveInches
   case xSeries
   case iPads
   public var rawValue: [Device] {
      switch self {
      case .fourInches:
         return [.iPhone5s, .iPhoneSE]
      case .fiveInches:
        return [.iPhone6, .iPhone6s, .iPhone7, .iPhone8,.simulator(.iPhone6), .simulator(.iPhone6Plus),.simulator(.iPhone6s),.simulator(.iPhone8),.simulator(.iPhone8Plus)]
      case .xSeries:
        return  [.simulator(.iPhoneX),.simulator(.iPhoneXS),.simulator(.iPhoneXSMax),.simulator(.iPhoneXR),.simulator(.iPhone11),.simulator(.iPhone11Pro), .simulator(.iPhone11ProMax), .iPhoneX ,.iPhoneXS, .iPhoneXSMax, .iPhoneXR, .iPhone11, .iPhone11Pro, .iPhone11ProMax]
      case .iPads:
         return Device.allPads
      }
   }
}


// DeviceManager라는 class를 생성해서 싱글톤으로 사용한다.
class DeviceManager {
   static let shared: DeviceManager = DeviceManager()
    
   func isFourIncheDevices() -> Bool {
      return Device.current.isOneOf(DeviceGroup.fourInches.rawValue)
   }
    
   func isXDevices() -> Bool {
      return Device.current.isOneOf(DeviceGroup.xSeries.rawValue)
   }
}
