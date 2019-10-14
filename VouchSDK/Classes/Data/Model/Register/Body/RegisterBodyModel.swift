//
//  RegisterBodyModel.swift
//  VouchSDK
//
//  Created by Ajie Pramono Arganata on 02/09/19.
//  Copyright © 2019 GITS Indonesia. All rights reserved.
//

import Foundation

class RegisterBodyModel: BaseDataParam {
    var apikey: String?
    var info: String?
    var password: String?
    var userid: String?
    
    init(apikey: String?, info: String?, password: String?, userid: String?) {
        super.init()
        self.apikey = apikey
        self.info = info
        self.password = password
        self.userid = userid
        self.param = [
            "apikey": apikey ?? "",
            "info": info ?? "",
            "password": password ?? "",
            "userid": userid ?? ""
        ]
    }
}
