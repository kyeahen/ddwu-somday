//
//  DeviceViewController.swift
//  Somday
//
//  Created by 김예은 on 2020/08/19.
//  Copyright © 2020 kyeahen. All rights reserved.
//

import UIKit

class DeviceViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var termLabel: UILabel!
    @IBOutlet weak var reservationButton: UIButton!
    
    @IBOutlet weak var mediaMenuView: UIView!
    @IBOutlet weak var media1Button: UIButton!
    @IBOutlet weak var media2Button: UIButton!
    @IBOutlet weak var media3Button: UIButton!
    @IBOutlet weak var media4Button: UIButton!
    @IBOutlet weak var media5Button: UIButton!
    
    var selectedList: [Int] = [] //이게 인덱스만 넘기는게 아니라 모델을 선택해서 넘겨야함
    var checkStatus = false
    
    var selected: [Int: Bool] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setTableView()
        //기본 날짜 세팅
        termLabel.text = "\(getTodayDate(format: "yyyy.MM.dd")) - \(getDate(format: "yyyy.MM.dd", date: Date.tomorrow))"

    }
    
    func setUI() {
        setNavigationBar()
        setSideBarButtonItem()
    }
    
    func setTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func printArray() {
    
        for i in 0..<selectedList.count  {
            
            print("P:\(selectedList[i])")
        }
    }
    
    //MARK: 메뉴 액션
    @IBAction func menuAction(_ sender: UIButton) {
        
        let index = sender.tag
        
        if index == 0 { //전체
            setSelectButton(media1Button)
            setNoneButton(media2Button)
            setNoneButton(media3Button)
            setNoneButton(media4Button)
            setNoneButton(media5Button)
            
        } else if index == 1 { //카메라
            setSelectButton(media2Button)
            setNoneButton(media1Button)
            setNoneButton(media3Button)
            setNoneButton(media4Button)
            setNoneButton(media5Button)
            
        } else if index == 2 { //조명
            setSelectButton(media3Button)
            setNoneButton(media1Button)
            setNoneButton(media2Button)
            setNoneButton(media4Button)
            setNoneButton(media5Button)
            
        } else if index == 3 { //삼각대
            setSelectButton(media4Button)
            setNoneButton(media1Button)
            setNoneButton(media2Button)
            setNoneButton(media3Button)
            setNoneButton(media5Button)
            
        } else { //기타
            setSelectButton(media5Button)
            setNoneButton(media1Button)
            setNoneButton(media2Button)
            setNoneButton(media3Button)
            setNoneButton(media4Button)
            
        }
        
        print(index)
    }
    
    //MARK: 메뉴 버튼 비활성화
    func setNoneButton(_ button: UIButton) {
        button.setTitleColor(UIColor.SomColor.Gray.menuGray, for: .normal)
        button.backgroundColor = UIColor.SomColor.Blue.viewBlue
    }
    
    //MARK: 메뉴 버튼 활성화
    func setSelectButton(_ button: UIButton) {
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.SomColor.Blue.mainBlue
    }
    
    @IBAction func reservationAction(_ sender: Any) {
        let vc = UIStoryboard(name: "Device", bundle: nil).instantiateViewController(identifier: ReservationViewController.reuseIdentifier) as! ReservationViewController
        
        vc.array = selectedList
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func caalendarAction(_ sender: Any) {
        let vc = UIStoryboard(name: "Device", bundle: nil).instantiateViewController(identifier: DeviceCalenderViewController.reuseIdentifier) as! DeviceCalenderViewController

        self.present(vc, animated: true, completion: nil)
    }
    
    
}

extension DeviceViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DeviceTableViewCell.reuseIdentifier) as! DeviceTableViewCell
        
        cell.isCheck = checkStatus
        cell.idx = indexPath.row
        cell.actionClosure = { [weak self] in
            //self?.simpleAlert(title: cell.isCheck.description, message: "")
            /*
             false = 미선택
             true = 체크
             뷰: 미선택(false) -> 셀 : 미선택 (클릭) 셀 : 선택(true) -> 뷰: 선택
             */
            print("view: \(cell.isCheck)")
            
            if cell.isCheck { // true(미선택)
                
                cell.checkButton.setImage(UIImage(named: "btUncheck"), for: .normal)
                self?.selectedList.remove(indexPath.row)
                self?.printArray()
            } else { //false(선택)
                cell.checkButton.setImage(UIImage(named: "btCheck"), for: .normal)
                self?.selectedList.append(indexPath.row)
                self?.printArray()
                
            }
            
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
    
}
