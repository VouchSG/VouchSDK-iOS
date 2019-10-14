//
//  ApiService.swift
//  VouchSDK
//
//  Created by Ajie Pramono Arganata on 02/09/19.
//  Copyright © 2019 GITS Indonesia. All rights reserved.
//

import Alamofire

enum ApiService: URLRequestConvertible {
    case doGetConfig(token: String)
    case doPostReplyMessage(body: MessageBodyModel, token: String)
    case doGetListMessage(page: Int, pageSize: Int, token: String)
    case doPostReference(body: ReferenceSendBodyModel, token: String)
    case doPostRegister(body: RegisterBodyModel, token: String)
    case doPostLocation(body: LocationSendBodyModel, token: String)
    case doPostUpload(body: UploadParam, token: String)
    case doPostUploadVoice(body: VoiceParam, token: String)
    
    var method: HTTPMethod {
        switch self {
        case .doGetConfig(_):
            return .get
        case .doGetListMessage(_):
            return .get
        default:
            return .post
        }
    }
    
    var res: (path: String, body: [String: Any], token: String) {
        switch self {
        case .doGetConfig(let token):
            return ("config", [:], token)
        case .doPostReplyMessage(let body, let token):
            return ("messages", body.param, token)
        case .doGetListMessage(let page, let pageSize, let token):
            return ("messages", ["page": page, "pageSize": pageSize], token)
        case .doPostReference(let body, let token):
            return ("messages/referrence", body.param, token)
        case .doPostRegister(let body, let token):
            return ("users/register", body.param, token)
        case .doPostLocation(let body, let token):
            return ("location", body.param, token)
        case .doPostUpload(let body, let token):
            return ("upload", body.param, token)
        case .doPostUploadVoice(let body, let token):
            return ("messages/voice", body.param, token)
        }
    }
    func multipartData()->((MultipartFormData)-> Void)? {
        switch self {
        case .doPostUpload(let body, _):
            return body.asFormData()
        default:
            return nil
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        var url: URL?
        var urlRequest: URLRequest?
        url = try (BaseApi.instance.baseUrl + "/api/v2/widget/").asURL()
        urlRequest = URLRequest(url: (url?.appendingPathComponent(res.path))!)
        urlRequest?.httpMethod = method.rawValue
        urlRequest?.addValue(res.token, forHTTPHeaderField: "token")
        urlRequest?.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest = try method == .post ?
            JSONEncoding.default.encode(urlRequest!, with: multipartData() != nil ? [:] : res.body) :
            URLEncoding.default.encode(urlRequest!, with: res.body)
        print("URL API => "+(urlRequest?.url?.absoluteString)!)
        print("Method => " + method.rawValue)
        print("Token => " + res.token)
        print("Parameter => \(res.body)")
        return urlRequest!
    }
}
