//
//  AppCalendarView.swift
//  CalendarDemo
//
//  Created by Truc Pham on 18/08/2021.
//

import Foundation
import UIKit
import SnapKit
import JTAppleCalendar
struct AppCalendarConfig {
    static let labelMonthTextColor : UIColor = .black
    static let labelMonthFont : UIFont = .boldSystemFont(ofSize: 20)
    static let dayOfWeekText : String = "T%d"
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
    static let formatTextMonth : String = "Tháng %d %d"
    
}


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
}

class AppCalendarView: UIView {
    enum DisableDate {
        case prevDate, nextDate , none
    }
    
    var disableDate : DisableDate = .nextDate
    var beforeCurrentMonth : Int = 2
    var afterCurrentMonth : Int = 0
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
        v.setTitle("Next", for: .normal)
        v.setTitleColor(.gray, for: .normal)
        v.addTarget(self, action: #selector(self.buttonNextHandler(_:)), for: .touchUpInside)
        return v
    }()
    fileprivate lazy var buttonPrev : UIButton = {
        let v = UIButton(frame: .init(origin: .zero, size: .init(width: 24, height: 24)))
        v.setTitle("Prev", for: .normal)
        v.setTitleColor(.gray, for: .normal)
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
        
        for i in 2...8{
            let thuLabel = createDayOfWeekLabel(text: String(format: AppCalendarConfig.dayOfWeekText, i))
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
                    
                    if let color = delegate?.cellSelectedBackgroundColorDayOfWeek(view: cell, text: cellState.text, isSelected : cellState.isSelected, indexPath: indexPath, date: date)[date.dayOfWeek]{
                        selectedcolor = color
                    }
                    else if let dayType = delegate?.cellDayType(view: cell, text: cellState.text, isSelected : cellState.isSelected, indexPath: indexPath, date: date), let color = delegate?.cellSelectedBackgroundColorDayType(view: cell,  text: cellState.text, isSelected : cellState.isSelected, indexPath: indexPath, date: date)[dayType] {
                        selectedcolor = color
                    }
                    myCustomCell.selectedView.backgroundColor = selectedcolor
                    myCustomCell.selectedView.isHidden = false
                } else {
                    /// text color
                    var selectedcolor : UIColor = AppCalendarConfig.textDeSelectedColor
                    if let color = delegate?.cellColorDayOfWeek(view: cell,  text: cellState.text, isSelected : cellState.isSelected, indexPath: indexPath, date: date)[date.dayOfWeek]{
                        selectedcolor = color
                    }
                    else if let dayType = delegate?.cellDayType(view: cell,  text: cellState.text, isSelected : cellState.isSelected, indexPath: indexPath, date: date), let color = delegate?.cellTextColorDayType(view: cell,  text: cellState.text, isSelected : cellState.isSelected, indexPath: indexPath, date: date)[dayType] {
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
        labelMonth.text = String(format: AppCalendarConfig.formatTextMonth, date.month, date.year)
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

enum CalendarType : Int {
    case single = 1
    case multi = 6
}


class AppCalendarCell: JTACDayCell {
    let selectedViewSize : CGSize = .init(width: 32, height: 32)
    var widthConstraint : NSLayoutConstraint?
    var dataTypeColor : [CalendarDataType : UIColor] = [:]
    var calendarDataType : [CalendarDataType] = []
    {
        didSet{
            setupViewType()
        }
    }
    lazy var dayLabel: UILabel = {
        let v = UILabel()
        v.textColor = .lightGray
        v.font = AppCalendarConfig.labelDayFont
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    lazy var selectedView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .blue
        return v
    }()
    lazy var layerCustomView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 4, height: 4)
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        let v = UICollectionView(frame: .zero, collectionViewLayout: layout)
        v.dataSource = self
        v.register(AppCalendarDayTypeCell.self, forCellWithReuseIdentifier: "AppCalendarDayTypeCell")
        v.backgroundColor = .clear
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        prepareUI()
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func prepareUI()
    {
        
        self.addSubview(selectedView)
        self.addSubview(dayLabel)
        self.addSubview(layerCustomView)
        widthConstraint = layerCustomView.widthAnchor.constraint(equalToConstant: min(CGFloat(5*self.calendarDataType.count),  5*3))
        NSLayoutConstraint.activate([
            selectedView.heightAnchor.constraint(equalToConstant: selectedViewSize.height),
            selectedView.widthAnchor.constraint(equalToConstant: selectedViewSize.width),
            selectedView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            selectedView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            dayLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            dayLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            layerCustomView.topAnchor.constraint(equalTo: self.dayLabel.bottomAnchor, constant: -1),
            layerCustomView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -3),
            layerCustomView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            widthConstraint!
        ])
    }
    
    private func setupViewType()
    {
        widthConstraint?.constant = min(CGFloat(5*self.calendarDataType.count), 5*3)
        self.layerCustomView.reloadData()
        
    }
    
    
}

extension AppCalendarCell : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return calendarDataType.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AppCalendarDayTypeCell", for: indexPath) as? AppCalendarDayTypeCell else {
            return UICollectionViewCell()
        }
        cell.view.backgroundColor = dataTypeColor[self.calendarDataType[indexPath.row]]
        return cell
    }
    
    
}



enum CalendarDataType {
    case success, fail, waitting, unknown
}

enum CalendarDayViewType {
    case off, holiday, unknown
}

class AppCalendarDayTypeCell : UICollectionViewCell {
    lazy var view : UIView = {
        let v = UIView()
        v.layer.cornerRadius = 2
        v.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(v)
        NSLayoutConstraint.activate([
            v.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            v.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            v.heightAnchor.constraint(equalToConstant: 3),
            v.widthAnchor.constraint(equalToConstant: 3)
        ])
        return v
    }()
}
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
