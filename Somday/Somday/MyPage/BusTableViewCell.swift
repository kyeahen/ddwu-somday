//
//  BusTableViewCell.swift
//  Somday
//
//  Created by 김예은 on 2020/08/19.
//  Copyright © 2020 kyeahen. All rights reserved.
//

import UIKit

class BusTableViewCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var busSwitch: UISwitch!
    
    var alarm = Bool()
    var callback : ((Bool) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func valChange(_ sender: UISwitch) {
        callback?(sender.isOn)
    }

}
