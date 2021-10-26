//
//  AppCalendarConfig.swift
//  ISCCamera
//
//  Created by TrucPham on 25/10/2021.
//  Copyright © 2021 fun.sdk.ftel.vn.su4. All rights reserved.
//

import Foundation
import UIKit
struct AppCalendarConfig {
    static let labelMonthTextColor : UIColor = .black
    static let labelMonthFont : UIFont = .boldSystemFont(ofSize: 20)
    static func dayOfWeekText(_ index : Int) -> String { return "T\(index)" }
    static let labelDayOfWeekTextColor : UIColor = .darkGray
    static let labelDayOfWeekFont : UIFont = .boldSystemFont(ofSize: 13)
    static let labelDayFont : UIFont = .systemFont(ofSize: 16)
    
    static let defaultSelectedColor : UIColor = .blue
    static let defaultDeSelectedColor : UIColor = .white
    static let textSelectedColor : UIColor = .white
    static let textDeSelectedColor : UIColor = .black
    static let textCurrentDayColor : UIColor = .blue
    static let textAnotherMonthColor : UIColor = .gray
    static let textDisableColor : UIColor = .gray
    static func formatTextMonth(_ index : Int) -> String { "Thang \(index) %d" }
    
}
