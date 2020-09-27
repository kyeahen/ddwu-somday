//
//  ApplyViewController.swift
//  Somday
//
//  Created by 김예은 on 2020/08/18.
//  Copyright © 2020 kyeahen. All rights reserved.
//

import UIKit
import FSCalendar
import SwiftyMenu
import SwiftyJSON

class RentalViewController: UIViewController {
    
    @IBOutlet weak var calendar: FSCalendar!
    
    @IBOutlet weak var calendarOpImageView: UIImageView!
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet private weak var dropDownMenu: SwiftyMenu!
    
    @IBOutlet weak var opImageView: UIImageView!
    @IBOutlet weak var calendarDateLabel: UILabel!
    @IBOutlet weak var applyDateLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var roomLabel: UILabel!
    
    var works : Work?
    var rooms: [Room] = [Room]()
    
    //야작 신청 상태
    var applyStatus = false

    //드롭다운 메뉴 배열
    private var items: [SwiftyMenuDisplayable] = []
    
    var selectedRoom = 0
    var applyId = 0
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    
    fileprivate lazy var dateFormatter2: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM"
        return formatter
    }()
    
    var startDate = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getWorkData()
        getRoomData()
        
        setUI()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        getWorkData()
        getRoomData()
       
    }
    
    func setUI() {
        setNavigationBar()
        setSideBarButtonItem()
        setDropDownMenu()
        setCalendar()
        
        applyButton.roundCorners([.bottomLeft, .bottomRight], radius: 10)
        
        calendarDateLabel.text = self.getTodayDate(format: "yyyy.MM")
        dateLabel.text = self.getTodayDate(format: "yyyy년 M월 dd일")
        startDate = self.getTodayDate(format: "yyyy/MM/dd")
        
        let time = stringToDate(dateString: getTodayDate(format: "HH:mm:ss"), format: "HH:mm:ss")
        applyDateLabel.text = self.setHours(start: time)
        
        if applyStatus == true {
            opImageView.isHidden = true
            calendarOpImageView.isHidden = false
            endLabel.isHidden = false
            endLabel.text = "야작 신청이 완료 되었습니다."
        }
        else if self.setHours(start: time) == "마감" {
            opImageView.isHidden = false
            calendarOpImageView.isHidden = false
            endLabel.isHidden = false
            endLabel.text = "야작 신청이 마감되었습니다."
        }
        else {
            opImageView.isHidden = true
            calendarOpImageView.isHidden = true
            endLabel.isHidden = true
        }
    }
    
    func setCalendar() {
            
            self.calendar.delegate = self
            self.calendar.dataSource = self
            

            // For UITest
            self.calendar.accessibilityIdentifier = "calendar"
            
            calendar.locale = Locale(identifier: "ko_KR")
            calendar.calendarWeekdayView.weekdayLabels[0].text = "일"
            calendar.calendarWeekdayView.weekdayLabels[1].text = "월"
            calendar.calendarWeekdayView.weekdayLabels[2].text = "화"
            calendar.calendarWeekdayView.weekdayLabels[3].text = "수"
            calendar.calendarWeekdayView.weekdayLabels[4].text = "목"
            calendar.calendarWeekdayView.weekdayLabels[5].text = "금"
            calendar.calendarWeekdayView.weekdayLabels[6].text = "토"
            
            calendar.calendarWeekdayView.weekdayLabels[6].textColor = UIColor.SomColor.Blue.mainBlue
            calendar.calendarWeekdayView.weekdayLabels[0].textColor = UIColor.SomColor.Red.mainRed
            
            calendar.placeholderType = .none //이전달 다음달 날짜 없애기
            
    }

    deinit {
           print("\(#function)")
    }
    

    //MARK: 드롭 다운 메뉴 세팅
    func setDropDownMenu() {
        
        // Assign the component that implement SwiftyMenuDelegate to SwiftyMenu component
        dropDownMenu.delegate = self

        // Give array of items to SwiftyMenu
        //dropDownMenu.items = items
        //dropDownMenu.placeHolderText = rooms[0].name
        
        // Change option's row height (default 35)
        dropDownMenu.rowHeight = 26

        // Change option's drop down menu height
        // default is 0, which make drop down height = number of options * rowHeight
        dropDownMenu.listHeight = 156

        // Change drop down menu border width
        dropDownMenu.borderWidth = 1.0

        // Change drop down menu scroll behavior
        dropDownMenu.scrollingEnabled = true
        dropDownMenu.isMultiSelect = false


        // Change drop down menu default colors
        dropDownMenu.borderColor = #colorLiteral(red: 0.3220832944, green: 0.3981915712, blue: 0.9999844432, alpha: 1)
        dropDownMenu.itemTextColor = .black
        dropDownMenu.placeHolderColor = .black
        dropDownMenu.menuHeaderBackgroundColor = UIColor(red: 239/255, green: 243/255, blue: 255/255, alpha: 1.0)
        dropDownMenu.rowBackgroundColor = .white
        dropDownMenu.separatorColor = .white

        // Change drop down menu default expand and collapse animation
        dropDownMenu.expandingAnimationStyle = .spring(level: .low)
        dropDownMenu.expandingDuration = 0.5
        dropDownMenu.collapsingAnimationStyle = .linear
        dropDownMenu.collapsingDuration = 0.5
    }
    
    //MARK: 신청 or 취소 액션하기
    @IBAction func applyAction(_ sender: Any) {
        
        if !applyStatus { //신청 x - false
            postWork(roomId: selectedRoom)
            print(applyStatus)
        } else {
            deleteWork(workId: applyId)
            print(applyId)
        }
    }
    
}

extension RentalViewController {
    
    func getWorkData() {
        
        WorkService.shareInstance.getWorkData(completion: {
            (result) in
            
            switch result {
            case .networkSuccess(let data) :
                let workData = data as? WorkData
                
                if let result = workData?.data {
                    print("이미 야작 신청한 상태")
                    self.applyId = result.id
                    self.roomLabel.text = "\(result.room.name)호"
                    self.applyStatus = true
                    
                    self.endLabel.text = "이미 야작 신청이 완료 되었습니다."
                    self.roomLabel.isHidden = false
                    self.dropDownMenu.isHidden = true
                    self.applyButton.setTitle("취소하기", for: .normal)
                    self.applyButton.backgroundColor = UIColor.SomColor.Red.mainRed
                }
                else { //신청x
                    print("야작 신청 가능")
                    self.applyStatus = false
                    
                    self.roomLabel.isHidden = true
                    self.dropDownMenu.isHidden = false
                    self.applyButton.setTitle("신청하기", for: .normal)
                    self.applyButton.backgroundColor = UIColor.SomColor.Blue.mainBlue
                }
                
                self.setUI()
                
                
                break
                
            case .networkFail :
                self.showToast(message: "네트워크 상태를 확인해주세요.", yValue: 110)
                
            default :
                self.showToast(message: "다시 시도해주세요.", yValue: 110)
                break
            }
        })
    }
    
    func getRoomData() {
        
        WorkRoomService.shareInstance.getRoomData(completion: {
            (result) in
            
            switch result {
            case .networkSuccess(let data) :
                let roomData = data as? [Room]
                
                if let result = roomData {
                    self.rooms = result
                    self.selectedRoom = self.rooms[0].id
                    print(self.rooms.description)
                    
                    for i in 0..<self.rooms.count {
                        self.items.append(self.rooms[i].name)
                    }
                    print(self.items.description)
                    
                    self.dropDownMenu.items = self.items
                    self.dropDownMenu.placeHolderText = self.rooms[0].name
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
    
    func postWork(roomId: Int) {
        
        
        DefaultWorkService.shareInstance.postWork(roomId: roomId, params: [:], completion: {
            (result) in
            
            switch result {
            case .networkSuccess(_) :
                let vc = UIStoryboard(name: "Rental", bundle: nil).instantiateViewController(identifier: RentalPopUpViewController.reuseIdentifier) as! RentalPopUpViewController
                self.addChild(vc)
                vc.applyStatus = false
                vc.view.frame = self.view.frame
                self.view.addSubview(vc.view)
                vc.didMove(toParent: self)
                
                self.getWorkData()
                break
                
            case .networkFail :
                self.showToast(message: "네트워크 상태를 확인해주세요.", yValue: 110)
                
            default :
                self.showToast(message: "다시 시도해주세요.", yValue: 110)
                break
            }
        })
    }
    
    func deleteWork(workId: Int) {
        
        DefaultWorkService.shareInstance.deleteWork(workId: workId, completion: { (result) in

            switch result {
            case .networkSuccess(_):
                let vc = UIStoryboard(name: "Rental", bundle: nil).instantiateViewController(identifier: RentalPopUpViewController.reuseIdentifier) as! RentalPopUpViewController
                self.addChild(vc)
                vc.applyStatus = true
                vc.view.frame = self.view.frame
                self.view.addSubview(vc.view)
                vc.didMove(toParent: self)
                
                self.getWorkData()
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


//MARK: 드롭 다운 메뉴 extension
extension RentalViewController: SwiftyMenuDelegate {
    // Get selected option from SwiftyMenu
    func swiftyMenu(_ swiftyMenu: SwiftyMenu, didSelectItem item: SwiftyMenuDisplayable, atIndex index: Int) {
        print("Selected item: \(item), at index: \(index)")
        self.selectedRoom = rooms[index].id
        print(selectedRoom)
    }
    
    // SwiftyMenu drop down menu will expand
    func swiftyMenu(willExpand swiftyMenu: SwiftyMenu) {
        print("SwiftyMenu willExpand.")
    }

    // SwiftyMenu drop down menu did expand
    func swiftyMenu(didExpand swiftyMenu: SwiftyMenu) {
        print("SwiftyMenu didExpand.")
    }

    // SwiftyMenu drop down menu will collapse
    func swiftyMenu(willCollapse swiftyMenu: SwiftyMenu) {
        print("SwiftyMenu willCollapse.")
    }

    // SwiftyMenu drop down menu did collapse
    func swiftyMenu(didCollapse swiftyMenu: SwiftyMenu) {
        print("SwiftyMenu didCollapse.")
    }
}

// Example on String. You can change it to what ever type you want ;)
// String extension to conform SwiftyMenuDisplayable Protocl
extension String: SwiftyMenuDisplayable {
    public var retrievableValue: Any {
        return self
    }
    
    
    public var displayableValue: String {
        return self
    }
}

extension RentalViewController: FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance {
    
    func lastDay(ofMonth m: Int, year y: Int) -> Int {
        let cal = Calendar.current
        var comps = DateComponents(calendar: cal, year: y, month: m)
        comps.setValue(m + 1, for: .month)
        comps.setValue(0, for: .day)
        let date = cal.date(from: comps)!
        return cal.component(.day, from: date)
    }

    func minimumDate(for calendar: FSCalendar) -> Date {
    
         let start = self.stringToDate(dateString: startDate, format: "yyyy/MM/dd")
         let yearInt = Int(self.getDate(format: "yyyy", date: start)) ?? 0
         print(lastDay(ofMonth: Date().month, year: yearInt))
         return self.dateFormatter.date(from: "\(yearInt)/\(Date().month)/01")!
     }
     
     func maximumDate(for calendar: FSCalendar) -> Date {
         let start = self.stringToDate(dateString: startDate, format: "yyyy/MM/dd")
         let yearInt = Int(self.getDate(format: "yyyy", date: start)) ?? 0
         let day = lastDay(ofMonth: Date().month, year: yearInt)
         return self.dateFormatter.date(from: "\(yearInt)/\(Date().month)/\(day)")!
     }
    
    //시작 날짜 고정
     func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {

        let dateString = self.dateFormatter.string(from: date)
        if self.startDate.contains(dateString) {
            return UIColor.white
           
        }

        
        let weekday = self.getTodayWeekDay(date: date)
        if weekday == "Sunday" {
            return UIColor.SomColor.Red.mainRed
        }
        
        if weekday == "Saturday" {
            return UIColor.SomColor.Blue.mainBlue
        }
        
        return UIColor.black
    }
    
    
}
