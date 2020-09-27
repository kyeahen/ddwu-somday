//
//  Colors.swift
//  Somday
//
//  Created by 김예은 on 2020/08/20.
//  Copyright © 2020 kyeahen. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    struct SomColor {
        
        struct Blue {
            static let mainBlue = UIColor(red: 82/255, green: 102/255, blue: 255/255, alpha: 1.0)
            static let viewBlue = UIColor(red: 239/255, green: 243/255, blue: 255/255, alpha: 1.0)
           
        }
        
        struct Red {
            static let mainRed = UIColor(red: 255/255, green: 92/255, blue: 78/255, alpha: 1.0)
            static let viewRed = UIColor(red: 255/255, green: 212/255, blue: 209/255, alpha: 1.0)
        }
        
        struct Black {
            static let mainBlack = UIColor(red: 45/255, green: 45/255, blue: 45/255, alpha: 1.0)
        }
        
        struct Gray {
            static let wordGray = UIColor(red: 141/255, green: 141/255, blue: 141/255, alpha: 1.0)
            static let viewGray = UIColor(red: 244/255, green: 244/255, blue: 244/255, alpha: 1.0)
            static let lineGray = UIColor(red: 172/255, green: 172/255, blue: 172/255, alpha: 1.0)
            static let menuGray = UIColor(red: 77/255, green: 77/255, blue: 77/255, alpha: 1.0)
            static let resGray = UIColor(red: 128/255, green: 128/255, blue: 128/255, alpha: 1.0)
        }
        
        struct White {
            static let popupWhite = UIColor(red: 250/255, green:252/255, blue: 253/255, alpha: 1.0)
        }
    }
}
