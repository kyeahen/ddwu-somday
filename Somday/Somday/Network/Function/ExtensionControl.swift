//
//  ExtensionControl.swift
//  Somday
//
//  Created by 김예은 on 2020/08/17.
//  Copyright © 2020 kyeahen. All rights reserved.
//

import Foundation
import UIKit

extension NSObject {
    
    //스토리보드 idetifier
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension NSLayoutConstraint {
    func constraintWithMultiplier(_ multiplier: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self.firstItem!, attribute: self.firstAttribute, relatedBy: self.relation, toItem: self.secondItem, attribute: self.secondAttribute, multiplier: multiplier, constant: self.constant)
    }
}

extension UIViewController {
    
    func gsno(_ value: String?) -> String { //겟스트링논옵셔널
        return value ?? ""
    }
    
    func gino(_ value: Int?) -> Int { //겟 인트 논 옵셔널
        return value ?? 0
    }
    
    //확인 팝업
    func simpleAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.view.tintColor = UIColor.SomColor.Blue.mainBlue
        let okAction = UIAlertAction(title: "확인",style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    //네트워크 에러 팝업
    func networkErrorAlert() {
        
        let alert = UIAlertController(title: "네트워크 오류", message: "네트워크 상태를 확인해주세요", preferredStyle: .alert)
        alert.view.tintColor = UIColor.SomColor.Red.mainRed
        let okAction = UIAlertAction(title: "확인",style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    //확인, 취소 팝업 - 버튼 커스텀
    func simpleAlertwithCustom(title: String, message: String, ok: String, cancel: String, okHandler : ((UIAlertAction) -> Void)?){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.view.tintColor = UIColor.SomColor.Red.mainRed
        let okAction = UIAlertAction(title: ok,style: .default, handler: okHandler)
        let cancelAction = UIAlertAction(title: cancel,style: .cancel, handler: nil)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    //확인, 취소 팝업
    func simpleAlertwithHandler(title: String, message: String, okHandler : ((UIAlertAction) -> Void)?){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.view.tintColor = UIColor.SomColor.Blue.mainBlue
        let okAction = UIAlertAction(title: "확인",style: .default, handler: okHandler)
        let cancelAction = UIAlertAction(title: "취소",style: .cancel, handler: nil)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    //네비게이션 바 투명하게 하는 함수
    func setNavigationBar() {
        let bar: UINavigationBar! = self.navigationController?.navigationBar
        
        bar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        bar.shadowImage = UIImage()
        bar.backgroundColor = UIColor.clear
    }
    
    //투명 네비게이션 바 복구하는 함수
    func recoverNavigationBar() {
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = nil
    }
    
    
    //네비바 길이 구하는 함수
    func getNavigationBarHeight() -> CGFloat {
        let navBarHeight = UIApplication.shared.statusBarFrame.size.height +
        (navigationController?.navigationBar.frame.height ?? 0.0)
        
        return navBarHeight
    }
    
    //커스텀 백버튼 설정
    func setBackBtn(color: UIColor){

        let backBTN = UIBarButtonItem(image: UIImage(named: "btBackarrow"), //백버튼 이미지 파일 이름에 맞게 변경해주세요.
            style: .plain,
            target: self,
            action: #selector(self.pop))

        navigationItem.leftBarButtonItem = backBTN
        navigationItem.leftBarButtonItem?.tintColor = color
        navigationController?.interactivePopGestureRecognizer?.delegate = self as? UIGestureRecognizerDelegate
    }

    @objc func pop(){
        self.navigationController?.popViewController(animated: true)
    }
    
    //백버튼 숨기기
    func setHiddenBackBtn() {
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton

    }
    
    //MARK: 사이드바 버튼 설정
    func setSideBarButtonItem() {
        
        let rightButtonItem = UIBarButtonItem.init(
            image: UIImage(named: "icHambugerbar"),
            style: .plain,
            target: self,
            action: #selector(sidebarAction(sender:))
        )
        
        self.navigationItem.rightBarButtonItem = rightButtonItem
        self.navigationItem.rightBarButtonItem?.tintColor = .black
    }
    
    // - 사이드바 액션
    @objc func sidebarAction(sender: UIBarButtonItem) {
        sideMenuController?.revealMenu()
    }
    
    //커스텀 팝업 띄우기 애니메이션
    func showAnimate()
    {
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
        });
    }
    
    //커스텀 팝업 끄기 애니메이션
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        });
    }
        
    //ContainerView 메소드
    func add(asChildViewController viewController: UIViewController, containerView: UIView) {
        
        // Add Child View as Subview
        containerView.addSubview(viewController.view)
        
        // Configure Child View
        viewController.view.frame = containerView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Notify Child View Controller
        viewController.didMove(toParent: self)
    }
    
    func remove(asChildViewController viewController: UIViewController, containerView: UIView) {
        // Notify Child View Controller
        viewController.willMove(toParent: nil)
        
        // Remove Child View From Superview
        viewController.view.removeFromSuperview()
        
        // Notify Child View Controller
        viewController.removeFromParent()
        
    }
    
    //데이트 변환
    func setDate(createdAt: String , format: String) -> String{
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.timeZone = TimeZone(abbreviation: "KST") //Set timezone that you want
        dateFormatterGet.locale = NSLocale.current
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = format
        
        guard let date = dateFormatterGet.date(from: createdAt) else {return ""}

        return dateFormatterPrint.string(from: date)
    }
    
    //현재 날짜 구하기
    func getTodayDate(format: String) -> String {
        let today = NSDate() //현재 시각 구하기
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let dateString = dateFormatter.string(from: today as Date)
        
        return dateString
    }
    
    //현재 날짜 구하기
    func getDate(format: String, date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let dateString = dateFormatter.string(from: date)
        
        return dateString
    }
    
    func stringToDate(dateString: String ,format: String) -> Date {


        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone(abbreviation: "KST") //Set timezone that you want

        let date:Date = dateFormatter.date(from: dateString)!
        return date
    }
    
    
    
    //커스텀 토스트
    func showToast(message : String, yValue: CGFloat) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width - (234 + 71), y: self.view.frame.size.height - yValue, width: 234, height: 37))
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center
        toastLabel.backgroundColor = UIColor(red: 141/255, green: 141/255, blue: 141/255, alpha: 1.0)
        toastLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)

        toastLabel.text = message
        toastLabel.alpha = 0.7
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        
        UIView.animate(withDuration: 1.5, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    func getTodayWeekDay(date: Date) -> String{
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "EEEE"
          let weekDay = dateFormatter.string(from: date)
          return weekDay
    }
       
    //1시간 전
    func setHours(start: Date) -> String {
        
        let end = stringToDate(dateString: "18:00:00", format: "HH:mm:ss")
        let diff = Int(end.timeIntervalSince1970 - start.timeIntervalSince1970)

        let hours = diff / 3600
        let minutes = (diff - hours * 3600) / 60
        
        let weekday = getTodayWeekDay(date: Date()) //주말
        if weekday == "Sunday" || weekday == "Saturday"  {
            return "마감"
        }

        
        if hours <= 0 && minutes <= 0 { //마감시간 이상
            return "마감"
        } else if hours >= 1 { //1시간 이상
            if minutes == 0 {
                return "\(hours)시간 전"
            }
            return "\(hours)시간 \(minutes)분 전"
        } else {
            return "\(minutes)분 전"
        }
    }
    
    //100일 남음
    func setDday(start: String, format: String) -> String {
        let dateFormatter = DateFormatter()
        
        //dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.dateFormat = format
        let day = dateFormatter.date(from: start)! //문자열을 date포맷으로 변경
        let interval = NSDate().timeIntervalSince(day)
        let days = Int(interval / 86400)
        
        if days <= 0 {
            return "D-\(days.magnitude)"
        } else {
            return "연체 \(days.magnitude)일째"
        }

    }
    
    //키보드 대응
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }


}

extension UIView {
    
    //뷰 라운드 처리 설정
    func makeRounded(cornerRadius : CGFloat?){
        if let cornerRadius_ = cornerRadius {
            self.layer.cornerRadius = cornerRadius_
        }  else {
            self.layer.cornerRadius = self.layer.frame.height/2
        }
        self.layer.masksToBounds = true
    }
    
    //방향별 라운드 처리 설정
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        if #available(iOS 11.0, *) {
            clipsToBounds = true
            layer.cornerRadius = radius
            layer.maskedCorners = CACornerMask(rawValue: corners.rawValue)
        } else {
            let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            layer.mask = mask
        }
    }
    
    //뷰 그림자 설정
    //color: 색상, opacity: 그림자 투명도, offset: 그림자 위치, radius: 그림자 크기
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
        
    @IBInspectable var dropShadows: Bool {
        set{
            if newValue {
                layer.shadowColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
                layer.shadowOpacity = 0.2
//                layer.shadowRadius = 5
                layer.shadowOffset = CGSize(width: 0, height: 3)
                layer.shadowOffset = CGSize.zero
            } else {
                layer.shadowColor = UIColor.clear.cgColor
                layer.shadowOpacity = 0
//                layer.shadowRadius = 0
                layer.shadowOffset = CGSize.zero
            }
        }
        get {
            return layer.shadowOpacity > 0
        }
    }
    
    // Corner radius
    @IBInspectable var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            
            layer.shadowRadius = newValue
            
        }
    }
    
    // Corner radius
    @IBInspectable var circle: Bool {
        get {
            return layer.cornerRadius == self.bounds.width * 0.5
        }
        set {
            if newValue == true {
                self.cornerRadius = self.bounds.width * 0.5
            }
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        
        set {
            self.layer.cornerRadius = newValue
        }
    }
    
}

extension UIButton {
    
    //MARK: 버튼 라벨 밑줄
    func underline() {
        guard let text = self.titleLabel?.text else { return }
        
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: text.count))
        
        self.setAttributedTitle(attributedString, for: .normal)
    }
}

extension UITableView {
    func addCorner(){
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }

    func addShadow(){
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = .zero
        self.layer.masksToBounds = false
    }
}

extension UITextField {
    
    func setTextField() {
        self.layer.borderColor = #colorLiteral(red: 0.9232344031, green: 0.5513463616, blue: 0.5515488386, alpha: 1)
        self.layer.borderWidth = 1
        self.makeRounded(cornerRadius: 8)
    }
    
    func setTextField(radius: CGFloat, color: CGColor) {
        self.layer.borderColor = color
        self.layer.borderWidth = 1
        self.makeRounded(cornerRadius: radius)
    }
    
    func shake() {
        self.transform = CGAffineTransform(translationX: 20, y: 0)
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform.identity
        }, completion: nil)
    }
}


extension CALayer {
    
    //뷰 테두리 설정
    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        
        let border = CALayer();
        
        switch edge {
        case UIRectEdge.top:
            border.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: thickness)
            break
        case UIRectEdge.bottom:
            border.frame = CGRect(x:0, y:self.frame.height - thickness, width:self.frame.width, height:thickness)
            break
        case UIRectEdge.left:
            border.frame = CGRect(x:0, y:0, width: thickness, height: self.frame.height)
            break
        case UIRectEdge.right:
            border.frame = CGRect(x:self.frame.width - thickness, y: 0, width: thickness, height:self.frame.height)
            break
        default:
            break
        }
        
        border.backgroundColor = color.cgColor;
        
        self.addSublayer(border)
    }
}

extension UILabel {
    func setLineHeight(lineHeight: CGFloat) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1.0
        paragraphStyle.lineHeightMultiple = lineHeight
        paragraphStyle.alignment = self.textAlignment

        let attrString = NSMutableAttributedString()
        if (self.attributedText != nil) {
            attrString.append( self.attributedText!)
        } else {
            attrString.append( NSMutableAttributedString(string: self.text!))
            attrString.addAttribute(NSAttributedString.Key.font, value: self.font, range: NSMakeRange(0, attrString.length))
        }
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
        self.attributedText = attrString
    }
}

extension Array where Element: Equatable {

    mutating func remove(_ element: Element) {
        _ = index(of: element).flatMap {
            self.remove(at: $0)
        }
    }
}

extension Date {
    static var yesterday: Date { return Date().dayBefore }
    static var tomorrow:  Date { return Date().dayAfter }
    
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    
    var datThree: Date {
        return Calendar.current.date(byAdding: .day, value: 3, to: noon)!
    }

    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    
    var year: Int {
        return Calendar.current.component(.year,  from: self)
    }
    
    var today: Int {
        return Calendar.current.component(.day,  from: self)
    }
    
    var isLastDayOfMonth: Bool {
        return dayAfter.month != month
    }
    
    
    func hours(sinceDate: Date) -> Int? {
        return Calendar.current.dateComponents([.hour], from: sinceDate, to: self).hour
    }

    func minutes(sinceDate: Date) -> Int? {
        return Calendar.current.dateComponents([.minute], from: sinceDate, to: self).minute
    }
    
    
}

extension Int {
    func dateFromMilliseconds() -> Date {
        return Date(timeIntervalSince1970: TimeInterval(self)/1000)
    }
}



