//
//  MessageBodyModel.swift
//  VouchSDK
//
//  Created by Ajie Pramono Arganata on 02/09/19.
//  Copyright © 2019 GITS Indonesia. All rights reserved.
//

import Foundation

public class MessageBodyModel: BaseDataParam {
    var idSent: String? // temp local id
    var msgType: String?
    var payload: String?
    var text: String?
    var type: String?
    
    init(idSent: String?, msgType: String?, payload: String?, text: String?, type: String?) {
        super.init()
        self.idSent = idSent
        
        self.msgType = msgType
        self.payload = payload
        self.text = text
        self.type = type
        self.param = [
            "msgType": msgType ?? "",
            "payload": payload ?? "",
            "text": text ?? "",
            "type": type ?? ""
        ]
    }
}
