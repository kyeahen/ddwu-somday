//
//  DeviceCalenderViewController.swift
//  Somday
//
//  Created by 김예은 on 2020/08/22.
//  Copyright © 2020 kyeahen. All rights reserved.
//

import UIKit
import FSCalendar

class DeviceCalenderViewController: UIViewController {

    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var titleView: UIView!
    
    var startDate = ""
    var endDate = ""
    
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleView.roundCorners([.topRight, .topLeft], radius: 10)
        setCalendar()
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
        
        
        //TODO: 통신 시 시작 날짜 받아오기 (우선은 현재날짜로 테스트 중)
//        startDate = self.getTodayDate(format: "yyyy/MM/dd")
        startDate = "2020/08/24"
    }

    deinit {
           print("\(#function)")
    }
    
    func lastDay(ofMonth m: Int, year y: Int) -> Int {
        let cal = Calendar.current
        var comps = DateComponents(calendar: cal, year: y, month: m)
        comps.setValue(m + 1, for: .month)
        comps.setValue(0, for: .day)
        let date = cal.date(from: comps)!
        return cal.component(.day, from: date)
    }

    func daysBetween(start: Date, end: Date) -> Int {
        var count = 0
        
        var currentDate = start
        while currentDate.compare(end) != .orderedDescending {
            
            let weekday = getTodayWeekDay(date: currentDate) //주말
            if weekday == "Sunday" || weekday == "Saturday" {
                
            } else {
                count += 1
            }
            currentDate = currentDate.dayAfter
        }
        
        return count
    }
    
}

extension DeviceCalenderViewController: FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance {
    
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
    
    
    //시작 날짜 이전 + 3일 초과 + 주말 + 공휴일은..? 은 클릭 못하게 하기
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        
        
        let start = self.stringToDate(dateString: startDate, format: "yyyy/MM/dd")
        print(daysBetween(start: start, end: date))
    
        if date.compare(start) == ComparisonResult.orderedAscending { //시작날짜 이전
            return false
        }
        
        if date.compare(start) == ComparisonResult.orderedSame { //같은거
            return false
        }
        
        let weekday = self.getTodayWeekDay(date: date) //주말
        if weekday == "Sunday" || weekday == "Saturday"  {
            return false
        }

        if daysBetween(start: start, end: date) > 3 {
            return false
        }
        
        return true
    }
    
    //날짜 선택
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("did select date \(self.dateFormatter.string(from: date))")

        let selectedDates = calendar.selectedDates.map({self.dateFormatter.string(from: $0)})
        print("selected dates is \(selectedDates)")
        endDate = selectedDates[0]

    }
    
    
    //시작 날짜 고정
     func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {

        let dateString = self.dateFormatter.string(from: date)
        if self.startDate.contains(dateString) {
            return UIColor.white
           
        }
        
        let start = self.stringToDate(dateString: startDate, format: "yyyy/MM/dd")
        if date.compare(start) == ComparisonResult.orderedAscending { //시작날짜 이전

            
            let weekday = self.getTodayWeekDay(date: date)
            if weekday == "Sunday" {
                return UIColor.SomColor.Red.mainRed
            }
            
            if weekday == "Saturday" {
                return UIColor.SomColor.Blue.mainBlue
            }
            
            return UIColor.systemGray2
        }
        
        if daysBetween(start: start, end: date) > 3 {
            
            
            let weekday = self.getTodayWeekDay(date: date)
            if weekday == "Sunday" {
                return UIColor.SomColor.Red.mainRed
            }
            
            if weekday == "Saturday" {
                return UIColor.SomColor.Blue.mainBlue
            }
            
            return UIColor.systemGray2
        }
        
//        let weekday = getTodayWeekDay(date: date)
//        if weekday == "Sunday" {
//            return UIColor.SomColor.Red.mainRed
//        }
//
//        if weekday == "Saturday" {
//            return UIColor.SomColor.Blue.mainBlue
//        }
        
        return UIColor.black
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleSelectionColorFor date: Date) -> UIColor? {
        
        let weekday = self.getTodayWeekDay(date: date)
        if weekday == "Sunday" {
            return UIColor.SomColor.Red.mainRed
        }
        if weekday == "Saturday" {
            return UIColor.SomColor.Blue.mainBlue
        }
        
        return UIColor.black
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {

        let dateString = self.dateFormatter.string(from: date)
        if self.startDate.contains(dateString) {
            return UIColor.SomColor.Blue.mainBlue
        }
        

        return UIColor.white // Return Default UIColor
    }
    
//    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderSelectionColorFor date: Date) -> UIColor? {
//        let start = self.stringToDate(dateString: startDate, format: "yyyy/MM/dd")
//
//
//            if start.compare(date) == ComparisonResult.orderedAscending { //셀렉 데이트 이전
//                return UIColor.SomColor.Blue.mainBlue
//            }
//
//        return UIColor.white
//    }
    
    
}
