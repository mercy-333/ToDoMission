//
//  ToDoViewController.swift
//  ToDoMission
//
//  Created by Konta on 2020/09/27.
//  Copyright © 2020 Masakazu Konno. All rights reserved.
//

import UIKit

class ToDoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var missionTable: UITableView!
    @IBOutlet weak var archivementRate: UILabel!
    @IBOutlet weak var reward: UITextField!

    // 画像 (true:checked / false:unchecked)
    let checkMark = UIImage(named: "checkMark")
    let unCheckMark = UIImage(named: "unCheckMark")
    
    /* ミッション内容のリスト */
    var missionList = [String]()
    
    /* ミッションリストのチェック状況 */
    /* true:達成 / false:未達成 */
    var isCheckList = [Bool]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        let cellButton = cell.viewWithTag(1) as! UIButton
        cellButton.setImage(unCheckMark, for: .normal)
        
        // カスタムセルのボタンをタップした時にcallするメソッドを設定
        cellButton.addTarget(self, action: #selector(checkButton(_:)), for: .touchUpInside)

        cellButton.tag = indexPath.row
        isCheckList.insert(false, at: isCheckList.endIndex)
        
        return cell
    }
    

    /** ミッション内容の追加 ボタンをタップ*/
    @IBAction func addMission(_ sender: Any) {
        
        // アラート画面設定
        let alertController = UIAlertController(title: "ミッション追加",
                message: "ミッション内容を入力してください。",
                preferredStyle: UIAlertController.Style.alert)
        alertController.addTextField(configurationHandler: nil)
        
        // クロージャ: OKタップ
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (action: UIAlertAction) in
            if let textField = alertController.textFields?.first {
                // ミッションリスト配列に追加
                self.missionList.insert(textField.text!, at: self.missionList.endIndex)
                // ミッションテーブルの先頭に行を追加
                self.missionTable.insertRows(at: [IndexPath(row: self.missionList.count-1, section: 0)], with: UITableView.RowAnimation.right)
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
        print("debug:checkButton(): ", sender.tag, "start")
        print("debug:checkButton(): isCheckList:", isCheckList[sender.tag])
        
        if (isCheckList[sender.tag]) {
            sender.setImage(unCheckMark, for: .normal)
            (isCheckList[sender.tag]) = false
        } else {
            sender.setImage(checkMark, for: .normal)
            (isCheckList[sender.tag]) = true
        }
        print("debug:checkButton(): isCheckList:", isCheckList[sender.tag])
        
//TODO : rewardのパーセンテージ更新
        
        print("debug:checkButton(): ", sender.tag, "end")
    }
}
