//
//  FacilityViewController.swift
//  Somday
//
//  Created by 김예은 on 2020/08/19.
//  Copyright © 2020 kyeahen. All rights reserved.
//

import UIKit

class FacilityViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var selectedCell: FacilityTableViewCell? = nil
    var selectedSection = 0
    var selectedCellRow = -1
    var expandedCells   = NSMutableArray()
    
    var hasNextPage = false
    var notices : [Notice] = [Notice]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    var noticePage = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setTableView()
        
        setBackBtn(color: .black)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        getCategoryData(categoryId: "CT04", page: noticePage)
    }
    
    func setTableView() {
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
}

extension FacilityViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notices.count
    }
    
    func isLastestRow(row: Int) -> Bool {
        return (row == tableView.numberOfRows(inSection: 0) - 1)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FacilityTableViewCell.reuseIdentifier) as! FacilityTableViewCell
        
        if isLastestRow(row: indexPath.row){
            
            if hasNextPage == true {
                noticePage += 1
                getCategoryData(categoryId: "CT04", page: noticePage)
            }
        }
        
        cell.titleLabel.text = notices[indexPath.row].title
        cell.contentLabel.text = notices[indexPath.row].content
        
        let str = self.stringToDate(dateString: notices[indexPath.row].registeredAt, format: "yyyy-MM-dd HH:mm:ss")
        let date = self.getDate(format: "yyyy.MM.dd", date: str)
        cell.dateLabel.text = date
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedCell = tableView.cellForRow(at: indexPath) as? FacilityTableViewCell
        selectedSection = indexPath.section
        selectedCellRow = indexPath.row
        
        if self.expandedCells.contains(indexPath) {
            self.expandedCells.remove(indexPath)
        } else{
            self.expandedCells.add(indexPath)
        }
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 74
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if selectedCell != nil && selectedSection == indexPath.section && selectedCellRow == indexPath.row {
            
            if self.expandedCells.contains(indexPath) {
                let tempTextView = selectedCell!.contentLabel
                var frame: CGRect
                
                frame = tempTextView!.frame
                frame.size.height = tempTextView!.intrinsicContentSize.height
                tempTextView!.frame = frame

                print(frame.size.height)
                return 130 + frame.size.height
            }else{
                print("bb")
                return 74
                
            }
        }else{
            print("cc")
            return 74
            
        }
    }
    
}

extension FacilityViewController {
    
    func getCategoryData(categoryId: String, page: Int) {
        
        NoticeService.shareInstance.getCategoryData(categoryId: categoryId, page: page, completion: {
            (result) in
            
            switch result {
            case .networkSuccess(let data) :
                let noticeData = data as? NoticeData
                
               if let resResult = noticeData?.data {
                
                    if resResult.pagination.page == 1 {
                        self.hasNextPage = true
                        self.notices = resResult.noticeList
                    } else {
                        self.hasNextPage = true
                        
                        for i in 0..<resResult.noticeList.count {
                            self.notices.append(resResult.noticeList[i])
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
    
}
