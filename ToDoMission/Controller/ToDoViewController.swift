//
//  ToDoViewController.swift
//  ToDoMission
//
//  Created by Mercy on 2020/09/27.
//  Copyright © 2020 Mercy's App. All rights reserved.
//

import UIKit
import GoogleMobileAds
import RealmSwift
import CalculateCalendarLogic

class ToDoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    
    @IBOutlet weak var missionTable: UITableView!
    @IBOutlet weak var archivementRate: UILabel!
    @IBOutlet weak var reward: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bannerView: GADBannerView!
    
    
    // 画像 (true:checked / false:unchecked)
    let checkMark = UIImage(named: "checkMark")
    let unCheckMark = UIImage(named: "unCheckMark")
    
    /* ミッション内容のリスト */
    var missionList = [String]()
    
    /* ミッションリストのチェック状況 */
    /* true:達成 / false:未達成 */
    var isCheckList = [Bool]()
    
    let todoCommon = TodoCommon()

    /*----------------------*/
    /* ViewDidLoad          */
    /*----------------------*/
    override func viewDidLoad() {
        super.viewDidLoad()
        debugLog("#############################")
        debugLog("##### APPLICATION START #####")
        debugLog("#############################")

        reward.delegate = self
        titleLabel.font = UIFont(name: "Mukasi-Mukasi", size: 30)
        //self.view.addBackground(imageName:"stripe.png")
        
        //本番
        //bannerView.adUnitID = "ca-app-pub-2345881481621230/3925128565"
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        debugLog("bannerView loaded.")
        
        todoCommon.updateDateStr()
        
        // Realmインスタンス生成
        if (todoCommon.isCheckRealm()) {
            // 現在日付のデータが存在している場合は生成せず既にあるデータをロードする
            let todayRealmData:TodoModel = todoCommon.getTodayRealm() as! TodoModel
            for i in 0..<todayRealmData.missionInfoList.count {
                missionList.insert(todayRealmData.missionInfoList[i].title, at: self.missionList.endIndex)
                isCheckList.insert(todayRealmData.missionInfoList[i].isCheck, at: isCheckList.endIndex)
            }
            reward.text = todayRealmData.gohoubi
        } else {
            self.todoCommon.createRealm()
        }
        
        debugLog("success.")
    }
    
    /* ミッション内容の数 */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return missionList.count
    }
    
    /* セルを生成時にcall **/
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {        
        // セルの取得(再利用)
        let cell = missionTable.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath)
        
        // ミッション内容をカスタムセルの Label(tag2)に設定
        let cellLabel = cell.viewWithTag(2) as! UILabel
        cellLabel.text = missionList[indexPath.row]
        
        // カスタムセルのボタン(tag1)をunCkeckMarkに設定
        if (cell.viewWithTag(1) as? UIButton) != nil {
            let cellButton = cell.viewWithTag(1) as! UIButton
        
            // true/falseで画像切り替え
            if (isCheckList[indexPath.row] == true) {
                cellButton.setImage(checkMark, for: .normal)
            } else {
                cellButton.setImage(unCheckMark, for: .normal)
            }
                
            // カスタムセルのボタンをタップした時にcallするメソッドを設定
            // * チェックボタンを切り替える
            cellButton.addTarget(self, action: #selector(checkButton(_:)), for: .touchUpInside)

            // カスタムセルのボタンにrowをタグ値として設定
            cellButton.tag = indexPath.row
        } else {
            debugLog("nill eror")
        }
        return cell
    }

    /** 追加 ボタンをタップ */
    @IBAction func addMission(_ sender: Any) {
        
        // アラート画面設定
        let alertController = UIAlertController(title: "ミッション追加",
                message: "ミッション内容を入力してください。",
                preferredStyle: UIAlertController.Style.alert)
        alertController.addTextField(configurationHandler: nil)
        
        // クロージャ: OKタップ
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { [self] (action: UIAlertAction) in
            if let textField = alertController.textFields?.first {
                // ミッションリスト配列に追加
                self.missionList.insert(textField.text!, at: self.missionList.endIndex)
                // ミッションテーブルの先頭に行を追加
                self.missionTable.insertRows(at: [IndexPath(row: self.missionList.count-1, section: 0)], with: UITableView.RowAnimation.right)
                
                self.updateArchivementRate()
                self.todoCommon.addMissionList(addStr:textField.text!)
                self.todoCommon.updateGohoubi(gohoubiStr: reward.text! )
            }
        }
        
        alertController.addAction(okAction)
        
        // クロージャ: キャンセルタップ
        let cancelButton = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler: nil)
        alertController.addAction(cancelButton)

        // アラート描画
        present(alertController, animated: true, completion: nil)
    }
    
    // カスタムセル内のチェックボックスをタップ
    // チェックボックス画像を切り替える
    @objc func checkButton(_ sender:UIButton) {
        if (isCheckList[sender.tag]) {
            sender.setImage(unCheckMark, for: .normal)
            (isCheckList[sender.tag]) = false
            todoCommon.updateMission(missionTitle:missionList[sender.tag], missionIsCheck:false)
        } else {
            sender.setImage(checkMark, for: .normal)
            (isCheckList[sender.tag]) = true
            todoCommon.updateMission(missionTitle:missionList[sender.tag], missionIsCheck:true)
        }
        updateArchivementRate()

    }
    
    /* 達成率更新 */
    func updateArchivementRate() {
        var countTrue = 0
        var result:Float = 0
        
        for data in isCheckList {
            if data {
                countTrue += 1
            }
        }
        result = Float(countTrue) / Float(isCheckList.count) * 100
        let result_str = String(format: "%.0f", result)
        archivementRate.text = "\(result_str) %   ( \(countTrue) / \(isCheckList.count) )"
        
        if result.isEqual(to: 100) {
            performSegue(withIdentifier: "PopUpSegue", sender: nil)
            todoCommon.updateCompleteFlg(flg:true)
        } else {
            todoCommon.updateCompleteFlg(flg:false)
        }
    }
    
    func gohoubi(){
        performSegue(withIdentifier: "PopUpSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PopUpSegue" {
            let nextView = segue.destination as! PopUpViewController
            nextView.rewardGetStr = reward.text!
            
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    // 遷移テスト用　最後に消す
    @IBAction func segueTest(_ sender: Any) {
        debugLog("segue:\(NSDate.now)")
        performSegue(withIdentifier: "PopUpSegue", sender: nil)
    }
    //デバッグログ
    func debugLog(_ message: String = "", function: String = #function, file: String = #file, line: Int = #line) {
        #if DEBUG
            let fileName = URL(string: file)!.lastPathComponent
            //NSLog("\(fileName) #\(line) \(function): \(message)")
            print("# \(fileName) #\(line) \(function): \(message)")
        #endif
    }
}
