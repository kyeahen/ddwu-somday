//
//  AlarmViewController.swift
//  Somday
//
//  Created by 김예은 on 2020/08/19.
//  Copyright © 2020 kyeahen. All rights reserved.
//

import UIKit

class AlarmViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var data = ["aaaaaaaaaaaaa", "bbbbbbbbbbbb", "ccccccccccccc"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setTableView()
        setUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.setNavigationBar()
        self.tabBarController?.tabBar.isHidden = false
    }

    func setUI() {
        setBackBtn(color: .black)
        setRightBarButtonItem()
        self.recoverNavigationBar()
        
        tableView.backgroundColor = UIColor.SomColor.White.popupWhite
        self.navigationController?.navigationBar.barTintColor = UIColor.SomColor.White.popupWhite
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func setTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView(frame: .zero)
    }
    
    //MARK: 전체 삭제 버튼 설정
    func setRightBarButtonItem() {
        
        let rightButtonItem = UIBarButtonItem.init(
            image: UIImage(named: "icTrash"),
            style: .plain,
            target: self,
            action: #selector(removeAction(sender:))
        )
        
        self.navigationItem.rightBarButtonItem = rightButtonItem
        self.navigationItem.rightBarButtonItem?.tintColor = .black
    }
    
    // - 전체 삭제 팝업
    @objc func removeAction(sender: UIBarButtonItem) {
        
        
        let vc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(identifier: RemoveAllAlarmPopUpViewController.reuseIdentifier)

        self.addChild(vc)
        vc.view.frame = self.view.bounds
        self.view.addSubview(vc.view)
        vc.didMove(toParent: self)
    
    }
}

extension AlarmViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: AlarmTableViewCell.reuseIdentifier) as! AlarmTableViewCell
        
        cell.contentLabel.text = data[indexPath.row]
        cell.dateLabel.text = "2020.08.19"
        cell.layer.borderColor = UIColor(red: 172/255, green: 172/255, blue: 172/255, alpha: 1.0).cgColor
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            self.data.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
    
    }
    

}
