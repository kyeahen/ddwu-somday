//
//  SendOpnionPopUpViewController.swift
//  Somday
//
//  Created by 김예은 on 2020/08/20.
//  Copyright © 2020 kyeahen. All rights reserved.
//

import UIKit

class SendOpnionPopUpViewController: UIViewController {
    
    @IBOutlet weak var backView: UIImageView!
    @IBOutlet weak var popUpView: UIView!
    
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var replyButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleView.roundCorners([.topLeft, .topRight], radius: 10)
        popUpView.backgroundColor = UIColor.SomColor.White.popupWhite
        
        self.showAnimate()
    }
    
    @IBAction func writeOpnionAction(_ sender: UIButton) {
        self.removeAnimate()
    }
    
}
