//
//  RentalPopUpViewController.swift
//  Somday
//
//  Created by 김예은 on 2020/08/21.
//  Copyright © 2020 kyeahen. All rights reserved.
//

import UIKit

class RentalPopUpViewController: UIViewController {

    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var okButton: UIButton!
    
    var applyStatus: Bool = false //야작 신청 상태
    /*
     false : 신청 가능한 상태(미신청)
     true : 신청 불가 상태 (신청 - 취소만 가능함)
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.isHidden = true
        self.showAnimate()
        setUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func setUI() {
        
        titleView.roundCorners([.topLeft, .topRight], radius: 10)
        
        if !applyStatus { //신청 완료 팝업 (false)
            titleView.backgroundColor = UIColor.SomColor.Blue.mainBlue
            titleLabel.text = "야작 신청"
            contentLabel.text = "야작 신청이 완료되었습니다."
            okButton.setTitleColor(UIColor.SomColor.Blue.mainBlue, for: .normal)
            
        } else { //신청 취소 팝업 (true)
            titleView.backgroundColor = UIColor.SomColor.Red.mainRed
            titleLabel.text = "야작 취소"
            contentLabel.text = "야작 신청이 취소되었습니다."
            okButton.setTitleColor(UIColor.SomColor.Red.mainRed, for: .normal)
        }
    }
    
    //MARK: 확인 액션
    @IBAction func okAciton(_ sender: Any) {
        self.removeAnimate()
    }
    
    

}
