//
//  VouchData.swift
//  VouchSDK
//
//  Created by Ajie Pramono Arganata on 02/09/19.
//  Copyright © 2019 GITS Indonesia. All rights reserved.
//

import Foundation

internal class VouchData {
    private let mRepository = Injection.createRepository()
    
    func getConfig(callback: GetConfigCallback) {
        mRepository?.getConfig(token: "", onSuccess: { (result) in
            callback.onSuccess(data: result)
        }, onError: { (code, message) in
            callback.onError(message: message)
        }, onFinish: {
            
        })
    }
    
    func referenceSend(message: String, callback: ReferenceSendCallback) {
        mRepository?.referenceSend(token: "", body: ReferenceSendBodyModel(referrence: message), onSuccess: { (result) in
            callback.onSuccess()
        }, onError: { (code, message) in
            callback.onError(message: message)
        }, onFinish: {
            
        })
    }
    
    func locationSend(callback: LocationSendCallback) {
        LocationHelper.instance.getLocationPermission()
        LocationHelper.instance.onGetLocation = { [weak self] (latitude, longitude) in
            guard let weakSelf = self else { return }
            weakSelf.mRepository?.locationSend(token: "", body: LocationSendBodyModel(longitude: longitude, latitude: latitude), onSuccess: { (result) in
                callback.onSuccess()
            }, onError: { (code, message) in
                callback.onError(message: message)
            }, onFinish: {
                
            })
        }
    }
    
    func registerAccount(credentialKey: String, username: String, password: String, callback: RegisterCallback) {
        mRepository?.registerUser(token: "", body: RegisterBodyModel(apikey: credentialKey, info: "", password: password, userid: NSUserName()), onSuccess: { (result) in
            callback.onSuccess(token: result.token ?? "", socketTicket: result.websocketTicket ?? "")
        }, onError: { (code, message) in
            callback.onError(message: message)
        }, onFinish: {
            
        })
    }
    
    func getListMessage(page: Int, pageSize: Int, callback: MessageCallback) {
        mRepository?.getListMessage(token: "", page: page, pageSize: pageSize, onSuccess: { (result) in
            callback.onSuccess(data: result)
        }, onError: { (code, message) in
            callback.onError(message: message)
        }, onFinish: {
            
        })
    }
    
    func replyMessage(body: MessageBodyModel, callback: ReplyMessageCallback) {
        mRepository?.replyMessage(token: "", body: body, onSuccess: { (result) in
            callback.onSuccess(data: result)
        }, onError: { (code, message) in
            callback.onError(message: message, idSent: body.idSent)
        }, onFinish: {
            
        })
    }
    
    func uploadFile(body: UploadParam, callback: UploadFileCallback) {
        mRepository?.uploadFile(token: "", body: body, onSuccess: { (result) in
            callback.onSuccess(data: result)
        }, onError: { (code, message) in
            callback.onError(message: message, idSent: body.idSent)
        }, onFinish: {
            
        })
    }
    
    func uploadVoice(body: VoiceParam, callback: UploadVoiceCallback) {
        mRepository?.uploadVoice(token: "", body: body, onSuccess: { (result) in
            callback.onSuccess(data: result)
        }, onError: { (code, message) in
            callback.onError(message: message, idSent: nil)
        }, onFinish: {
            
        })
    }
}
