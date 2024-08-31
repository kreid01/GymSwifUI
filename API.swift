// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public final class MessagesQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query Messages {
      messages {
        __typename
        id
        user
        content
        date
      }
    }
    """

  public let operationName: String = "Messages"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("messages", type: .nonNull(.list(.nonNull(.object(Message.selections))))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(messages: [Message]) {
      self.init(unsafeResultMap: ["__typename": "Query", "messages": messages.map { (value: Message) -> ResultMap in value.resultMap }])
    }

    public var messages: [Message] {
      get {
        return (resultMap["messages"] as! [ResultMap]).map { (value: ResultMap) -> Message in Message(unsafeResultMap: value) }
      }
      set {
        resultMap.updateValue(newValue.map { (value: Message) -> ResultMap in value.resultMap }, forKey: "messages")
      }
    }

    public struct Message: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Message"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("user", type: .nonNull(.scalar(String.self))),
          GraphQLField("content", type: .nonNull(.scalar(String.self))),
          GraphQLField("date", type: .nonNull(.scalar(String.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID, user: String, content: String, date: String) {
        self.init(unsafeResultMap: ["__typename": "Message", "id": id, "user": user, "content": content, "date": date])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return resultMap["id"]! as! GraphQLID
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }

      public var user: String {
        get {
          return resultMap["user"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "user")
        }
      }

      public var content: String {
        get {
          return resultMap["content"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "content")
        }
      }

      public var date: String {
        get {
          return resultMap["date"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "date")
        }
      }
    }
  }
}
