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
    @objc dynamic var missionList = [String]()
    @objc dynamic var isCheckList = [Bool]()
    @objc dynamic var gohoubi = ""    
}
