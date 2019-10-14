//
//  VouchLocalDataSource.swift
//  VouchSDK
//
//  Created by Ajie Pramono Arganata on 02/09/19.
//  Copyright © 2019 GITS Indonesia. All rights reserved.
//

import Foundation

internal class VouchLocalDataSource: VouchDataSource {
    private static let mPref = UserDefaults(suiteName: Constant.PREF_KEY)
    
    private static func apply() {
        VouchLocalDataSource.mPref?.synchronize()
    }

    func saveWebSocketTicket(token: String) {
        VouchLocalDataSource.mPref?.set(token, forKey: Constant.PREF_SOCKET_TICKET)
        VouchLocalDataSource.apply()
    }
    
    func getWebSocketTicket()-> String {
        return VouchLocalDataSource.mPref?.string(forKey: Constant.PREF_SOCKET_TICKET) ?? ""
    }
    
    func saveApiToken(token: String) {
        VouchLocalDataSource.mPref?.set(token, forKey: Constant.PREF_API_KEY)
        VouchLocalDataSource.apply()
    }
    
    func getApiToken()-> String {
        return VouchLocalDataSource.mPref?.string(forKey: Constant.PREF_API_KEY) ?? ""
    }
    
    func revokeCredential() {
//        mPref.edit().clear().apply()
    }
    
    func getConfig(token: String, onSuccess: (_ data: ConfigData)-> (), onError: @escaping onFailed, onFinish: ()-> ()) {
        throwRemoteException()
    }
    
    func getListMessage(token: String, page: Int, pageSize: Int, onSuccess: (_ data: [MessageResponseData])-> (), onError: @escaping onFailed, onFinish: ()-> ()) {
        throwRemoteException()
    }
    
    func registerUser(token: String, body: RegisterBodyModel, onSuccess: (_ data: RegisterData)-> (), onError: @escaping onFailed, onFinish: () -> Unit) {
        throwRemoteException()
    }
    
    func referenceSend(token: String, body: ReferenceSendBodyModel, onSuccess: (_ data: String)-> (), onError: @escaping onFailed, onFinish: ()-> ()) {
        throwRemoteException()
    }
    
    func locationSend(token: String, body: LocationSendBodyModel, onSuccess: @escaping (String) -> (), onError: @escaping onFailed, onFinish: () -> ()) {
        throwRemoteException()
    }
    
    func replyMessage(token: String, body: MessageBodyModel, onSuccess: (_ data: MessageResponseData)-> (), onError: @escaping onFailed, onFinish: ()-> ()) {
        throwRemoteException()
    }
    
    func uploadFile(token: String, body: UploadParam, onSuccess: @escaping (MessageResponseData) -> (), onError: @escaping onFailed, onFinish: () -> ()) {
        throwRemoteException()
    }
    
    func uploadVoice(token: String, body: VoiceParam, onSuccess: @escaping (MessageResponseData) -> (), onError: @escaping onFailed, onFinish: () -> ()) {
        throwRemoteException()
    }
    
    func registerUser(token: String, body: RegisterBodyModel, onSuccess: (RegisterData) -> (), onError: @escaping onFailed, onFinish: () -> ()) {}
    
    private func throwRemoteException() {
//        throw Error("This function only available on RemoteDataSource")
    }
    
    
}
