//
//  BusViewController.swift
//  Somday
//
//  Created by 김예은 on 2020/08/19.
//  Copyright © 2020 kyeahen. All rights reserved.
//

import UIKit
import UserNotifications

class BusViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var data = ["오전 11:10", "오후 2:10", "오후 3:50"]
    var status = [false, false, false]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setTableView()

        
        // 권한 체크
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {didAllow, error in
        })
        
        
        
        setBackBtn(color: .black)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
    }
    
    func setTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func setNotification(h: Int, min: Int, prev: Int, id: String) {
        
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "버스 알림"
        notificationContent.body = "셔틀 버스 도착 \(prev)분 전입니다."

        var date = DateComponents()
        date.hour = h
        date.minute = min
        let notificationTrigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)


        let notificationRequest = UNNotificationRequest(identifier: id, content: notificationContent, trigger: notificationTrigger)
        UNUserNotificationCenter.current().add(notificationRequest) { (error) in
            if let error = error
            {
                let errorString = String(format: NSLocalizedString("Unable to Add Notification Request %@, %@", comment: ""), error as CVarArg, error.localizedDescription)
                print(errorString)
            }
        }
    }

}

extension BusViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BusTableViewCell.reuseIdentifier) as! BusTableViewCell
        
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor(red: 239/255, green: 243/255, blue: 255/255, alpha: 1.0)
        } else {
            cell.backgroundColor = .white
        }
        
        cell.timeLabel.text = data[indexPath.row]
        cell.busSwitch.tag = indexPath.row // for detect which row switch Changed
//        cell.busSwitch.isOn = status[indexPath.row]
//
//        cell.callback = { newValue in
//            self.status[indexPath.row] = newValue
//        }
        
        if indexPath.row == 0 {
            cell.busSwitch.isOn = UserDefaults.standard.bool(forKey: "switch1")
        } else if indexPath.row == 2 {
            cell.busSwitch.isOn = UserDefaults.standard.bool(forKey: "switch2")
        } else {
            cell.busSwitch.isOn = UserDefaults.standard.bool(forKey: "switch3")
        }
        cell.busSwitch.addTarget(self, action: #selector(self.switchChanged(_:)), for: .valueChanged)
        
        return cell
    }
    
    @objc func switchChanged(_ sender : UISwitch!){

          print("table row switch Changed \(sender.tag)")
          print("The switch is \(sender.isOn ? "ON" : "OFF")")
        
        if sender.tag == 0 { //11 10
            
            if !sender.isOn {
                UserDefaults.standard.set(false, forKey: "switch1")
                
                let center = UNUserNotificationCenter.current()
                center.removeDeliveredNotifications(withIdentifiers: ["first15", "first10", "first5"])
                center.removePendingNotificationRequests(withIdentifiers: ["first15", "first10", "first5"])

                print(UserDefaults.standard.bool(forKey: "switch1"))

            } else {
                UserDefaults.standard.set(true, forKey: "switch1")

                setNotification(h: 19, min: 11, prev: 15, id: "first15")
                setNotification(h: 11, min: 00, prev: 10, id: "first10")
                setNotification(h: 11, min: 5, prev: 5, id: "first5")
                print(UserDefaults.standard.bool(forKey: "switch1"))
            }
            
        } else if sender.tag == 1 { // 2 10
            
            if !sender.isOn {
                UserDefaults.standard.set(false, forKey: "switch2")
                
                let center = UNUserNotificationCenter.current()
                center.removeDeliveredNotifications(withIdentifiers: ["second15", "second10", "second5"])
                center.removePendingNotificationRequests(withIdentifiers: ["second15", "second10", "second5"])
                print(UserDefaults.standard.value(forKey: "switch2"))

            } else {
                UserDefaults.standard.set(true, forKey: "switch2")
                
                setNotification(h: 13, min: 55, prev: 15, id: "second15")
                setNotification(h: 14, min: 00, prev: 10, id: "second10")
                setNotification(h: 14, min: 5, prev: 5, id: "second5")
            }
            
            
        } else { //3 50
            
            if !sender.isOn {
                UserDefaults.standard.set(false, forKey: "switch3")
                let center = UNUserNotificationCenter.current()
                center.removeDeliveredNotifications(withIdentifiers: ["third15", "third10", "third5"])
                center.removePendingNotificationRequests(withIdentifiers: ["third15", "third10", "third5"])
                print(UserDefaults.standard.value(forKey: "switch3"))


            } else {
                UserDefaults.standard.set(true, forKey: "switch3")
                setNotification(h: 15, min: 35, prev: 15, id: "third15")
                setNotification(h: 15, min: 40, prev: 10, id: "third10")
                setNotification(h: 15, min: 45, prev: 5, id: "third5")
            }
        
        }
    }
    
    
}
