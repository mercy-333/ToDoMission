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
