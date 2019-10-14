//
//  ConfigData.swift
//
//  Created by Ajie Pramono Arganata on 03/09/19
//  Copyright (c) GITS Indonesia. All rights reserved.
//

import Foundation
import SwiftyJSON

public final class ConfigData: NSCoding, Equatable {
    public static func == (lhs: ConfigData, rhs: ConfigData) -> Bool {
        return false
    }
    

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let footerTextColor = "footerTextColor"
    static let closeIconURL = "closeIconURL"
    static let rightBubbleBgColor = "rightBubbleBgColor"
    static let xButtonColor = "xButtonColor"
    static let greetingButtonTitle = "greetingButtonTitle"
    static let useAttachment = "useAttachment"
    static let behaviour = "behaviour"
    static let sendIconColor = "sendIconColor"
    static let inputTextBackgroundColor = "inputTextBackgroundColor"
    static let greetingMessage = "greetingMessage"
    static let sendIconURL = "sendIconURL"
    static let widgetButtonSize = "widgetButtonSize"
    static let domainWhiteList = "domainWhiteList"
    static let btnBgColor = "btnBgColor"
    static let customChannelList = "customChannelList"
    static let mobileBehaviour = "mobileBehaviour"
    static let borderRadius = "borderRadius"
    static let delay = "delay"
    static let rightBubbleColor = "rightBubbleColor"
    static let useVoice = "useVoice"
    static let headerBgColor = "headerBgColor"
    static let title = "title"
    static let useNotification = "useNotification"
    static let iconColor = "iconColor"
    static let leftBubbleColor = "leftBubbleColor"
    static let defaultInput = "defaultInput"
    static let autoComplete = "autoComplete"
    static let sendButtonColor = "sendButtonColor"
    static let displayHeader = "displayHeader"
    static let shakeWidget = "shakeWidget"
    static let poweredByVouch = "poweredByVouch"
    static let leftBubbleBgColor = "leftBubbleBgColor"
    static let backgroundColorChat = "backgroundColorChat"
    static let forceFullScreen = "forceFullScreen"
    static let openImmediately = "openImmediately"
    static let widgetFailedURL = "widgetFailedURL"
    static let dismissKeyboard = "dismissKeyboard"
    static let bubbleChatBorderRadius = "bubbleChatBorderRadius"
    static let attachmentButtonColor = "attachmentButtonColor"
    static let avatar = "avatar"
    static let inputTextColor = "inputTextColor"
    static let fontStyle = "fontStyle"
    static let attachmentIconColor = "attachmentIconColor"
    static let mobileDelay = "mobileDelay"
    static let openIconURL = "openIconURL"
  }

  // MARK: Properties
  public var footerTextColor: String?
  public var closeIconURL: String?
  public var rightBubbleBgColor: String?
  public var xButtonColor: String?
  public var greetingButtonTitle: String?
  public var useAttachment: Bool? = false
  public var behaviour: Int?
  public var sendIconColor: String?
  public var inputTextBackgroundColor: String?
  public var greetingMessage: ConfigGreetingMessage?
  public var sendIconURL: String?
  public var widgetButtonSize: Int?
  public var domainWhiteList: [String]?
  public var btnBgColor: String?
  public var customChannelList: [Any]?
  public var mobileBehaviour: Int?
  public var borderRadius: Int?
  public var delay: Int?
  public var rightBubbleColor: String?
  public var useVoice: Int?
  public var headerBgColor: String?
  public var title: String?
  public var useNotification: Bool? = false
  public var iconColor: String?
  public var leftBubbleColor: String?
  public var defaultInput: Int?
  public var autoComplete: Bool? = false
  public var sendButtonColor: String?
  public var displayHeader: Bool? = false
  public var shakeWidget: Bool? = false
  public var poweredByVouch: Bool? = false
  public var leftBubbleBgColor: String?
  public var backgroundColorChat: String?
  public var forceFullScreen: Bool? = false
  public var openImmediately: Bool? = false
  public var widgetFailedURL: String?
  public var dismissKeyboard: Int?
  public var bubbleChatBorderRadius: Int?
  public var attachmentButtonColor: String?
  public var avatar: String?
  public var inputTextColor: String?
  public var fontStyle: String?
  public var attachmentIconColor: String?
  public var mobileDelay: Int?
  public var openIconURL: String?

  public init() {}
    
  // MARK: SwiftyJSON Initializers
  /// Initiates the instance based on the object.
  ///
  /// - parameter object: The object of either Dictionary or Array kind that was passed.
  /// - returns: An initialized instance of the class.
  public convenience init(object: Any) {
    self.init(json: JSON(object))
  }

  /// Initiates the instance based on the JSON that was passed.
  ///
  /// - parameter json: JSON object from SwiftyJSON.
  public required init(json: JSON) {
    footerTextColor = json[SerializationKeys.footerTextColor].string
    closeIconURL = json[SerializationKeys.closeIconURL].string
    rightBubbleBgColor = json[SerializationKeys.rightBubbleBgColor].string
    xButtonColor = json[SerializationKeys.xButtonColor].string
    greetingButtonTitle = json[SerializationKeys.greetingButtonTitle].string
    useAttachment = json[SerializationKeys.useAttachment].boolValue
    behaviour = json[SerializationKeys.behaviour].int
    sendIconColor = json[SerializationKeys.sendIconColor].string
    inputTextBackgroundColor = json[SerializationKeys.inputTextBackgroundColor].string
    greetingMessage = ConfigGreetingMessage(json: json[SerializationKeys.greetingMessage])
    sendIconURL = json[SerializationKeys.sendIconURL].string
    widgetButtonSize = json[SerializationKeys.widgetButtonSize].int
    if let items = json[SerializationKeys.domainWhiteList].array { domainWhiteList = items.map { $0.stringValue } }
    btnBgColor = json[SerializationKeys.btnBgColor].string
    if let items = json[SerializationKeys.customChannelList].array { customChannelList = items.map { $0.object} }
    mobileBehaviour = json[SerializationKeys.mobileBehaviour].int
    borderRadius = json[SerializationKeys.borderRadius].int
    delay = json[SerializationKeys.delay].int
    rightBubbleColor = json[SerializationKeys.rightBubbleColor].string
    useVoice = json[SerializationKeys.useVoice].int
    headerBgColor = json[SerializationKeys.headerBgColor].string
    title = json[SerializationKeys.title].string
    useNotification = json[SerializationKeys.useNotification].boolValue
    iconColor = json[SerializationKeys.iconColor].string
    leftBubbleColor = json[SerializationKeys.leftBubbleColor].string
    defaultInput = json[SerializationKeys.defaultInput].int
    autoComplete = json[SerializationKeys.autoComplete].boolValue
    sendButtonColor = json[SerializationKeys.sendButtonColor].string
    displayHeader = json[SerializationKeys.displayHeader].boolValue
    shakeWidget = json[SerializationKeys.shakeWidget].boolValue
    poweredByVouch = json[SerializationKeys.poweredByVouch].boolValue
    leftBubbleBgColor = json[SerializationKeys.leftBubbleBgColor].string
    backgroundColorChat = json[SerializationKeys.backgroundColorChat].string
    forceFullScreen = json[SerializationKeys.forceFullScreen].boolValue
    openImmediately = json[SerializationKeys.openImmediately].boolValue
    widgetFailedURL = json[SerializationKeys.widgetFailedURL].string
    dismissKeyboard = json[SerializationKeys.dismissKeyboard].int
    bubbleChatBorderRadius = json[SerializationKeys.bubbleChatBorderRadius].int
    attachmentButtonColor = json[SerializationKeys.attachmentButtonColor].string
    avatar = json[SerializationKeys.avatar].string
    inputTextColor = json[SerializationKeys.inputTextColor].string
    fontStyle = json[SerializationKeys.fontStyle].string
    attachmentIconColor = json[SerializationKeys.attachmentIconColor].string
    mobileDelay = json[SerializationKeys.mobileDelay].int
    openIconURL = json[SerializationKeys.openIconURL].string
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = footerTextColor { dictionary[SerializationKeys.footerTextColor] = value }
    if let value = closeIconURL { dictionary[SerializationKeys.closeIconURL] = value }
    if let value = rightBubbleBgColor { dictionary[SerializationKeys.rightBubbleBgColor] = value }
    if let value = xButtonColor { dictionary[SerializationKeys.xButtonColor] = value }
    if let value = greetingButtonTitle { dictionary[SerializationKeys.greetingButtonTitle] = value }
    dictionary[SerializationKeys.useAttachment] = useAttachment
    if let value = behaviour { dictionary[SerializationKeys.behaviour] = value }
    if let value = sendIconColor { dictionary[SerializationKeys.sendIconColor] = value }
    if let value = inputTextBackgroundColor { dictionary[SerializationKeys.inputTextBackgroundColor] = value }
    if let value = greetingMessage { dictionary[SerializationKeys.greetingMessage] = value.dictionaryRepresentation() }
    if let value = sendIconURL { dictionary[SerializationKeys.sendIconURL] = value }
    if let value = widgetButtonSize { dictionary[SerializationKeys.widgetButtonSize] = value }
    if let value = domainWhiteList { dictionary[SerializationKeys.domainWhiteList] = value }
    if let value = btnBgColor { dictionary[SerializationKeys.btnBgColor] = value }
    if let value = customChannelList { dictionary[SerializationKeys.customChannelList] = value }
    if let value = mobileBehaviour { dictionary[SerializationKeys.mobileBehaviour] = value }
    if let value = borderRadius { dictionary[SerializationKeys.borderRadius] = value }
    if let value = delay { dictionary[SerializationKeys.delay] = value }
    if let value = rightBubbleColor { dictionary[SerializationKeys.rightBubbleColor] = value }
    if let value = useVoice { dictionary[SerializationKeys.useVoice] = value }
    if let value = headerBgColor { dictionary[SerializationKeys.headerBgColor] = value }
    if let value = title { dictionary[SerializationKeys.title] = value }
    dictionary[SerializationKeys.useNotification] = useNotification
    if let value = iconColor { dictionary[SerializationKeys.iconColor] = value }
    if let value = leftBubbleColor { dictionary[SerializationKeys.leftBubbleColor] = value }
    if let value = defaultInput { dictionary[SerializationKeys.defaultInput] = value }
    dictionary[SerializationKeys.autoComplete] = autoComplete
    if let value = sendButtonColor { dictionary[SerializationKeys.sendButtonColor] = value }
    dictionary[SerializationKeys.displayHeader] = displayHeader
    dictionary[SerializationKeys.shakeWidget] = shakeWidget
    dictionary[SerializationKeys.poweredByVouch] = poweredByVouch
    if let value = leftBubbleBgColor { dictionary[SerializationKeys.leftBubbleBgColor] = value }
    if let value = backgroundColorChat { dictionary[SerializationKeys.backgroundColorChat] = value }
    dictionary[SerializationKeys.forceFullScreen] = forceFullScreen
    dictionary[SerializationKeys.openImmediately] = openImmediately
    if let value = widgetFailedURL { dictionary[SerializationKeys.widgetFailedURL] = value }
    if let value = dismissKeyboard { dictionary[SerializationKeys.dismissKeyboard] = value }
    if let value = bubbleChatBorderRadius { dictionary[SerializationKeys.bubbleChatBorderRadius] = value }
    if let value = attachmentButtonColor { dictionary[SerializationKeys.attachmentButtonColor] = value }
    if let value = avatar { dictionary[SerializationKeys.avatar] = value }
    if let value = inputTextColor { dictionary[SerializationKeys.inputTextColor] = value }
    if let value = fontStyle { dictionary[SerializationKeys.fontStyle] = value }
    if let value = attachmentIconColor { dictionary[SerializationKeys.attachmentIconColor] = value }
    if let value = mobileDelay { dictionary[SerializationKeys.mobileDelay] = value }
    if let value = openIconURL { dictionary[SerializationKeys.openIconURL] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.footerTextColor = aDecoder.decodeObject(forKey: SerializationKeys.footerTextColor) as? String
    self.closeIconURL = aDecoder.decodeObject(forKey: SerializationKeys.closeIconURL) as? String
    self.rightBubbleBgColor = aDecoder.decodeObject(forKey: SerializationKeys.rightBubbleBgColor) as? String
    self.xButtonColor = aDecoder.decodeObject(forKey: SerializationKeys.xButtonColor) as? String
    self.greetingButtonTitle = aDecoder.decodeObject(forKey: SerializationKeys.greetingButtonTitle) as? String
    self.useAttachment = aDecoder.decodeBool(forKey: SerializationKeys.useAttachment)
    self.behaviour = aDecoder.decodeObject(forKey: SerializationKeys.behaviour) as? Int
    self.sendIconColor = aDecoder.decodeObject(forKey: SerializationKeys.sendIconColor) as? String
    self.inputTextBackgroundColor = aDecoder.decodeObject(forKey: SerializationKeys.inputTextBackgroundColor) as? String
    self.greetingMessage = aDecoder.decodeObject(forKey: SerializationKeys.greetingMessage) as? ConfigGreetingMessage
    self.sendIconURL = aDecoder.decodeObject(forKey: SerializationKeys.sendIconURL) as? String
    self.widgetButtonSize = aDecoder.decodeObject(forKey: SerializationKeys.widgetButtonSize) as? Int
    self.domainWhiteList = aDecoder.decodeObject(forKey: SerializationKeys.domainWhiteList) as? [String]
    self.btnBgColor = aDecoder.decodeObject(forKey: SerializationKeys.btnBgColor) as? String
    self.customChannelList = aDecoder.decodeObject(forKey: SerializationKeys.customChannelList) as? [Any]
    self.mobileBehaviour = aDecoder.decodeObject(forKey: SerializationKeys.mobileBehaviour) as? Int
    self.borderRadius = aDecoder.decodeObject(forKey: SerializationKeys.borderRadius) as? Int
    self.delay = aDecoder.decodeObject(forKey: SerializationKeys.delay) as? Int
    self.rightBubbleColor = aDecoder.decodeObject(forKey: SerializationKeys.rightBubbleColor) as? String
    self.useVoice = aDecoder.decodeObject(forKey: SerializationKeys.useVoice) as? Int
    self.headerBgColor = aDecoder.decodeObject(forKey: SerializationKeys.headerBgColor) as? String
    self.title = aDecoder.decodeObject(forKey: SerializationKeys.title) as? String
    self.useNotification = aDecoder.decodeBool(forKey: SerializationKeys.useNotification)
    self.iconColor = aDecoder.decodeObject(forKey: SerializationKeys.iconColor) as? String
    self.leftBubbleColor = aDecoder.decodeObject(forKey: SerializationKeys.leftBubbleColor) as? String
    self.defaultInput = aDecoder.decodeObject(forKey: SerializationKeys.defaultInput) as? Int
    self.autoComplete = aDecoder.decodeBool(forKey: SerializationKeys.autoComplete)
    self.sendButtonColor = aDecoder.decodeObject(forKey: SerializationKeys.sendButtonColor) as? String
    self.displayHeader = aDecoder.decodeBool(forKey: SerializationKeys.displayHeader)
    self.shakeWidget = aDecoder.decodeBool(forKey: SerializationKeys.shakeWidget)
    self.poweredByVouch = aDecoder.decodeBool(forKey: SerializationKeys.poweredByVouch)
    self.leftBubbleBgColor = aDecoder.decodeObject(forKey: SerializationKeys.leftBubbleBgColor) as? String
    self.backgroundColorChat = aDecoder.decodeObject(forKey: SerializationKeys.backgroundColorChat) as? String
    self.forceFullScreen = aDecoder.decodeBool(forKey: SerializationKeys.forceFullScreen)
    self.openImmediately = aDecoder.decodeBool(forKey: SerializationKeys.openImmediately)
    self.widgetFailedURL = aDecoder.decodeObject(forKey: SerializationKeys.widgetFailedURL) as? String
    self.dismissKeyboard = aDecoder.decodeObject(forKey: SerializationKeys.dismissKeyboard) as? Int
    self.bubbleChatBorderRadius = aDecoder.decodeObject(forKey: SerializationKeys.bubbleChatBorderRadius) as? Int
    self.attachmentButtonColor = aDecoder.decodeObject(forKey: SerializationKeys.attachmentButtonColor) as? String
    self.avatar = aDecoder.decodeObject(forKey: SerializationKeys.avatar) as? String
    self.inputTextColor = aDecoder.decodeObject(forKey: SerializationKeys.inputTextColor) as? String
    self.fontStyle = aDecoder.decodeObject(forKey: SerializationKeys.fontStyle) as? String
    self.attachmentIconColor = aDecoder.decodeObject(forKey: SerializationKeys.attachmentIconColor) as? String
    self.mobileDelay = aDecoder.decodeObject(forKey: SerializationKeys.mobileDelay) as? Int
    self.openIconURL = aDecoder.decodeObject(forKey: SerializationKeys.openIconURL) as? String
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(footerTextColor, forKey: SerializationKeys.footerTextColor)
    aCoder.encode(closeIconURL, forKey: SerializationKeys.closeIconURL)
    aCoder.encode(rightBubbleBgColor, forKey: SerializationKeys.rightBubbleBgColor)
    aCoder.encode(xButtonColor, forKey: SerializationKeys.xButtonColor)
    aCoder.encode(greetingButtonTitle, forKey: SerializationKeys.greetingButtonTitle)
    aCoder.encode(useAttachment, forKey: SerializationKeys.useAttachment)
    aCoder.encode(behaviour, forKey: SerializationKeys.behaviour)
    aCoder.encode(sendIconColor, forKey: SerializationKeys.sendIconColor)
    aCoder.encode(inputTextBackgroundColor, forKey: SerializationKeys.inputTextBackgroundColor)
    aCoder.encode(greetingMessage, forKey: SerializationKeys.greetingMessage)
    aCoder.encode(sendIconURL, forKey: SerializationKeys.sendIconURL)
    aCoder.encode(widgetButtonSize, forKey: SerializationKeys.widgetButtonSize)
    aCoder.encode(domainWhiteList, forKey: SerializationKeys.domainWhiteList)
    aCoder.encode(btnBgColor, forKey: SerializationKeys.btnBgColor)
    aCoder.encode(customChannelList, forKey: SerializationKeys.customChannelList)
    aCoder.encode(mobileBehaviour, forKey: SerializationKeys.mobileBehaviour)
    aCoder.encode(borderRadius, forKey: SerializationKeys.borderRadius)
    aCoder.encode(delay, forKey: SerializationKeys.delay)
    aCoder.encode(rightBubbleColor, forKey: SerializationKeys.rightBubbleColor)
    aCoder.encode(useVoice, forKey: SerializationKeys.useVoice)
    aCoder.encode(headerBgColor, forKey: SerializationKeys.headerBgColor)
    aCoder.encode(title, forKey: SerializationKeys.title)
    aCoder.encode(useNotification, forKey: SerializationKeys.useNotification)
    aCoder.encode(iconColor, forKey: SerializationKeys.iconColor)
    aCoder.encode(leftBubbleColor, forKey: SerializationKeys.leftBubbleColor)
    aCoder.encode(defaultInput, forKey: SerializationKeys.defaultInput)
    aCoder.encode(autoComplete, forKey: SerializationKeys.autoComplete)
    aCoder.encode(sendButtonColor, forKey: SerializationKeys.sendButtonColor)
    aCoder.encode(displayHeader, forKey: SerializationKeys.displayHeader)
    aCoder.encode(shakeWidget, forKey: SerializationKeys.shakeWidget)
    aCoder.encode(poweredByVouch, forKey: SerializationKeys.poweredByVouch)
    aCoder.encode(leftBubbleBgColor, forKey: SerializationKeys.leftBubbleBgColor)
    aCoder.encode(backgroundColorChat, forKey: SerializationKeys.backgroundColorChat)
    aCoder.encode(forceFullScreen, forKey: SerializationKeys.forceFullScreen)
    aCoder.encode(openImmediately, forKey: SerializationKeys.openImmediately)
    aCoder.encode(widgetFailedURL, forKey: SerializationKeys.widgetFailedURL)
    aCoder.encode(dismissKeyboard, forKey: SerializationKeys.dismissKeyboard)
    aCoder.encode(bubbleChatBorderRadius, forKey: SerializationKeys.bubbleChatBorderRadius)
    aCoder.encode(attachmentButtonColor, forKey: SerializationKeys.attachmentButtonColor)
    aCoder.encode(avatar, forKey: SerializationKeys.avatar)
    aCoder.encode(inputTextColor, forKey: SerializationKeys.inputTextColor)
    aCoder.encode(fontStyle, forKey: SerializationKeys.fontStyle)
    aCoder.encode(attachmentIconColor, forKey: SerializationKeys.attachmentIconColor)
    aCoder.encode(mobileDelay, forKey: SerializationKeys.mobileDelay)
    aCoder.encode(openIconURL, forKey: SerializationKeys.openIconURL)
  }

}
