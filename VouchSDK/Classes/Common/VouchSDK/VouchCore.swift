//
//  VouchCore.swift
//  VouchSDK
//
//  Created by Ajie Pramono Arganata on 27/08/19.
//  Copyright © 2019 GITS Indonesia. All rights reserved.
//

import SocketIO
import SwiftyJSON

internal class VouchCore {
    private var manager: SocketManager?
    private var mSocket: SocketIOClient?
    private var mCallback: VouchCallback?
    
    private var mCredentialKey: String = ""
    private var mRepository: VouchRepository?
    private var isForceDisconnect = false
    
    private var username: String = Helper.generateDevice()
    private var password: String = Helper.generateDevice()
    private var baseUrl: String = Constant.BASE_URL_API
    
    /*========================= Begin of Connection Function =============================*/
    
    /**
     * Set Credential for chat
     */
    func setCredential(username: String, password: String) {
        self.username = username
        self.password = password
    }
    
    /**
     * Set Base URL for api
     */
    func setBaseUrl(baseUrl: String) {
        self.baseUrl = baseUrl
        BaseApi.instance.baseUrl = self.baseUrl
    }
    
    /**
     * initialize all fields
     */
    func initialize(application: UIApplication, callback: VouchCallback) {
        mCallback = callback
        mRepository = Injection.createRepository()
        mCredentialKey = Helper.getVouchSDKApiKey()
    }
    
    /**
     * Register user for get ticket for
     * init socket client
     */
    private func registerUser() {
        mRepository?.registerUser(token: mCredentialKey, body: RegisterBodyModel(apikey: mCredentialKey, info: "", password: password, userid: username), onSuccess: { (result) in
            self.createSocket()
        }, onError: { (code, message) in
            self.mCallback?.onError(message: message)
        }, onFinish: {})
    }
    
    /**
     * Create Socket Client
     */
    func createSocket() {
        self.isForceDisconnect = false
        let url = URL(string: BaseApi.instance.baseUrl)!
        
        self.manager = SocketManager(socketURL: url, config: [.log(true), .extraHeaders(["token": mCredentialKey, "Content-Type": "application/json"]), .connectParams(["channel": "widget", "ticket": mRepository?.getWebSocketTicket() ?? ""])])
//        self.manager = SocketManager(socketURL: request, config: [.log(true), .extraHeaders(["token": mCredentialKey, "Content-Type": "application/json"])])
//        self.manager.ex
        self.mSocket = manager?.defaultSocket
//        self.mSocket?.addHeader(credentialToken: mCredentialKey)
        self.mSocket?.on(clientEvent: .connect, callback: { (data, ack) in
            print("socket connected")
            self.mCallback?.onConnected()
        })
        self.mSocket?.on(Constant.SOCKET_EVENT_NEW_MESSAGE, callback: { (data, ack) in
            guard let data = data.first as? NSDictionary else { return }
            print(JSON(data))
            let obj = MessageResponseData(json: JSON(data))
            self.mCallback?.onReceivedNewMessage(message: obj)
        })
        
        self.mSocket?.on(Constant.SOCKET_EVENT_ERROR, callback: { (data, ack) in
            self.mCallback?.onError(message: data.first as? String ?? "")
        })
        self.mSocket?.on(clientEvent: .disconnect, callback: { (data, ack) in
            print("socket disconnected")
            if !self.isForceDisconnect {
                self.reconnect()
            }
            self.mCallback?.onDisconnected(isActionFromUser: self.isForceDisconnect)
        })
        self.mSocket?.connect()
    }
    
    public static func convertDictionaryToJSONString(data: [String: Any]) -> String{
        if let data = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted),
            let str = String(data: data, encoding: .utf8) {
            return str
        }
        return ""
    }
    
    public static func convertJSONStringToDictionary(text: String) -> [String: Any] {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] ?? [:]
            } catch {
                print(error.localizedDescription)
            }
        }
        return [:]
    }
//    on(EVENT_NEW_MESSAGE) {
//    try {
//    val jsonObject = (it.firstOrNull() as JSONObject).toString()
//    val result = mGson.fromJson<MessageResponseModel>(jsonObject, MessageResponseModel::class.java)
//    executeOnMainThread {
//    mCallback?.onReceivedNewMessage(result)
//    }
//
//    } catch (e: Exception) {
//    executeOnMainThread {
//    mCallback?.onError("invalid response socket for the message object, ${e.message ?: ""}")
//    }
//    }
//    }
    
    /**
     * connect to socket
     */
    func connect() {
        self.mSocket?.connect()
    }
    
    /**
     * Reconnect socket with new ticket
     */
    func reconnect() {
        self.registerUser()
    }
    
    /**
     * Disconnect from socket
     * @param forceDisconnect used for disable retry connection,
     * this param will send back to callback
     */
    func disconnect() {
        self.isForceDisconnect = true
        self.mSocket?.disconnect()
    }
    
    /**
     * Close connection from socket
     */
    func close() {
//        self.mSocket?.close()
    }
    
    /**
     * Check current socket connection
     */
    func isConnected() -> Bool {
        return self.mSocket?.status.active ?? false
    }
    
    func changeActivity(callback: VouchCallback) {
        mCallback = callback
    }
}

class VouchCoreBuilder {
    private var INSTANCE: VouchCore?
    
    func setupCore(application: UIApplication, callback: VouchCallback)-> VouchCoreBuilder {
        if (INSTANCE == nil) {
            INSTANCE = VouchCore()
            INSTANCE?.setCredential(username: Helper.generateDevice(), password: Helper.generateDevice())
            INSTANCE?.setBaseUrl(baseUrl: Constant.BASE_URL_API)
            INSTANCE?.initialize(application: application, callback: callback)
        }
        return self
    }
    
    func setupCore(application: UIApplication, username: String, password: String, baseUrl: String, callback: VouchCallback)-> VouchCoreBuilder {
        if (INSTANCE == nil) {
            INSTANCE = VouchCore()
            INSTANCE?.setCredential(username: username, password: password)
            INSTANCE?.setBaseUrl(baseUrl: baseUrl)
            INSTANCE?.initialize(application: application, callback: callback)
        }
        return self
    }
    
    
    func build()-> VouchCore {
        return INSTANCE!
    }
    
}
