// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class MessagesQuery: GraphQLQuery {
  public static let operationName: String = "Messages"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query Messages { messages { __typename id user content date } }"#
    ))

  public init() {}

  public struct Data: ChatAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { ChatAPI.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("messages", [Message].self),
    ] }

    public var messages: [Message] { __data["messages"] }

    /// Message
    ///
    /// Parent Type: `Message`
    public struct Message: ChatAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { ChatAPI.Objects.Message }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("id", ChatAPI.ID.self),
        .field("user", String.self),
        .field("content", String.self),
        .field("date", String.self),
      ] }

      public var id: ChatAPI.ID { __data["id"] }
      public var user: String { __data["user"] }
      public var content: String { __data["content"] }
      public var date: String { __data["date"] }
    }
  }
}
