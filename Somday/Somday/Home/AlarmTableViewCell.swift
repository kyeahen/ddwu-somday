//
//  AlarmTableViewCell.swift
//  Somday
//
//  Created by 김예은 on 2020/08/19.
//  Copyright © 2020 kyeahen. All rights reserved.
//

import UIKit

class AlarmTableViewCell: UITableViewCell {

    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        dateLabel.textColor = UIColor(red: 141/255, green: 141/255, blue: 141/255, alpha: 1.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
