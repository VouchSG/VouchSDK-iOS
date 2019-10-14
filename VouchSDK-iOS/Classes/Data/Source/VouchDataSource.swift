//
//  VouchDataSource.swift
//  VouchSDK
//
//  Created by Ajie Pramono Arganata on 02/09/19.
//  Copyright © 2019 GITS Indonesia. All rights reserved.
//

import Foundation

protocol VouchDataSource {
    func getConfig(token: String, onSuccess: @escaping (_ data: ConfigData)-> (), onError: @escaping onFailed, onFinish: ()-> ())
    func replyMessage(token: String,body: MessageBodyModel, onSuccess: @escaping (_ data: MessageResponseData)-> (), onError: @escaping onFailed, onFinish: ()-> ())
    func uploadFile(token: String, body: UploadParam, onSuccess: @escaping (_ data: MessageResponseData)-> (), onError: @escaping onFailed, onFinish: ()-> ())
    func uploadVoice(token: String, body: VoiceParam, onSuccess: @escaping (_ data: MessageResponseData)-> (), onError: @escaping onFailed, onFinish: ()-> ())
    func registerUser(token: String, body: RegisterBodyModel, onSuccess: @escaping (_ data: RegisterData)-> (), onError: @escaping onFailed, onFinish: ()-> ())
    func referenceSend(token: String, body: ReferenceSendBodyModel, onSuccess: @escaping (_ data: String)-> (), onError: @escaping onFailed, onFinish: ()-> ())
    func locationSend(token: String, body: LocationSendBodyModel, onSuccess: @escaping (_ data: String)-> (), onError: @escaping onFailed, onFinish: ()-> ())
    func getListMessage(token: String, page: Int, pageSize: Int, onSuccess: @escaping (_ data: [MessageResponseData])-> (), onError: @escaping onFailed, onFinish: ()-> ())
    func saveWebSocketTicket(token: String)
    func getWebSocketTicket()-> String
    func saveApiToken(token: String)
    func getApiToken()-> String
    func revokeCredential()
}
