//
//  MessageResponseCustomerInfo.swift
//
//  Created by Ajie Pramono Arganata on 04/09/19
//  Copyright (c) GITS Indonesia. All rights reserved.
//

import Foundation
import SwiftyJSON

public final class MessageResponseCustomerInfo: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let picture = "picture"
    static let firstname = "firstname"
  }

  // MARK: Properties
  public var picture: String?
  public var firstname: String?

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
    picture = json[SerializationKeys.picture].string
    firstname = json[SerializationKeys.firstname].string
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = picture { dictionary[SerializationKeys.picture] = value }
    if let value = firstname { dictionary[SerializationKeys.firstname] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.picture = aDecoder.decodeObject(forKey: SerializationKeys.picture) as? String
    self.firstname = aDecoder.decodeObject(forKey: SerializationKeys.firstname) as? String
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(picture, forKey: SerializationKeys.picture)
    aCoder.encode(firstname, forKey: SerializationKeys.firstname)
  }

}
