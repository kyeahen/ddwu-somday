//
//  CancelReservationViewController.swift
//  Somday
//
//  Created by 김예은 on 2020/08/22.
//  Copyright © 2020 kyeahen. All rights reserved.
//

import UIKit

class CancelReservationViewController: UIViewController {

    @IBOutlet weak var titleView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleView.roundCorners([.topRight, .topLeft], radius: 10)
        self.showAnimate()
    }
    
    //MARK: 예약 취소 액션 - 통신
    @IBAction func okAction(_ sender: Any) {
        //TODO: 통신 코드 추가
    }
    
    //MARK: 아니요 액션
    @IBAction func noneAction(_ sender: Any) {
        self.removeAnimate()
    }
    
}
