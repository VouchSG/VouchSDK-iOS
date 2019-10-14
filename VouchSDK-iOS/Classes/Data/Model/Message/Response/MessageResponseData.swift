//
//  MessageResponseData.swift
//
//  Created by Ajie Pramono Arganata on 04/09/19
//  Copyright (c) GITS Indonesia. All rights reserved.
//

import Foundation
import SwiftyJSON

public final class MessageResponseData: NSCoding, Equatable {
    public static func == (lhs: MessageResponseData, rhs: MessageResponseData) -> Bool {
        return false
    }
    

    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let allowTranslate = "allowTranslate"
        static let customerInfo = "customerInfo"
        static let msgType = "msgType"
        static let createdAt = "createdAt"
        static let belongsToConversation = "belongsToConversation"
        static let lists = "lists"
        static let entity = "entity"
        static let id = "_id"
        static let quickReplies = "quick_replies"
        static let text = "text"
        static let disableKeyboard = "disableKeyboard"
        static let failed = "failed"
        static let updatedAt = "updatedAt"
        static let v = "__v"
        static let buttons = "buttons"
        static let elements = "elements"
        static let senderId = "senderId"
        static let fromMe = "fromMe"
    }

    // MARK: Properties
    public var allowTranslate: Bool? = false
    public var customerInfo: MessageResponseCustomerInfo?
    public var msgType: String?
    public var createdAt: String?
    public var belongsToConversation: String?
    public var lists: [MessageResponseLists]?
    public var entity: [Any]?
    public var id: String?
    public var quickReplies: [MessageResponseQuickReplies]?
    public var text: String?
    public var disableKeyboard: Bool? = false
    public var failed: Bool? = false
    public var updatedAt: String?
    public var v: Int?
    public var buttons: [MessageResponseButtons]?
    public var elements: [MessageResponseElements]?
    public var senderId: String?
    public var fromMe: Bool?
    
    public var payload: String?
    public var type: String?
    public var isSent = true
    public var idSent: String?
    public var imageLocal: UIImage?
    public var isError = false

    public init(text: String?, createdAt: String?, msgType: String? = "text", type: String? = "text", fromMe: Bool = false, payload: String? = nil, isSent: Bool = true, image: UIImage? = nil) {
        self.text = text
        self.createdAt = createdAt
        self.msgType = msgType
        self.type = type
        self.fromMe = fromMe
        self.payload = payload
        self.isSent = isSent
        self.idSent = Date().timeIntervalSince1970.secondsToString()
        self.imageLocal = image
    }
    
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
    allowTranslate = json[SerializationKeys.allowTranslate].boolValue
    customerInfo = MessageResponseCustomerInfo(json: json[SerializationKeys.customerInfo])
    msgType = json[SerializationKeys.msgType].string
    createdAt = json[SerializationKeys.createdAt].string
    belongsToConversation = json[SerializationKeys.belongsToConversation].string
    if let items = json[SerializationKeys.lists].array { lists = items.map { MessageResponseLists(json: $0) } }
    if let items = json[SerializationKeys.entity].array { entity = items.map { $0.object} }
    id = json[SerializationKeys.id].string
    if let items = json[SerializationKeys.quickReplies].array { quickReplies = items.map { MessageResponseQuickReplies(json: $0) } }
    text = json[SerializationKeys.text].string
    disableKeyboard = json[SerializationKeys.disableKeyboard].boolValue
    failed = json[SerializationKeys.failed].boolValue
    updatedAt = json[SerializationKeys.updatedAt].string
    v = json[SerializationKeys.v].int
    if let items = json[SerializationKeys.buttons].array { buttons = items.map { MessageResponseButtons(json: $0) } }
    if let items = json[SerializationKeys.elements].array { elements = items.map { MessageResponseElements(json: $0) } }
    senderId = json[SerializationKeys.senderId].string
    fromMe = json[SerializationKeys.fromMe].boolValue
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    dictionary[SerializationKeys.allowTranslate] = allowTranslate
    if let value = customerInfo { dictionary[SerializationKeys.customerInfo] = value.dictionaryRepresentation() }
    if let value = msgType { dictionary[SerializationKeys.msgType] = value }
    if let value = createdAt { dictionary[SerializationKeys.createdAt] = value }
    if let value = belongsToConversation { dictionary[SerializationKeys.belongsToConversation] = value }
    if let value = lists { dictionary[SerializationKeys.lists] = value }
    if let value = entity { dictionary[SerializationKeys.entity] = value }
    if let value = id { dictionary[SerializationKeys.id] = value }
    if let value = quickReplies { dictionary[SerializationKeys.quickReplies] = value.map { $0.dictionaryRepresentation() } }
    if let value = text { dictionary[SerializationKeys.text] = value }
    dictionary[SerializationKeys.disableKeyboard] = disableKeyboard
    dictionary[SerializationKeys.failed] = failed
    if let value = updatedAt { dictionary[SerializationKeys.updatedAt] = value }
    if let value = v { dictionary[SerializationKeys.v] = value }
    if let value = buttons { dictionary[SerializationKeys.buttons] = value }
    if let value = elements { dictionary[SerializationKeys.elements] = value }
    if let value = senderId { dictionary[SerializationKeys.senderId] = value }
    if let value = fromMe { dictionary[SerializationKeys.fromMe] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.allowTranslate = aDecoder.decodeBool(forKey: SerializationKeys.allowTranslate)
    self.customerInfo = aDecoder.decodeObject(forKey: SerializationKeys.customerInfo) as? MessageResponseCustomerInfo
    self.msgType = aDecoder.decodeObject(forKey: SerializationKeys.msgType) as? String
    self.createdAt = aDecoder.decodeObject(forKey: SerializationKeys.createdAt) as? String
    self.belongsToConversation = aDecoder.decodeObject(forKey: SerializationKeys.belongsToConversation) as? String
    self.lists = aDecoder.decodeObject(forKey: SerializationKeys.lists) as? [MessageResponseLists]
    self.entity = aDecoder.decodeObject(forKey: SerializationKeys.entity) as? [Any]
    self.id = aDecoder.decodeObject(forKey: SerializationKeys.id) as? String
    self.quickReplies = aDecoder.decodeObject(forKey: SerializationKeys.quickReplies) as? [MessageResponseQuickReplies]
    self.text = aDecoder.decodeObject(forKey: SerializationKeys.text) as? String
    self.disableKeyboard = aDecoder.decodeBool(forKey: SerializationKeys.disableKeyboard)
    self.failed = aDecoder.decodeBool(forKey: SerializationKeys.failed)
    self.updatedAt = aDecoder.decodeObject(forKey: SerializationKeys.updatedAt) as? String
    self.v = aDecoder.decodeObject(forKey: SerializationKeys.v) as? Int
    self.buttons = aDecoder.decodeObject(forKey: SerializationKeys.buttons) as? [MessageResponseButtons]
    self.elements = aDecoder.decodeObject(forKey: SerializationKeys.elements) as? [MessageResponseElements]
    self.senderId = aDecoder.decodeObject(forKey: SerializationKeys.senderId) as? String
    self.fromMe = aDecoder.decodeObject(forKey: SerializationKeys.fromMe) as? Bool
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(allowTranslate, forKey: SerializationKeys.allowTranslate)
    aCoder.encode(customerInfo, forKey: SerializationKeys.customerInfo)
    aCoder.encode(msgType, forKey: SerializationKeys.msgType)
    aCoder.encode(createdAt, forKey: SerializationKeys.createdAt)
    aCoder.encode(belongsToConversation, forKey: SerializationKeys.belongsToConversation)
    aCoder.encode(lists, forKey: SerializationKeys.lists)
    aCoder.encode(entity, forKey: SerializationKeys.entity)
    aCoder.encode(id, forKey: SerializationKeys.id)
    aCoder.encode(quickReplies, forKey: SerializationKeys.quickReplies)
    aCoder.encode(text, forKey: SerializationKeys.text)
    aCoder.encode(disableKeyboard, forKey: SerializationKeys.disableKeyboard)
    aCoder.encode(failed, forKey: SerializationKeys.failed)
    aCoder.encode(updatedAt, forKey: SerializationKeys.updatedAt)
    aCoder.encode(v, forKey: SerializationKeys.v)
    aCoder.encode(buttons, forKey: SerializationKeys.buttons)
    aCoder.encode(elements, forKey: SerializationKeys.elements)
    aCoder.encode(senderId, forKey: SerializationKeys.senderId)
    aCoder.encode(fromMe, forKey: SerializationKeys.fromMe)
  }

}
