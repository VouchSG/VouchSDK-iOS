//
//  VouchSDKViewModel.swift
//  VouchSDK
//
//  Created by Ajie Pramono Arganata on 02/09/19.
//  Copyright © 2019 GITS Indonesia. All rights reserved.
//

import Foundation

class VouchSDKViewModel: VouchCallback {
    private var application: UIApplication!
    private var username = ""
    private var password = ""
    private var baseUrl = ""
    private var mVouchSDK: VouchSDK!
    
    var isRequesting = Observable<Bool>()
    var changeConnectStatus = Observable<Bool>()
    var eventShowMessage = Observable<String>()
    var loadConfiguration = Observable<ConfigData>()
    var loadReceivedNewMessage = Observable<MessageResponseData>()
    var loadListMessage = Observable<[MessageResponseData]>()
    var loadReplyMessage = Observable<MessageResponseData>()
    var onFailed: ((_ message: String, _ idSent: String?)->())?
    
    init(application: UIApplication, username: String, password: String, baseUrl: String, onFailed: ((_ message: String, _ idSent: String?) ->())?) {
        self.username = username
        self.password = password
        self.baseUrl = baseUrl
        self.mVouchSDK = VouchSDKBuilder().setCredential(username: username, password: password).setBaseURLApi(urlString: baseUrl).createSDK(application: application)
        self.onFailed = onFailed
    }
    
    func start() {
        mVouchSDK.initSDK(callback: self)
    }
    
    func onConnected() {
        changeConnectStatus.property = true
        getLayoutConfiguration()
    }
    
    func onReceivedNewMessage(message: MessageResponseData) {
        loadReceivedNewMessage.property = message
    }
    
    func onDisconnected(isActionFromUser: Bool) {
        changeConnectStatus.property = false
    }
    
    func onError(message: String) {
        eventShowMessage.property = message
        isRequesting.property = false
        self.onFailed?(message, nil)
    }
    
    private func getLayoutConfiguration() {
        isRequesting.property = true
        mVouchSDK.getConfig(callback: self)
    }
        
    public func replyMessage(body: MessageBodyModel) {
        mVouchSDK.replyMessage(body: body, callback: self)
    }
    
    public func uploadFile(body: UploadParam) {
        mVouchSDK.uploadFile(body: body, callback: self)
    }
    
    public func uploadVoice(body: VoiceParam) {
        mVouchSDK.uploadVoice(body: body, callback: self)
    }
    
    public func sendReferrence() {
        mVouchSDK.referenceSend(message: "welcome", callback: self)
    }
    
    public func sendLocation() {
        mVouchSDK.locationSend(callback: self)
    }
    
    func disconnectSocket() {
        mVouchSDK.disconnect()
    }
    
    func reconnectSocket(){
        mVouchSDK.reconnect(callback: self, forceReconnect: true)
    }
}

extension VouchSDKViewModel: GetConfigCallback {
    func onSuccess(data: ConfigData) {
        loadConfiguration.property = data
        isRequesting.property = false
        if loadListMessage.property == nil {
            mVouchSDK.getListMessages(page: 1, pageSize: 10, callback: self)
        }
    }
}

extension VouchSDKViewModel: MessageCallback {
    func onSuccess(data: [MessageResponseData]) {
        self.loadListMessage.property = data.reversed()
    }
}

extension VouchSDKViewModel: ReplyMessageCallback, UploadVoiceCallback {
    func onSuccess(data: MessageResponseData) {
        self.loadReplyMessage.property = data
    }
    
    func onError(message: String, idSent: String?) {
        self.onFailed?(message, idSent)
    }
}

extension VouchSDKViewModel: ReferenceSendCallback {
    func onSuccess() {
        
    }
}

extension VouchSDKViewModel: LocationSendCallback {
    
}

extension VouchSDKViewModel: UploadFileCallback {
    func onSuccess(data: String) {
        
    }
}
