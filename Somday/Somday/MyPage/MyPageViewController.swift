//
//  MyPageViewController.swift
//  Somday
//
//  Created by 김예은 on 2020/08/19.
//  Copyright © 2020 kyeahen. All rights reserved.
//

import UIKit
import SideMenuSwift

class MyPageViewController: UIViewController, SideMenuControllerDelegate {

    @IBOutlet weak var topC: NSLayoutConstraint!
    @IBOutlet weak var profileViewTopC: NSLayoutConstraint!
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var departmentLabel: UILabel!
    @IBOutlet weak var studentIdLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var menu = ["개인정보 수정", "기기 대여 / 야작 신청 조회", "버스 시간 확인 및 알람", "편의시설 정보 안내", "의견 보내기", "로그아웃 하기"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationBar()
        setLeftBarButtonItem()
        setUI()
        
        setTableView()
        
        sideMenuController?.delegate = self
        
        getMainStudentData()
    }

    func setTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
    
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    func setUI() {
        
        //네비바 길이만큼 화면 올리기
        let navBarHeight = UIApplication.shared.statusBarFrame.size.height +
           (navigationController?.navigationBar.frame.height ?? 0.0)
        
        
        topC.constant -= navBarHeight
        profileViewTopC.constant -= navBarHeight
        print(navBarHeight)
    }
    
    //MARK: 백버튼
       func setLeftBarButtonItem() {
           
           let leftButtonItem = UIBarButtonItem.init(
               image: UIImage(named: "btBackarroWhite"),
               style: .plain,
               target: self,
               action: #selector(alarmAction(sender:))
           )
           
           self.navigationItem.leftBarButtonItem = leftButtonItem
        self.navigationItem.leftBarButtonItem?.tintColor = .white
       }
       
       //알림 액션
       @objc func alarmAction(sender: UIBarButtonItem) {
            sideMenuController?.hideMenu()
       }

}

extension MyPageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MenuTableViewCell.reuseIdentifier) as! MenuTableViewCell
        
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = .white
        } else {
            cell.backgroundColor = UIColor(red: 239/255, green: 243/255, blue: 255/255, alpha: 1.0)
        }
        
        cell.titleLabel.text = menu[indexPath.row]

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 { //개인정보 수정
            let vc = UIStoryboard(name: "MyPage", bundle: nil).instantiateViewController(identifier: ModifyDataViewController.reuseIdentifier)
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else if indexPath.row == 1{ //기기 대여, 야작 신청 조회
            let vc = UIStoryboard(name: "MyPage", bundle: nil).instantiateViewController(identifier: LookUpViewController.reuseIdentifier)
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else if indexPath.row == 2 { //버스 알림
            let vc = UIStoryboard(name: "MyPage", bundle: nil).instantiateViewController(identifier: BusViewController.reuseIdentifier)
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else if indexPath.row == 3 { //편의 시설
            let vc = UIStoryboard(name: "MyPage", bundle: nil).instantiateViewController(identifier: FacilityViewController.reuseIdentifier)
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 4 { //의견 보내기 (팝업)
            let vc = UIStoryboard(name: "MyPage", bundle: nil).instantiateViewController(identifier: SendOpnionPopUpViewController.reuseIdentifier) 
             
            self.addChild(vc)
            vc.view.frame = self.view.frame
            self.view.addSubview(vc.view)
            vc.didMove(toParent: self)
        } else { //로그아웃
            UserDefaults.standard.removeObject(forKey: "token")
            let vc = UIStoryboard(name: "Sign", bundle: nil).instantiateViewController(identifier: "SignNaviVC")
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
            
 
    }
    
}

extension MyPageViewController {
    
    func getMainStudentData() {
        
        MainStudentService.shareInstance.getMainStudentData(completion: {
            (result) in
            
            switch result {
            case .networkSuccess(let data) :
                let data = data as? StudentData
                
                if let resResult = data {
                    self.nameLabel.text = resResult.data.name
                    self.departmentLabel.text = "\(resResult.data.major.name) 디자인학과"
                    self.studentIdLabel.text = resResult.data.studentId
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
