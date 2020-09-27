//
//  ForgetPwdViewController.swift
//  Somday
//
//  Created by 김예은 on 2020/08/17.
//  Copyright © 2020 kyeahen. All rights reserved.
//

import UIKit

class ForgetPwdViewController: UIViewController {
    
    @IBOutlet weak var headerLabel: UILabel!
    

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var emailButton: UIButton!
    
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var codeView: UIView!
    @IBOutlet weak var codeButton: UIButton!
    
    var sendNumFlag = false
    var confirmNumFlag = false
    
    //var num = "11234"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setBackBtn(color: .black)
        checkTextField()
        headerLabel.setLineHeight(lineHeight: 1.25)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    func setUI(){
        emailButton.layer.borderColor = UIColor.SomColor.Blue.mainBlue.cgColor
        emailButton.setTitleColor(UIColor.SomColor.Blue.mainBlue, for: .normal)
        emailButton.layer.borderWidth = 1
        
        codeButton.layer.borderColor = UIColor.SomColor.Black.mainBlack.cgColor
        codeButton.setTitleColor(UIColor.SomColor.Black.mainBlack, for: .normal)
        codeButton.layer.borderWidth = 1
    }
    
    
    func checkTextField() {
        emailTextField.addTarget(self, action: #selector(emptyEmailCheck), for: .editingChanged)
        codeTextField.addTarget(self, action: #selector(emptyCodeCheck), for: .editingChanged)
    }
    
    //MARK: 이메일 공백 체크 함수
    @objc func emptyEmailCheck() {
        
        if emailTextField.text == ""{
            emailView.backgroundColor = UIColor.SomColor.Gray.viewGray
        } else {
            emailView.backgroundColor = UIColor.SomColor.Blue.viewBlue
        }
    }
    
    //MARK: 인증번호 공백 체크 함수
    @objc func emptyCodeCheck() {
        
        if codeTextField.text == ""{
            codeView.backgroundColor = UIColor.SomColor.Gray.viewGray
        } else {
            codeView.backgroundColor = UIColor.SomColor.Blue.viewBlue
        }
    }
    
    
    //MARK: 인증번호 전송
    @IBAction func sendNumAction(_ sender: UIButton) {
        
        if emailTextField.text == ""  {
            sendNumFlag = false
            emailView.backgroundColor = UIColor.SomColor.Red.viewRed
            
        } else {
            postMail(id: gsno(emailTextField.text))
        }

        print(sendNumFlag)
    }
    
    //MARK: 인증번호 확인
    @IBAction func confirmNumAction(_ sender: UIButton) {

        if let code = Int(gsno(codeTextField.text)) {
            getMail(id: gsno(emailTextField.text), code: code)
            print(code)
        }
    }

    
    
    @IBAction func sendPwdAction(_ sender: Any) {
    
        if emailTextField.text == "" || codeTextField.text == "" {
            
            emailView.backgroundColor = UIColor.SomColor.Red.viewRed
            codeView.backgroundColor = UIColor.SomColor.Red.viewRed

        } else if !confirmNumFlag {
            self.showToast(message: "이메일이 인증되지 않았습니다.", yValue: 110)
        } else {
            
            let vc = UIStoryboard(name: "Sign", bundle: nil).instantiateViewController(identifier: SetPwdViewController.reuseIdentifier) as! SetPwdViewController
            vc.id = gsno(emailTextField.text)
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
}

//MARK: Networking Extension
extension ForgetPwdViewController {
    
    func postMail(id: String) {
        
        let params : [String : Any] = [ "studentId" : id]
        
        MailService.shareInstance.postMail(params: params) {(result) in
            
            switch result {
            case .networkSuccess( _): //201
                self.sendNumFlag = true
                self.showToast(message: "인증 번호가 전송되었습니다", yValue: 110)
                
                break
            
            case .badRequest: //400(학번을 넣어서 보내지 않음)
                
                self.showToast(message: "정확한 이메일을 작성해주세요.", yValue: 60)
                break
                
            case .networkFail :
                self.showToast(message: "네트워크 상태를 확인해주세요.", yValue: 60)
                break
                
            case .serverErr :
                self.showToast(message: "메일 전송을 실패했습니다.", yValue: 60)
                break
                
            default : //500
                self.showToast(message: "다시 시도해주세요.", yValue: 60)
                break
            }
        }
    }
    
    func getMail(id: String, code: Int) {
    
        
        MailService.shareInstance.getCode(id: id, code: code){(result) in
            
            switch result {
            case .networkSuccess( _): //200
                self.confirmNumFlag = true
                
                self.codeButton.layer.borderColor = UIColor.SomColor.Blue.mainBlue.cgColor
                self.codeButton.setTitleColor(UIColor.SomColor.Blue.mainBlue, for: .normal)
                self.codeButton.setTitle("인증 완료", for: .normal)
                
                break
            
            case .noRequlst: //701
                
                self.confirmNumFlag = false
                
                self.codeButton.layer.borderColor = UIColor.SomColor.Black.mainBlack.cgColor
                self.codeButton.setTitleColor(UIColor.SomColor.Black.mainBlack, for: .normal)
                self.codeButton.setTitle("인증 미완료", for: .normal)
                
                self.showToast(message: "인증번호를 전송해주세요.", yValue: 60)
                break
                
            case .wrongInput: //702
                
                self.confirmNumFlag = false
                
                self.codeButton.layer.borderColor = UIColor.SomColor.Black.mainBlack.cgColor
                self.codeButton.setTitleColor(UIColor.SomColor.Black.mainBlack, for: .normal)
                self.codeButton.setTitle("인증 미완료", for: .normal)
            
                self.showToast(message: "인증코드가 일치하지 않습니다.", yValue: 60)
                break
                
            case .expireCode: //703
                
                self.confirmNumFlag = false
                
                self.codeButton.layer.borderColor = UIColor.SomColor.Black.mainBlack.cgColor
                self.codeButton.setTitleColor(UIColor.SomColor.Black.mainBlack, for: .normal)
                self.codeButton.setTitle("인증 미완료", for: .normal)
            
                self.showToast(message: "인증코드를 다시 전송해주세요.", yValue: 60)
                break
                
            case .networkFail :
                self.confirmNumFlag = false
                
                self.codeButton.layer.borderColor = UIColor.SomColor.Black.mainBlack.cgColor
                self.codeButton.setTitleColor(UIColor.SomColor.Black.mainBlack, for: .normal)
                self.codeButton.setTitle("인증 미완료", for: .normal)
                
                self.showToast(message: "네트워크 상태를 확인해주세요.", yValue: 60)
                break
                
            default : //500
                
                self.confirmNumFlag = false
                
                self.codeButton.layer.borderColor = UIColor.SomColor.Black.mainBlack.cgColor
                self.codeButton.setTitleColor(UIColor.SomColor.Black.mainBlack, for: .normal)
                self.codeButton.setTitle("인증 미완료", for: .normal)
                
                self.showToast(message: "다시 시도해주세요.", yValue: 60)
                break
            }
        }
    }
    
}


//MARK: 키보드 대응 extension
extension ForgetPwdViewController {
    
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
    
}
