//
//  BaseApi.swift
//  VouchSDK
//
//  Created by Ajie Pramono Arganata on 02/09/19.
//  Copyright © 2019 GITS Indonesia. All rights reserved.
//

import Alamofire
import SwiftyJSON

typealias onResponseSuccess = (_ response: JSON)->()
typealias onRequest = (_ request: DataRequest)->()
typealias onFailed = (_ code: Int?, _ message: String)->()

struct BaseApi {
    public static var instance = BaseApi()
    public var baseUrl = Constant.BASE_URL_API
    
    init() {}
    
    static func request(url: ApiService, usingMultipart: Bool = false, onSuccess: @escaping onResponseSuccess, onFailed: @escaping onFailed, onRequest: @escaping onRequest) {
        if usingMultipart, let multipartData = url.multipartData() {
            Alamofire.upload(multipartFormData: multipartData, with: url, encodingCompletion: { (encodingResult) in
                switch encodingResult {
                case .success(let request, _, _):
                    let runRequest = request.responseJSON { response in
                        var json: JSON?
                        var code: Int?
                        var errorMessage: String?
                        switch response.result {
                        case .success(let value) :
                            json = JSON(value)
                        case .failure(let error) :
                            let nserror = error as NSError
                            code = nserror.code
                            errorMessage = nserror.localizedDescription
                        }
                        if errorMessage == nil, let json = json {
                            print("JSON Result => \(String(describing: json))" )
                            onSuccess(json)
                        } else if let err = errorMessage {
                            print("JSON Error => \(err)" )
                            if err.lowercased() != "cancelled" {
                                onFailed(code, err)
                            }
                        }
                    }
                    onRequest(runRequest)
                case .failure(let encodingError):
                    print("===Failure Encoding===")
                    print(encodingError)
                    onFailed(nil, encodingError.localizedDescription)
                }
            })
        } else {
            let request = Alamofire.request(url).responseJSON(completionHandler: { (response) in
                var json: JSON?
                var errorMessage: String?
                var code: Int?
                switch response.result {
                case .success(let value) :
                    json = JSON(value)
                case .failure(let error) :
                    let error = error as NSError
                    code = error.code
                    errorMessage = error.localizedDescription
                }
                if errorMessage == nil, let json = json {
                    print("JSON Result => \(String(describing: json))" )
                    onSuccess(json)
                } else if let err = errorMessage {
                    print("JSON Error => \(err)" )
                    if err.lowercased() != "cancelled" {
                        onFailed(code, err)
                    }
                }
            })
            onRequest(request)
        }
    }
}
