//
//  RegisterData.swift
//
//  Created by Ajie Pramono Arganata on 03/09/19
//  Copyright (c) GITS Indonesia. All rights reserved.
//

import Foundation
import SwiftyJSON

public final class RegisterData: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let token = "token"
    static let websocketTicket = "websocketTicket"
  }

  // MARK: Properties
  public var token: String?
  public var websocketTicket: String?

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
    token = json[SerializationKeys.token].string
    websocketTicket = json[SerializationKeys.websocketTicket].string
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = token { dictionary[SerializationKeys.token] = value }
    if let value = websocketTicket { dictionary[SerializationKeys.websocketTicket] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.token = aDecoder.decodeObject(forKey: SerializationKeys.token) as? String
    self.websocketTicket = aDecoder.decodeObject(forKey: SerializationKeys.websocketTicket) as? String
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(token, forKey: SerializationKeys.token)
    aCoder.encode(websocketTicket, forKey: SerializationKeys.websocketTicket)
  }

}
