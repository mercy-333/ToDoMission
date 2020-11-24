//
//  CalendarViewController.swift
//  ToDoMission
//
//  Created by Mercy on 2020/11/11.
//  Copyright © 2020 Mercy's App. All rights reserved.
//

import UIKit
import GoogleMobileAds
import RealmSwift
import CalculateCalendarLogic
import FSCalendar

/// カレンダー画面の制御
class CalendarViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource {

    
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var tableView: UITableView!
    
    let todoCommon = TodoCommon()
    
    /// viewDidLoad
    override func viewDidLoad() {
        debugLog("start.")
        super.viewDidLoad()

        // デリゲートの設定
        self.calendar.dataSource = self
        self.calendar.delegate = self
        calendarSetting()
        
        debugLog("success.")
    }
    
    
    /// カレンダーにドットをつける
    /// - Parameters:
    ///   - calendar:
    ///   - date: カレンダーの月単位ページ描画時に１ヶ月分の日付が格納されて、日付の数だけこの関数が呼ばれる
    /// - Returns: ドットの数
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        
        let dateStr = Common.stringFromDate(date: date, format: "yyyyMMdd")
        
        //let realmData:TodoModel = todoCommon.getDateRealm(dateStr) as! TodoModel
        if (todoCommon.isCheckDateRealm(dateStr: dateStr)) {
            return 1
        } else {
            return 0
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // date型 -> 年月日をIntで取得
    func getDay(_ date:Date) -> (Int,Int,Int){
        let tmpCalendar = Calendar(identifier: .gregorian)
        let year = tmpCalendar.component(.year, from: date)
        let month = tmpCalendar.component(.month, from: date)
        let day = tmpCalendar.component(.day, from: date)
        return (year,month,day)
    }
    
    /// デバッグログ
    func debugLog(_ message: String = "", function: String = #function, file: String = #file, line: Int = #line) {
        #if DEBUG
            let fileName = URL(string: file)!.lastPathComponent
            //NSLog("\(fileName) #\(line) \(function): \(message)")
            print("# \(fileName) #\(line) \(function): \(message)")
        #endif
    }
    
    
    /// カレンダー画面の個別設定. 曜日の日本語表記など
    func calendarSetting() {
        
        // ヘッダー
    
        
        // 曜日
        calendar.calendarWeekdayView.weekdayLabels[0].text = "日"
        calendar.calendarWeekdayView.weekdayLabels[1].text = "月"
        calendar.calendarWeekdayView.weekdayLabels[2].text = "火"
        calendar.calendarWeekdayView.weekdayLabels[3].text = "水"
        calendar.calendarWeekdayView.weekdayLabels[4].text = "木"
        calendar.calendarWeekdayView.weekdayLabels[5].text = "金"
        calendar.calendarWeekdayView.weekdayLabels[6].text = "土"
        
        calendar.calendarWeekdayView.weekdayLabels[0].textColor = UIColor.red
        calendar.calendarWeekdayView.weekdayLabels[1].textColor = UIColor.black
        calendar.calendarWeekdayView.weekdayLabels[2].textColor = UIColor.black
        calendar.calendarWeekdayView.weekdayLabels[3].textColor = UIColor.black
        calendar.calendarWeekdayView.weekdayLabels[4].textColor = UIColor.black
        calendar.calendarWeekdayView.weekdayLabels[5].textColor = UIColor.black
        calendar.calendarWeekdayView.weekdayLabels[6].textColor = UIColor.blue
    }
}
