//
//  VouchRepository.swift
//  VouchSDK
//
//  Created by Ajie Pramono Arganata on 02/09/19.
//  Copyright © 2019 GITS Indonesia. All rights reserved.
//

import Foundation

class VouchRepository: VouchDataSource {
    private var localDataSource: VouchDataSource
    private var remoteDataSource: VouchDataSource
    
    init(localDataSource: VouchDataSource, remoteDataSource: VouchDataSource) {
        self.localDataSource = localDataSource
        self.remoteDataSource = remoteDataSource
    }
    
    func getConfig(token: String, onSuccess: @escaping (_ data: ConfigData)-> (), onError: @escaping onFailed, onFinish: ()-> ()) {
        remoteDataSource.getConfig(token: getApiToken(), onSuccess: onSuccess, onError: onError, onFinish: onFinish)
    }

    func replyMessage(token: String, body: MessageBodyModel, onSuccess: @escaping (_ data: MessageResponseData)-> (), onError: @escaping onFailed, onFinish: ()-> ()) {
        remoteDataSource.replyMessage(token: getApiToken(), body: body, onSuccess: onSuccess, onError: onError, onFinish: onFinish)
    }

    func getListMessage(token: String, page: Int, pageSize: Int, onSuccess: @escaping (_ data: [MessageResponseData])-> (), onError: @escaping onFailed, onFinish: ()-> ()) {
        remoteDataSource.getListMessage(token: getApiToken(), page: page, pageSize: pageSize, onSuccess: onSuccess, onError: onError, onFinish: onFinish)
    }

    func registerUser(token: String, body: RegisterBodyModel, onSuccess: @escaping (_ data: RegisterData)-> (), onError: @escaping onFailed, onFinish: ()-> ()) {
        remoteDataSource.registerUser(token: token, body: body, onSuccess: { result in
            self.saveWebSocketTicket(token: result.websocketTicket ?? "")
            self.saveApiToken(token: result.token ?? "")
            onSuccess(result)
        }, onError: onError, onFinish: onFinish)
    }

    func referenceSend(token: String, body: ReferenceSendBodyModel, onSuccess: @escaping (_ data: String)-> (), onError: @escaping onFailed, onFinish: ()-> ()) {
        remoteDataSource.referenceSend(token: getApiToken(), body: body, onSuccess: onSuccess, onError: onError, onFinish: onFinish)
    }
    
    func locationSend(token: String, body: LocationSendBodyModel, onSuccess: @escaping (String) -> (), onError: @escaping onFailed, onFinish: () -> ()) {
        remoteDataSource.locationSend(token: getApiToken(), body: body, onSuccess: onSuccess, onError: onError, onFinish: onFinish)
    }
    
    func uploadFile(token: String, body: UploadParam, onSuccess: @escaping (MessageResponseData) -> (), onError: @escaping onFailed, onFinish: () -> ()) {
        remoteDataSource.uploadFile(token: getApiToken(), body: body, onSuccess: onSuccess, onError: onError, onFinish: onFinish)
    }

    func uploadVoice(token: String, body: VoiceParam, onSuccess: @escaping (MessageResponseData) -> (), onError: @escaping onFailed, onFinish: () -> ()) {
        remoteDataSource.uploadVoice(token: getApiToken(), body: body, onSuccess: onSuccess, onError: onError, onFinish: onFinish)
    }
    
    func saveWebSocketTicket(token: String) {
        localDataSource.saveWebSocketTicket(token: token)
    }

    func getWebSocketTicket()-> String {
        return localDataSource.getWebSocketTicket()
    }

    func saveApiToken(token: String) {
        localDataSource.saveApiToken(token: token)
    }

    func getApiToken()-> String {
        return localDataSource.getApiToken()
    }


    func revokeCredential() {
        localDataSource.revokeCredential()
    }
}
