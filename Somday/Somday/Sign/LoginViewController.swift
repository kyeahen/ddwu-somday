//
//  LoginViewController.swift
//  Somday
//
//  Created by 김예은 on 2020/08/17.
//  Copyright © 2020 kyeahen. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {


    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var idView: UIView!
    @IBOutlet weak var pwdTextField: UITextField!
    @IBOutlet weak var pwdView: UIView!
    

    @IBOutlet weak var login1Button: UIButton!
    @IBOutlet weak var joinButton: UIButton!
    @IBOutlet weak var forgetPwdButton: UIButton!
    
    @IBOutlet weak var topC: NSLayoutConstraint!
    
    var count = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setNavigationBar()
        checkTextField()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
        pwdTextField.delegate = self

    }
    
    
    //MARK: 뷰 요소들을 변경하는 함수
    func setUI() {
        topC.constant -= getNavigationBarHeight()
    }
    
    //MARK: 상태바 높이를 구하는 함수
    func getStatusBarHeight() -> CGFloat {
        var statusBarHeight: CGFloat = 0
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        } else {
            statusBarHeight = UIApplication.shared.statusBarFrame.height
        }
        return statusBarHeight
    }
    
    //MARK: 텍스트필드 체크 함수
    func checkTextField() {
           
       idTextField.addTarget(self, action: #selector(emptyIdCheck), for: .editingChanged)
       pwdTextField.addTarget(self, action: #selector(emptyPwdCheck), for: .editingChanged)
       
    }
   
   //MARK: id 공백 체크 함수
   @objc func emptyIdCheck() {
       
       if idTextField.text == "" {
            idView.backgroundColor = UIColor.SomColor.Red.mainRed
       } else {
        idView.backgroundColor = .white
       }
   }
   
   //MARK: 비밀번호 공백 체크 함수
   @objc func emptyPwdCheck() {
       
       if pwdTextField.text == ""{
            pwdView.backgroundColor = UIColor.SomColor.Red.mainRed
       } else {
        pwdView.backgroundColor = .white
       }
   }
    
    //MARK: 로그인 액션 (성공 시, 메인으로 이동)
    @IBAction func loginAction(_ sender: Any) {
        
        if idTextField.text == "" || pwdTextField.text == "" {
            
            idView.backgroundColor = UIColor.SomColor.Red.mainRed
            pwdView.backgroundColor = UIColor.SomColor.Red.mainRed
        } else {
            
            postLogin(id: gsno(idTextField.text), pwd: gsno(pwdTextField.text))
        }
    }
    
    //MARK: unwind segue
    @IBAction func unwindToLogin (segue : UIStoryboardSegue) {}
    
}

//MARK: Networking Extension
extension LoginViewController {
    
    func postLogin(id: String, pwd: String) {
        
        let params : [String : Any] = ["password" : pwd,
                                       "studentId" : id]
        
        AuthService.shareInstance.postLogin(params: params) {(result) in
            
            switch result {
            case .networkSuccess( _): //200
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SideMenu")
                
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
                break
            
            case .nullValue, .badRequest: //400(비밀번호 틀림), 404(존재하지 않는 학생)
                //self.simpleAlert(title: "로그인 실패", message: "아이디나 비밀번호가 일치하지 않습니다.")
                self.showToast(message: "아이디나 비밀번호가 일치하지 않습니다.", yValue: 110)
                break
                
            case .networkFail :
                self.showToast(message: "네트워크 상태를 확인해주세요.", yValue: 110)
                break
                
            default : //444
                self.showToast(message: "다시 시도해주세요.", yValue: 110)
                break
            }
        }
    }
    
}


//MARK: 키보드 대응 extension
extension LoginViewController : UITextFieldDelegate{
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
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
