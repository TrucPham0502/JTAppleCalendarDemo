//
//  AppCalendarCell.swift
//  ISCCamera
//
//  Created by TrucPham on 25/10/2021.
//  Copyright © 2021 fun.sdk.ftel.vn.su4. All rights reserved.
//

import Foundation
import UIKit
import JTAppleCalendar

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
        self.layerCustomView.reloadData()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        widthConstraint?.constant = min(CGFloat(5*self.calendarDataType.count), 5*3)
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
