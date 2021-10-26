//
//  AppCalendarView.swift
//  ISCCamera
//
//  Created by TrucPham on 25/10/2021.
//  Copyright © 2021 fun.sdk.ftel.vn.su4. All rights reserved.
//

import Foundation
import UIKit
import JTAppleCalendar
import SnapKit

enum CalendarDataType {
    case success, fail, waitting, unknown
}

enum CalendarDayViewType {
    case off, holiday, unknown
}
enum CalendarType : Int {
    case single = 1
    case multi = 6
}
class AppCalendarView: UIView {
    enum DisableDate {
        case prevDate, nextDate , none
    }
    
    var disableDate : DisableDate = .nextDate
    var beforeCurrentMonth : Int = 2 {
        didSet {
            reloadData()
        }
    }
    var afterCurrentMonth : Int = 0 {
        didSet {
            reloadData()
        }
    }
    var calendarType : CalendarType {
        didSet {
            reloadData()
        }
    }
    fileprivate lazy var labelMonth : UILabel = {
        let v = UILabel()
        v.font = AppCalendarConfig.labelMonthFont
        v.textColor = AppCalendarConfig.labelMonthTextColor
        return v
    }()
    fileprivate lazy var buttonNext : UIButton = {
        let v = UIButton(frame: .init(origin: .zero, size: .init(width: 24, height: 24)))
        v.transform = .init(rotationAngle: CGFloat.pi)
        v.setImage(.init(named: "ic_arrow_left_black"), for: .normal)
        v.addTarget(self, action: #selector(self.buttonNextHandler(_:)), for: .touchUpInside)
        return v
    }()
    fileprivate lazy var buttonPrev : UIButton = {
        let v = UIButton(frame: .init(origin: .zero, size: .init(width: 24, height: 24)))
        v.setImage(.init(named: "ic_arrow_left_black"), for: .normal)
        v.addTarget(self, action: #selector(self.buttonPrevHandler(_:)), for: .touchUpInside)
        return v
    }()
    fileprivate lazy var viewHeader : UIView = {
        let v = UIView()
        return v
    }()
    fileprivate lazy var viewDaysOfWeek : UIView = {
        let v = UIView()
        return v
    }()
    fileprivate lazy var calendarView : JTACMonthView = {
        let v = JTACMonthView()
        v.backgroundColor = .white
        v.isUserInteractionEnabled = true
        v.ibCalendarDelegate = self
        v.ibCalendarDataSource = self
        v.showsHorizontalScrollIndicator = false
        v.minimumLineSpacing = 0
        v.minimumInteritemSpacing = 0
        v.scrollingMode = .stopAtEachSection
        v.scrollDirection = .horizontal
        v.register(AppCalendarCell.self, forCellWithReuseIdentifier: "AppCalendarCell")
        return v
    }()
    
    weak var delegate : AppCalendarViewDelegate?
    /**
     - Returns: Ngày được chọn
     */
    var dateSelected : Date? {
        return self.calendarView.selectedDates.first
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.calendarType = .multi
        super.init(coder: aDecoder)
        self.prepareUI()
    }
    
    init(frame: CGRect, calendarType : CalendarType) {
        self.calendarType = calendarType
        super.init(frame: frame)
        self.prepareUI()
    }
    
    public override init(frame: CGRect) {
        self.calendarType = .multi
        super.init(frame: frame)
        self.prepareUI()
    }
    
    
    override func awakeFromNib() {
        self.calendarType = .multi
        super.awakeFromNib()
        self.prepareUI()
    }
    
    private func prepareUI() {
        [viewHeader,viewDaysOfWeek ,calendarView].forEach({ self.addSubview($0) })
        
        [labelMonth,buttonPrev, buttonNext].forEach({ viewHeader.addSubview($0) })
        
        ///header
        viewHeader.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
        }
        labelMonth.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
        }
        buttonPrev.snp.makeConstraints { (make) -> Void in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(buttonNext.snp.leading).offset(-24)
            make.width.equalTo(self.buttonPrev.bounds.width)
            make.height.equalTo(self.buttonPrev.bounds.height)
        }
        buttonNext.snp.makeConstraints { (make) -> Void in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
            make.width.equalTo(self.buttonNext.bounds.width)
            make.height.equalTo(self.buttonNext.bounds.height)
        }
        
        /// create day of week
        viewDaysOfWeek.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(viewHeader.snp.bottom).offset(26)
            make.leading.equalTo(self).offset(24)
            make.trailing.equalTo(self).offset(-24)
        }
        daysOfWeekPrepare()
        
        /// calendar view
        calendarView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(viewDaysOfWeek.snp.bottom).offset(11)
            make.bottom.equalTo(self)
            make.leading.equalTo(self).offset(24)
            make.trailing.equalTo(self).offset(-24)
        }
        moveToDay()
        
        
    }
    
    
    private func daysOfWeekPrepare() {
        let stackDaysOfWeek = UIStackView()
        stackDaysOfWeek.distribution = .fillEqually
        stackDaysOfWeek.axis = .horizontal
        
        for i in 0...6{
            let thuLabel = createDayOfWeekLabel(text: AppCalendarConfig.dayOfWeekText(i))
            stackDaysOfWeek.addArrangedSubview(thuLabel)
        }
        viewDaysOfWeek.addSubview(stackDaysOfWeek)
        stackDaysOfWeek.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(viewDaysOfWeek).offset(8)
            make.bottom.equalTo(viewDaysOfWeek).offset(-8)
            make.leading.equalTo(viewDaysOfWeek)
            make.trailing.equalTo(viewDaysOfWeek)
        }
    }
    
    private func createDayOfWeekLabel(text : String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textAlignment = .center
        label.textColor = AppCalendarConfig.labelDayOfWeekTextColor
        label.font = AppCalendarConfig.labelDayOfWeekFont
        return label
    }
    /**
        Load lại data.
     */
    func reloadData()
    {
        calendarView.reloadData()
    }
    
    @objc private func buttonNextHandler(_ button: UIButton) {
        if let currentSection = self.calendarView.currentSection() {
            self.calendarView.scrollToItem(at: .init(row: 0, section: currentSection + 1), at: .left, animated: true)
        }
       
    }
    @objc private func buttonPrevHandler(_ button: UIButton) {
        if let currentSection = self.calendarView.currentSection() {
            self.calendarView.scrollToItem(at: .init(row: 0, section: currentSection - 1), at: .left, animated: true)
        }
    }
    /**
        Di chuyển đến ngày hiện tại.
     */
    func moveToDay() {
        let dateNow = Date()
        setSelected(date: dateNow)
    }
    
    /**
        Di chuyển đến ngày.
     */
    func setSelected(date : Date)
    {
        calendarView.selectDates([date], triggerSelectionDelegate: false)
        calendarView.scrollToDate(date)
        setupViewsOfCalendar(from: date)
        delegate?.appCalendarView(self, dateSelected: date)
    }
    
    private func resetCell(cell: AppCalendarCell, cellState: CellState){
        cell.isHidden = false
        cell.isUserInteractionEnabled = true
        cell.dayLabel.text = cellState.text
        cell.selectedView.isHidden = true
        cell.selectedView.layer.sublayers = []
        cell.dayLabel.textColor = AppCalendarConfig.textDeSelectedColor
    }
    
    private func handleCellConfiguration(cell: AppCalendarCell?, cellState: CellState, indexPath: IndexPath, date: Date) {
        guard let myCustomCell = cell  else {
            return
        }
        resetCell(cell: myCustomCell, cellState: cellState)
        if(cellState.dateBelongsTo == .thisMonth || calendarType == .single){
            var enable = true
            switch self.disableDate {
            case .nextDate:
                enable = !(cellState.date.removeTimeStamp > Date().removeTimeStamp)
            case .prevDate:
                enable = !(cellState.date.removeTimeStamp < Date().removeTimeStamp)
            default:
                break
            }
            myCustomCell.isUserInteractionEnabled = enable
            if enable {
                if cellState.isSelected {
                    /// text color
                    myCustomCell.dayLabel.textColor = AppCalendarConfig.textSelectedColor
                    /// background
                    myCustomCell.selectedView.layer.cornerRadius =  myCustomCell.selectedViewSize.height / 2
                    var selectedcolor : UIColor = AppCalendarConfig.defaultSelectedColor
                    if let dayType = delegate?.cellDayType(view: cell, text: cellState.text, isSelected : cellState.isSelected, indexPath: indexPath, date: date), let color = delegate?.cellSelectedBackgroundColorDayType(view: cell,  text: cellState.text, isSelected : cellState.isSelected, indexPath: indexPath, date: date)[dayType] {
                        selectedcolor = color
                    }
                    else if let color = delegate?.cellSelectedBackgroundColorDayOfWeek(view: cell, text: cellState.text, isSelected : cellState.isSelected, indexPath: indexPath, date: date)[date.dayOfWeek]{
                        selectedcolor = color
                    }
                    myCustomCell.selectedView.backgroundColor = selectedcolor
                    myCustomCell.selectedView.isHidden = false
                } else {
                    /// text color
                    var selectedcolor : UIColor = AppCalendarConfig.textDeSelectedColor
                    if let dayType = delegate?.cellDayType(view: cell,  text: cellState.text, isSelected : cellState.isSelected, indexPath: indexPath, date: date), let color = delegate?.cellTextColorDayType(view: cell,  text: cellState.text, isSelected : cellState.isSelected, indexPath: indexPath, date: date)[dayType] {
                        selectedcolor = color
                    }
                    else if let color = delegate?.cellColorDayOfWeek(view: cell,  text: cellState.text, isSelected : cellState.isSelected, indexPath: indexPath, date: date)[date.dayOfWeek]{
                        selectedcolor = color
                    }
                    myCustomCell.dayLabel.textColor = selectedcolor
                    
                    /// background
                    myCustomCell.selectedView.backgroundColor = AppCalendarConfig.defaultDeSelectedColor
                    myCustomCell.selectedView.isHidden = true
                    
                    /// current date deselect
                    if Calendar.current.isDateInToday(date) {
                        myCustomCell.dayLabel.textColor = AppCalendarConfig.textCurrentDayColor
                        myCustomCell.selectedView.layer.borderWidth = 1
                        myCustomCell.selectedView.layer.borderColor = AppCalendarConfig.textCurrentDayColor.cgColor
                        myCustomCell.selectedView.layer.cornerRadius =  myCustomCell.selectedViewSize.height / 2
                        myCustomCell.selectedView.isHidden = false
                    }
                }
            }
            else {
                myCustomCell.dayLabel.textColor = AppCalendarConfig.textDisableColor
                myCustomCell.selectedView.backgroundColor = AppCalendarConfig.defaultDeSelectedColor
            }
        } else {
            myCustomCell.isHidden = (calendarType == .multi)
            myCustomCell.isUserInteractionEnabled = false
        }
        
        delegate?.cellConfig(view: cell,  text: cellState.text, isSelected : cellState.isSelected, indexPath: indexPath, date: date)
    }
    
    
    
    private func setupViewsOfCalendar(from date: Date) {
        labelMonth.text = String(format: AppCalendarConfig.formatTextMonth(date.month - 1), date.year)
        let month = self.calendarView.numberOfSections(in: self.calendarView)
        if let currentSection = self.calendarView.currentSection() {
            buttonNext.isEnabled = currentSection < month - 1
            buttonPrev.isEnabled = currentSection > 0
        }
       
        
    }
}
extension AppCalendarView: JTACMonthViewDelegate, JTACMonthViewDataSource  {
    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        let curDate = Date()
        var startDate = curDate.adding(.month, value: -self.beforeCurrentMonth)
        var endDate = curDate.adding(.month, value: self.afterCurrentMonth)
        switch calendarType {
        case .multi:
            startDate = startDate.startOfMonth
            endDate = endDate.endOfMonth
        case .single:
            startDate = startDate.startOfMonth
            endDate = endDate.endOfWeek ?? endDate
        }
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "vi_VI")
        let parameters = ConfigurationParameters(startDate: startDate,
                                                 endDate: endDate,
                                                 numberOfRows: calendarType.rawValue,
                                                 calendar: calendar,
                                                 generateInDates: .forAllMonths,
                                                 generateOutDates: .tillEndOfGrid,
                                                 firstDayOfWeek: .monday)
        return parameters
    }
    
    func configureVisibleCell(myCustomCell: AppCalendarCell, cellState: CellState, date: Date, indexPath: IndexPath) {
        myCustomCell.dayLabel.text = cellState.text
        handleCellConfiguration(cell: myCustomCell, cellState: cellState, indexPath: indexPath, date: date)
    }
    
    func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        // This function should have the same code as the cellForItemAt function
        let myCustomCell = cell as! AppCalendarCell
        configureVisibleCell(myCustomCell: myCustomCell, cellState: cellState, date: date, indexPath: indexPath)
    }
    
    func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        let myCustomCell = calendar.dequeueReusableCell(withReuseIdentifier: "AppCalendarCell", for: indexPath) as! AppCalendarCell
        configureVisibleCell(myCustomCell: myCustomCell, cellState: cellState, date: date, indexPath: indexPath)
        myCustomCell.dataTypeColor = delegate?.cellColorDataType(view: myCustomCell, text: cellState.text, isSelected : cellState.isSelected, indexPath: indexPath, date: date) ?? [:]
        myCustomCell.calendarDataType = delegate?.cellDataType(view: myCustomCell, text: cellState.text, isSelected : cellState.isSelected, indexPath: indexPath, date: date) ?? []
        return myCustomCell
    }
    
    func calendar(_ calendar: JTACMonthView, didDeselectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        guard let cell  = cell as? AppCalendarCell else { return }
        handleCellConfiguration(cell: cell, cellState: cellState, indexPath: indexPath, date: date)
    }
    
    func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        guard let cell  = cell as? AppCalendarCell else { return }
        handleCellConfiguration(cell: cell, cellState: cellState, indexPath: indexPath, date: date)
        setupViewsOfCalendar(from: date)
        delegate?.appCalendarView(self, dateSelected: date)
    }
    

    func calendarDidScroll(_ calendar: JTACMonthView) {
        guard let startDate = calendar.visibleDates().monthDates.first?.date else {
            return
        }
        setupViewsOfCalendar(from: startDate)
    }
    
    func sizeOfDecorationView(indexPath: IndexPath) -> CGRect {
        let stride = calendarView.frame.width * CGFloat(indexPath.section)
        return CGRect(x: stride + 5, y: 5, width: calendarView.frame.width - 10, height: calendarView.frame.height - 10)
    }
}

