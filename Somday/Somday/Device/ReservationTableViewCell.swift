//
//  ReservationTableViewCell.swift
//  Somday
//
//  Created by 김예은 on 2020/08/22.
//  Copyright © 2020 kyeahen. All rights reserved.
//

import UIKit

class ReservationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var deviceImageView: UIImageView!
    
    var checkClosure : (()->Void)? = nil
    
    var isCheck = false {
        didSet {
            if self.isCheck == true {
                self.checkButton.setImage(UIImage(named: "btCheck"), for: .normal)
            } else{
                self.checkButton.setImage(UIImage(named: "btUncheck"), for: .normal)
            }
        }
    }
    
    var idx = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func checkAction(_ sender: Any) {
        self.checkClosure?()
        isCheck = !isCheck
        print("cell : \(isCheck)")
        //print(idx)
    }
    
}
