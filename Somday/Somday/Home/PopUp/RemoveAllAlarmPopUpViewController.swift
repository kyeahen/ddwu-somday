//
//  RemoveAllAlarmPopUpViewController.swift
//  Somday
//
//  Created by 김예은 on 2020/08/21.
//  Copyright © 2020 kyeahen. All rights reserved.
//

import UIKit

class RemoveAllAlarmPopUpViewController: UIViewController {

    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var popUpView: UIView!
    
    @IBOutlet weak var okAction: UIButton!
    @IBOutlet weak var topC: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleView.roundCorners([.topRight, .topLeft], radius: 10)
        popUpView.backgroundColor = UIColor.SomColor.White.popupWhite
        okAction.layer.addBorder(edge: .left, color: UIColor.systemGray3, thickness: 1)
        
        self.showAnimate()
        self.setNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.recoverNavigationBar()
    }
    
    //MARK: 전체 삭제 액션
    @IBAction func okAction(_ sender: Any) {
        //TODO: 전체 삭제 통신
    }
    
    //MARK: 아니요 액션
    @IBAction func noneAction(_ sender: Any) {
        //네비바 덮기
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 0.0;
            self.recoverNavigationBar()
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        });
        
    }
    

}
