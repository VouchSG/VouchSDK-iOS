//
//  BaseDataParam.swift
//  VouchSDK
//
//  Created by Ajie Pramono Arganata on 02/09/19.
//  Copyright © 2019 GITS Indonesia. All rights reserved.
//

import Alamofire

public class BaseDataParam {
    var param: [String: Any] = [:]
    
    func asFormData()-> (MultipartFormData)-> Void {
        return { formData in
            for (key, value) in self.param {
                if let data = value as? Data {
                    let mimeType = Swime.mimeType(data: data)
                    formData.append(data, withName: key, fileName: "file.\(mimeType?.ext ?? "")", mimeType: mimeType?.mime ?? "")
                } else {
                    formData.append((value as? String ?? "").data(using: .utf8)!, withName: key)
                }
            }
        }
    }
}
