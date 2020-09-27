//
//  MemoTableViewCell.swift
//  Somday
//
//  Created by 김예은 on 2020/08/18.
//  Copyright © 2020 kyeahen. All rights reserved.
//

import UIKit

class MemoTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var contentTextField: UITextField!
    @IBOutlet weak var backdView: UIView!
    @IBOutlet weak var memoTextfield: UITextField!
    
    
    var actionClosure : (()->Void)? = nil
    var checkClosure : (()->Void)? = nil
    var touchClosure : (()->Void)? = nil
    
    var startIdx: Int = 0
    var endIdx: Int = 0
    
    var isCheck = false {
        didSet {
            if self.isCheck == true {
                self.checkButton.setImage(UIImage(named: "btCheck"), for: .normal)
            } else{
                self.checkButton.setImage(UIImage(named: "btUncheck"), for: .normal)
            }
        }
    }

    @IBAction func memoStartAction(_ sender: UITextField) {
        self.touchClosure?()
        print("수정~")
        print("!!!!!!!!!!!!\(startIdx)")
    }
    
    @IBAction func memoTextFieldAction(_ sender: UITextField) {
        self.actionClosure?()
        print("??????????\(endIdx)")
        print("textFieldDidEndEditing: \((sender.text) ?? "Empty")")
    }

    @IBAction func checkAction(_ sender: UIButton) {

        self.checkClosure?()
        isCheck = !isCheck
        print("cell : \(isCheck)")
    }
    
    

}
