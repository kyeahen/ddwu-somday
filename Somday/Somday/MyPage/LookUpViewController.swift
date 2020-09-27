//
//  LookUpViewController.swift
//  Somday
//
//  Created by 김예은 on 2020/08/19.
//  Copyright © 2020 kyeahen. All rights reserved.
//

import UIKit

class LookUpViewController: UIViewController {

    @IBOutlet weak var topC: NSLayoutConstraint!
    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var status1Label: UILabel!
    @IBOutlet weak var status2Label: UILabel!
    @IBOutlet weak var status3Label: UILabel!
    @IBOutlet weak var status4Label: UILabel!
    
    @IBOutlet weak var deviceDataView: UIView!
    @IBOutlet weak var rentalDateLabel: UILabel!
    @IBOutlet weak var returnDateLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    
    @IBOutlet weak var applyDataView: UIView!
    @IBOutlet weak var applyDateLabel: UILabel!
    @IBOutlet weak var roomLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        setBackBtn(color: .white)
        setUI()
        getWorkData()
    }
    
    func setUI() {
        //네비바 길이만큼 화면 올리기
        var navBarHeight = UIApplication.shared.statusBarFrame.size.height +
           (navigationController?.navigationBar.frame.height ?? 0.0)
        
        topC.constant -= navBarHeight
        print(navBarHeight)
        
        backView.roundCorners([.topLeft, .topRight], radius: 20)
        deviceDataView.isHidden = true
    }
    
    //MARK: 상세보기 액션
    @IBAction func detailAction(_ sender: Any) {
        let vc = UIStoryboard(name: "Device", bundle: nil).instantiateViewController(withIdentifier: ReservationViewController.reuseIdentifier) as! ReservationViewController
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

}

extension LookUpViewController {
    
    func getWorkData() {
        
        WorkService.shareInstance.getWorkData(completion: {
            (result) in
            
            switch result {
            case .networkSuccess(let data) :
                let workData = data as? WorkData
                
                if let result = workData?.data {
                    print("이미 야작 신청한 상태")
                    let str = self.stringToDate(dateString: result.registeredAt, format: "yyyy-MM-dd HH:mm:ss")
                    let date = self.getDate(format: "yyyy.MM.dd", date: str)
                    self.applyDateLabel.text = date
                    
                    self.roomLabel.text = "\(result.room.name)호"
                    self.applyDataView.isHidden = false

                }
                else { //신청x
                    print("야작 신청 가능")
                    self.applyDataView.isHidden = true
                }
                
                break
                
            case .networkFail :
                self.showToast(message: "네트워크 상태를 확인해주세요.", yValue: 110)
                
            default :
                self.showToast(message: "다시 시도해주세요.", yValue: 110)
                break
            }
        })
    }
}
