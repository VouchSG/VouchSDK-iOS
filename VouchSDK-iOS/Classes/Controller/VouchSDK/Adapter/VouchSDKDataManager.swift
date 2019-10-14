//
//  VouchSDKDataManager.swift
//  VouchSDK
//
//  Created by Ajie Pramono Arganata on 13/08/19.
//  Copyright © 2019 GITS Indonesia. All rights reserved.
//

import Foundation

class VouchSDKDataManager {
    public private(set) var listChat: [MessageResponseData] = []
    public private(set) var queueListChat: [MessageResponseData] = []
    public private(set) var isGreeting = false
    
    public private(set) var username: String?
    public private(set) var password: String?
    public private(set) var baseUrl: String?
    
    func setUserData(username: String?, password: String?) {
        self.username = username
        self.password = password
    }
    
    func setBaseUrl(baseUrl: String?) {
        self.baseUrl = baseUrl
    }
    
    func setIsGreeting(value: Bool) {
        self.isGreeting = value
    }
    
    func insertChatToQueue(value: MessageResponseData) {
        self.queueListChat.append(value)
    }
    
    func insertNewChat(value: MessageResponseData) {
        self.listChat.append(value)
    }
    
    func updateChat(idx: Int, value: MessageResponseData) {
        self.listChat[idx] = value
    }
    
    func insertListChat(value: [MessageResponseData]) {
        self.listChat.append(contentsOf: value)
    }
    
    func removeListChat(at index: Int) {
        self.listChat.remove(at: index)
    }
    
    func removeChatFromQueue(at index: Int) {
        self.insertNewChat(value: self.queueListChat[index])
        self.queueListChat.remove(at: index)
    }

    func removeListChat() {
        self.listChat.removeAll()
    }
}
