//
//  ReservationViewController.swift
//  Somday
//
//  Created by 김예은 on 2020/08/21.
//  Copyright © 2020 kyeahen. All rights reserved.
//

import UIKit

class ReservationViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var termLabel: UILabel!
    
    @IBOutlet weak var reservationStatusView: UIView!
    @IBOutlet weak var status1Label: UILabel!
    @IBOutlet weak var status2Label: UILabel!
    @IBOutlet weak var status3Label: UILabel!
    @IBOutlet weak var status4Label: UILabel!
    
    @IBOutlet weak var CancelButton: UIButton!
    
    var array: [Int] = []
    var temp: [Int] = []
    
    var selected: [Int: Bool] = [:]
    
    var checkStatus = true
    var reservationStatus = false //예약 여부 상태 (true : 신청, false : 미신청)
    
    var allCheck = false
    var delete = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 0..<array.count {
            selected.updateValue(true, forKey: array[i])
        }
        
        print(selected.description)
        
        temp = array
        print(temp.description)

        setTableView()
        setUI()
        
        //통신 관련
        if !reservationStatus { //미신청
            reservationStatusView.isHidden = true
            CancelButton.isHidden = true
         
            //TODO: 상태에 따른 색깔 체인지
//            status1Label.textColor = UIColor.SomColor.Red.mainRed
//            status1Label.textColor = UIColor.SomColor.Gray.resGray
        } else { //신청 상태 (예약 대기, 예약 완료 1일전만 가능)
            reservationStatusView.isHidden = false
            CancelButton.isHidden = false
        }
    }
    
    func setUI() {
        setBackBtn(color: .black)
        
    }
    
    func setTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let nibName = UINib(nibName: FooterReservationTableViewCell.reuseIdentifier, bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: FooterReservationTableViewCell.reuseIdentifier)
    }
    
    func printArray() {
        for i in 0..<array.count  {
            print("s:\(array[i])")
        }
    }
    
    
    //MARK: 전체선택 액션
    @IBAction func allSelectAcion(_ sender: Any) {
        allCheck = true
        print("all")
        checkStatus = true
        self.tableView.reloadData()
    }
    
    //MARK: 삭제 액션
    @IBAction func deleteAction(_ sender: Any) {
        self.delete = true
        for i in 0..<temp.count {
            if array.contains(temp[i]) {
                array.remove(temp[i])
            }
        }
        
        temp.removeAll()
        print("삭제 temp: \(temp.description)")
        print("삭제 arr: \(array.description)")
        print(array.count)
        checkStatus = false
        self.tableView.reloadData()
    }
    
    //MARK: 예약하기 액션
    @IBAction func reservationAction(_ sender: Any) {
    }
    
    
}

extension ReservationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let lastIdx = array.count
        
        if array.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: FooterReservationTableViewCell.reuseIdentifier) as! FooterReservationTableViewCell
                
                cell.countLabel.text = "총 0개 기기"
                cell.costLabel.text = "연체비 0원" //기기대여 상태가 연체일때만 계산됨
            
                
                return cell
            
        } else {
            if indexPath.row == lastIdx {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: FooterReservationTableViewCell.reuseIdentifier) as! FooterReservationTableViewCell
                
                cell.countLabel.text = "총 \(temp.count)개 기기"
                cell.costLabel.text = "연체비 0원" //기기대여 상태가 연체일때만 계산됨
            
                
                return cell
                
            } else {
                
                
                let cell = tableView.dequeueReusableCell(withIdentifier: ReservationTableViewCell.reuseIdentifier) as! ReservationTableViewCell
                
                if allCheck {
                    cell.isCheck = true
                    print("전)전체선택 array : \(array.description)")
                    print("전)전체선택 temp : \(temp.description)")
                    
                    if array.count != temp.count {
                        for i in 0..<array.count  {
                            if !temp.contains(array[i]) {
                                temp.append(array[i])
                            }
                        }
                        temp.sort()
                        print("후)전체선택(정렬) temp: \(temp.description)")
                    }
                    allCheck = false
                }
                
                
                cell.titleLabel.text = array[indexPath.row].description
                
                if indexPath.row % 2 == 0 {
                    cell.backView.backgroundColor = UIColor.SomColor.Gray.viewGray
                } else {
                    cell.backView.backgroundColor = .white
                }
                
                cell.isCheck = self.checkStatus
                
                cell.checkClosure = { [weak self] in
                    
                    self?.checkStatus = cell.isCheck
                            
                    print("view: \(cell.isCheck)")
                    
                    if cell.isCheck { // true(미선택)
                        
                        //TODO: 여기서는 id로 지워야할듯
                        self?.temp.remove(indexPath.row)
                                                
                    } else { //false(선택)
    
                        self?.temp.append(indexPath.row)
                    }
                    self?.temp.sort()
                    print("temp : \(self?.temp.description)")

                }
                
                return cell
            }
        }
        
        
        
        
    
    }
    
    
    
}
