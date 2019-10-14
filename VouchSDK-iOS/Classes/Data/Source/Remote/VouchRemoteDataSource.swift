//
//  VouchRemoteDataSource.swift
//  VouchSDK
//
//  Created by Ajie Pramono Arganata on 02/09/19.
//  Copyright © 2019 GITS Indonesia. All rights reserved.
//

import Alamofire

class VouchRemoteDataSource: VouchDataSource {
    public var currentRequest: DataRequest?
    func getConfig(token: String, onSuccess: @escaping (_ data: ConfigData)-> (), onError: @escaping onFailed, onFinish: ()-> ()) {
        currentRequest?.cancel()
        BaseApi.request(url: ApiService.doGetConfig(token: token), onSuccess: { response in
            let obj = ConfigResponseModel(json: response)
            if obj.code == 200, let data = obj.data {
                onSuccess(data)
            } else {
                onError(obj.code, obj.message ?? "")
            }
        }, onFailed: { (code, errMessage) in
            onError(code, errMessage)
        }, onRequest: { request in
            self.currentRequest = request
        })
    }
    
    func replyMessage(token: String, body: MessageBodyModel, onSuccess: @escaping (_ data: MessageResponseData)-> (), onError: @escaping onFailed, onFinish: ()-> ()) {
        currentRequest?.cancel()
        BaseApi.request(url: ApiService.doPostReplyMessage(body: body, token: token), onSuccess: { response in
            let obj = DAOReplyMessageBaseClass(json: response)
            if obj.code == 200, let data = obj.data {
                data.idSent = body.idSent
                onSuccess(data)
            } else {
                onError(obj.code, obj.message ?? "")
            }
        }, onFailed: { (code, errMessage) in
            onError(code, errMessage)
        }, onRequest: { request in
            self.currentRequest = request
        })
    }
    
    func registerUser(token: String, body: RegisterBodyModel, onSuccess: @escaping (_ data: RegisterData)-> (), onError: @escaping onFailed, onFinish: ()-> ()) {
        currentRequest?.cancel()
        BaseApi.request(url: ApiService.doPostRegister(body: body, token: token), onSuccess: { response in
            let obj = RegisterResponseModel(json: response)
            if obj.code == 200, let data = obj.data {
                onSuccess(data)
            } else {
                onError(obj.code, obj.message ?? "")
            }
        }, onFailed: { (code, errMessage) in
            onError(code, errMessage)
        }, onRequest: { request in
            self.currentRequest = request
        })
    }
    
    func referenceSend(token: String, body: ReferenceSendBodyModel, onSuccess: @escaping (_ data: String)-> (), onError: @escaping onFailed, onFinish: ()-> ()) {
        currentRequest?.cancel()
        BaseApi.request(url: ApiService.doPostReference(body: body, token: token), onSuccess: { response in
            
        }, onFailed: { (code, errMessage) in
            onError(code, errMessage)
        }, onRequest: { request in
            self.currentRequest = request
        })
    }
    
    func locationSend(token: String, body: LocationSendBodyModel, onSuccess: @escaping (String) -> (), onError: @escaping onFailed, onFinish: () -> ()) {
        currentRequest?.cancel()
        BaseApi.request(url: ApiService.doPostLocation(body: body, token: token), onSuccess: { (response) in
            onSuccess("")
        }, onFailed: { (code, errMessage) in
            onError(code, errMessage)
        }) { (request) in
            self.currentRequest = request
        }
    }
    
    func getListMessage(token: String, page: Int, pageSize: Int, onSuccess: @escaping (_ data: [MessageResponseData])-> (), onError: @escaping onFailed, onFinish: ()-> ()) {
        currentRequest?.cancel()
        BaseApi.request(url: ApiService.doGetListMessage(page: page, pageSize: pageSize, token: token), onSuccess: { response in
            let obj = MessageResponseModel(json: response)
            if obj.code == 200, let data = obj.data {
                onSuccess(data)
            } else {
                onError(obj.code, obj.message ?? "")
            }
        }, onFailed: { (code, errMessage) in
            onError(code, errMessage)
        }, onRequest: { request in
            self.currentRequest = request
        })
    }
    
    func uploadFile(token: String, body: UploadParam, onSuccess: @escaping (MessageResponseData) -> (), onError: @escaping onFailed, onFinish: () -> ()) {
        BaseApi.request(url: ApiService.doPostUpload(body: body, token: token), usingMultipart: true, onSuccess: { (rawjson) in
            let obj = DAOUploadFileBaseClass(json: rawjson)
            if obj.code == 200, let data = obj.data?.url {
                self.replyMessage(token: token, body: MessageBodyModel(idSent: body.idSent, msgType: "image", payload: "", text: data, type: "image"), onSuccess: onSuccess, onError: onError, onFinish: { })
            } else {
                onError(obj.code, obj.message ?? "")
            }
        }, onFailed: onError) { (request) in
            self.currentRequest = request
        }
    }
    
    func uploadVoice(token: String, body: VoiceParam, onSuccess: @escaping (MessageResponseData) -> (), onError: @escaping onFailed, onFinish: () -> ()) {
        BaseApi.request(url: ApiService.doPostUploadVoice(body: body, token: token), onSuccess: { (rawjson) in
            let obj = DAOReplyMessageBaseClass(json: rawjson)
            if obj.code == 200, let data = obj.data {
                onSuccess(data)
            } else {
                onError(obj.code, obj.message ?? "")
            }
        }, onFailed: onError) { (request) in
            self.currentRequest = request
        }
    }
    
    func saveWebSocketTicket(token: String) {}
    func getWebSocketTicket()-> String { return "" }
    func saveApiToken(token: String) {}
    func getApiToken()-> String { return ""}
    func revokeCredential() {}
}
