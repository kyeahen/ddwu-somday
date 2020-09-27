//
//  DeviceTableViewCell.swift
//  Somday
//
//  Created by 김예은 on 2020/08/21.
//  Copyright © 2020 kyeahen. All rights reserved.
//

import UIKit

class DeviceTableViewCell: UITableViewCell {
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var deviceImageView: UIImageView!
    @IBOutlet weak var checkButton: UIButton!
    
    var actionClosure : (()->Void)? = nil
    
    var isCheck = false
    var idx = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: 목록 선택
    @IBAction func reportAction(_ sender: UIButton) {
        self.actionClosure?()
        isCheck = !isCheck
        print(isCheck)
        //print(idx)
    }

}
