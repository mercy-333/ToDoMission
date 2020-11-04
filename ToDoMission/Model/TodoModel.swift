//
//  TodoModel.swift
//  ToDoMission
//
//  Created by Konta on 2020/10/08.
//  Copyright © 2020 Masakazu Konno. All rights reserved.
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
    
    //Realmファイルの存在チェック
    func isCheckRealm() ->Bool {
        print("###checkRealm() start. [\(todayStr)]")
        do {
            let realmCheck = try Realm()
            let todayRealm = realmCheck.objects(TodoModel.self).filter("date == '\(todayStr)'")
            if (todayRealm.count > 0) {
                print("###Realm file is already exist.")
                return true
            } else {
                print("###Realm file is not exist.")
                return false
            }
        } catch  {
            print("### Realm file check error.")
            return false
        }
    }
    
    //Realmファイル生成
    func createRealm() {
        print("### createRealm() start.[\(todayStr)")
        do {
            let realm = try! Realm()
            let todoModel = TodoModel()
            todoModel.date = todayStr
            try realm.write {
                realm.add(todoModel)
            }
        } catch {
            print("###createRealm error.")
        }
    }
    
    //更新:ごほうび
    func updateGohoubi(dateStr:String, gohoubiStr:String) {
        print("###updateGohoubi() start. [\(dateStr),\(gohoubiStr)]")
        do {
            let realm =  try Realm()
            let results = realm.objects(TodoModel.self).filter("date == '\(dateStr)'").first
            
            try! realm.write {
                results?.gohoubi = gohoubiStr
            }
        } catch {
            print("###update gohoubi error.")
        }
        print("###updateGohoubi() end.")
        
    }
    
    //追加:ミッションリスト
    func addMissionList(addStr:String) {
        print("###updateMission() call.")
        do {
            let realm =  try Realm()
            let results = realm.objects(TodoModel.self).filter("date == '\(todayStr)'").first
            
            try! realm.write {
                let addInfo:missionInfo = missionInfo(value: ["title":addStr, "isCheck":false])
                results?.missionInfoList.append(addInfo)
                print("### Add info:\(addInfo)")
            }
        } catch {
            print("###add mission error.")
        }
    }
    //更新:ミッションリスト
    func updateMission(){
        
    }
}
