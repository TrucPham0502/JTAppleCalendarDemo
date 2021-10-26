//
//  AppCalendarDayTypeCell.swift
//  ISCCamera
//
//  Created by TrucPham on 25/10/2021.
//  Copyright © 2021 fun.sdk.ftel.vn.su4. All rights reserved.
//

import Foundation
import UIKit
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
