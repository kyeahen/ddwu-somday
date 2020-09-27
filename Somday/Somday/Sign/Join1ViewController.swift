//
//  Join1ViewController.swift
//  Somday
//
//  Created by 김예은 on 2020/08/17.
//  Copyright © 2020 kyeahen. All rights reserved.
//

import UIKit

class Join1ViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var department1Button: UIButton!
    @IBOutlet weak var department2Button: UIButton!
    @IBOutlet weak var department3Button: UIButton!
    @IBOutlet weak var department4Button: UIButton!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var pwdTextField: UITextField! //학번
    @IBOutlet weak var phoneTextField: UITextField!
    
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var pwdView: UIView!
    @IBOutlet weak var phoneView: UIView!
    
    let selectColor = UIColor.SomColor.Blue.mainBlue
    let noneColor = UIColor.white
    let noneLineColor = UIColor(red: 214/255, green: 209/255, blue: 230/255, alpha: 1.0).cgColor
    let selectTextColor = UIColor.white
    let noneTextColor = UIColor(red: 142/255, green: 142/255, blue: 142/255, alpha: 1.0)
    
    var departmentIdx = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackBtn(color: .black)
        setUI()
        
        checkTextField()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
        
        scrollTouchsBegan()
        
    }
    
    func setUI() {
        
        department2Button.layer.borderColor = noneLineColor
        department2Button.layer.borderWidth = 1
        department2Button.setTitleColor(noneTextColor, for: .normal)
        
        department3Button.layer.borderColor = noneLineColor
        department3Button.layer.borderWidth = 1
        department3Button.setTitleColor(noneTextColor, for: .normal)
        
        department4Button.layer.borderColor = noneLineColor
        department4Button.layer.borderWidth = 1
        department4Button.setTitleColor(noneTextColor, for: .normal)
        
    }
    
    func checkTextField() {
        
        nameTextField.addTarget(self, action: #selector(emptyNameCheck), for: .editingChanged)
        pwdTextField.addTarget(self, action: #selector(emptyPwdCheck), for: .editingChanged)
        phoneTextField.addTarget(self, action: #selector(emptyPhoneCheck), for: .editingChanged)
        
    }
    
    //MARK: 이름 공백 체크 함수
    @objc func emptyNameCheck() {
        
        if nameTextField.text == ""{
            nameView.backgroundColor = UIColor.SomColor.Gray.viewGray
        } else {
            nameView.backgroundColor = UIColor.SomColor.Blue.viewBlue
        }
    }
    
    //MARK: 학번 공백 체크 함수
    @objc func emptyPwdCheck() {
        
        if pwdTextField.text == ""{
            pwdView.backgroundColor = UIColor.SomColor.Gray.viewGray
        } else {
            pwdView.backgroundColor = UIColor.SomColor.Blue.viewBlue
        }
    }
    
    //MARK: 전화번호 공백 체크 함수
    @objc func emptyPhoneCheck() {
        
        if phoneTextField.text == "" { //공백인 경우
            phoneView.backgroundColor = UIColor.SomColor.Gray.viewGray
        } else {
            phoneView.backgroundColor = UIColor.SomColor.Blue.viewBlue
        }
    }
    
    @IBAction func departmentAction(_ sender: UIButton) {
        
        let index = sender.tag

        if index == 1 {
            
            //선택
            department1Button.backgroundColor = selectColor
            department1Button.setTitleColor(selectTextColor, for: .normal)
            department1Button.layer.borderWidth = 0
            
            //미선택
            department2Button.backgroundColor = noneColor
            department2Button.setTitleColor(noneTextColor, for: .normal)
            department2Button.layer.borderColor = noneLineColor
            department2Button.layer.borderWidth = 1
            
            department3Button.backgroundColor = noneColor
            department3Button.setTitleColor(noneTextColor, for: .normal)
            department3Button.layer.borderColor = noneLineColor
            department3Button.layer.borderWidth = 1
            
            department4Button.backgroundColor = noneColor
            department4Button.setTitleColor(noneTextColor, for: .normal)
            department4Button.layer.borderColor = noneLineColor
            department4Button.layer.borderWidth = 1
        } else if index == 2 {
            
            //선택
            department2Button.backgroundColor = selectColor
            department2Button.setTitleColor(selectTextColor, for: .normal)
            department2Button.layer.borderWidth = 0
            
            //미선택
            department1Button.backgroundColor = noneColor
            department1Button.setTitleColor(noneTextColor, for: .normal)
            department1Button.layer.borderColor = noneLineColor
            department1Button.layer.borderWidth = 1
            
            department3Button.backgroundColor = noneColor
            department3Button.setTitleColor(noneTextColor, for: .normal)
            department3Button.layer.borderColor = noneLineColor
            department3Button.layer.borderWidth = 1
            
            department4Button.backgroundColor = noneColor
            department4Button.setTitleColor(noneTextColor, for: .normal)
            department4Button.layer.borderColor = noneLineColor
            department4Button.layer.borderWidth = 1
            
        } else if index == 3 {
            
            //선택
            department3Button.backgroundColor = selectColor
            department3Button.setTitleColor(selectTextColor, for: .normal)
            department3Button.layer.borderWidth = 0
            
            //미선택
            department2Button.backgroundColor = noneColor
            department2Button.setTitleColor(noneTextColor, for: .normal)
            department2Button.layer.borderColor = noneLineColor
            department2Button.layer.borderWidth = 1
            
            department1Button.backgroundColor = noneColor
            department1Button.setTitleColor(noneTextColor, for: .normal)
            department1Button.layer.borderColor = noneLineColor
            department1Button.layer.borderWidth = 1
            
            department4Button.backgroundColor = noneColor
            department4Button.setTitleColor(noneTextColor, for: .normal)
            department4Button.layer.borderColor = noneLineColor
            department4Button.layer.borderWidth = 1
            
        } else {
            
            //선택
            department4Button.backgroundColor = selectColor
            department4Button.setTitleColor(selectTextColor, for: .normal)
            department4Button.layer.borderWidth = 0
            
            //미선택
            department2Button.backgroundColor = noneColor
            department2Button.titleLabel?.textColor = noneTextColor
            department2Button.layer.borderColor = noneLineColor
            department2Button.layer.borderWidth = 1
            
            department3Button.backgroundColor = noneColor
            department3Button.titleLabel?.textColor = noneTextColor
            department3Button.layer.borderColor = noneLineColor
            department3Button.layer.borderWidth = 1
            
            department1Button.backgroundColor = noneColor
            department1Button.titleLabel?.textColor = noneTextColor
            department1Button.layer.borderColor = noneLineColor
            department1Button.layer.borderWidth = 1
        
        }
        
        departmentIdx = index
        print(index)
    }
    
    
    
    //MARK: 회원가입 다음 단계(2)로 이동
    @IBAction func nextAction(_ sender: Any) {
        
        if nameTextField.text == "" || pwdTextField.text == "" || phoneTextField.text == "" {
            nameView.backgroundColor = UIColor.SomColor.Red.viewRed
            pwdView.backgroundColor = UIColor.SomColor.Red.viewRed
            phoneView.backgroundColor = UIColor.SomColor.Red.viewRed
        } else {
            let vc = UIStoryboard(name: "Sign", bundle: nil).instantiateViewController(identifier: Join2ViewController.reuseIdentifier) as! Join2ViewController
            
            vc.majorId = departmentIdx
            vc.name = gsno(nameTextField.text)
            vc.studentId = gsno(pwdTextField.text)
            vc.phone = gsno(phoneTextField.text)
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

}

//MARK: 키보드 대응 extension
extension Join1ViewController : UITextFieldDelegate{
    
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

}

