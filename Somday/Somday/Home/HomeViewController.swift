//
//  HomeViewController.swift
//  Somday
//
//  Created by 김예은 on 2020/08/18.
//  Copyright © 2020 kyeahen. All rights reserved.
//

import UIKit
import SideMenuSwift

class HomeViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var departmentLabel: UILabel!
    @IBOutlet weak var idNameLabel: UILabel!
    

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var ddayLabel: UILabel!
    @IBOutlet weak var applyTimeLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addMemoButton: UIButton!
    
    var count = 3
    //var data = ["aa", "bb", "cc"]
    
    var isEdited = false
    
    var isAdd = false
    
    var memos: [Memo] = [Memo]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableView()
        setUI()
        getMemoList()
        getMainStudentData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getMemoList()
        getMainStudentData()
    }
    
    func setUI() {
        dateLabel.text = self.getTodayDate(format: "yyyy년 MM월 dd일")
        ddayLabel.text = self.setDday(start: "2020/09/01", format: "yyyy/MM/dd")
        
        let time = stringToDate(dateString: getTodayDate(format: "HH:mm:ss"), format: "HH:mm:ss")
        
        applyTimeLabel.text = self.setHours(start: time)
        
        
        //네비게이션바
        setNavigationBar()
        setLeftBarButtonItem() //알림 버튼
        setSideBarButtonItem() //사이드바 버튼
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func setTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    //MARK: 메모 추가 액션
    @IBAction func AddMemoAction(_ sender: Any) {
        
        isAdd = true
        print(isAdd)
        self.tableView.reloadData()
        
    }
    
    //MARK: 알림 버튼
    func setLeftBarButtonItem() {
        
        let leftButtonItem = UIBarButtonItem.init(
            image: UIImage(named: "icBall"),
            style: .plain,
            target: self,
            action: #selector(alarmAction(sender:))
        )
        
        self.navigationItem.leftBarButtonItem = leftButtonItem
        self.navigationItem.leftBarButtonItem?.tintColor = .black
    }
    
    //알림 액션
    @objc func alarmAction(sender: UIBarButtonItem) {
        let alarmVC = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(identifier: AlarmViewController.reuseIdentifier)
        
        self.navigationController?.pushViewController(alarmVC, animated: true)
    }
    

}

extension HomeViewController {
    
    func getMainStudentData() {
        
        MainStudentService.shareInstance.getMainStudentData(completion: {
            (result) in
            
            switch result {
            case .networkSuccess(let data) :
                let data = data as? StudentData
                
                if let resResult = data {
                    self.idNameLabel.text = "\(resResult.data.studentId) \(resResult.data.name)"
                    self.departmentLabel.text = "\(resResult.data.major.name)"
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
    
    func getMemoList() {
        
        MemoService.shareInstance.getMemoList(completion: {
            (result) in
            
            switch result {
            case .networkSuccess(let data) :
                let memoData = data as? [Memo]
                
                if let resResult = memoData {
                    self.memos = resResult
                    //메모를 id순으로 정렬
                    self.memos = self.memos.sorted(by: {$0.id < $1.id})
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
    
    func postMemo(content: String) {
        
        let params : [String : Any] = ["content" : content]
                                       
        
        DefaultMemoService.shareInstance.postMemo(params: params, completion: {
            (result) in
            
            switch result {
            case .networkSuccess(_) :
                self.getMemoList()
                break
                
            case .badRequest :
                self.showToast(message: "내용을 입력해주세요.", yValue: 110)
                
            case .networkFail :
                self.showToast(message: "네트워크 상태를 확인해주세요.", yValue: 110)
                
            default :
                self.showToast(message: "다시 시도해주세요.", yValue: 110)
                break
            }
        })
    }
    
    func putMemo(idx: Int, content: String) {
        
        let params : [String : Any] = ["content" : content]
        
        DefaultMemoService.shareInstance.putMemo(idx: idx, params: params, completion: { (result) in

            switch result {
            case .networkSuccess(_):
                self.getMemoList()
                break
                
            case .badRequest :
                self.showToast(message: "내용을 입력해주세요.", yValue: 110)
                break

            
            case .networkFail :
                self.showToast(message: "네트워크 상태를 확인해주세요.", yValue: 110)
                
            default :
                self.showToast(message: "다시 시도해주세요.", yValue: 110)
                break
            }
        })
    }
    
    func deleteMemo(idx: Int) {
        
        DefaultMemoService.shareInstance.deleteMemo(idx: idx, completion: { (result) in

            switch result {
            case .networkSuccess(_):
                self.getMemoList()
                break

            
            case .networkFail :
                self.showToast(message: "네트워크 상태를 확인해주세요.", yValue: 110)
                
            default :
                self.showToast(message: "다시 시도해주세요.", yValue: 110)
                break
            }
        })
    }
    
    func putCheck(idx: Int, check: Bool) {
          
        DefaultMemoService.shareInstance.putCheck(idx: idx, checked : check, params: [:], completion: { (result) in

            switch result {
            case .networkSuccess(_):
                self.getMemoList()
                break
                
            case .badRequest :
                //self.showToast(message: "내용을 입력해주세요.", yValue: 110)
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

//MARK: TableView extension
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MemoTableViewCell.reuseIdentifier) as! MemoTableViewCell
        
        if isAdd { //메모 추가 액션
            
            postMemo(content: " ")
            isAdd = false
        }
        
        if indexPath.row % 2 == 0 {
            cell.backdView.backgroundColor = UIColor(red: 244/255, green: 244/255, blue: 244/255, alpha: 1.0)
        } else {
            cell.backdView.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        }
        
        cell.contentTextField.text = memos[indexPath.row].content

        
        cell.touchClosure = { [weak self] in
            
            if let idx = self?.memos[indexPath.row].id {
               cell.startIdx = idx
            }
            
        }
        
        cell.actionClosure = { [weak self] in
            cell.endIdx = self?.memos[indexPath.row].id ?? 0
            let prevContent = self?.memos[indexPath.row].content
            let newContent = self?.gsno(cell.contentTextField.text)
            if prevContent != newContent && cell.startIdx == cell.endIdx { //이때만 통신
                guard let idx = self?.memos[indexPath.row].id else {return}
                guard let content = cell.contentTextField.text else {return}
                self?.putMemo(idx: idx, content: content)
            }
        }

        cell.isCheck = memos[indexPath.row].checked

        cell.checkClosure = { [weak self] in
            
            guard let idx = self?.memos[indexPath.row].id else {return}
            self?.putCheck(idx: idx, check: !cell.isCheck)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = UIContextualAction(style: .normal, title: "삭제") { (action, sourceView, completionHandler) in
            
            let idx = self.memos[indexPath.row].id
            self.deleteMemo(idx: idx)
            
            completionHandler(true)
        }
        delete.backgroundColor = UIColor.SomColor.Red.mainRed
        
        let swipeActionConfig = UISwipeActionsConfiguration(actions: [delete])
        swipeActionConfig.performsFirstActionWithFullSwipe = false
        return swipeActionConfig
    }
}

extension HomeViewController {
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
}
