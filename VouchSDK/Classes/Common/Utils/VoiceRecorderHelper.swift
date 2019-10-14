//
//  VoiceRecorderHelper.swift
//  VouchSDK
//
//  Created by Ajie Pramono Arganata on 04/10/19.
//

import AVFoundation

internal class VoiceRecorderHelper: NSObject {
    public static let instance = VoiceRecorderHelper()
    
    private var recordingSession: AVAudioSession?
    private var audioRecorder: AVAudioRecorder?
    private var audioPlayer:AVAudioPlayer?
    private var counter = 0
    private var timer = Timer()
    
    public var onUpdateRecordAction: ((_ value: String)->())?
    public var onFinishRecordAction: ((_ data: Data, _ url: String)->())?
    public var onError: onFailed?
    
    public func doClearClosure() {
        self.onUpdateRecordAction = nil
        self.onFinishRecordAction = nil
        self.onError = nil
    }
}

extension VoiceRecorderHelper: AVAudioRecorderDelegate, AVAudioPlayerDelegate {
     func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        do {
            let data = try Data(contentsOf: recorder.url)
            VoiceRecorderHelper.instance.onFinishRecordAction?(data, recorder.url.absoluteString)
//                self.messageTV.text = data.base64EncodedString(options: .lineLength64Characters)
//                self.viewModel.uploadVoice(body: VoiceParam(voice: data))
//
//                self.dataManager.insertChatToQueue(value: MessageResponseData(text: recorder.url.absoluteString, createdAt: Helper.dateParseToString(Date(), newFormat: Helper.dateOldFormat), msgType: "audio", senderId: "mychat"))
//                if self.timerQueueChat == nil {
//                    self.timerQueueChat?.invalidate()
//                    self.timerQueueChat = Timer.scheduledTimer(timeInterval: 0, target: self, selector: #selector(self.loadNewChat), userInfo: nil, repeats: false)
//                }
        } catch {
            VoiceRecorderHelper.instance.onError?(nil, error.localizedDescription)
        }
        VoiceRecorderHelper.instance.doClearClosure()
    }
    
    private func configureRecordSession() {
        VoiceRecorderHelper.instance.recordingSession = AVAudioSession.sharedInstance()
        do {
            try VoiceRecorderHelper.instance.recordingSession?.setCategory(.playAndRecord, mode: .default)
            try VoiceRecorderHelper.instance.recordingSession?.setActive(true)
            VoiceRecorderHelper.instance.recordingSession?.requestRecordPermission() { [weak self] allowed in
                guard let _ = self else { return }
                DispatchQueue.main.async {
                    if allowed {
//                        self.recordBtn.isEnabled = true
                    } else {
                        // failed to record!
                    }
                }
            }
        } catch {
            // failed to record!
            VoiceRecorderHelper.instance.onError?(nil, error.localizedDescription)
        }
    }
    
    public func startRecording() {
        VoiceRecorderHelper.instance.startTimer()
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        
        // Create File name based on current date/time value
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss";
        let recordingName = formatter.string(from: currentDate) + ".wav"
        
        let filePath = dirPath.appending("/" + recordingName)
        let fileUrl = URL(fileURLWithPath: filePath)
        
        // We need to set the recording category
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.record)
            
            VoiceRecorderHelper.instance.audioRecorder = try AVAudioRecorder(url: fileUrl, settings: [
                AVSampleRateKey: 16000,
                AVFormatIDKey: kAudioFormatLinearPCM,
                AVNumberOfChannelsKey: 2,
                AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue
                ])
            VoiceRecorderHelper.instance.audioRecorder?.delegate = self
            VoiceRecorderHelper.instance.audioRecorder?.isMeteringEnabled = true
            VoiceRecorderHelper.instance.audioRecorder?.record()
        } catch {
            VoiceRecorderHelper.instance.onError?(nil, error.localizedDescription)
        }
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    public func finishRecording() {
        VoiceRecorderHelper.instance.timer.invalidate()
        VoiceRecorderHelper.instance.counter = 0
        
        VoiceRecorderHelper.instance.audioRecorder?.stop()
        VoiceRecorderHelper.instance.audioRecorder = nil
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setActive(false, options: .notifyOthersOnDeactivation)
        } catch {
            VoiceRecorderHelper.instance.onError?(nil, error.localizedDescription)
        }
    }
    
    private func startTimer() {
        VoiceRecorderHelper.instance.counter = 0
        VoiceRecorderHelper.instance.timer.invalidate() // just in case this button is tapped multiple times
        // start the timer
        VoiceRecorderHelper.instance.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    
    private func secondsToHoursMinutesSeconds (seconds : Int) -> String {
        let hours = seconds / 3600
        let minutes = seconds / 60 % 60
        let seconds = seconds % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    @objc private func timerAction() {
        VoiceRecorderHelper.instance.counter += 1
        VoiceRecorderHelper.instance.onUpdateRecordAction?(secondsToHoursMinutesSeconds(seconds: counter))
    }
}
