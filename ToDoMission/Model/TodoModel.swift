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
    
    init(){
        debugLog("initialized.")
        updateDateStr()
    }
    
    //デバッグログ
    func debugLog(_ message: String = "", function: String = #function, file: String = #file, line: Int = #line) {
        #if DEBUG
            let fileName = URL(string: file)!.lastPathComponent
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
                debugLog("Realm file is NOT exist.")
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
                debugLog("Realm file is NOT exist. \(dateStr)")
                return false
            }
        } catch  {
            debugLog("Realm file check error. \(dateStr)")
            return false
        }
    }
    
    /// 指定した日付のRealmファイルに "ごほうび" が存在するかを判定
    /// - Parameter dateStr: 日付 (ex)"20201231"
    /// - Returns: true(ごほうびあり)/false(ごほうびなし)
    func isCheckGohoubiRealm(dateStr:String) ->Bool {
        // ごほうび データを取得
        var gohoubi = ""
        do {
            let realm =  try Realm()
            let results = realm.objects(TodoModel.self).filter("date == '\(dateStr)'").first
            guard let value = results?.gohoubi else { return false }
            gohoubi = value
        } catch {
            debugLog("get Realm error. \(dateStr)")
        }
    
        // ごほうびを判定
        if (gohoubi == "") {
            debugLog("Gohoubi is NOT exist. [\(dateStr)]")
            return false
        } else {
            debugLog("Gohoubi is exist. [\(dateStr)]")
            return true
        }
    }
    
    /// 指定した日付のRealmファイルに "ごほうび" が存在するかを判定
    /// - Parameter dateStr: 日付 (ex)"20201231"
    /// - Returns: true(ごほうびあり)/false(ごほうびなし)
    func isCheckInfolistRealm(dateStr:String) ->Bool {
        // ごほうび データを取得
        var count = 0
        do {
            let realm =  try Realm()
            let results = realm.objects(TodoModel.self).filter("date == '\(dateStr)'").first
            guard let value = results?.missionInfoList.count else { return false }
            count = value
        } catch {
            debugLog("get Realm error. \(dateStr)")
        }
    
        // ごほうびを判定
        if (count == 0) {
            debugLog("Infolist is NOT exist. [\(dateStr)]")
            return false
        } else {
            debugLog("Infolist is exist. [\(dateStr)]")
            return true
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
    
    func deleteMissionList(missionTitle:String) {
        debugLog("start. [\(missionTitle)]")
        do {
            let realm =  try Realm()
            let today = realm.objects(TodoModel.self).filter("date == '\(todayStr)'").first
            let results = today?.missionInfoList.filter("title == '\(missionTitle)'")
            
            try! realm.write {
                debugLog("deleted : \(String(describing: results))")
                realm.delete(results!)
            }
        } catch {
            debugLog("delete mission error.")
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
        debugLog("start. \(dateStr)")
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
