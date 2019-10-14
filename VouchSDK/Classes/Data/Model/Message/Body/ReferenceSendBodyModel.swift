//
//  ReferenceSendBodyModel.swift
//  VouchSDK
//
//  Created by Ajie Pramono Arganata on 02/09/19.
//  Copyright © 2019 GITS Indonesia. All rights reserved.
//

import Foundation

class ReferenceSendBodyModel: BaseDataParam {
    var referrence: String?
    
    init(referrence: String?) {
        super.init()
        self.referrence = referrence
        self.param = [
            "referrence": referrence
        ]
    }
}
