//
//  AppCalendarViewDelegate.swift
//  ISCCamera
//
//  Created by TrucPham on 25/10/2021.
//  Copyright © 2021 fun.sdk.ftel.vn.su4. All rights reserved.
//

import Foundation
import UIKit
protocol AppCalendarViewDelegate : AnyObject {
    /**
     Chỉnh sửa layout date.
     - Parameters:
         - view: Date layout
         - text: ngày (String)
         - indexPath: Vị trí date
         - date: ngày (Date)
         - isSelected: Date có đang được chọn không
     */
    func cellConfig(view: AppCalendarCell?, text: String, isSelected : Bool, indexPath: IndexPath, date: Date)
    /**
     Dữ liệu trong ngày.
     - Parameters:
         - view: Date layout
         - text: ngày (String)
         - indexPath: Vị trí date
         - date: ngày (Date)
         - isSelected: Date có đang được chọn không
     - Returns: DS Dữ liệu trong ngày.
     */
    func cellDataType(view: AppCalendarCell?, text: String, isSelected : Bool, indexPath: IndexPath, date: Date) -> [CalendarDataType]
    /**
     Loại ngày.
     - Parameters:
         - view: Date layout
         - text: ngày (String)
         - indexPath: Vị trí date
         - date: ngày (Date)
         - isSelected: Date có đang được chọn không
     - Returns: Loại ngày.
     */
    func cellDayType(view: AppCalendarCell?, text: String, isSelected : Bool, indexPath: IndexPath, date: Date) -> CalendarDayViewType
    /**
     Màu chữ theo loại ngày.
     - Parameters:
         - view: Date layout
         - text: ngày (String)
         - indexPath: Vị trí date
         - date: ngày (Date)
         - isSelected: Date có đang được chọn không
     - Returns: Màu chữ theo loại ngày.
     */
    func cellTextColorDayType(view: AppCalendarCell?, text: String, isSelected : Bool, indexPath: IndexPath, date: Date) -> [CalendarDayViewType : UIColor]
    /**
     Màu background theo loại ngày.
     - Parameters:
         - view: Date layout
         - text: ngày (String)
         - indexPath: Vị trí date
         - date: ngày (Date)
         - isSelected: Date có đang được chọn không
     - Returns: Màu background theo loại ngày.
     */
    func cellSelectedBackgroundColorDayType(view: AppCalendarCell?, text: String, isSelected : Bool, indexPath: IndexPath, date: Date) -> [CalendarDayViewType : UIColor]
    /**
     Màu chữ theo ngày trong tuần.
     - Parameters:
         - view: Date layout
         - text: ngày (String)
         - indexPath: Vị trí date
         - date: ngày (Date)
         - isSelected: Date có đang được chọn không
     - Returns: Màu chữ theo ngày trong tuần.
     */
    func cellColorDayOfWeek(view: AppCalendarCell?, text: String, isSelected : Bool, indexPath: IndexPath, date: Date) -> [Date.Day : UIColor]
    /**
     Màu background theo ngày trong tuần.
     - Parameters:
         - view: Date layout
         - text: ngày (String)
         - indexPath: Vị trí date
         - date: ngày (Date)
         - isSelected: Date có đang được chọn không
     - Returns: Màu background theo ngày trong tuần.
     */
    func cellSelectedBackgroundColorDayOfWeek(view: AppCalendarCell?, text: String, isSelected : Bool, indexPath: IndexPath, date: Date) -> [Date.Day : UIColor]
    
    /**
     Màu dữ liệu trong ngày.
     - Parameters:
         - view: Date layout
         - text: ngày (String)
         - indexPath: Vị trí date
         - date: ngày (Date)
         - isSelected: Date có đang được chọn không
     - Returns: Màu dữ liệu trong ngày.
     */
    func cellColorDataType(view: AppCalendarCell?, text: String, isSelected : Bool, indexPath: IndexPath, date: Date) -> [CalendarDataType : UIColor]
    
    
    /**
     chon ngay.
     - Parameters:
         - dateSelected: ngay chon
     */
    func appCalendarView(_ view : AppCalendarView, dateSelected date: Date)
    
}

extension AppCalendarViewDelegate{
    func cellConfig(view: AppCalendarCell?, text: String, isSelected : Bool, indexPath: IndexPath, date: Date) {
        
    }
    func cellDataType(view: AppCalendarCell?, text: String, isSelected : Bool, indexPath: IndexPath, date: Date) -> [CalendarDataType] {
        return []
    }
    
    func cellDayType(view: AppCalendarCell?, text: String, isSelected : Bool, indexPath: IndexPath, date: Date) -> CalendarDayViewType {
        return .unknown
    }
    
    func appCalendarView(_ view : AppCalendarView, dateSelected date: Date) {
        
    }
    
    func cellTextColorDayType(view: AppCalendarCell?, text: String, isSelected : Bool, indexPath: IndexPath, date: Date) -> [CalendarDayViewType : UIColor] {
        return [:]
    }
    
    func cellSelectedBackgroundColorDayType(view: AppCalendarCell?, text: String, isSelected : Bool, indexPath: IndexPath, date: Date) -> [CalendarDayViewType : UIColor] {
        return [:]
    }
    
    func cellColorDayOfWeek(view: AppCalendarCell?, text: String, isSelected : Bool, indexPath: IndexPath, date: Date) -> [Date.Day : UIColor] {
        return [:]
    }
    
    func cellSelectedBackgroundColorDayOfWeek(view: AppCalendarCell?, text: String, isSelected : Bool, indexPath: IndexPath, date: Date) -> [Date.Day : UIColor] {
        return [:]
    }
    
    func cellColorDataType(view: AppCalendarCell?, text: String, isSelected : Bool, indexPath: IndexPath, date: Date) -> [CalendarDataType : UIColor] {
        return [:]
    }
}
