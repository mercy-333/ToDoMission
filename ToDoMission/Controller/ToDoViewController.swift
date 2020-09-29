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

    /* ミッション内容のリスト */
    var missionList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // test

    }
    
    /* ミッション内容の数 */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return missionList.count
    }
    
    /* セルを生成 **/
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // セルの取得(再利用)
        let cell = missionTable.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath)
        
        // ミッション内容をカスタムセルの tag2(Label)に設定
        let cellLabel = cell.viewWithTag(2) as! UILabel
        cellLabel.text = missionList[indexPath.row]
        
        return cell
    }
    

    /** ミッション内容の追加 */
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
                self.missionList.insert(textField.text!, at: 0)
                // ミッションテーブルの先頭に行を追加
                self.missionTable.insertRows(at: [IndexPath(row: 0, section: 0)], with: UITableView.RowAnimation.right)
            }
        }
        
        alertController.addAction(okAction)
        
        // クロージャ: キャンセルタップ
        let cancelButton = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler: nil)
        alertController.addAction(cancelButton)

        // アラート描画
        present(alertController, animated: true, completion: nil)
    }
}
