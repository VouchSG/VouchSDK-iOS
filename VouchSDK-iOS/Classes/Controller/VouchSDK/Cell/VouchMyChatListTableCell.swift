//
//  ChatDetailMineTableCell.swift
//  GITSChat
//
//  Created by Ajie Pramono Arganata on 13/08/19.
//  Copyright © 2019 GITS Indonesia. All rights reserved.
//

import UIKit
import AVKit
import SwiftAudio

internal class VouchMyChatListTableCell: UITableViewCell {
    // MARK: Outlet
    @IBOutlet weak var videoConstraint: NSLayoutConstraint!
    @IBOutlet weak var videoContainerVw: UIView!
    @IBOutlet weak var videoImageVw: UIImageView!
    @IBOutlet weak var videoPlayBtn: CustomButton!
    @IBOutlet weak var audioVw: UIView!
    @IBOutlet weak var audioSlider: UISlider!
    @IBOutlet weak var audioTimeLbl: UILabel!
    @IBOutlet weak var audioPlayBtn: CustomButton!
    @IBOutlet weak var attachmentImgVw: UIImageView!
    @IBOutlet weak var attachmentImgHeight: NSLayoutConstraint!
    @IBOutlet weak var mineContentVw: UIView!
    @IBOutlet weak var mineMessageLbl: UILabel!
    @IBOutlet weak var mineTimeLbl: UILabel!
    @IBOutlet weak var icSentImgVw: UIImageView!
    @IBOutlet weak var maxChatConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var previewBtn: UIButton!
    @IBOutlet weak var retryBtn: UIButton!
    
    // MARK: Properties
    let audioSessionController = AudioSessionController.shared
    var player: QueuedAudioPlayer? = nil
    private var isScrubbing: Bool = false
    private var lastLoadFailed: Bool = false
    private var onTapPreviewBtnAction: ((_ type: String?, _ url: String?)->())?
    private var onTapRetryBtnAction: ((_ idx: Int)->())?
    private var videoSnapshot: UIImage?
    private var data: MessageResponseData?
    private var configData: ConfigData?
    private var idx: Int?
    
    private func configureCell(data: MessageResponseData, isFirst: Bool, configData: ConfigData?) {
        self.data = data
        self.configData = configData
        
        self.retryBtn.isHidden = !data.isError
        
        self.icSentImgVw.image = UIImage(named: self.data?.isSent == true ? "ic_chat_sent" : "ic_time", in: VouchSDKViewController.bundleVouch, compatibleWith: nil)
        
        self.mineMessageLbl.text = data.text ?? ""
        self.mineTimeLbl.text = Helper.dateParseToString(data.createdAt ?? "", oldFormat: Helper.dateOldFormat, newFormat: "dd MMM, HH:mm")
        self.mineContentVw.backgroundColor = Color.color(value: configData?.rightBubbleBgColor, defaultColor: Color.colorNavy)
        self.mineMessageLbl.textColor = Color.color(value: configData?.rightBubbleColor, defaultColor: Color.colorWhite)
        let max = UIScreen.main.bounds.width / 2.8
        self.maxChatConstraint.constant = max
        
        self.audioTimeLbl.textColor = Color.color(value: configData?.rightBubbleColor, defaultColor: Color.colorWhite)
        let audioSliderThumb = UIImage(named: "ic_ellipse", in: VouchSDKViewController.bundleVouch, compatibleWith: nil)?.maskWithColor(color: Color.colorNavy)
        self.audioSlider.setThumbImage(audioSliderThumb, for: .normal)
        self.audioSlider.setThumbImage(audioSliderThumb, for: .highlighted)
        
        self.videoPlayBtn.setImage(self.videoPlayBtn.currentImage?.maskWithColor(color: Color.color(value: configData?.rightBubbleBgColor, defaultColor: Color.colorNavy) ?? Color.colorNavy), for: .normal)
        self.videoPlayBtn.backgroundColor = Color.color(value: configData?.rightBubbleColor, defaultColor: Color.colorWhiteGray)
        
        if data.msgType == "image" {
            self.previewBtn.isHidden = false
            self.videoContainerVw.isHidden = true
            self.attachmentImgVw.isHidden = false
            self.mineMessageLbl.isHidden = true
            self.audioVw.isHidden = true
            if let image = data.text, let url = URL(string: image) {
                self.attachmentImgVw.sd_setImage(with: url) { (image, error, cahces, urls) in
                    guard let image = image else { return }
                    let hImage = image.size.height
                    let hWidth = image.size.width
                    let wImg = self.frame.width - max - 44
                    let finishHeight  = (hImage*wImg) / hWidth
                    self.attachmentImgHeight.constant = finishHeight
                    self.setNeedsLayout()
                }
            } else {
                if let image = data.imageLocal {
                    self.attachmentImgVw.image = image
                    let hImage = image.size.height
                    let hWidth = image.size.width
                    let wImg = self.frame.width - max - 44
                    let finishHeight  = (hImage*wImg) / hWidth
                    self.attachmentImgHeight.constant = finishHeight
                    self.setNeedsLayout()
                } else {
                    self.attachmentImgVw.image = nil
                }
            }
        } else if data.msgType == "video" {
            self.previewBtn.isHidden = false
            self.videoContainerVw.isHidden = false
            self.attachmentImgVw.isHidden = true
            self.mineMessageLbl.isHidden = true
            self.audioVw.isHidden = true
            if let video = data.text {
                self.videoImageVw.backgroundColor = .clear
                if self.videoSnapshot == nil {
                    self.videoSnapshot = self.videoSnapshot(filePathLocal: video)
                }
                if let videoSnaspshot = self.videoSnapshot {
                    self.videoImageVw.image = videoSnapshot
                    let hImage = videoSnaspshot.size.height
                    let hWidth = videoSnaspshot.size.width
                    let wImg = self.frame.width - max - 44
                    let finishHeight  = (hImage*wImg) / hWidth
                    self.videoConstraint.constant = finishHeight
                    self.setNeedsLayout()
                }
            } else {
                self.videoImageVw.image = nil
                self.videoImageVw.backgroundColor = .lightGray
            }
        } else if data.msgType == "audio" {
            self.previewBtn.isHidden = true
            self.videoContainerVw.isHidden = true
            self.attachmentImgVw.isHidden = true
            self.attachmentImgVw.image = nil
            self.mineMessageLbl.isHidden = true
            self.audioVw.isHidden = false
            
            let controller = RemoteCommandController()
            player = QueuedAudioPlayer(remoteCommandController: controller)
            let audio = DefaultAudioItem(audioUrl: data.text ?? "", artist: "", title: "", albumTitle: "", sourceType: .stream, artwork: nil)
            try? audioSessionController.set(category: .playback)
            try? player?.add(item: audio, playWhenReady: false)
            player?.event.stateChange.addListener(self, handleAudioPlayerStateChange)
            player?.event.seek.addListener(self, handleAudioPlayerDidSeek)
            player?.event.secondElapse.addListener(self, handleAudioPlayerSecondElapsed)
            player?.event.updateDuration.addListener(self, handleAudioPlayerUpdateDuration)
            player?.event.didRecreateAVPlayer.addListener(self, handleAVPlayerRecreated)
            player?.event.fail.addListener(self, handlePlayerFailure)
            handleAudioPlayerStateChange(data: player!.playerState)
        } else {
            self.previewBtn.isHidden = true
            self.videoContainerVw.isHidden = true
            self.attachmentImgVw.isHidden = true
            self.attachmentImgVw.image = nil
            self.mineMessageLbl.isHidden = false
            self.audioVw.isHidden = true
        }
        
        self.audioTimeLbl.changeFont(fontText: configData?.fontStyle ?? "")
        self.mineTimeLbl.changeFont(fontText: configData?.fontStyle ?? "")
        self.mineMessageLbl.changeFont(fontText: configData?.fontStyle ?? "")
    }
    
    @IBAction func previewBtnAction(_ sender: UIButton) {
        guard let data = self.data else { return }
        self.onTapPreviewBtnAction?(data.msgType, data.text)
    }
    
    @IBAction func retryBtnAction(_ sender: UIButton) {
        guard let idx = self.idx else { return }
        self.data?.isError = false
        self.retryBtn.isHidden = true
        self.onTapRetryBtnAction?(idx)
    }
    
    func videoSnapshot(filePathLocal: String) -> UIImage? {
        guard let vidURL = URL(string: filePathLocal) else { return nil }
        let asset = AVURLAsset(url: vidURL)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        
        let timestamp = CMTime(seconds: 0, preferredTimescale: 1)
        do {
            let imageRef = try generator.copyCGImage(at: timestamp, actualTime: nil)
            return UIImage(cgImage: imageRef)
        } catch let error as NSError {
            print("Image generation failed with error \(error)")
            return nil
        }
    }
    
    @IBAction func togglePlay(_ sender: Any) {
        if !audioSessionController.audioSessionIsActive {
            try? audioSessionController.activateSession()
        }
        if lastLoadFailed, let item = player?.currentItem {
            lastLoadFailed = false
            try? player?.load(item: item, playWhenReady: true)
        } else {
            player?.togglePlaying()
        }
    }
    
    @IBAction func startScrubbing(_ sender: UISlider) {
        isScrubbing = true
    }
    
    @IBAction func scrubbing(_ sender: UISlider) {
        player?.seek(to: Double(sender.value))
    }
    
    @IBAction func scrubbingValueChanged(_ sender: UISlider) {
        let value = Double(sender.value)
        audioTimeLbl.text = ((player?.duration ?? 0) - value).secondsToString()
    }
    
    func setPlayButtonState(forAudioPlayerState state: AudioPlayerState) {
        let image = UIImage(named: state == .playing ? "ic_pause.png" : "ic_play.png", in: VouchSDKViewController.bundleVouch, compatibleWith: nil)?.maskWithColor(color: Color.color(value: configData?.rightBubbleColor, defaultColor: Color.colorWhite) ?? Color.colorWhite)
        audioPlayBtn.setImage(image, for: .normal)
    }
    
    func handleAudioPlayerStateChange(data: AudioPlayer.StateChangeEventData) {
        print(data)
        DispatchQueue.main.async {
            self.setPlayButtonState(forAudioPlayerState: data)
            switch data {
            case .loading:
                //                self.loadIndicator.startAnimating()
                //                self.updateMetaData()
                self.updateTimeValues()
            case .buffering:
                break
            //                self.loadIndicator.startAnimating()
            case .ready:
                //                self.loadIndicator.stopAnimating()
                //                self.updateMetaData()
                self.updateTimeValues()
            case .playing, .paused, .idle:
                //                self.loadIndicator.stopAnimating()
                self.updateTimeValues()
            }
        }
    }
    
    func handleAudioPlayerDidSeek(data: AudioPlayer.SeekEventData) {
        isScrubbing = false
    }
    
    func handleAudioPlayerUpdateDuration(data: AudioPlayer.UpdateDurationEventData) {
        DispatchQueue.main.async {
            self.updateTimeValues()
        }
    }
    
    func handleAudioPlayerSecondElapsed(data: AudioPlayer.SecondElapseEventData) {
        if !isScrubbing {
            DispatchQueue.main.async {
                self.updateTimeValues()
            }
        }
    }
    
    func updateTimeValues() {
        self.audioSlider.maximumValue = Float(self.player?.duration ?? 0)
        self.audioSlider.setValue(Float(self.player?.currentTime ?? 0), animated: true)
        self.audioTimeLbl.text = ((self.player?.duration ?? 0) - (self.player?.currentTime ?? 0)).secondsToString()
    }
    
    func handleAVPlayerRecreated() {
        try? audioSessionController.set(category: .playback)
    }
    
    func handlePlayerFailure(data: AudioPlayer.FailEventData) {
        if let error = data as NSError? {
            if error.code == -1009 {
                lastLoadFailed = true
                DispatchQueue.main.async {
                    print("Network Disconnected")
                    //                    self.setErrorMessage("Network disconnected. Please try again...")
                }
            }
        }
    }
}

extension VouchMyChatListTableCell {
    public static var name = "VouchMyChatListTableCell"
    
    public static func registerCell(_ tableView: UITableView, bundle: Bundle?) {
        tableView.register(UINib(nibName: self.name, bundle: bundle), forCellReuseIdentifier: self.name)
    }
    
    public static func initCell(_ tableView: UITableView, indexPath: IndexPath, data: MessageResponseData, configData: ConfigData?, onTapPreviewBtnAction: ((_ type: String?, _ url: String?)->())?, onTapRetryBtnAction: ((_ idx: Int)->())?) -> VouchMyChatListTableCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.name, for: indexPath) as! VouchMyChatListTableCell
        cell.idx = indexPath.section
        cell.configureCell(data: data, isFirst: indexPath.row == 0, configData: configData)
        cell.selectionStyle = .none
        cell.onTapPreviewBtnAction = onTapPreviewBtnAction
        cell.onTapRetryBtnAction = onTapRetryBtnAction
        return cell
    }
}
