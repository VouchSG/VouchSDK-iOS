//
//  VouchSDK.swift
//  VouchSDK
//
//  Created by Ajie Pramono Arganata on 27/08/19.
//  Copyright © 2019 GITS Indonesia. All rights reserved.
//

import UIKit

public protocol VouchSDK {
    func initSDK(callback: VouchCallback)
    func reconnect(callback: VouchCallback, forceReconnect: Bool)
    func disconnect()
    func close(application: UIApplication)
    func isConnected()-> Bool
    func referenceSend(message: String, callback: ReferenceSendCallback)
    func locationSend(callback: LocationSendCallback)
    func getListMessages(page: Int, pageSize: Int, callback: MessageCallback)
    func replyMessage(body: MessageBodyModel, callback: ReplyMessageCallback)
    func uploadFile(body: UploadParam, callback: UploadFileCallback)
    func uploadVoice(body: VoiceParam, callback: UploadVoiceCallback)
    func getConfig(callback: GetConfigCallback)
}

public class VouchSDKBuilder {
    private var mUsername = ""
    private var mPassword = ""
    private var baseUrlApi = ""
    
    public init() {}
    
    /**
     * send user credential to SDK
     * @param username is userId for the user
     * @param password is password for the user
     */
    public func setCredential(username: String, password: String) -> VouchSDKBuilder {
        mUsername = username.isEmpty ? Helper.generateDevice() : username
        mPassword = password.isEmpty ? Helper.generateDevice() : password
        return self
    }
    
    public func setBaseURLApi(urlString: String) -> VouchSDKBuilder {
        self.baseUrlApi = urlString.isEmpty ? Constant.BASE_URL_API : urlString
        return self
    }
    
    public func createSDK(application: UIApplication)-> VouchSDK {
        return VouchSDKImpl(val: application, val: mUsername, val: mPassword, val: baseUrlApi)
    }
    
    /** Open Vouch SDK Chat Page
     *
     */
    public func openVouchSDKViewController(from controller: UIViewController) {
        let storyboard = UIStoryboard(name: Constant.VOUCH_STORYBOARD, bundle: VouchSDKViewController.bundleVouch)
        guard let nav = storyboard.instantiateInitialViewController() as? UINavigationController, let vc = nav.topViewController as? VouchSDKViewController else { return }
        vc.configureData(data: ["username": mUsername, "password": mPassword, "baseUrl": self.baseUrlApi])
        controller.present(nav, animated: true, completion: nil)
    }
}
