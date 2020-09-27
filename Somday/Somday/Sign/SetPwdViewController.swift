//
//  SetPwdViewController.swift
//  Somday
//
//  Created by 김예은 on 2020/08/20.
//  Copyright © 2020 kyeahen. All rights reserved.
//

import UIKit

class SetPwdViewController: UIViewController {

    @IBOutlet weak var headerLabel: UILabel!
    
    @IBOutlet weak var pwdView: UIView!
    @IBOutlet weak var rePwdView: UIView!
    
    @IBOutlet weak var pwdTextField: UITextField!
    @IBOutlet weak var rePwdTextField: UITextField!
    
    var id = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerLabel.setLineHeight(lineHeight: 1.25)
        setBackBtn(color: .black)
        checkTextField()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        self.pwdTextField.delegate = self
        self.rePwdTextField.delegate = self
    }
    
    func checkTextField() {
        
        pwdTextField.addTarget(self, action: #selector(emptyPwdCheck), for: .editingChanged)
        rePwdTextField.addTarget(self, action: #selector(emptyRePwdCheck), for: .editingChanged)
    }
    
    //MARK: 비밀번호 공백 체크 함수
    @objc func emptyPwdCheck() {
        
        if pwdTextField.text == ""  {
            pwdView.backgroundColor = UIColor.SomColor.Gray.viewGray
        } else {
            pwdView.backgroundColor = UIColor.SomColor.Blue.viewBlue
        }
    }
    
     //MARK: 비밀번호 확인 공백 체크 함수
     @objc func emptyRePwdCheck() {
         
         if rePwdTextField.text == "" {
             rePwdView.backgroundColor = UIColor.SomColor.Gray.viewGray
         } else {
             rePwdView.backgroundColor = UIColor.SomColor.Blue.viewBlue
         }
     }
    
    //MARK: 패스워드 재설정 완료 액션
    @IBAction func okAction(_ sender: Any) {
        
        if pwdTextField.text == "" || rePwdTextField.text == "" || pwdTextField.text?.count != 4 || rePwdTextField.text?.count != 4{ //공백이 있는 경우
            pwdView.backgroundColor = UIColor.SomColor.Red.viewRed
            rePwdView.backgroundColor = UIColor.SomColor.Red.viewRed
            
        } else if pwdTextField.text != rePwdTextField.text { //비밀번호 확인이 틀린 경우
            
            self.showToast(message: "패스워드를 다시 확인해 주세요.", yValue: 60)
        
        } else {
            putPassword(id: id, pwd: gsno(pwdTextField.text))
        }
        
    }
    
    //MARK: 로그인 페이지로 돌아가기
    @IBAction func backLoginPageAction(_ sender: Any) {
        
        performSegue(withIdentifier: "unwindToLogin", sender: self)
    }
    
}

//MARK: Networking Extension
extension SetPwdViewController {
    
    func putPassword(id: String, pwd: String) {
        
        let params : [String : Any] = [ "studentId" : id,
                                        "password" : pwd]
        
        AuthService.shareInstance.putPassword(params: params) {(result) in
            
            switch result {
            case .networkSuccess( _): //204
                self.performSegue(withIdentifier: "unwindToLogin", sender: self)
                break
            
            case .badRequest: //400(존재하지 않는 학생)
                //self.simpleAlert(title: "로그인 실패", message: "아이디나 비밀번호가 일치하지 않습니다.")
                self.showToast(message: "존재하지 않는 학생입니다", yValue: 60)
                break
                
            case .networkFail :
                self.showToast(message: "네트워크 상태를 확인해주세요.", yValue: 60)
                break
                
            default :
                self.showToast(message: "다시 시도해주세요.", yValue: 60)
                break
            }
        }
    }
    
}

//MARK: 키보드 대응 extension
extension SetPwdViewController : UITextFieldDelegate {
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= (keyboardSize.height - 100)
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    //화면 터치하면 키보드 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        
        self.view.endEditing(true)
    }
    
    //MARK: 글자수 제한 - Textfield Delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        let currentCharacterCount = textField.text?.count ?? 0
        if range.length + range.location > currentCharacterCount {
            return false
        }
        let newLength = currentCharacterCount + string.count - range.length
        return newLength <= 4
    }
    
}

