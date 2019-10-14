//
//  VouchSDKImpl.swift
//  VouchSDK
//
//  Created by Ajie Pramono Arganata on 02/09/19.
//  Copyright © 2019 GITS Indonesia. All rights reserved.
//

import Alamofire

class VouchSDKImpl: VouchSDK {
    var application: UIApplication
    var username: String
    var password: String
    var baseUrl: String
    private var mVouchCore: VouchCore?
    private var mVouchData: VouchData?
    private lazy var reachabilityManager = NetworkReachabilityManager()
    
    init(val application: UIApplication, val username: String, val password: String, val baseUrl: String){
        self.application = application
        self.username = username
        self.password = password
        self.baseUrl = baseUrl
    }
    
    /**
     * This BroadCastReceiver will triggered when connection status change
     */
    private func internetReceiver()-> NetworkReachabilityManager.Listener {
        return  { _ in
            if let isNetworkReachable = self.reachabilityManager?.isReachable,
                isNetworkReachable == true {
                //Internet Available
                print("Network STATUS = available)")
                self.mVouchCore?.reconnect()
            } else {
                print("Network STATUS = not avb)")
                //Internet Not Available"
                self.disconnect()
            }
        }
    }
    
    /**
     * @param callback used for callback from request data from socket and api
     * This function used for init socket connection and register BroadCastReceiver,
     * The BroadCastReceiver will triggered when connection status change
     */
    func initSDK(callback: VouchCallback) {
        mVouchCore = VouchCoreBuilder().setupCore(application: application, username: username, password: password, baseUrl: baseUrl, callback: callback).build()
        mVouchData = VouchData()
        reachabilityManager?.startListening()
        reachabilityManager?.listener = self.internetReceiver()
    }
    
    /**
     * Reconnect to socket
     * before reconnect, system will
     * re-register for get new token and new ticket
     */
    func reconnect(callback: VouchCallback, forceReconnect: Bool) {
        if forceReconnect || !isConnected() {
            mVouchCore?.changeActivity(callback: callback)
            reachabilityManager?.startListening()
            mVouchCore?.reconnect()
        }
    }
    
    /**
     * Disconnect from the socket
     */
    func disconnect() {
        mVouchCore?.disconnect()
    }
    
    /**
     * Check current socket connection
     */
    func isConnected()-> Bool {
        return mVouchCore?.isConnected() ?? false
    }
    
    /**
     * Send a new message
     * @param message is content of the message
     * @param callback is callback listener from the API
     */
    func referenceSend(message: String, callback: ReferenceSendCallback) {
        mVouchData?.referenceSend(message: message, callback: callback)
    }
    
    func locationSend(callback: LocationSendCallback) {
        mVouchData?.locationSend(callback: callback)
    }
    
    /**
     * Send a new message
     * @param page
     * @param pageSize is size of list when request the data
     */
    func getListMessages(page: Int, pageSize: Int, callback: MessageCallback) {
        mVouchData?.getListMessage(page: page, pageSize: pageSize, callback: callback)
    }
    
    /**
     * Reply a new message
     * @param body
     * @param callback is size of list when request the data
     */
    func replyMessage(body: MessageBodyModel, callback: ReplyMessageCallback) {
        mVouchData?.replyMessage(body: body, callback: callback)
    }
    
    func uploadFile(body: UploadParam, callback: UploadFileCallback) {
        mVouchData?.uploadFile(body: body, callback: callback)
    }
    
    func uploadVoice(body: VoiceParam, callback: UploadVoiceCallback) {
        mVouchData?.uploadVoice(body: body, callback: callback)
    }
    
    /**
     * @param callback is size of list when request the data
     */
    func getConfig(callback: GetConfigCallback) {
        mVouchData?.getConfig(callback: callback)
    }
    
    /**
     * Close, disconnect from socket, and close socket
     * this function will disable broadcastreceiver too
     */
    func close(application: UIApplication) {
        reachabilityManager?.stopListening()
        mVouchCore?.disconnect()
        mVouchCore?.close()
    }
}
