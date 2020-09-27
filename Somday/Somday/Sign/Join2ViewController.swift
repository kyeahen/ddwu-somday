//
//  Join2ViewController.swift
//  Somday
//
//  Created by 김예은 on 2020/08/17.
//  Copyright © 2020 kyeahen. All rights reserved.
//

import UIKit
import DeviceKit

class Join2ViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var reEmailTextField: UITextField!
    @IBOutlet weak var pwdTextField: UITextField!
    @IBOutlet weak var rePwdTextField: UITextField!
    
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var reEmailView: UIView!
    @IBOutlet weak var pwdView: UIView!
    @IBOutlet weak var rePwdView: UIView!
    
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var reEmailButton: UIButton!

    @IBOutlet weak var scrollView: UIScrollView!
    
    var sendNumFlag = false
    var confirmNumFlag = false
    
    //var num = "11234"
    var majorId = 0
    var name = ""
    var studentId = ""
    var phone = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setBackBtn(color: .black)
        setUI()
        
        checkTextField()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
        
        scrollTouchsBegan()
        
        pwdTextField.delegate = self
        rePwdTextField.delegate = self
    }
    
    //MARK: 키보드 대응 method
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func setUI() {
        emailView.backgroundColor = UIColor.SomColor.Blue.viewBlue
        
        emailButton.layer.borderColor = UIColor.SomColor.Blue.mainBlue.cgColor
        emailButton.setTitleColor(UIColor.SomColor.Blue.mainBlue, for: .normal)
        emailButton.layer.borderWidth = 1
        
        reEmailButton.layer.borderColor = UIColor.SomColor.Black.mainBlack.cgColor
        reEmailButton.setTitleColor(UIColor.SomColor.Black.mainBlack, for: .normal)
        reEmailButton.layer.borderWidth = 1
        
        emailTextField.text = studentId
        
        print(studentId)
        print(majorId)
        print(name)
        
    }
    
    func checkTextField() {
        
        emailTextField.addTarget(self, action: #selector(emptyEmailCheck), for: .editingChanged)
        reEmailTextField.addTarget(self, action: #selector(emptyreEmailCheck), for: .editingChanged)
        pwdTextField.addTarget(self, action: #selector(emptyPwdCheck), for: .editingChanged)
        rePwdTextField.addTarget(self, action: #selector(emptyRePwdCheck), for: .editingChanged)
        
        rePwdTextField.addTarget(self, action: #selector(checkPwd), for: .editingChanged)
    }
    
    //MARK: 이메일 공백 체크 함수
    @objc func emptyEmailCheck() {
        
        if emailTextField.text == ""  {
            emailView.backgroundColor = UIColor.SomColor.Gray.viewGray
        } else {
            emailView.backgroundColor = UIColor.SomColor.Blue.viewBlue
        }
    }
    
    //MARK: 인증번호 공백 체크 함수
    @objc func emptyreEmailCheck() {
        
        if reEmailTextField.text == ""{
            reEmailView.backgroundColor = UIColor.SomColor.Gray.viewGray
        } else {
            reEmailView.backgroundColor = UIColor.SomColor.Blue.viewBlue
        }
    }
    
    //MARK: 비밀번호 공백 체크 함수
    @objc func emptyPwdCheck() {
        
        if pwdTextField.text == ""{ //공백인 경우
            pwdView.backgroundColor = UIColor.SomColor.Gray.viewGray
        } else {
            pwdView.backgroundColor = UIColor.SomColor.Blue.viewBlue
        }
    }
    
     //MARK: 비밀번호 확인 공백 체크 함수
     @objc func emptyRePwdCheck() {
         
         if rePwdTextField.text == ""{ //공백인 경우
             rePwdView.backgroundColor = UIColor.SomColor.Gray.viewGray
         } else {
             rePwdView.backgroundColor = UIColor.SomColor.Blue.viewBlue
         }
     }
    
    //MARK: 비밀번호 일치 여부 체크 함수
    @objc func checkPwd() {
        
        if pwdTextField.text != rePwdTextField.text {
            pwdView.backgroundColor = UIColor.SomColor.Red.viewRed
            rePwdView.backgroundColor = UIColor.SomColor.Red.viewRed
        } else {
            pwdView.backgroundColor = UIColor.SomColor.Blue.viewBlue
            rePwdView.backgroundColor = UIColor.SomColor.Blue.viewBlue
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
        
        if reEmailTextField.text == "" {
            self.showToast(message: "인증번호를 입력해주세요.", yValue: 110)
        } else {
            if let code = Int(gsno(reEmailTextField.text)) {
                getMail(id: gsno(emailTextField.text), code: code)
                print(code)
            }
        }
    }
    
    

    //MARK: 회원가입 다음 단계 이동
    @IBAction func nextAction(_ sender: Any) {
        
        /*
         
         1. 모두 공백일 때 -> 빨간뷰
         2. 이메일, 패스워드, 패스워드 확인 모두 채웠으나 인증번호를 치지 않았을 때 -> 빨간뷰, 토스트
         3. 패스워드 형식이 틀렸을 때
         */
        
        if emailTextField.text == "" || pwdTextField.text == "" || rePwdTextField.text == "" || pwdTextField.text?.count != 4 || rePwdTextField.text?.count != 4  {
            
            emailView.backgroundColor = UIColor.SomColor.Red.viewRed
            pwdView.backgroundColor = UIColor.SomColor.Red.viewRed
            rePwdView.backgroundColor = UIColor.SomColor.Red.viewRed
        } else if !confirmNumFlag {
            
            self.showToast(message: "이메일이 인증되지 않았습니다.", yValue: 110)
        } else if pwdTextField.text != rePwdTextField.text {
            
            pwdView.backgroundColor = UIColor.SomColor.Red.viewRed
            rePwdView.backgroundColor = UIColor.SomColor.Red.viewRed
        } else { //TODO : 어디론가 이동..
            
            postJoin(id: studentId, major: majorId, name: name, pwd: gsno(pwdTextField.text), phone: phone)
        }
    }
}

//MARK: Networking Extension
extension Join2ViewController {
    
    func postMail(id: String) {
        
        let params : [String : Any] = [ "studentId" : id]
        
        MailService.shareInstance.postMail(params: params) {(result) in
            
            switch result {
            case .networkSuccess( _): //201
                self.sendNumFlag = true
                self.showToast(message: "인증 번호가 전송되었습니다", yValue: 110)
                
                break
            
            case .badRequest: //400(학번을 넣어서 보내지 않음)
                
                self.showToast(message: "정확한 이메일을 작성해주세요.", yValue: 110)
                break
                
            case .networkFail :
                self.showToast(message: "네트워크 상태를 확인해주세요.", yValue: 110)
                break
                
            case .serverErr :
                self.showToast(message: "메일 전송을 실패했습니다.", yValue: 110)
                break
                
            default : //500
                self.showToast(message: "다시 시도해주세요.", yValue: 110)
                break
            }
        }
    }
    
    func getMail(id: String, code: Int) {
    
        MailService.shareInstance.getCode(id: id, code: code){(result) in
            
            switch result {
            case .networkSuccess( _): //200
                self.confirmNumFlag = true
                
                self.reEmailButton.layer.borderColor = UIColor.SomColor.Blue.mainBlue.cgColor
                self.reEmailButton.setTitleColor(UIColor.SomColor.Blue.mainBlue, for: .normal)
                self.reEmailButton.setTitle("인증 완료", for: .normal)
                
                break
            
            case .noRequlst: //701
                
                self.confirmNumFlag = false
                
                self.reEmailButton.layer.borderColor = UIColor.SomColor.Black.mainBlack.cgColor
                self.reEmailButton.setTitleColor(UIColor.SomColor.Black.mainBlack, for: .normal)
                self.reEmailButton.setTitle("인증 미완료", for: .normal)
                
                self.showToast(message: "인증번호를 전송해주세요.", yValue: 110)
                break
                
            case .wrongInput: //702
                
                self.confirmNumFlag = false
                
                self.reEmailButton.layer.borderColor = UIColor.SomColor.Black.mainBlack.cgColor
                self.reEmailButton.setTitleColor(UIColor.SomColor.Black.mainBlack, for: .normal)
                self.reEmailButton.setTitle("인증 미완료", for: .normal)
            
                self.showToast(message: "인증코드가 일치하지 않습니다.", yValue: 110)
                break
                
            case .expireCode: //703
                
                self.confirmNumFlag = false
                
                self.reEmailButton.layer.borderColor = UIColor.SomColor.Black.mainBlack.cgColor
                self.reEmailButton.setTitleColor(UIColor.SomColor.Black.mainBlack, for: .normal)
                self.reEmailButton.setTitle("인증 미완료", for: .normal)
            
                self.showToast(message: "인증코드를 다시 전송해주세요.", yValue: 110)
                break
                
            case .networkFail :
                
                self.confirmNumFlag = false
                
                self.reEmailButton.layer.borderColor = UIColor.SomColor.Black.mainBlack.cgColor
                self.reEmailButton.setTitleColor(UIColor.SomColor.Black.mainBlack, for: .normal)
                self.reEmailButton.setTitle("인증 미완료", for: .normal)
                
                self.showToast(message: "네트워크 상태를 확인해주세요.", yValue: 110)
                break
                
            default : //500
                
                self.confirmNumFlag = false
                
                self.reEmailButton.layer.borderColor = UIColor.SomColor.Black.mainBlack.cgColor
                self.reEmailButton.setTitleColor(UIColor.SomColor.Black.mainBlack, for: .normal)
                self.reEmailButton.setTitle("인증 미완료", for: .normal)
                
                self.showToast(message: "다시 시도해주세요.", yValue: 110)
                break
            }
        }
    }
    
    func postJoin(id: String, major: Int, name: String, pwd: String, phone: String) {
        
        let params : [String : Any] = ["studentId": id,
                                        "majorId" : major,
                                        "name" : name,
                                        "password": pwd,
                                        "phone" : phone]
        
        StudentService.shareInstance.postJoin(params: params) {(result) in
            
            switch result {
            case .networkSuccess( _): //201
                self.performSegue(withIdentifier: "unwindToLogin", sender: self)
                break
            
            case .badRequest: //400(이미 존재하는 학생)
                //self.simpleAlert(title: "로그인 실패", message: "아이디나 비밀번호가 일치하지 않습니다.")
                self.showToast(message: "이미 가입되어있습니다.", yValue: 110)
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
extension Join2ViewController : UITextFieldDelegate{
    
    @objc func keyboardWillShow(notification:NSNotification){

        let userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)

        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        scrollView.contentInset = contentInset
    }

    @objc func keyboardWillHide(notification:NSNotification){

        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }
    
    //화면 터치시 키보드 내리기
    func scrollTouchsBegan() {
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(Join1ViewController.tapRecognized))
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        scrollView.addGestureRecognizer(singleTapGestureRecognizer)
    }
    
    @objc func tapRecognized() {
    
        view.endEditing(true)
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


