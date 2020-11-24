//
//  TodoModel.swift
//  ToDoMission
//
//  Created by Mercy on 2020/10/08.
//  Copyright © 2020 Mercy's App. All rights reserved.
//

import Foundation
import RealmSwift

class TodoModel: Object {
    @objc dynamic var date = "" //yyyy.mm.dd
    @objc dynamic var gohoubi = ""
    @objc dynamic var completeFlg = false
    var missionInfoList = List<missionInfo>()
    
    // 日付を主キーとする
    override class func primaryKey() -> String? {
        return "date"
    }
}

class missionInfo: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var isCheck: Bool = false
}

class TodoCommon {
    
    var todayStr = ""
    
    //デバッグログ
    func debugLog(_ message: String = "", function: String = #function, file: String = #file, line: Int = #line) {
        #if DEBUG
            let fileName = URL(string: file)!.lastPathComponent
            //NSLog("\(fileName) #\(line) \(function): \(message)")
            print("# \(fileName) #\(line) \(function): \(message)")
        #endif
    }
    
    //更新:日付のメンバ変数
    func updateDateStr(){
        let date = Date()
        let df = DateFormatter()
        df.dateFormat = "yyyyMMdd"
        todayStr = df.string(from: date)
        debugLog("\(todayStr)")
    }
    
    /// 当日のRealmファイルが存在するかを判定
    /// - Returns: true(ファイルあり)/false(ファイルなし)
    func isCheckTodayRealm() ->Bool {
        debugLog("start.")
        
        do {
            let realmCheck = try Realm()
            let todayRealm = realmCheck.objects(TodoModel.self).filter("date == '\(todayStr)'")
            if (todayRealm.count > 0) {
                debugLog("Realm file is already exist.")
                return true
            } else {
                debugLog("Realm file is not exist.")
                return false
            }
        } catch  {
            debugLog("Realm file check error.")
            return false
        }
    }
    
    /// 指定した日付のRealmファイルが存在するかを判定
    /// - Parameter dateStr: 日付 (ex)"20201231"
    /// - Returns: true(ファイルあり)/false(ファイルなし)
    func isCheckDateRealm(dateStr:String) ->Bool {
        do {
            let realmCheck = try Realm()
            let todayRealm = realmCheck.objects(TodoModel.self).filter("date == '\(dateStr)'")
            if (todayRealm.count > 0) {
                debugLog("Realm file is exist. \(dateStr)")
                return true
            } else {
                debugLog("Realm file is not exist. \(dateStr)")
                return false
            }
        } catch  {
            debugLog("Realm file check error. \(dateStr)")
            return false
        }
    }
    
    //Realmファイル生成
    func createRealm() {
        debugLog("start :\(todayStr)")
        do {
            let realm = try! Realm()
            let todoModel = TodoModel()
            todoModel.date = todayStr
            try realm.write {
                realm.add(todoModel)
            }
        } catch {
            debugLog("createRealm error.")
        }
        debugLog("success.")
    }
    
    //更新:ごほうび
    func updateGohoubi(gohoubiStr:String) {
        debugLog("start. :[\(gohoubiStr)]")
        do {
            let realm =  try Realm()
            let results = realm.objects(TodoModel.self).filter("date == '\(todayStr)'").first
            try! realm.write {
                results?.gohoubi = gohoubiStr
            }
        } catch {
            debugLog("update error.")
        }
        debugLog("success.")
    }
    
    //更新:完了フラグ
    func updateCompleteFlg(flg:Bool) {
        debugLog("start. :set[\(flg)]")
        do {
            let realm =  try Realm()
            let results = realm.objects(TodoModel.self).filter("date == '\(todayStr)'").first
            try! realm.write {
                results?.completeFlg = flg
            }
        } catch {
            debugLog("update error.")
        }
        debugLog("success.")
    }
    
    //追加:ミッションリスト
    func addMissionList(addStr:String) {
        debugLog("start.")
        do {
            let realm =  try Realm()
            let results = realm.objects(TodoModel.self).filter("date == '\(todayStr)'").first
            
            try! realm.write {
                let addInfo:missionInfo = missionInfo(value: ["title":addStr, "isCheck":false])
                results?.missionInfoList.append(addInfo)
                debugLog("Add info:\(addInfo)")
            }
        } catch {
            debugLog("add mission error.")
        }
        debugLog("success.")
    }
    
    //更新:ミッションリスト
    func updateMission(missionTitle:String, missionIsCheck:Bool) {
        debugLog("start.")
        do {
            let realm =  try Realm()
            let results = realm.objects(TodoModel.self).filter("date == '\(todayStr)'").first
            
            try! realm.write {
                /*results?.missionInfoList = tmpInfoList
                debugLog("updated :\(tmpInfoList)")
                */
                for i in 0..<(results?.missionInfoList.count)! {
                    if (results?.missionInfoList[i].title == missionTitle ) {
                        debugLog("Hit! cnt[\(i)]")
                        results?.missionInfoList[i].isCheck = missionIsCheck
                    }
                }
                debugLog("updated : \(String(describing: results?.missionInfoList))")
            }
        } catch {
            debugLog("update mission error.")
        }
        debugLog("success.")
    }
    
    
    /// 当日のRealmファイルを取得する
    /// - Returns: TodoModel型データ
    func getTodayRealm() ->Any {
        debugLog("start.")
        var results = TodoModel()
        
        do {
            let realm =  try Realm()
            results = realm.objects(TodoModel.self).filter("date == '\(todayStr)'").first!
            
        } catch {
            debugLog("get Realm error. \(todayStr)")
        }
        debugLog("success.")
        return results
    }
    
    /// 指定した日のRealmファイルを取得する
    /// - Parameter dateStr: 日付 (ex)"20201231"
    /// - Returns: TodoModel型データ
    func getDateRealm(_ dateStr:String) -> Any {
        debugLog("start.")
        var results = TodoModel()
        
        do {
            let realm =  try Realm()
            results = realm.objects(TodoModel.self).filter("date == '\(dateStr)'").first!
            
        } catch {
            debugLog("get Realm error. \(dateStr)")
        }
        debugLog("success.")
        return results
    }

}
