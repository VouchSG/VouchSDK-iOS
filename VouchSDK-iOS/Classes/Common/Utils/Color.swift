//
//  Color.swift
//  VouchSDK
//
//  Created by Ajie Pramono Arganata on 03/09/19.
//  Copyright © 2019 GITS Indonesia. All rights reserved.
//

import UIColor_Hex_Swift

internal struct Color {
    static let colorNavy = UIColor("#131E2D")
    static let colorWhite = UIColor.white
    static let colorWhiteGray = UIColor("#F2F2F2")
    static let colorGray = UIColor("#B4B4B4")
    static func color(value: String?, defaultColor: UIColor?) -> UIColor? {
        return !Helper.isNullOrEmpty(value: value) ? UIColor(value ?? "") : defaultColor
    }
//    static let colorNavBar = Color.color(value: "", defaultColor: Color.colorNavy)
}
