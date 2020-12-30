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
class CalendarViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var rewardLabel: UILabel!
    @IBOutlet weak var completeResults: UIImageView!
    
    let todoCommon = TodoCommon()
    
    /* ミッション内容のリスト */
    var missionList = [String]()
    
    /* ミッションリストのチェック状況 true:達成 / false:未達成 */
    var isCheckList = [Bool]()

    // タップした日付
    var currentDate:String = ""
    
    /*----------------------*/
    /* ViewDidLoad          */
    /*----------------------*/
    override func viewDidLoad() {
        super.viewDidLoad()
        debugLog("#############################")
        debugLog("##### Calender Screen   #####")
        debugLog("#############################")
        // デリゲートの設定
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.calendar.dataSource = self
        self.calendar.delegate = self
        calendarSetting()
        uiInit()
        currentDate = todoCommon.todayStr
        realmLoad(currentDate)
        debugLog("success.")
    }
    
    
    /// 本画面に遷移した時に毎回呼ばれる
    /// *TableViewを再読み込みする
    /// - Parameter animated: <#animated description#>
    override func viewWillAppear(_ animated: Bool) {
        debugLog("start.")
        initTableView()
        realmLoad(currentDate)
        calendar.reloadData()
        debugLog("success.")
    }
    
    /// カレンダーにドットをつける
    /// - Parameters:
    ///   - calendar:
    ///   - date: カレンダーの月単位ページ描画時に１ヶ月分の日付が格納されて、日付の数だけこの関数が呼ばれる
    /// - Returns: ドットの数
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let dateStr = Common.stringFromDate(date: date, format: "yyyyMMdd")
        if (todoCommon.isCheckGohoubiRealm(dateStr: dateStr) ||
            todoCommon.isCheckInfolistRealm(dateStr: dateStr)) {
            return 1
        } else {
            return 0
        }
    }
    
    /// カレンダーの日付をタップした際に呼ばれる
    /// TableViewに情報を反映する
    /// - Parameters:
    ///   - calendar:
    ///   - date:
    ///   - monthPosition:カレンダーの月(前月:0 当月:1 次月:2)
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let dateStr = Common.stringFromDate(date: date, format: "yyyyMMdd")
        debugLog("tapped. \(dateStr) / current:\(currentDate)")
        
        // 同じ日付を連続でタップした場合TableViewを更新しない
        if (currentDate != dateStr) {
            initTableView()
            realmLoad(dateStr)
        } else {
            debugLog("don't update.")
        }
        
        // タップした日付を保持(連続で押しても更新させない)
        currentDate = dateStr

        debugLog("success.")
    }
    
    /// TableViewのセル数を設定
    /// Realmデータから取得したデータ数をセル数に設定
    /// - Parameters:
    ///   - tableView:
    ///   - section:
    /// - Returns: セル数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //debugLog("start. \(missionList.count)")
        return missionList.count
    }
    
    /// cellForRowAt() TableViewのセル生成時に呼ばれる
    /// Realmデータから取得したデータ数をセル内容に設定
    /// - Parameters:
    ///   - tableView:
    ///   - indexPath:
    /// - Returns:
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        debugLog("start. indexPath.row:\(indexPath.row)")
        
        for i in 0..<isCheckList.count {
            debugLog("isCheckList[\(i)]:\(String(isCheckList[i]))")
        }
        // セルの取得(再利用)
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath)
        
        // ミッション内容をカスタムセルの Label(tag2)に設定
        let cellLabel = cell.viewWithTag(2) as! UILabel
        cellLabel.text = missionList[indexPath.row]
        
        // カスタムセルのボタン(tag1)をunCkeckMarkに設定
        if (cell.viewWithTag(1) as? UIButton) != nil {
            let cellButton = cell.viewWithTag(1) as! UIButton

            // true/falseで画像切り替え
            if (isCheckList[indexPath.row] == true) {
                cellButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
            } else {
                cellButton.setImage(UIImage(systemName: "circle"), for: .normal)
            }
            
        } else {
            debugLog("nil error")
        }
        
        debugLog("success.")
        return cell
    }
    
    /// タップした日の Realmデータが存在したら、取得する
    /// missionList,isCheckList,達成結果,ごほうびlabelに反映
    /// - Parameter dateStr: 取得するRealmデータの日付
    func realmLoad(_ dateStr:String) {
        debugLog("start. [\(dateStr)]")
        // タップした日の Realmデータが存在したら、取得する
        if (todoCommon.isCheckDateRealm(dateStr: dateStr)) {
            let realmData:TodoModel = todoCommon.getDateRealm(dateStr) as! TodoModel
            
            for i in 0..<realmData.missionInfoList.count {
                missionList.insert(realmData.missionInfoList[i].title, at: self.missionList.endIndex)
                isCheckList.insert(realmData.missionInfoList[i].isCheck, at: isCheckList.endIndex)
                
                // TableViewにセルを追加
                tableView.insertRows(at: [IndexPath(row: missionList.count-1, section: 0)], with: UITableView.RowAnimation.automatic)
            }
            
            // 達成結果
            if realmData.completeFlg {
                completeResults.image = UIImage(systemName: "star.fill")
            } else {
                completeResults.image = UIImage(systemName: "star.leadinghalf.fill")
            }
            completeResults.tintColor = UIColor.yellow

            // ごほうび
            rewardLabel.text = realmData.gohoubi
            
            debugLog("realm loaded.")
        } else {
            /* 何もしない */
        }
    }
    
    /// TableView,missionList,isCheckListを初期化する
    func initTableView() {
        if (missionList.count > 0) {
            let listLen = missionList.count
            tableView.beginUpdates()
            for i in (0..<listLen).reversed() {
                tableView.deleteRows(at: [IndexPath(row: i, section: 0)], with: UITableView.RowAnimation.automatic)
                missionList.remove(at: i)
                isCheckList.remove(at: i)
            }
            tableView.endUpdates()
        }
    }
    
    /// デバッグログ
    /// - Parameters:
    ///   - message: ログ文字列
    ///   - function:
    ///   - file:
    ///   - line:
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
    
    func uiInit() {
        rewardLabel.layer.cornerRadius = 10
        rewardLabel.clipsToBounds = true
        
        completeResults.layer.cornerRadius = 10
        completeResults.clipsToBounds = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
