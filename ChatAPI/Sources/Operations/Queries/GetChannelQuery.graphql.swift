// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class GetChannelQuery: GraphQLQuery {
  public static let operationName: String = "GetChannel"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query GetChannel($id: ID!, $page: Int, $pageSize: Int) { channel(id: $id, page: $page, pageSize: $pageSize) { __typename channel { __typename messages { __typename id content user date channelId } } hasMore } }"#
    ))

  public var id: ID
  public var page: GraphQLNullable<Int>
  public var pageSize: GraphQLNullable<Int>

  public init(
    id: ID,
    page: GraphQLNullable<Int>,
    pageSize: GraphQLNullable<Int>
  ) {
    self.id = id
    self.page = page
    self.pageSize = pageSize
  }

  public var __variables: Variables? { [
    "id": id,
    "page": page,
    "pageSize": pageSize
  ] }

  public struct Data: ChatAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { ChatAPI.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("channel", Channel.self, arguments: [
        "id": .variable("id"),
        "page": .variable("page"),
        "pageSize": .variable("pageSize")
      ]),
    ] }

    public var channel: Channel { __data["channel"] }

    /// Channel
    ///
    /// Parent Type: `ChannelConnection`
    public struct Channel: ChatAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { ChatAPI.Objects.ChannelConnection }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("channel", Channel.self),
        .field("hasMore", Bool.self),
      ] }

      public var channel: Channel { __data["channel"] }
      public var hasMore: Bool { __data["hasMore"] }

      /// Channel.Channel
      ///
      /// Parent Type: `Channel`
      public struct Channel: ChatAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { ChatAPI.Objects.Channel }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("messages", [Message?].self),
        ] }

        public var messages: [Message?] { __data["messages"] }

        /// Channel.Channel.Message
        ///
        /// Parent Type: `Message`
        public struct Message: ChatAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: any ApolloAPI.ParentType { ChatAPI.Objects.Message }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("id", ChatAPI.ID.self),
            .field("content", String.self),
            .field("user", String.self),
            .field("date", String.self),
            .field("channelId", Int.self),
          ] }

          public var id: ChatAPI.ID { __data["id"] }
          public var content: String { __data["content"] }
          public var user: String { __data["user"] }
          public var date: String { __data["date"] }
          public var channelId: Int { __data["channelId"] }
        }
      }
    }
  }
}
