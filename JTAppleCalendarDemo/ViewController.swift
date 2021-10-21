//
//  ViewController.swift
//  JTAppleCalendarDemo
//
//  Created by Truc Pham on 21/10/2021.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let v = AppCalendarView(frame: CGRect(x: 0, y: 50, width: self.view.frame.width, height: 325), calendarType: .multi)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.delegate = self
        self.view.addSubview(v)
        NSLayoutConstraint.activate([
            v.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 70),
            v.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            v.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            v.heightAnchor.constraint(equalToConstant: 325)
        ])
    }
    
    
}

extension ViewController : AppCalendarViewDelegate{
    func cellDataType(view: AppCalendarCell?,  text: String, isSelected : Bool, indexPath: IndexPath, date: Date) -> [CalendarDataType] {
        if Calendar.current.isDateInToday(date) {
            return [.fail,.success, .waitting]
        }
        return []
    }
    func cellColorDataType(view: AppCalendarCell?,  text: String, isSelected : Bool, indexPath: IndexPath, date: Date) -> [CalendarDataType : UIColor] {
        return [.fail : .red, .success : .green, .waitting : .orange, .unknown : .black]
    }
//    func cellColorDayOfWeek(view: AppCalendarCell?, cellState: CellState, indexPath: IndexPath, date: Date) -> [Date.Day : UIColor] {
//        return [.sunday : .gray, .monday : .red]
//    }
//    func cellSelectedBackgroundColorDayOfWeek(view: AppCalendarCell?, cellState: CellState, indexPath: IndexPath, date: Date) -> [Date.Day : UIColor] {
//        return [.sunday : .blue]
//    }
}
