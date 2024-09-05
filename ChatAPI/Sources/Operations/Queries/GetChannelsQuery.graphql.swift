// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class GetChannelsQuery: GraphQLQuery {
  public static let operationName: String = "GetChannels"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query GetChannels { channels { __typename name id } }"#
    ))

  public init() {}

  public struct Data: ChatAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { ChatAPI.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("channels", [Channel].self),
    ] }

    public var channels: [Channel] { __data["channels"] }

    /// Channel
    ///
    /// Parent Type: `Channel`
    public struct Channel: ChatAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { ChatAPI.Objects.Channel }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("name", String?.self),
        .field("id", ChatAPI.ID.self),
      ] }

      public var name: String? { __data["name"] }
      public var id: ChatAPI.ID { __data["id"] }
    }
  }
}
