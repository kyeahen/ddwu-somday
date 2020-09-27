//
//  NoticeViewController.swift
//  Somday
//
//  Created by 김예은 on 2020/08/21.
//  Copyright © 2020 kyeahen. All rights reserved.
//

import UIKit

class NoticeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    
    var searchActive : Bool = false
    var filtered:[String] = []
    
    var allNotices: [Notice] = [Notice]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var topData: TopNotice? {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var searchData: [Notice] = [Notice]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var isTop = false
    var category = "All"
    var allPage = 1
    var ctPage = 1
    
    var hasNextPage = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setTableView()
        getAllNoticeData(page: allPage)
    }
    
    func setUI() {
        setSideBarButtonItem()
        setNavigationBar()
        self.searchTextField.delegate = self
        searchTextField.addTarget(self, action: #selector(NoticeViewController.textFieldDidChange(_:)),
        for: UIControl.Event.editingChanged)
        
        tableView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
    }
    
    func setTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.tableFooterView = UIView(frame: .zero)
    }
    
    @IBAction func menuAction(_ sender: UIButton) {
        
        let index = sender.tag
        
        if index == 0 { //전체
            isTop = false
            category = "All"
            allPage = 1
            searchActive = false
            
            button1.setTitleColor(.white, for: .normal)
            button1.backgroundColor = UIColor.SomColor.Blue.mainBlue
            
            button2.setTitleColor(UIColor.SomColor.Gray.menuGray, for: .normal)
            button2.backgroundColor = UIColor.SomColor.Blue.viewBlue
            button3.setTitleColor(UIColor.SomColor.Gray.menuGray, for: .normal)
            button3.backgroundColor = UIColor.SomColor.Blue.viewBlue
            button4.setTitleColor(UIColor.SomColor.Gray.menuGray, for: .normal)
            button4.backgroundColor = UIColor.SomColor.Blue.viewBlue
            
            self.getAllNoticeData(page: allPage)
            
        } else if index == 1 { //학과 공지
            category = "major"
            ctPage = 1
            searchActive = false
            
            button2.setTitleColor(.white, for: .normal)
            button2.backgroundColor = UIColor.SomColor.Blue.mainBlue
            
            button1.setTitleColor(UIColor.SomColor.Gray.menuGray, for: .normal)
            button1.backgroundColor = UIColor.SomColor.Blue.viewBlue
            button3.setTitleColor(UIColor.SomColor.Gray.menuGray, for: .normal)
            button3.backgroundColor = UIColor.SomColor.Blue.viewBlue
            button4.setTitleColor(UIColor.SomColor.Gray.menuGray, for: .normal)
            button4.backgroundColor = UIColor.SomColor.Blue.viewBlue
            
            self.getCategoryData(categoryId: "major", page: ctPage)
            self.getTopData()
            
        } else if index == 2 { //취업
            isTop = false
            category = "CT02"
            ctPage = 1
            searchActive = false
            
            button3.setTitleColor(.white, for: .normal)
            button3.backgroundColor = UIColor.SomColor.Blue.mainBlue
            
            button1.setTitleColor(UIColor.SomColor.Gray.menuGray, for: .normal)
            button1.backgroundColor = UIColor.SomColor.Blue.viewBlue
            button2.setTitleColor(UIColor.SomColor.Gray.menuGray, for: .normal)
            button2.backgroundColor = UIColor.SomColor.Blue.viewBlue
            button4.setTitleColor(UIColor.SomColor.Gray.menuGray, for: .normal)
            button4.backgroundColor = UIColor.SomColor.Blue.viewBlue
            
            self.getCategoryData(categoryId: "CT02", page:  ctPage)
            
        } else { //공모전
            isTop = false
            category = "CT03"
            ctPage = 1
            searchActive = false
            
            button4.setTitleColor(.white, for: .normal)
            button4.backgroundColor = UIColor.SomColor.Blue.mainBlue
            
            button1.setTitleColor(UIColor.SomColor.Gray.menuGray, for: .normal)
            button1.backgroundColor = UIColor.SomColor.Blue.viewBlue
            button2.setTitleColor(UIColor.SomColor.Gray.menuGray, for: .normal)
            button2.backgroundColor = UIColor.SomColor.Blue.viewBlue
            button3.setTitleColor(UIColor.SomColor.Gray.menuGray, for: .normal)
            button3.backgroundColor = UIColor.SomColor.Blue.viewBlue
            
            self.getCategoryData(categoryId: "CT03", page: ctPage)
        }
        
        print(index)
    }
    
    @objc func hideKeyboard() {
      view.endEditing(true)
      //textField.resignFirstResponder()  /* This line also worked fine for me */
    }
        
}

extension NoticeViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        if isTop {
            return 2
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchActive {
            if isTop {
                if section == 0 {
                    return 1
                } else {
                    return searchData.count
                }
            }
            
            return searchData.count
        } else {
            if isTop {
                if section == 0 {
                    return 1
                } else {
                    return allNotices.count
                }

            }
            return allNotices.count
        }
    }
    
    func isLastestRow(row: Int) -> Bool {
        if isTop {
           return (row == tableView.numberOfRows(inSection: 1) - 1)
        }
        
        return (row == tableView.numberOfRows(inSection: 0) - 1)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NoticeTableViewCell.reuseIdentifier) as! NoticeTableViewCell
        
        if isLastestRow(row: indexPath.row){
            
            if hasNextPage == true {
                
                if category == "All" {
                    allPage += 1
                    getAllNoticeData(page: allPage)
                } else {
                    ctPage += 1
                    getCategoryData(categoryId: category, page: ctPage)
                }
            }
        }
        
        if searchActive {
            
            if !isTop {
                cell.titleLabel.text = searchData[indexPath.row].title
                cell.menuLabel.text = searchData[indexPath.row].category.name
                
                let str = self.stringToDate(dateString: searchData[indexPath.row].registeredAt, format: "yyyy-MM-dd HH:mm:ss")
                let date = self.getDate(format: "yyyy.MM.dd", date: str)
                cell.dateLabel.text = date
                
                cell.contentLabel.text = searchData[indexPath.row].content
        
                cell.pinImage.isHidden = true
                cell.menuLeadingC.constant = 16
                cell.backView.backgroundColor = .white
            } else {
                
                if indexPath.section == 0 {
                    cell.titleLabel.text = topData?.title
                    cell.menuLabel.text = topData?.category.name
                    
                    let str = self.stringToDate(dateString: gsno(topData?.registeredAt), format: "yyyy-MM-dd HH:mm:ss")
                    let date = self.getDate(format: "yyyy.MM.dd", date: str)
                    cell.dateLabel.text = date
                    
                    cell.contentLabel.text = topData?.content
                    
                    cell.pinImage.isHidden = false
                    cell.menuLeadingC.constant = 32
                    cell.backView.backgroundColor = UIColor.SomColor.Blue.viewBlue
                } else {
                    cell.titleLabel.text = searchData[indexPath.row].title
                    cell.menuLabel.text = searchData[indexPath.row].category.name
                    
                    let str = self.stringToDate(dateString: searchData[indexPath.row].registeredAt, format: "yyyy-MM-dd HH:mm:ss")
                    let date = self.getDate(format: "yyyy.MM.dd", date: str)
                    cell.dateLabel.text = date
                    
                    cell.contentLabel.text = searchData[indexPath.row].content
                    
                    cell.pinImage.isHidden = true
                    cell.menuLeadingC.constant = 16
                    cell.backView.backgroundColor = .white
                }
            }

        } else {
            
            if !isTop {
                cell.titleLabel.text = allNotices[indexPath.row].title
                cell.menuLabel.text = allNotices[indexPath.row].category.name
                
                let str = self.stringToDate(dateString: allNotices[indexPath.row].registeredAt, format: "yyyy-MM-dd HH:mm:ss")
                let date = self.getDate(format: "yyyy.MM.dd", date: str)
                cell.dateLabel.text = date
                
                cell.contentLabel.text = allNotices[indexPath.row].content
                
                cell.pinImage.isHidden = true
                cell.menuLeadingC.constant = 16
                cell.backView.backgroundColor = .white
            } else {
                
                if indexPath.section == 0 {
                    cell.titleLabel.text = topData?.title
                    cell.menuLabel.text = topData?.category.name
                    
                    let str = self.stringToDate(dateString: gsno(topData?.registeredAt), format: "yyyy-MM-dd HH:mm:ss")
                    let date = self.getDate(format: "yyyy.MM.dd", date: str)
                    cell.dateLabel.text = date
                    
                    cell.contentLabel.text = topData?.content
                    
                    cell.pinImage.isHidden = false
                    cell.menuLeadingC.constant = 32
                    cell.backView.backgroundColor = UIColor.SomColor.Blue.viewBlue
                } else {
                    cell.titleLabel.text = allNotices[indexPath.row].title
                    cell.menuLabel.text = allNotices[indexPath.row].category.name
                    
                    let str = self.stringToDate(dateString: allNotices[indexPath.row].registeredAt, format: "yyyy-MM-dd HH:mm:ss")
                    let date = self.getDate(format: "yyyy.MM.dd", date: str)
                    cell.dateLabel.text = date
                    
                    cell.contentLabel.text = allNotices[indexPath.row].content
                    
                    cell.pinImage.isHidden = true
                    cell.menuLeadingC.constant = 16
                    cell.backView.backgroundColor = .white
                }
                
            }
            
        }
        
        return cell
    }
    
    
    //상세보기로 넘어가기
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if searchActive {
            let vc = UIStoryboard(name: "Notice", bundle: nil).instantiateViewController(identifier: DetailNoticeViewController.reuseIdentifier) as! DetailNoticeViewController
            vc.idx = searchData[indexPath.row].id
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = UIStoryboard(name: "Notice", bundle: nil).instantiateViewController(identifier: DetailNoticeViewController.reuseIdentifier) as! DetailNoticeViewController
            vc.idx = allNotices[indexPath.row].id
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
}


extension NoticeViewController {
    
    func getAllNoticeData(page: Int) {
        
        NoticeService.shareInstance.getAllNoticeData(page: page, completion: {
            (result) in
            
            switch result {
            case .networkSuccess(let data) :
                let noticeData = data as? NoticeData
                
                if let resResult = noticeData?.data {
                    
                    if resResult.pagination.page == 1 {
                        
                        self.hasNextPage = true
                        self.allNotices = resResult.noticeList

                    } else {
                        
                        self.hasNextPage = true
                        
                        for i in 0..<resResult.noticeList.count {
                            self.allNotices.append(resResult.noticeList[i])
                        }
                    }
                    
                    if resResult.pagination.remainPage == 0 {
        
                        self.hasNextPage = false
                    }
                }
                
                break
                
            case .networkFail :
                self.showToast(message: "네트워크 상태를 확인해주세요.", yValue: 110)
                break
                
            default :
                self.showToast(message: "다시 시도해주세요.", yValue: 110)
                break
            }
        })
    }
    
    func getCategoryData(categoryId: String, page: Int) {
        
        NoticeService.shareInstance.getCategoryData(categoryId: categoryId, page: page, completion: {
            (result) in
            
            switch result {
            case .networkSuccess(let data) :
                let noticeData = data as? NoticeData
                
               if let resResult = noticeData?.data {
                
                    if resResult.pagination.page == 1 {
                        self.hasNextPage = true
                        self.allNotices = resResult.noticeList
                    } else {
                        self.hasNextPage = true
                        
                        for i in 0..<resResult.noticeList.count {
                            self.allNotices.append(resResult.noticeList[i])
                        }
                    }
                    
                    if resResult.pagination.remainPage == 0 {
                        self.hasNextPage = false
                    }
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
    
    func getTopData() {
        
        TopNoticeService.shareInstance.getTopData(completion: {
            (result) in
            
            switch result {
            case .networkSuccess(let data) :
                let topData = data as? TopNotice
                
                if let resResult = topData {
                    self.isTop = true
                    self.topData = resResult
                    
                } else {
                    self.isTop = false
                }
                
                print(self.isTop)
                
                
                break
                
            case .networkFail :
                self.showToast(message: "네트워크 상태를 확인해주세요.", yValue: 110)
                break
                
            default :
                self.showToast(message: "다시 시도해주세요.", yValue: 110)
                break
            }
        })
    }
    
    func getAllSerchData(word: String) {
        
        SearchNoticeService.shareInstance.getAllSearchData(word: word, completion: {
            (result) in
            
            switch result {
            case .networkSuccess(let data) :
                let searchData = data as? [Notice]
                
                if let resResult = searchData {
                    self.searchActive = true
                    self.searchData = resResult
                } else {
                    self.searchActive = false
                }

                break
                
                case .badRequest :
                    self.showToast(message: "검색 결과가 없습니다.", yValue: 110)
                    break
                    
                case .searchNull :
                    self.allPage = 1
                    self.getAllNoticeData(page: self.allPage)
                    break
                
            case .networkFail :
                self.showToast(message: "네트워크 상태를 확인해주세요.", yValue: 110)
                break
                
            default :
                self.showToast(message: "다시 시도해주세요.", yValue: 110)
                break
            }
        })
    }
    
    func getCategorySerchData(categoryId: String, word: String) {
        
        NoticeService.shareInstance.getCategorySearchData(categoryId: categoryId, word: word, completion: {
            (result) in
            
            switch result {
            case .networkSuccess(let data) :
                let searchData = data as? NoticeData
                
                if let resResult = searchData?.data.noticeList {
                    self.searchActive = true
                    self.searchData = resResult
                } else {
                    self.searchActive = false
                }

                break
                
                case .badRequest :
                    self.showToast(message: "검색 결과가 없습니다.", yValue: 110)
                    break
                    
                case .searchNull :
                    
                    break
                
            case .networkFail :
                self.showToast(message: "네트워크 상태를 확인해주세요.", yValue: 110)
                break
                
            default :
                self.showToast(message: "다시 시도해주세요.", yValue: 110)
                break
            }
        })
    }
    
    
}

extension NoticeViewController: UITextFieldDelegate {
    
    @objc func textFieldDidChange(_ textField: UITextField) {

        if let searchText  = textField.text {
            
//            if category == "All" {
                if searchText == "" {
                    self.searchActive = false
                    self.allPage = 1
                    self.getAllNoticeData(page: allPage)
                
                } else {
                    self.getAllSerchData(word: searchText)
                }
               
//            } else {
//                if searchText == "" {
//                    self.ctPage = 1
//                    self.getCategoryData(categoryId: category, page: ctPage)
//                } else {
//                    self.getCategorySerchData(categoryId: category, word: searchText)
//                }
//            }
            //self.getAllSerchData(word: searchText)
        }
    }
}
