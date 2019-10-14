//
//  LocationSendBodyModel.swift
//  VouchSDK
//
//  Created by Ajie Pramono Arganata on 17/09/19.
//

import Foundation

public class LocationSendBodyModel: BaseDataParam {
    var longitude: String?
    var latitude: String?
    
    init(longitude: String?, latitude: String?) {
        super.init()
        self.longitude = longitude
        self.latitude = latitude
        
        self.param = [
            "longitude": longitude ?? "",
            "latitude": latitude ?? ""
        ]
    }
}
