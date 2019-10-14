//
//  DataCallback.swift
//  VouchSDK
//
//  Created by Ajie Pramono Arganata on 29/08/19.
//  Copyright © 2019 GITS Indonesia. All rights reserved.
//

import Foundation

public protocol ReferenceSendCallback {
    func onSuccess()
    func onError(message: String)
}

public protocol GetConfigCallback {
    func onSuccess(data: ConfigData)
    func onError(message: String)
}

public protocol RegisterCallback {
    func onSuccess(token: String, socketTicket: String)
    func onError(message: String)
}

public protocol LocationSendCallback {
    func onSuccess()
    func onError(message: String)
}

public protocol MessageCallback {
    func onSuccess(data: [MessageResponseData])
    func onError(message: String)
}

public protocol ReplyMessageCallback {
    func onSuccess(data: MessageResponseData)
    func onError(message: String, idSent: String?)
}

public protocol UploadFileCallback {
    func onSuccess(data: MessageResponseData)
    func onError(message: String, idSent: String?)
}

public protocol UploadVoiceCallback {
    func onSuccess(data: MessageResponseData)
    func onError(message: String, idSent: String?)
}
