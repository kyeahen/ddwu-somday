//
//  ConfirmCanceledReservationPopUpViewController.swift
//  Somday
//
//  Created by 김예은 on 2020/08/22.
//  Copyright © 2020 kyeahen. All rights reserved.
//

import UIKit

class ConfirmCanceledReservationPopUpViewController: UIViewController {
    
    @IBOutlet weak var titleView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleView.roundCorners([.topRight, .topLeft], radius: 10)
        self.showAnimate()
    }
    
    //MARK: 확인 액션
    @IBAction func okAction(_ sender: Any) {
        self.removeAnimate()
    }
    
}
