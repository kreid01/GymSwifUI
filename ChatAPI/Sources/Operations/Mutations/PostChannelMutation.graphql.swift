// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class PostChannelMutation: GraphQLMutation {
  public static let operationName: String = "PostChannel"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation PostChannel($input: ChannelInput!) { postChannel(input: $input) { __typename id name } }"#
    ))

  public var input: ChannelInput

  public init(input: ChannelInput) {
    self.input = input
  }

  public var __variables: Variables? { ["input": input] }

  public struct Data: ChatAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { ChatAPI.Objects.Mutation }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("postChannel", PostChannel.self, arguments: ["input": .variable("input")]),
    ] }

    public var postChannel: PostChannel { __data["postChannel"] }

    /// PostChannel
    ///
    /// Parent Type: `Channel`
    public struct PostChannel: ChatAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { ChatAPI.Objects.Channel }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("id", ChatAPI.ID.self),
        .field("name", String?.self),
      ] }

      public var id: ChatAPI.ID { __data["id"] }
      public var name: String? { __data["name"] }
    }
  }
}
