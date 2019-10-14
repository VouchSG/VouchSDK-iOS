//
//  MessageResponseElements.swift
//
//  Created by Ajie Pramono Arganata on 29/08/19
//  Copyright (c) GITS Indonesia. All rights reserved.
//

import Foundation
import SwiftyJSON

public final class MessageResponseElements: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let buttons = "buttons"
    static let title = "title"
    static let imageUrl = "image_url"
    static let subtitle = "subtitle"
  }

  // MARK: Properties
  public var buttons: [MessageResponseButtons]?
  public var title: String?
  public var imageUrl: String?
  public var subtitle: String?

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
    if let items = json[SerializationKeys.buttons].array { buttons = items.map { MessageResponseButtons(json: $0) } }
    title = json[SerializationKeys.title].string
    imageUrl = json[SerializationKeys.imageUrl].string
    subtitle = json[SerializationKeys.subtitle].string
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = buttons { dictionary[SerializationKeys.buttons] = value.map { $0.dictionaryRepresentation() } }
    if let value = title { dictionary[SerializationKeys.title] = value }
    if let value = imageUrl { dictionary[SerializationKeys.imageUrl] = value }
    if let value = subtitle { dictionary[SerializationKeys.subtitle] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.buttons = aDecoder.decodeObject(forKey: SerializationKeys.buttons) as? [MessageResponseButtons]
    self.title = aDecoder.decodeObject(forKey: SerializationKeys.title) as? String
    self.imageUrl = aDecoder.decodeObject(forKey: SerializationKeys.imageUrl) as? String
    self.subtitle = aDecoder.decodeObject(forKey: SerializationKeys.subtitle) as? String
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(buttons, forKey: SerializationKeys.buttons)
    aCoder.encode(title, forKey: SerializationKeys.title)
    aCoder.encode(imageUrl, forKey: SerializationKeys.imageUrl)
    aCoder.encode(subtitle, forKey: SerializationKeys.subtitle)
  }

}
