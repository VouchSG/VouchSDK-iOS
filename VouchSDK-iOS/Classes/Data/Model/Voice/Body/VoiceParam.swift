//
//  VoiceParam.swift
//  VouchSDK
//
//  Created by Ajie Pramono Arganata on 03/10/19.
//

import Foundation

public class VoiceParam: BaseDataParam {
    public var voice: Data?
    
    public init(voice: Data?) {
        super.init()
        self.voice = voice
        
        if let voice = voice { self.param["voice"] = voice.base64EncodedString(options: .lineLength64Characters) }
        self.param["channelCount"] = "2"
    }
}
