//
//  TACanceledPopUpViewController.swift
//  Somday
//
//  Created by 김예은 on 2020/08/22.
//  Copyright © 2020 kyeahen. All rights reserved.
//

import UIKit

class TACanceledPopUpViewController: UIViewController {
    
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var contentLabel: UILabel!
    
    var reason = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleView.roundCorners([.topRight, .topLeft], radius: 10)
        contentLabel.text =
        """
        기기 대여 예약이 취소되었습니다.
        자세한 사항은 학과에 문의해주세요.
        
        사유 (\(reason))
        """
    }
    
    //MARK: 확인 액션
    @IBAction func okAction(_ sender: Any) {
        self.removeAnimate()
    }
    

}
