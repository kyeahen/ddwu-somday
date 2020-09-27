//
//  ForgetEmailViewController.swift
//  Somday
//
//  Created by 김예은 on 2020/08/25.
//  Copyright © 2020 kyeahen. All rights reserved.
//

import UIKit

class ForgetEmailViewController: UIViewController {

    @IBOutlet weak var headerLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        headerLabel.setLineHeight(lineHeight: 1.25)
        setBackBtn(color: .black)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backLogin(_ sender: Any) {
        
        performSegue(withIdentifier: "unwindToLogin", sender: self)
    }
    


}
