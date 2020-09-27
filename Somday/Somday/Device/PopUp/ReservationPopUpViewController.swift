//
//  ReservationPopUpViewController.swift
//  Somday
//
//  Created by 김예은 on 2020/08/22.
//  Copyright © 2020 kyeahen. All rights reserved.
//

import UIKit

class ReservationPopUpViewController: UIViewController {

    
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var contentLabel: UILabel!
    
    var count = 0
    var date = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleView.roundCorners([.topRight, .topLeft], radius: 10)
        contentLabel.text =
        """
        기기 대여 총 수량 \(count)대
        대여신청 하였습니다.
        
        \(date) 예약되었습니다.
        """
        
        self.showAnimate()
    }
    
    //MARK: 확인 액션
    @IBAction func okAction(_ sender: Any) {
        self.removeAnimate()
    }
    
}
