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
    // "YYMMDD"の日付を返却
    class func getDateStr() -> String {
        let date = Date()
        let df = DateFormatter()
        df.dateFormat = "yyyyMMdd"
        print("###getDateStr() : " + df.string(from: date))
        return df.string(from: date)
    }
    
    /// StringからDate型に変換
    /// - Parameters:
    ///   - string: 変換前の文字列 (sample) "2020/12/31 12:34:56 +09:00"
    ///   - format: 変換するフォーマット (sample) "yyyy/MM/dd HH:mm:ss Z"
    /// - Returns: Date型
    class func dateFromString(string: String, format: String) -> Date {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = format
        return formatter.date(from: string)!
    }

    /// Date型からStringに変換
    /// - Parameters:
    ///   - string: Date情報
    ///   - format: 変換するフォーマット (sample) "yyyy/MM/dd HH:mm:ss Z"
    /// - Returns: String型
    class func stringFromDate(date: Date, format: String) -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
}
