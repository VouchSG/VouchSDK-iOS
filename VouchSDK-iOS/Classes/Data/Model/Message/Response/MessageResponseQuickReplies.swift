//
//  MessageResponseQuickReplies.swift
//
//  Created by Ajie Pramono Arganata on 04/09/19
//  Copyright (c) GITS Indonesia. All rights reserved.
//

import Foundation
import SwiftyJSON

public final class MessageResponseQuickReplies: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let payload = "payload"
    static let title = "title"
    static let contentType = "content_type"
  }

  // MARK: Properties
  public var payload: String?
  public var title: String?
  public var contentType: String?

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
    payload = json[SerializationKeys.payload].string
    title = json[SerializationKeys.title].string
    contentType = json[SerializationKeys.contentType].string
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = payload { dictionary[SerializationKeys.payload] = value }
    if let value = title { dictionary[SerializationKeys.title] = value }
    if let value = contentType { dictionary[SerializationKeys.contentType] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.payload = aDecoder.decodeObject(forKey: SerializationKeys.payload) as? String
    self.title = aDecoder.decodeObject(forKey: SerializationKeys.title) as? String
    self.contentType = aDecoder.decodeObject(forKey: SerializationKeys.contentType) as? String
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(payload, forKey: SerializationKeys.payload)
    aCoder.encode(title, forKey: SerializationKeys.title)
    aCoder.encode(contentType, forKey: SerializationKeys.contentType)
  }

}
