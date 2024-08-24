//
//  DateFormatterManager.swift
//  Liner
//
//  Created by ram on 8/25/24.
//

import Foundation

class DateFormatterManager {
    static let shared = DateFormatterManager()
    
    private init() {}
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        return formatter
    }()
    
    // 여러 날짜 형식 정의
    enum DateFormat: String {
        case fullDateTime = "yyyy-MM-dd HH:mm:ss"
        case shortDate = "yyyy-MM-dd"
        case timeOnly = "HH:mm:ss"
        case customDateTime = "dd/MM/yyyy HH:mm" // 원하는 다른 형식을 추가할 수 있음
    }
    
    // 현재 시간을 포함하는 경우
    func stringWithCurrentDate(format: DateFormat) -> String {
        let currentDate = Date()
        dateFormatter.dateFormat = format.rawValue
        return dateFormatter.string(from: currentDate)
    }
    
    // 특정 날짜를 문자열로 변환 (현재 시간 포함 안함)
    func string(from date: Date, format: DateFormat) -> String {
        dateFormatter.dateFormat = format.rawValue
        return dateFormatter.string(from: date)
    }
    
    // 문자열을 날짜로 변환
    func date(from string: String, format: DateFormat) -> Date? {
        dateFormatter.dateFormat = format.rawValue
        return dateFormatter.date(from: string)
    }
}
