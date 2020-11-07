//
//  Common.swift
//  ToDoMission
//
//  Created by Mercy on 2020/11/03.
//  Copyright © 2020 Mercy's App. All rights reserved.
//

import Foundation
import UIKit


class Common: NSObject {
    class func commonPrint(str:String){
        print("\(str)")
    }
    
    
    // "YYMMDD"の日付を返却
    class func getDateStr() -> String {
        let date = Date()
        let df = DateFormatter()
        df.dateFormat = "yyyyMMdd"
        print("###getDateStr() : " + df.string(from: date))
        return df.string(from: date)
    }
}
