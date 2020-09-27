//
//  ModifyDataPopUpViewController.swift
//  Somday
//
//  Created by 김예은 on 2020/08/21.
//  Copyright © 2020 kyeahen. All rights reserved.
//

import UIKit

class ModifyDataPopUpViewController: UIViewController {

    @IBOutlet weak var noneButton: UIButton!
    @IBOutlet weak var okButton: UIButton!
    
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var titleView: UIView!
    
    var major = 0
    var name = ""
    var pwd = ""
    var phone = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()


        popUpView.backgroundColor = UIColor.SomColor.White.popupWhite
        okButton.layer.addBorder(edge: .left, color: UIColor.systemGray3, thickness: 1)
        titleView.roundCorners([.topLeft, .topRight], radius: 10)
        
        self.showAnimate()
    }
    
    
    //MARK: 개인정보 수정 액션
    @IBAction func modifyAction(_ sender: Any) {
        putJoin(major: major, name: name, pwd: pwd, phone: phone)
    }
    
    //MARK: 아니요 액션
    @IBAction func noneAction(_ sender: Any) {
        self.removeAnimate()
    }
    
}

//MARK: 네트워크 통신 extension
extension ModifyDataPopUpViewController {
    
    func putJoin(major: Int, name: String, pwd: String, phone: String) {
        
        let params : [String : Any] = [
                                        "majorId" : major,
                                        "name" : name,
                                        "password": pwd,
                                        "phone" : phone]
        
        StudentService.shareInstance.putStudentData(params: params) {(result) in
            
            switch result {
            case .networkSuccess( _): //200
                self.removeAnimate()
                self.navigationController?.popViewController(animated: true)
                break
            
            case .badRequest: //400
                self.showToast(message: "전화번호를 입력해주세요", yValue: 110)
                break
                
            case .networkFail :
                self.showToast(message: "네트워크 상태를 확인해주세요.", yValue: 110)
                break
                
            default : //500
                self.showToast(message: "다시 시도해주세요.", yValue: 110)
                break
            }
        }
    }
}
