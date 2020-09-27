//
//  DetailNoticeViewController.swift
//  Somday
//
//  Created by 김예은 on 2020/08/21.
//  Copyright © 2020 kyeahen. All rights reserved.
//

import UIKit
import Kingfisher

class DetailNoticeViewController: UIViewController {
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var detailImageView: UIImageView!
    
    var idx = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setBackBtn(color: .black)
        setSideBarButtonItem()
        self.title = "공지사항"
        self.tabBarController?.tabBar.isHidden = true
        
        self.getDetailData(idx: idx)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    

}

extension DetailNoticeViewController {
    
    func getDetailData(idx: Int) {
        
        DetailNoticeService.shareInstance.getDetailNoticeData(idx: idx,completion: {
            (result) in
            
            switch result {
            case .networkSuccess(let data) :
                let detailData = data as? Detail
                
                if let resResult = detailData {
                    print("dd")
                    self.categoryLabel.text = resResult.category.name
                    
                    let str = self.stringToDate(dateString: resResult.registeredAt, format: "yyyy-MM-dd HH:mm:ss")
                    let date = self.getDate(format: "yyyy.MM.dd", date: str)
                    self.dateLabel.text = date
                
                    self.titleLabel.text = resResult.title
                    self.contentLabel.text = resResult.content
                    
                    if let img = detailData?.images {
                        if img.count != 0 {
                            self.detailImageView.kf.setImage(with: URL(string: img[0].imageUrl), placeholder: UIImage())
                        }
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

