//
//  VouchSDKViewController.swift
//  VouchSDK
//
//  Created by Ajie Pramono Arganata on 27/08/19.
//  Copyright © 2019 GITS Indonesia. All rights reserved.
//

import UIKit
import AVKit
import GrowingTextView
import SDWebImage
import AVFoundation

public class VouchSDKViewController: BaseVC {
    // MARK: Outlet
    @IBOutlet private weak var recordBtnVw: UIView!
    @IBOutlet private weak var sendBtnVw: UIView!
    @IBOutlet private weak var sendBtn: UIButton!
    @IBOutlet private weak var attachmentBtn: UIButton!
    @IBOutlet private weak var recordBtn: UIButton!
    @IBOutlet private weak var messageTV: GrowingTextView!
    @IBOutlet private weak var tableVw: UITableView!
    @IBOutlet private weak var poweredVw: UIView!
    @IBOutlet private weak var poweredLbl: UILabel!
    @IBOutlet private weak var getStartedBtn: CustomButton!
    @IBOutlet private weak var getStartedVw: UIView!
    @IBOutlet private weak var chatActionVw: UIView!
    @IBOutlet private weak var errorMessageVw: UIView!
    @IBOutlet private weak var errorMessageLbl: UILabel!
    @IBOutlet weak var recordAction: UIView!
    @IBOutlet weak var recordTimer: UILabel!
    @IBOutlet weak var imageVw: UIImageView!
    private var chatImage: UIImageView?
    private var chatTitle: UILabel?
    
    
    // MARK: Properties
    private lazy var dataManager = VouchSDKDataManager()
    private var timerQueueChat: Timer?
    private var viewModel: VouchSDKViewModel!
    private lazy var collectionAdapter = VouchSDKCollectionAdapter(dataManager: self.dataManager, currentIdx: 0, configData: ConfigData())
    private lazy var tableAdapter = VouchSDKTableAdapter(dataManager: self.dataManager, collectionAdapter: self.collectionAdapter, configData: ConfigData())
    private var isReferrence = false
    private var isOpenAnotherPage = false
    
    deinit {
        print("DEINIT Vouch SDK")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        FontHelper.loadFonts = {}
        self.configureTitleView()
        self.configureView()
        self.viewModel.reconnectSocket()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        viewModel.reconnectSocket()
        VoiceRecorderHelper.instance.doClearClosure()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.isOpenAnotherPage = false
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if !isOpenAnotherPage {
            viewModel.disconnectSocket()
        }
    }
    
    private func configureView() {
        self.getStartedVw.isHidden = true
        self.chatActionVw.isHidden = true
        self.recordBtn.isEnabled = true
        self.configureView(data: ConfigData())
        self.viewModel = VouchSDKViewModel(application: UIApplication.shared, username: self.dataManager.username ?? "", password: self.dataManager.password ?? "", baseUrl: self.dataManager.baseUrl ?? "", onFailed: { (message, idSent) in
            self.showErrorMessage(message: message)
            
            guard idSent != nil, let idx = self.dataManager.listChat.lastIndex(where: { (item) -> Bool in
                return item.idSent == idSent
            }) else { return }
            let data = self.dataManager.listChat[idx]
            data.isError = true
            self.dataManager.updateChat(idx: idx, value: data)
            self.tableVw.reloadSections([idx], with: .none)
            
        })
        self.observeLiveData()
        self.viewModel.start()
        
        // REGISTER TABLE CELL
        VouchMyChatListTableCell.registerCell(self.tableVw, bundle: self.nibBundle)
        VouchOtherChatListTableCell.registerCell(self.tableVw, bundle: self.nibBundle)
        VouchQuickRepliesTableCell.registerCell(self.tableVw, bundle: self.nibBundle)
        VouchButtonRepliesTableCell.registerCell(self.tableVw, bundle: self.nibBundle)
        VouchGalleryTableCell.registerCell(self.tableVw, bundle: self.nibBundle)
        VouchListElementTableCell.registerCell(self.tableVw, bundle: self.nibBundle)
        self.tableVw.dataSource = self.tableAdapter
        self.tableVw.delegate = self.tableAdapter
        self.messageTV.delegate = self
        
        self.sendBtnVw.isHidden = true
        let onTapButtonAction: ((_ type: String?, _ payload: String?, _ url: String?, _ title: String?)-> ())? = { [weak self] (type, payload, url, title) in
            guard let weakSelf = self else { return }
            if type == "text" || type == "postback" {
                // SEND Quick Reply
                let data = MessageResponseData(text: title, createdAt: Helper.dateParseToString(Date(), newFormat: Helper.dateOldFormat), msgType: "text", type: "quick_reply", fromMe: true, payload: payload, isSent: false)
                weakSelf.viewModel.replyMessage(body: MessageBodyModel(idSent: data.idSent, msgType: "text", payload: payload, text: title, type: "quick_reply"))
                
                weakSelf.dataManager.insertNewChat(value: data)
                weakSelf.tableVw.beginUpdates()
                weakSelf.tableVw.reloadSections([weakSelf.dataManager.listChat.count-2], with: .fade)
                weakSelf.tableVw.insertSections([weakSelf.dataManager.listChat.count-1], with: .fade)
                weakSelf.tableVw.endUpdates()
                weakSelf.scrollToBottom()
            } else if type == "web_url" { // url
                // Open web browser
                guard let url = URL(string: url ?? "") else { return }
                if UIApplication.shared.canOpenURL(url) { UIApplication.shared.open(url, options: [:], completionHandler: nil) }
            } else if type == "phone_number" { // payload
                // Open call phone number
                guard let url = URL(string: "tel://" + (payload ?? "")) else { return }
                if UIApplication.shared.canOpenURL(url) { UIApplication.shared.open(url, options: [:], completionHandler: nil) }
            } else if type == "location" {
                // SEND My Location
                weakSelf.viewModel.sendLocation()
            }
        }
        self.tableAdapter.onTapButtonAction = onTapButtonAction
        self.tableAdapter.onTapPreviewBtnAction = { [weak self] (type, url) in
            guard let weakSelf = self else { return }
            if type == "video" {
                // PREVIEW an video
                if let url = URL(string: url ?? "") {
                    let controller = AVPlayerViewController()
                    controller.player = AVPlayer(url: url)
                    weakSelf.isOpenAnotherPage = true
                    weakSelf.present(controller, animated: true, completion: nil)
                }
            } else if type == "image" {
                // PREVIEW an image
                PhotoViewerVC.openPhotoViewerViewController(from: weakSelf, data: ["images": [url], "isWithPage": false])
            }
        }
        self.tableAdapter.onTapRetryBtnAction = { [weak self] (idx) in
            // RETRY
            guard let weakSelf = self else { return }
            let data = weakSelf.dataManager.listChat[idx]
            data.isError = false
            weakSelf.dataManager.updateChat(idx: idx, value: data)
            if data.msgType == "text" {
                weakSelf.viewModel.replyMessage(body: MessageBodyModel(idSent: data.idSent, msgType: data.msgType, payload: data.payload, text: data.text, type: data.type))
            } else if data.msgType == "image" , let image = data.imageLocal {
                weakSelf.viewModel.uploadFile(body: UploadParam(idSent: data.idSent, file: image.jpegData(compressionQuality: 1)))
            }
        }
        self.collectionAdapter.onTapButtonAction = onTapButtonAction
    }
    
    public func configureData(data: [String: Any?]) {
        self.dataManager.setUserData(username: data["username"] as? String, password: data["password"] as? String)
        self.dataManager.setBaseUrl(baseUrl: data["baseUrl"] as? String)
    }
    
    public func configureView(data: ConfigData) {
        self.configColorBar(
            colorBar: Color.color(value: data.headerBgColor, defaultColor: Color.colorNavy),
            colorTitle: Color.color(value: data.xButtonColor, defaultColor: Color.colorWhite),
            colorBarButton: Color.color(value: data.xButtonColor, defaultColor: Color.colorWhite)
        )
        
        self.chatTitle?.text = data.title ?? ""
        if let url = URL(string: data.avatar ?? "") {
            self.chatImage?.sd_setImage(with: url, completed: nil)
            self.chatImage?.backgroundColor = .clear
        } else {
            self.chatImage?.image = nil
            self.chatImage?.backgroundColor = .lightGray
        }
        
        self.view.backgroundColor = Color.color(value: data.backgroundColorChat, defaultColor: Color.colorWhite)
        self.poweredVw.backgroundColor = Color.color(value: data.headerBgColor, defaultColor: Color.colorNavy)
        self.sendBtn.backgroundColor = Color.color(value: data.sendButtonColor, defaultColor: Color.colorNavy)
        let sendImage = self.sendBtn.currentImage?.withRenderingMode(.alwaysTemplate)
        self.sendBtn.setImage(sendImage, for: .normal)
        self.sendBtn.tintColor = Color.color(value: data.sendIconColor, defaultColor: Color.colorWhite)
        
        self.attachmentBtn.backgroundColor = Color.color(value: data.attachmentButtonColor, defaultColor: Color.colorWhite)
        let attachImage = self.attachmentBtn.currentImage?.withRenderingMode(.alwaysTemplate)
        self.attachmentBtn.setImage(attachImage, for: .normal)
        self.attachmentBtn.tintColor = Color.color(value: data.attachmentIconColor, defaultColor: Color.colorGray)
        
        self.recordBtn.backgroundColor = Color.color(value: data.sendButtonColor, defaultColor: Color.colorWhiteGray)
        let recordImage = self.recordBtn.currentImage?.withRenderingMode(.alwaysTemplate)
        self.recordBtn.setImage(recordImage, for: .normal)
        self.recordBtn.tintColor = Color.color(value: data.sendIconColor, defaultColor: Color.colorGray)
        
        guard let greetings = data.greetingMessage, !self.dataManager.isGreeting else { return }
        self.dataManager.insertNewChat(value: MessageResponseData(text: greetings.text, createdAt: Helper.dateParseToString(Date(), newFormat: Helper.dateOldFormat)))
        self.tableVw.beginUpdates()
        self.tableVw.insertSections([self.dataManager.listChat.count-1], with: .fade)
        self.tableVw.endUpdates()
        self.dataManager.setIsGreeting(value: true)
        
        self.getStartedBtn.setTitleColor(Color.color(value: data.rightBubbleBgColor, defaultColor: Color.colorNavy), for: .normal)
        self.getStartedBtn.setTitleColor(Color.color(value: data.rightBubbleColor, defaultColor: Color.colorWhite), for: .highlighted)
        self.getStartedBtn.backgroundColor = Color.color(value: data.backgroundColorChat, defaultColor: Color.colorWhite)
        self.getStartedBtn.borderColor = Color.color(value: data.rightBubbleBgColor, defaultColor: Color.colorNavy) ?? Color.colorNavy
        
        self.getStartedBtn.changeFont(font: data.fontStyle ?? "")
        self.poweredLbl.changeFont(fontText: data.fontStyle ?? "")
        self.chatTitle?.changeFont(fontText: data.fontStyle ?? "")
        self.messageTV.changeFont(fontText: data.fontStyle ?? "")
    }
    
    private func observeLiveData() {
        viewModel.isRequesting.observe = { value in
            print("IsRequesting : \(value)")
        }
        
        viewModel.changeConnectStatus.observe = { value in
            print("Change Connection Status : \(value)")
        }
        
        viewModel.eventShowMessage.observe = { value in
            print("Event message : \(value)")
        }
        
        viewModel.loadConfiguration.observe = { value in
            self.configureView(data: value)
            self.tableAdapter.configData = value
            self.collectionAdapter.configData = value
        }
        
        viewModel.loadReceivedNewMessage.observe = { value in
            if value.fromMe == true && value.fromMe != nil {
                
            } else {
                if self.isReferrence {
                    self.isReferrence = false
                    self.getStartedVw.isHidden = true
                    self.chatActionVw.isHidden = false
                    self.dataManager.removeListChat(at: 0)
                    self.tableVw.reloadData()
                }
                self.insertRowTableView(value: value)
            }
        }
        
        viewModel.loadListMessage.observe = { value in
            self.dataManager.insertListChat(value: value)
            if value.count != 0 {
                self.isReferrence = false
                self.getStartedVw.isHidden = true
                self.chatActionVw.isHidden = false
                self.dataManager.removeListChat(at: 0)
            } else {
                self.getStartedVw.isHidden = false
                self.chatActionVw.isHidden = true
            }
            self.tableVw.reloadData()
            if value.count != 0 {
                DispatchQueue.main.async {
                    self.tableVw.scrollTo(direction: .Bottom, animated: false)
                }
            }
        }
        
        viewModel.loadReplyMessage.observe = { value in
            guard value.idSent != nil, let idx = self.dataManager.listChat.lastIndex(where: { (item) -> Bool in
                return item.idSent == value.idSent
            }) else {
                value.fromMe = true
                self.insertRowTableView(value: value)
                return
            }
            let data = self.dataManager.listChat[idx]
            data.fromMe = true
            data.belongsToConversation = value.belongsToConversation
            data.msgType = value.msgType
            data.text = value.text
            data.isSent = true
            self.dataManager.updateChat(idx: idx, value: data)
            self.tableVw.reloadSections([idx], with: .none)
        }
    }
    
    @objc private func loadNewChat() {
        self.dataManager.removeChatFromQueue(at: 0)
        self.tableVw.beginUpdates()
        self.tableVw.reloadSections([self.dataManager.listChat.count-2], with: .fade)
        self.tableVw.insertSections([self.dataManager.listChat.count-1], with: .fade)
        self.tableVw.endUpdates()
        self.scrollToBottom()
        self.timerQueueChat?.invalidate()
        self.timerQueueChat = nil
        if self.dataManager.queueListChat.count != 0 {
            self.timerQueueChat = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(self.loadNewChat), userInfo: nil, repeats: false)
        }
    }
    
    /** Attachment Image Button Action
     ** Will open alert dialog action sheet with option camera or gallery
     */
    @IBAction private func attachImageBtnAction(_ sender: UIButton) {
        GalleryHelper.openDialogGallery(from: self, onChooseImageAction: { [weak self](image, file, url) in
            guard let weakSelf = self else { return }
            weakSelf.isOpenAnotherPage = true
            
            // SEND Quick Reply
            let data = MessageResponseData(text: nil, createdAt: Helper.dateParseToString(Date(), newFormat: Helper.dateOldFormat), msgType: "image", type: "image", fromMe: true, isSent: false, image: image)
            weakSelf.viewModel.uploadFile(body: UploadParam(idSent: data.idSent, file: image.jpegData(compressionQuality: 1)))
            
            weakSelf.dataManager.insertNewChat(value: data)
            weakSelf.tableVw.beginUpdates()
            weakSelf.tableVw.reloadSections([weakSelf.dataManager.listChat.count-2], with: .fade)
            weakSelf.tableVw.insertSections([weakSelf.dataManager.listChat.count-1], with: .fade)
            weakSelf.tableVw.endUpdates()
            weakSelf.scrollToBottom()
        })
    }

    /** Voice Record Record Button Action
     ** Will record audio
     */
    @IBAction func recordBtnAction(_ sender: UIButton) {
        self.recordTimer.text = "0:0:0"
        self.recordAction.isHidden = false
        self.chatActionVw.isHidden = true
    }
    
    @IBAction func cancelRecordBtnAction(_ sender: UIButton) {
        self.recordAction.isHidden = true
        self.chatActionVw.isHidden = false
        self.recordAction.isHidden = true
        VoiceRecorderHelper.instance.doClearClosure()
        VoiceRecorderHelper.instance.finishRecording()
    }
    
    @IBAction func startAndStopRecordBtnAction(_ sender: UIButton) {
        if !sender.isSelected {
            print("Audio recording")
            sender.isSelected = true
            VoiceRecorderHelper.instance.startRecording()
            VoiceRecorderHelper.instance.onUpdateRecordAction = { value in
                self.recordTimer.text = value
            }
            VoiceRecorderHelper.instance.onFinishRecordAction = { value, url in
                self.viewModel.uploadVoice(body: VoiceParam(voice: value))
            }
        } else {
            print("Audio recorded")
            sender.isSelected = false
            self.recordAction.isHidden = true
            self.chatActionVw.isHidden = false
            VoiceRecorderHelper.instance.finishRecording()
        }
    }
    
    /** Send Message Button Action
     ** Will send message chat
     */
    @IBAction private func sendMessageBtnAction(_ sender: UIButton) {
        if self.messageTV.text != "" {
            let data = MessageResponseData(text: self.messageTV.text, createdAt: Helper.dateParseToString(Date(), newFormat: Helper.dateOldFormat), msgType: "text", type: "text", fromMe: true, isSent: false)
            self.viewModel.replyMessage(body: MessageBodyModel(idSent: data.idSent, msgType: "text", payload: nil, text: self.messageTV.text, type: "text"))
            
            self.dataManager.insertNewChat(value: data)
            self.tableVw.beginUpdates()
            self.tableVw.reloadSections([self.dataManager.listChat.count-2], with: .fade)
            self.tableVw.insertSections([self.dataManager.listChat.count-1], with: .fade)
            self.tableVw.endUpdates()
            self.scrollToBottom()
            
            self.messageTV.text = ""
            self.recordBtnVw.isHidden = self.messageTV.text != ""
            self.sendBtnVw.isHidden = self.messageTV.text == ""
        } else {
            self.showErrorMessage(message: "Please fill the message!")
        }
    }
    
    /** Get Started Button Action
     ** Will send reference to start the conversation
     */
    @IBAction private func getStartedBtnAction(_ sender: UIButton) {
        self.viewModel.sendReferrence()
        self.isReferrence = true
    }
    
    /** Close Button Action
     ** Will close the page
     */
    @IBAction private func closeBarBtnAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension VouchSDKViewController: UITextViewDelegate {
    /** TextView Delegate
    */
    public func textViewDidChange(_ textView: UITextView) {
        let text = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        self.recordBtnVw.isHidden = text != ""
        self.sendBtnVw.isHidden = text == ""
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        let text = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        self.recordBtnVw.isHidden = text != ""
        self.sendBtnVw.isHidden = text == ""
    }
}

extension VouchSDKViewController {
    /** Vouch Title View
    */
    func configureTitleView() {
        self.title = ""
        self.navigationItem.leftBarButtonItem = nil
        
        let container = UIStackView(frame: CGRect(x: 0, y: 0, width: self.navigationController?.navigationBar.frame.size.width ?? 0, height: 35))
        container.axis = .horizontal
        container.alignment = .center
        container.spacing = 8
        
        let image = UIImageView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        image.layer.cornerRadius = 32/2
        image.contentMode = .scaleAspectFill
        image.backgroundColor = .lightGray
        image.clipsToBounds = true
        image.addConstraints([
            NSLayoutConstraint(item: image, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 32),
            NSLayoutConstraint(item: image, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 32)
        ])
        
        let containerLabel = UIStackView()
        containerLabel.axis = .vertical
        let nameLbl = UILabel()
        nameLbl.font = UIFont.boldSystemFont(ofSize: 15)
        nameLbl.textColor = .white
        containerLabel.addArrangedSubview(nameLbl)
        container.addArrangedSubview(image)
        container.addArrangedSubview(containerLabel)
        let barButton = UIBarButtonItem(customView: container)
        self.chatImage = image
        self.chatTitle = nameLbl
        self.navigationItem.leftBarButtonItem = barButton
    }
    
    /** Vouch Error View
     */
    func showErrorMessage(message: String) {
        self.errorMessageLbl.text = message
        self.errorMessageVw.frame = CGRect(x: 0, y: -self.errorMessageVw.frame.height, width: self.errorMessageVw.frame.width, height: self.errorMessageVw.frame.height)
        self.errorMessageVw.isHidden = false
        self.errorMessageLbl.isHidden = false
        self.errorMessageVw.backgroundColor = UIColor.gray.withAlphaComponent(0)
        self.errorMessageLbl.textColor = UIColor.white.withAlphaComponent(0)
        UIView.animate(withDuration: 1) {
            self.errorMessageVw.backgroundColor = UIColor.gray.withAlphaComponent(1)
            self.errorMessageLbl.textColor = UIColor.white.withAlphaComponent(1)
            self.errorMessageVw.frame = CGRect(x: 0, y: 0, width: self.errorMessageVw.frame.width, height: self.errorMessageVw.frame.height)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            UIView.animate(withDuration: 1) {
                self.errorMessageVw.backgroundColor = UIColor.gray.withAlphaComponent(0)
                self.errorMessageLbl.textColor = UIColor.white.withAlphaComponent(0)
                self.errorMessageVw.frame = CGRect(x: 0, y: -self.errorMessageVw.frame.height, width: self.errorMessageVw.frame.width, height: self.errorMessageVw.frame.height)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.errorMessageVw.isHidden = true
                self.errorMessageLbl.isHidden = true
            }
        }
    }
    
    func insertRowTableView(value: MessageResponseData) {
        if self.dataManager.listChat.count != 0 {
            self.dataManager.insertChatToQueue(value: value)
            if self.timerQueueChat == nil {
                self.timerQueueChat?.invalidate()
                self.timerQueueChat = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.loadNewChat), userInfo: nil, repeats: false)
            }
            
        } else {
            self.dataManager.insertNewChat(value: value)
            self.tableVw.beginUpdates()
            self.tableVw.insertSections([self.dataManager.listChat.count-1], with: .fade)
            self.tableVw.endUpdates()
        }
    }
    
    func scrollToBottom() {
        let lists = self.dataManager.listChat.last?.msgType == "list" ? ((self.dataManager.listChat.last?.lists?.count ?? 0) - 1) : 0
        let buttons = self.dataManager.listChat.last?.buttons?.count ?? 0
        let quickReplies = (self.dataManager.listChat.last?.quickReplies?.count ?? 0) != 0 ? 1 : 0
        let lastRow = 0 + quickReplies + buttons + lists
        self.tableVw.scrollToRow(at: IndexPath(row: lastRow, section: self.dataManager.listChat.count-1), at: .bottom, animated: false)
    }
}

extension VouchSDKViewController {
    /** Vouch SDK Bundle
     * This is a variable to get vouch sdk bundle
     */
    public static var bundleVouch: Bundle {
        let podBundle = Bundle(for: VouchSDKViewController.self)
        let bundleURL = podBundle.url(forResource: Constant.VOUCH_SDK, withExtension: Constant.BUNDLE)
        if bundleURL == nil {
            return podBundle
        } else{
            return Bundle(url: bundleURL!)!
        }
    }
}
