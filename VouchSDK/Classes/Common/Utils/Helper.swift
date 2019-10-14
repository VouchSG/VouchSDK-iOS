//
//  Helper.swift
//  VouchSDK
//
//  Created by Ajie Pramono Arganata on 27/08/19.
//  Copyright © 2019 GITS Indonesia. All rights reserved.
//

import Foundation

internal struct Helper {
    
    /** Vouch SDK Api Key From Info.plist
    */
    static func getVouchSDKApiKey()-> String {
        let infoDictionary = Bundle.main.infoDictionary ?? [:]
        let apikey = infoDictionary[Constant.VOUCH_SDK_API_KEY] as? String ?? ""
        return apikey
    }
    
    /** Generate Device ID
    *   This Method allows you to get unique device ID From your phone
    */
    static func generateDevice() -> String {
        return UIDevice.current.identifierForVendor?.uuidString ?? ""
    }
    
    /** Check is null or empty on a string
    */
    static func isNullOrEmpty(value: String?) -> Bool {
        return value == nil || value == ""
    }
    
    static let dateOldFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    static func dateParseToString(_ date: Date, newFormat: String)-> String {
        let newFormatter = DateFormatter()
        newFormatter.dateFormat = newFormat
        let newDateString = newFormatter.string(from: date)
        return newDateString
    }
    static func dateParseToString(_ date: String, oldFormat: String, newFormat: String)-> String {
        let oldFormatter = DateFormatter()
        oldFormatter.dateFormat = oldFormat
        let newFormatter = DateFormatter()
        newFormatter.dateFormat = newFormat
        var newDateString = date
        if let oldDate = oldFormatter.date(from: date) {
            newDateString = newFormatter.string(from: oldDate)
        }
        return newDateString
    }
}
