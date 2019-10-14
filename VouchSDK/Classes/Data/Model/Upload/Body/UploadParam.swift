//
//  UploadParam.swift
//  VouchSDK
//
//  Created by Ajie Pramono Arganata on 30/09/19.
//

import Foundation

public class UploadParam: BaseDataParam {
    public var idSent: String?
    public var file: Data?
    
    public init(idSent: String?, file: Data?) {
        super.init()
        self.idSent = idSent
        self.file = file
        
        if let file = file { self.param["file"] = file }
    }
}
