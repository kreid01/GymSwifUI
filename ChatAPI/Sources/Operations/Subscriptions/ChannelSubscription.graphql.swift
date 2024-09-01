// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class ChannelSubscription: GraphQLSubscription {
  public static let operationName: String = "ChannelSubscription"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"subscription ChannelSubscription($id: ID!) { messages(channelId: $id) { __typename content user date id user channelId } }"#
    ))

  public var id: ID

  public init(id: ID) {
    self.id = id
  }

  public var __variables: Variables? { ["id": id] }

  public struct Data: ChatAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { ChatAPI.Objects.Subscription }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("messages", [Message?].self, arguments: ["channelId": .variable("id")]),
    ] }

    public var messages: [Message?] { __data["messages"] }

    /// Message
    ///
    /// Parent Type: `Message`
    public struct Message: ChatAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { ChatAPI.Objects.Message }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("content", String.self),
        .field("user", String.self),
        .field("date", String.self),
        .field("id", ChatAPI.ID.self),
        .field("channelId", Int.self),
      ] }

      public var content: String { __data["content"] }
      public var user: String { __data["user"] }
      public var date: String { __data["date"] }
      public var id: ChatAPI.ID { __data["id"] }
      public var channelId: Int { __data["channelId"] }
    }
  }
}
