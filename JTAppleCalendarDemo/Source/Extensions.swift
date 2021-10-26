//
//  Extensions.swift
//  JTAppleCalendarDemo
//
//  Created by TrucPham on 26/10/2021.
//

import Foundation
import UIKit
extension Date {
    var day : Int
    {
        let calendar = Calendar.current
        return calendar.component(.day, from: self)
    }
    var month : Int
    {
        let calendar = Calendar.current
        return calendar.component(.month, from: self)
    }
    var year : Int
    {
        let calendar = Calendar.current
        return calendar.component(.year, from: self)
    }
    func noon(using calendar: Calendar = .current) -> Date {
        calendar.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    func day(using calendar: Calendar = .current) -> Int {
        calendar.component(.day, from: self)
    }
    func adding(_ component: Calendar.Component, value: Int, using calendar: Calendar = .current) -> Date {
        calendar.date(byAdding: component, value: value, to: self)!
    }
    func monthSymbol(using calendar: Calendar = .current) -> String {
        calendar.monthSymbols[calendar.component(.month, from: self)-1]
    }
    var removeTimeStamp : Date {
        guard let date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: self)) else {
            fatalError("Failed to strip time from Date object")
        }
        return date
    }
    var startOfMonth: Date {
        
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year, .month], from: self)
        
        return  calendar.date(from: components)!
    }
    var endOfMonth: Date {
        var components = DateComponents()
        components.month = 1
        components.second = -1
        return Calendar(identifier: .gregorian).date(byAdding: components, to: startOfMonth)!
    }
    var startOfWeek: Date? {
        let gregorian = Calendar.current
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 1, to: sunday)
    }
    
    var endOfWeek: Date? {
        let gregorian = Calendar.current
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 7, to: sunday)
    }
    static func from(year: Int, month: Int, day: Int) -> Date? {
        let calendar = Calendar(identifier: .gregorian)
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        
        return calendar.date(from: dateComponents)
    }
    var dayOfWeek : Day {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: self)
        return Day(rawValue: calendar.component(.weekday, from: today)) ?? .none
    }
    enum Day : Int {
        case none = -1
        case sunday = 1, monday = 2,tuesday = 3, wednesday = 4, thursday = 5, friday = 6, saturday = 7
    }
    
}
extension String {
    var firstCapitalized: String {
        var string = self
        string.replaceSubrange(string.startIndex...string.startIndex, with: String(string[string.startIndex]).capitalized)
        return string
    }
}
