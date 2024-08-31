// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class PostMessageMutation: GraphQLMutation {
  public static let operationName: String = "postMessage"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation postMessage($input: MessageInput!) { postMessage(input: $input) { __typename id content date user } }"#
    ))

  public var input: MessageInput

  public init(input: MessageInput) {
    self.input = input
  }

  public var __variables: Variables? { ["input": input] }

  public struct Data: ChatAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { ChatAPI.Objects.Mutation }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("postMessage", PostMessage.self, arguments: ["input": .variable("input")]),
    ] }

    public var postMessage: PostMessage { __data["postMessage"] }

    /// PostMessage
    ///
    /// Parent Type: `Message`
    public struct PostMessage: ChatAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { ChatAPI.Objects.Message }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("id", ChatAPI.ID.self),
        .field("content", String.self),
        .field("date", String.self),
        .field("user", String.self),
      ] }

      public var id: ChatAPI.ID { __data["id"] }
      public var content: String { __data["content"] }
      public var date: String { __data["date"] }
      public var user: String { __data["user"] }
    }
  }
}
