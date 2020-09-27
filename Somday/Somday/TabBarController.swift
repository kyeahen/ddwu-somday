//
//  TabBarController.swift
//  Somday
//
//  Created by 김예은 on 2020/08/18.
//  Copyright © 2020 kyeahen. All rights reserved.
//

import UIKit
import SideMenuSwift

class TabBarController: UITabBarController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: 사이드바 세팅
        SideMenuController.preferences.basic.menuWidth = self.view.safeAreaLayoutGuide.layoutFrame.width
        //SideMenuController.preferences.basic.statusBarBehavior = .hideOnMenu
        SideMenuController.preferences.basic.direction = .right
        SideMenuController.preferences.basic.position = .sideBySide
        SideMenuController.preferences.basic.enablePanGesture = false
        
    }

}
