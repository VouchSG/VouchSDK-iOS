//
//  VouchCallback.swift
//  VouchSDK
//
//  Created by Ajie Pramono Arganata on 27/08/19.
//  Copyright © 2019 GITS Indonesia. All rights reserved.
//

import Foundation

public protocol VouchCallback {
    func onConnected()
    func onReceivedNewMessage(message: MessageResponseData)
    func onDisconnected(isActionFromUser: Bool)
    func onError(message: String)
}

